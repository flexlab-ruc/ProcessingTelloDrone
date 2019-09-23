

TelloDrone drone;

void setup()
{
  size(1100, 700);
  // Create Drone instance
  setupDrone();
}

void draw()
{
  uiUpdate(mouseX, mouseY, mousePressed, key, width, height);
  background(0);

  printBattery(800, 500);
  drawDroneUI();


//  exercise1();
}

void exercise1()
{
  if (uiButton("Connect", 800, 30).clicked)
  {
    isConnected = drone.connect();
  } 
  if (uiButton("Do drone show", 800, 70).clicked)
  {
    drone.addToCommandQueue("takeoff");
    drone.addToCommandQueue("right 30");
    drone.addToCommandQueue("left 30");
    drone.addToCommandQueue("land");
  }
  fill(255);
  text("Drone connected: " + isConnected, 800, 120);
  if (uiButton("STOP!", 800, 300, color(255, 0, 0)).clicked )
  {
    drone.sendMessage("emergency");
  }
}


void keyPressed() {
  if (key == 'b' ) {
    drone.addToCommandQueue("right 30");
  }
  
  else if (key == 'a' ) {
    drone.addToCommandQueue("right 30");
  }
}
