
int missionPad = 3;

TelloDrone drone;

void setup()
{
  size(1200, 700);
  setupDrone();
  
}

void draw()
{
 
  
  
  
  background(0);
  uiUpdate(mouseX, mouseY, mousePressed, key, width, height);
  drawDroneUI();


  if (uiButton("Do drone show", 800, 190).clicked )
  {
    drone.addToCommandQueue("takeoff");
    drone.addToCommandQueue("right 30"); 
    drone.addToCommandQueue("left 30");
    drone.addToCommandQueue("land");
  }
  
  /*if(drone.commander.commandsToExecute.size() < 3 && missionPadOn)
   {
   drone.addToCommandQueue("go 0 0 100 20 m" + missionPad);
   }*/
}




void keyPressed() {
  if (key == 'b' ) {
    println("hep" );
  } else if (key == 'a' ) {
    drone.addToCommandQueue("right 30");
  }
}
