boolean streamOn = false;
boolean missionPadOn = false;
boolean isConnected = false;
String latestCmd = "";
uiFloat joyX =new uiFloat(0.0f);
uiFloat joyY =new uiFloat(0.0f);
uiFloat scrollHeight = new uiFloat(0.0f);
boolean showParams = false;


void setupDrone()
{
  drone = new TelloDrone();
  drone.setLogToConsole(false);
  drone.startCommandQueue();
  drone.startStateReicever();
  // add eventlistener to the "drone command queue"
  drone.addCommandQueueEventListener(new DroneCommandEventListener() {
    @Override
      public void commandExecuted(Command command)
    {
      System.out.println("Command Executed:");
      System.out.println(command);
    }

    @Override
      public void commandFinished(Command command)
    {
      System.out.println("Command Finished:");
      System.out.println(command);
      latestCmd = command.toString();
    }

    @Override
      public void commandAdded(Command command)
    {
      System.out.println(command.getCommand() + " added to queue");
    }

    @Override
      public void commandQueueFinished() {
      //System.out.println("Done. No more commands in queue");
    }
  }
  );
}

void printBattery(int x, int y)
{
  fill(255);
  textSize(80);
  //println(drone.getStateInfo("bat"));
  text( drone.getStateInfo("bat") + "%", x, y);
}


void drawDroneUI()
{

  uiContainerStart(30, 30, 200);

  if (uiButton("Connected: " + isConnected).clicked && !isConnected)
  {
    isConnected = drone.connect();
  } 

  int qSize2 = drone.commander.commandsToExecute.size();
  uiText("Q: " + qSize2, max(15, qSize2/3));
  if (isConnected)
  {



    if (uiButton("Take off").clicked  )
    {
      drone.addToCommandQueue("takeoff");
    }

    if (uiButton("Land").clicked )
    {
      drone.addToCommandQueue("land");
    }
    /*
    if (uiButton("Streaming: " + streamOn).clicked )
     {
     if (!streamOn)
     {
     drone.addToCommandQueue("streamon");
     } else
     {
     drone.addToCommandQueue("streamoff");
     }
     streamOn = !streamOn;
     }*/

    if (uiButton("Mission: " + missionPadOn).clicked )
    {
      doMissionPads();
    }

    if (uiButton("Go to pad "+ missionPad).clicked )
    {
      if (!missionPadOn)
      {
        doMissionPads();
      }
      drone.addToCommandQueue("go 0 0 100 20 m" + missionPad);
    }



    if (uiButton("Clear queue: " + drone.commander.commandsToExecute.size()).clicked )
    {
      drone.commander.clearQueue();
    }


    uiObj joyobj = uiJoystick("2D control", -100, 100, joyX, joyY);

    if (joyobj.pressed)
    {
      if (drone.commander.commandsToExecute.size() < 10)
      {
        drone.addToCommandQueue("rc 0 " + round(joyY.get()) +" 0 "+ round(joyX.get()*-1) , true);
      }
    } else if (  joyobj.pressedUp )
    {

      drone.addToCommandQueue("rc 0 0 0 0", true);
    }

    if (uiButton("STOP!", color(255, 0, 0)).clicked )
    {
      drone.sendMessage("emergency");
    }
    if (uiButton("Show Params").clicked )
    {
      showParams = !showParams;
    }
    uiText("Bat: " + drone.getStateInfo("bat") + "%");

    String[] strCMD = latestCmd.split(";");
    for (int i = 0; i < strCMD.length; i++)
    {
      uiText(strCMD[i]);
    }

    
  }
  
  uiContainerEnd();





  if (showParams)
  {
    uiContainerStart(330, 20, 200).margin = 0;
    String[] states = drone.stateReceiver.state.split(";");
    for (int i = 0; i < states.length; i++)
    {
      uiText(" " +states[i].replace(":", ":\t"));
      if (i == 15)
      {
        uiContainerEnd();
        uiContainerStart(330+220, 20, 200).margin = 0;
      }
    }
    uiContainerEnd();


    int qSize = drone.commander.commandsToExecute.size();
    uiContainerStart(330+220*2, 20, 200).margin = 0;
    for (int i = 0; i < min(qSize, 20); i++)
    {
      uiText(drone.commander.commandsToExecute.get(i).getCommand());
    }
    uiContainerEnd();
  }
}

void doMissionPads()
{
  if (!missionPadOn)
  {
    drone.addToCommandQueue("mon");
  } else
  {
    drone.addToCommandQueue("moff");
  }
  missionPadOn = !missionPadOn;
}
