void setup()
{
  // Create Drone instance
  TelloDrone drone = new TelloDrone();

  drone.setLogToConsole(true);
  drone.connect();
  
  // choose to send commands directly to the drone or use the queue system
  
  //sending commands  (blocks the thread)
  //sendCommandsToDrone(drone);
  
  // use queue system to store and execute commands
  useCommandQueue(drone);
  
}

void sendCommandsToDrone(TelloDrone drone)
{
  //sending single commands to the drone:
  drone.getBatteryPercentage();
  drone.takeoff();
  drone.rotateClockwise(360);
  drone.land();
}

// create a queue of commands and execute them
void useCommandQueue(TelloDrone drone)
  {
  drone.addToCommandQueue("sdk?");
  drone.addToCommandQueue("sn?");
  drone.addToCommandQueue("takeoff");
  for (int i=0; i<5; i++)
  {
    drone.addToCommandQueue("cw 180");
  }
  drone.addToCommandQueue("land");

  
  
  
  //disable logging drone and use the eventlistener below instead
  drone.setLogToConsole(false);

  //add eventlistener to the "drone command queue"

  drone.addCommandQueueEventListener(new DroneCommandEventListener() {
    @Override
      public void commandExecuted(Command command)
    {
      System.out.println("Command Executed:");
      System.out.println(command.getCommand());
    }

    @Override
      public void commandFinished(Command command)
    {
      System.out.println("Command Finished:");
      System.out.println(command);
    }

    @Override
      public void commandAdded(Command command)
    {
      System.out.println(command.getCommand() + " added to queue");
    }

    @Override
      public void commandQueueFinished() {
      System.out.println("Done. No more commands in queue");
    }
  });
  drone.startCommandQueue();
  
  System.out.println("DONE SENDING COMMANDS - READY FOR OTHER TASKS :-)");
  
  delay(15000);
  drone.clearCommandQueue();
  delay(3000);
  drone.addToCommandQueue("takeoff");
  drone.addToCommandQueue("land");
}
