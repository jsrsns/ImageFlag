/* Built with Processing 3.2.1 and Processing.js 1.4.8 */
/* Controls:
- click image to randomize the oscilation frequency and amplitude.
- move the mouse across x and y axis to change the oscilation speed.
- press spacebar to change image. */
/* !do not delete the line above, required for linking your tweak if you upload again */
/* @pjs preload="flag.jpg, flag2.jpg"; */

Boolean isInitialized = false;//loading image
PImage pimg;
float dw = 0, dh = 0;
int[] px;
int imageW, imageH, offset;
PVector minSize = new PVector(.2, .7);//image min size
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
    arrayCopy(pimg.pixels, px);//store the pixels of the image
    pimg.updatePixels();
    offset = (int)((width-imageW)/2 + (height-imageH)/2*width);//centers the image but currently doesn't work with JS ;(
    isInitialized = true;
  }
}

void draw()
{
  background(255,0);
  dw += map(mouseX, 0, width, .16, -.16);//oscilation speed
  dh += map(mouseY, 0, height, .16, -.16);//oscilation speed
  loadPixels();
  for (int i = 0; i < imageW; i++)
  {
    for (int j = 0; j < imageH; j++)
    {
      int w = ((int)(map(1+sin((TWO_PI*j*freq.x)/imageH+dh), 0, 2, minSize.x, 1)*imageW));
      int h = ((int)(map(1+sin((TWO_PI*i*freq.y)/imageW+dw), 0, 2, minSize.y, 1)*imageH));
      if ((imageW-w)/2 <= i && i < (imageW+w)/2
        && ((imageH-h)/2 <= j && j < (imageH+h)/2))//check pixels in new frame
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