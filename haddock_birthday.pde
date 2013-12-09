PImage img;
ArrayList circles;
boolean displayImage=true;
int minimumRadius=2;
int maximumRadius=10;
float scale;
float stencilSize=152.4;   //the output will be 152.4mm x 152.4mm
PrintWriter output;

void setup()
{
  size(700, 700);
  scale=width/stencilSize;
  output=createWriter("stencil.GTP");
  img=loadImage("haddock birthday.png");
  img.loadPixels();
  circles=new ArrayList();
  while (circles.size ()<800)
  {
    println(circles.size());
    int x=(int)random(img.width);
    int y=(int)random(img.height);
    float radius=minimumRadius+random(maximumRadius-minimumRadius);
    if (isDark(img.pixels[y*img.width+x], 100+(int)random(50)-25))
    {
      boolean unique=true;
      float smallestDistance=img.width;
      float distance=0;
      Circle testCircle=new Circle(x, y, radius);
      for (int j=0;j<circles.size();j++)
      {
        Circle existingCircle=(Circle) circles.get(j);
        distance=getDistance(testCircle, existingCircle);
        if (distance<smallestDistance)
          smallestDistance=distance;
        if (distance<=2)
          unique=false;
      }
      if (unique)
        circles.add(testCircle);
    }
  }
  println(circles.size());
  writeGerberHeader();
  for(int i=0;i<circles.size();i++) //draw each of the circles
     ((Circle)circles.get(i)).renderGerber(i);    
  writeGerberFooter();
}

void writeGerberHeader()
{
  output.println("haddock birthday cake");
  output.println("%FSLAX36Y26*%");  //Coordinate format specification: 
                                    //Leading zeroes omitted 
                                    //Absolute coordinates 
                                    //2 digits in the integer part 
                                    //6 digits in the fractional part
  output.println("%MOMM*%");        //set units to mm
  output.println("%LPD%");          //Start a new level with dark polarity

/*
                                    //define each of the circular apertures
  for(int i=minimumRadius;i<=maximumRadius;i++)
    output.println("%ADD"+i+"C,"+(float)i*scale+"*%"); 
*/

  for(int i=0;i<circles.size();i++) //define each of the rectangular apertures
     ((Circle)circles.get(i)).writeGerberAperture(i);
}

void writeGerberFooter()
{
  output.println("M02*"); // End of file 
  output.flush();
  output.close();
}

boolean isDark(color pixel, int threshhold)
{
  int a=(int)(red(pixel)+green(pixel)+blue(pixel))/3;
  return (a<threshhold);
}

float getDistance(Circle a, Circle b)
{
  float distance=sqrt(pow(a.x-b.x, 2)+pow(a.y-b.y, 2));
  return distance-a.radius-b.radius;
}

void draw()
{
  background(255);
  if (frameCount>1)
    if (displayImage)
      image(img, 0, 0);
  fill(0);
  stroke(0);
  for (int i=0;i<circles.size();i++)
  {
    Circle thisCircle=(Circle)circles.get(i);
    thisCircle.render();
  }
  if(frameCount==1)
    save(month()+"."+day()+" "+hour()+"-"+minute()+"-"+second()+".bmp");
  if(frameCount==2)
    save(month()+"."+day()+" "+hour()+"-"+minute()+"-"+second()+"-background.bmp");
}

class Circle {
  float x, y, radius, rectWidth, rectHeight;
  boolean circleMode;
  Circle(float _x, float _y, float _radius) {
    x=_x;
    y=_y;
    radius=_radius;
    circleMode=(random(1)>0.25);
    if (!circleMode)
    {
      rectWidth=(minimumRadius+random(radius-minimumRadius));
      rectHeight=sqrt(pow(radius, 2)-pow(rectWidth, 2));
      println(rectWidth+" "+rectHeight);
    }
  }
  void render()
  {
    if (circleMode)
      ellipse(x, y, radius*2, radius*2);
    else
      rect(x-rectWidth, y-rectHeight, rectWidth*2, rectHeight*2);
  }
  
  void writeGerberAperture(int i)
  {
    if(circleMode)
      output.println("%ADD"+i+"C,"+radius*2*scale+"*%"); 
    else
      output.println("%ADD"+i+"R,"+rectWidth*2*scale+"X"+rectHeight*2*scale+"*%");          
  }
  
  void renderGerber(int i)
  {
    output.println("D"+i+"*");  //select this circle's aperture
    //scale the location and format it with 3 integer digits and 6 fractional digits
    String xString=nf(x*scale, 3,6);
    String yString=nf(y*scale, 3,6);
    //trash the decimal points
    xString=xString.substring(0,xString.indexOf("."))+xString.substring(xString.indexOf(".")+1);
    yString=yString.substring(0,yString.indexOf("."))+yString.substring(yString.indexOf(".")+1);
    
    output.println("X"+xString+"Y"+yString+"D03*");  //flash the aperture at this location
  }
}

void keyPressed()
{
  displayImage=!displayImage;
}

