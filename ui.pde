/*
 todo:
 - dynamic styling
 - relative positioning
 - horizontal container.
 - Draggable
 - mouse as an object.
 - onUp onDown
 - key bindings
 
 
 */

boolean uiMPOld = false;
float uiMXOld = 0;
float uiMYOld = 0;
float uiMX = 0;
float uiMY = 0;
float uiSWidth = 0;
float uiSHeight = 0;
boolean uiPressedUP = false;
boolean uiMP = false;
char uiKey;
ArrayList<uiObj> stack = new ArrayList<uiObj>();

void uiUpdate(int _mouseX, int _mouseY, boolean _mousePressed, char _key, float screenWidth, float screenHeight)
{
  stack.clear();
  uiSWidth = screenWidth;
  uiSHeight = screenHeight;
  uiMXOld = _mouseX;
  uiMYOld = _mouseY;
  uiMPOld = uiMP;
  uiMX = _mouseX;
  uiMY = _mouseY;
  uiMP = _mousePressed;
  uiKey = _key;
}

uiObj uiContainerStart()
{
  if (stack.size() > 0)
  {
    uiObj parentContainer = getCont();
    return uiContainerStart(parentContainer.x, parentContainer.currentY + parentContainer.margin, parentContainer.width);
  }
  return uiContainerStart(0, 0, 200);
}

uiObj uiContainerStart(float x, float y, float width)
{
  uiObj uiO = new uiObj();

  uiO.x = x;
  uiO.y = y;

  uiO.width = width;

  stack.add(uiO);
  return uiO;
}

void uiContainerEnd()
{
  uiObj container = getCont();
  noFill();
  stroke(255);
  rect(container.x-container.margin, container.y- container.margin, container.width + container.margin*2, container.currentY+container.margin*2); 
  stack.remove(container);
}

uiObj uiButton(String name)
{
  return uiButton(name, color(255));
}

uiObj uiButton(String name, color background)
{
  uiObj container = getCont();
  uiObj interactive =  uiButton(name, 
    container.currentX +container.x, container.currentY + container.y, 
    container.width, 30, background); 

  container.currentY = container.currentY + interactive.height + container.margin;

  return interactive;
}

uiObj uiButton(String name, float x, float  y)
{
  return uiButton( name, x, y, 200, 30, color(255));
}

uiObj uiButton(String name, float x, float  y, color background)
{
  return uiButton( name, x, y, 200, 30, background);
}

uiObj uiButton(String name, float x, float  y, float width, float height, color background) {

  uiObj interactive = uiCompileInteractive(x, y, width, height);
 
  uiRectStyling();
  if (interactive.hover) {
    fill(100);

    if (interactive.pressed) {
      fill(50);
    }
  } else {
    fill(background);
  }

  rect(x, y, width, height);
  if (interactive.pressed)
  {
    fill(255);
  } else
  {
    fill(0);
  }
  uiTextStyling();
  text(name, x + 10, y + 20);
  return interactive;
}


uiObj uiScrollbar(String name, float min, float max, uiFloat value)
{
  uiObj container = getCont();
  uiObj uiobj = uiScrollbar(name, 
    container.currentX +container.x, container.currentY + container.y, container.width
    , min, max, value);

  container.currentY = container.currentY + uiobj.height + container.margin;
  return uiobj;
}
uiObj uiScrollbar(String name, float x, float y, float width, float min, float max, uiFloat value)
{
  uiObj uiobj = uiCompileInteractive(x, y, width, 30);

  if (uiobj.hover && uiobj.pressed)
  {
    value.set(map(uiobj.mX, 0, uiobj.width, min, max));
  }
  uiRectStyling();
  rect(x, y, uiobj.width, uiobj.height);
  fill(255, 100, 100);
  rect(x, y, map(value.get(), min, max, 0, uiobj.width), uiobj.height);
  uiTextStyling();
  text(name, x + 10, y + 20);
 
  return uiobj;
}
uiObj uiText(String name)
{
  return uiText(name, 15);
}
uiObj uiText(String name, int fontSize)
{
  uiObj container = getCont();
  uiObj uiobj = uiText(name, 
    container.currentX +container.x, container.currentY + container.y, container.width, fontSize);

  container.currentY = container.currentY + uiobj.height + container.margin;
  return uiobj;
}
uiObj uiText(String name, float x, float y, float width,int fontSize)
{
  uiObj uiobj = uiCompileInteractive(x, y, width, 30);
  uiTextStyling();
  fill(255);
  textSize(fontSize);
  text(name, x, y + 20);

  return uiobj;
}

