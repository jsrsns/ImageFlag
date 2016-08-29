/* Joes Roosens - 2015 */
/* Built with Processing 2.2.1 and Processing.js 1.4.1 */
/* Controls:
- Click image to randomize the frequency and amplitude of the oscilation.
- Move the mouse along the y and x axis to change the speed of the oscilation.
- Press spacebar to change the image. */
/* @pjs preload="flag.jpg, flag2.jpg"; */

Boolean isInitialized = false;//JS load image
PImage pimg;
float dw = 0, dh = 0;
int[] px;
int imageW, imageH, offset;
PVector minSize = new PVector(.2, .7);//Min image size
PVector freq = new PVector(1, 1);

void setup()
{
  size(700, 700, P2D);
  pimg = loadImage("flag.jpg");
  initPicture();
}

void initPicture()
{
  imageW = pimg.width;
  imageH = pimg.height;
  if (imageW * imageH > 0)
  {
    px = new int[imageW*imageH];
    pimg.loadPixels();
    arrayCopy(pimg.pixels, px);//Store the pixels
    pimg.updatePixels();
    offset = (int)((width-imageW)/2 + (height-imageH)/2*width);//Center image (doesn't work in JS)
    isInitialized = true;
  }
}

void draw()
{
  background(255,0);
  dw += map(mouseX, 0, width, .16, -.16);//Oscilation speed
  dh += map(mouseY, 0, height, .16, -.16);//Oscilation speed
  loadPixels();
  for (int i = 0; i < imageW; i++)
  {
    for (int j = 0; j < imageH; j++)
    {
      int w = ((int)(map(1+sin((TWO_PI*j*freq.x)/imageH+dh), 0, 2, minSize.x, 1)*imageW));
      int h = ((int)(map(1+sin((TWO_PI*i*freq.y)/imageW+dw), 0, 2, minSize.y, 1)*imageH));
      if ((imageW-w)/2 <= i && i < (imageW+w)/2
        && ((imageH-h)/2 <= j && j < (imageH+h)/2))//Check pixels
      {
        pixels[width*j+i/*+offset*/] = px[imageW*(int)map(j, (imageH-h)/2, (imageH+h)/2-1, 0, imageH-1) + (int)map(i, (imageW-w)/2, (imageW+w)/2-1, 0, imageW-1)];
      }
    }
  }
  updatePixels();
}

void mousePressed()
{
  if (!isInitialized)
  {
    initPicture();
  } else
  {
    minSize = new PVector(random(0, 1), random(0, 1));
    freq = new PVector(random(.2, 2), random(.2, 2));
  }
}

void keyPressed(){
  if (key==' '){
    if (isInitialized == false){
      pimg = loadImage("flag2.jpg");
      initPicture();
      isInitialized = true;
    }else{
      pimg = loadImage("flag.jpg");
      initPicture();
      isInitialized = false;
    }
  }
}