uiObj uiJoystick(String name, float min, float max, uiFloat joyX, uiFloat joyY)
{
  uiObj container = getCont();
  uiObj uiobj =  uiJoystick(name, 
    container.currentX +container.x, container.currentY + container.y, container.width, min, max, 
    joyX, joyY); 

  container.currentY = container.currentY + uiobj.height + container.margin;

  return uiobj;
}

uiObj uiJoystick(String name, float x, float y, float size, float min, float max, uiFloat joyX, uiFloat joyY)
{

  int ballSize = 40;
  uiObj uiobj = uiCompileInteractive(x, y, size, size);

  stroke(255);
  noFill();
  ellipse(x + size/2, y + size/2, size, size);
  fill(200);


  if (uiobj.hover && uiobj.pressed)
  {
    fill(255, 100, 100);
    joyX.set(map(uiMX- (x+size/2), -size/2, size/2, min, max));
    joyY.set(map(uiMY- (y+size/2), -size/2, size/2, min, max));
  } else
  {
    joyX.set(0); 
    joyY.set(0);
  }


  noStroke();
  ellipse(x+size/2+map(joyX.get(), min, max, -size/2, size/2), y+size/2+map(joyY.get(), min, max, -size/2, size/2), ballSize, ballSize);

  return uiobj;
}

uiObj uiCompileInteractive(float x, float y, float width, float height)
{
  uiObj uiobj =  new uiObj();

  uiobj.x = x;
  uiobj.y = y;
  uiobj.mX = uiMX-x;
  uiobj.mY = uiMY-y;
  uiobj.width = width;
  uiobj.height = height;
  uiobj.hoverOld = (uiMXOld > x && uiMYOld > y && uiMXOld < x + width && uiMYOld < y + height);
  uiobj.hover = (uiMX > x && uiMY > y && uiMX < x + width && uiMY < y + height);

  uiobj.pressed =uiobj.hover && uiMP;
  uiobj.pressedOld = uiobj.hoverOld && uiMPOld;
  uiobj.pressedDown = uiobj.hover && uiMP && !uiMPOld;
  uiobj.dragging = uiobj.hover && uiobj.pressed && uiobj.pressedOld && (uiMYOld != uiMY || uiMXOld != uiMX);
  uiobj.clicked = !uiobj.dragging && uiobj.hover && !uiMP && uiMPOld; // not perfect.
  uiobj.pressedUp = (!uiobj.hover && uiobj.hoverOld) || (uiobj.hover && !uiobj.pressed && uiMPOld);
  return uiobj;
}

uiObj getCont()
{ 
  if (stack.size() == 0)
  {
    uiContainerStart();
  }
  return stack.get(stack.size() -1);
}

void uiRectStyling()
{
  noStroke();
  fill(255);
}

void uiTextStyling()
{

  fill(0);
  textSize(15);
  noStroke();
}




class uiPosition 
{
  float x = 0;
  float y = 0;
}

class uiObj
{
  float x =0;
  float y = 0;
  float mX =0;
  float mY = 0;
  float width = 0;
  float height = 0;
  boolean clicked = false;
  boolean pressed = false;
  boolean pressedOld = false;

  boolean hover = false;
  boolean hoverOld = false;
  boolean dragging = false;
  boolean pressedUp = false;
  boolean pressedDown = false;

  float currentX = 0;
  float currentY = 0;
  float margin = 10;
}



public class uiFloat
{
  private float val;

  public uiFloat(float val)
  {
    this.val = val;
  }

  public void set(float newVal)
  {
    this.val = newVal;
  }

  public float get()
  {
    return this.val;
  }
}

uiFloat uiJoyX =new uiFloat(0.0f);
uiFloat uiJoyY =new uiFloat(0.0f);
uiFloat uiScrollValue = new uiFloat(0.0f); 

void uiDemo()
{

  uiContainerStart(width-200, 30, 150);

  uiText("DEMO");
  if (uiButton("Button one").clicked )
  {
    println("Button one");
  }

  if (uiButton("STOP!", color(255, 0, 0)).clicked )
  {
    println("Stop");
  }

  uiText("Some text");

  if (uiScrollbar("Scrollbar", 0, 100, uiScrollValue ).clicked)
  {
    println("Scrollbar value: " + uiScrollValue.get());
  };

  uiObj joyobj = uiJoystick("2D control", -100, 100, uiJoyX, uiJoyY);

  if (joyobj.pressed)
  {
    println("joystick: " + uiJoyX.get() + "," + uiJoyY.get());
  } 


  uiContainerEnd();
}
