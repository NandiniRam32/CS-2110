#include "gba.h"
volatile unsigned short *videoBuffer = (volatile unsigned short *) 0x6000000;
//u16 *videoBuffer = (u16 *)0x6000000;
u32 vBlankCounter = 0;

/*
  Wait until the start of the next VBlank. This is useful to avoid tearing.
  Completing this function is required.
*/
void waitForVBlank(void) {
  while(SCANLINECOUNTER > 160);
  while(SCANLINECOUNTER < 160);
  vBlankCounter++;
  // TODO: IMPLEMENT

  // (1)
  // Write a while loop that loops until we're NOT in vBlank anymore:
  // (This prevents counting one VBlank more than once if your app is too fast)

  // (2)
  // Write a while loop that keeps going until we're in vBlank:

  // (3)
  // Finally, increment the vBlank counter:
}

static int __qran_seed = 42;
static int qran(void) {
  __qran_seed = 1664525 * __qran_seed + 1013904223;
  return (__qran_seed >> 16) & 0x7FFF;
}

int randint(int min, int max) { return (qran() * (max - min) >> 15) + min; }

/*
  Sets a pixel in the video buffer to a given color.
  Using DMA is NOT recommended. (In fact, using DMA with this function would be really slow!)
*/
void setPixel(int row, int col, u16 color) {
  videoBuffer[row + 240 * col] = color;
  UNUSED(row);
  UNUSED(col);
  UNUSED(color);
}

/*
  Draws a rectangle of a given color to the video buffer.
  The width and height, as well as the top left corner of the rectangle, are passed as parameters.
  This function can be completed using `height` DMA calls. 
*/
void drawRectDMA(int row, int col, int width, int height, volatile u16 color) {
  for (int i = 0; i < height; i++) {
    DMA[3].src = &color;
		DMA[3].dst = &videoBuffer[OFFSET(row + i, col, 240)];
		DMA[3].cnt = (width) | DMA_SOURCE_FIXED | DMA_ON;
  }
  UNUSED(row);
  UNUSED(col);
  UNUSED(width);
  UNUSED(height);
  UNUSED(color);
}

/*
  Draws a fullscreen image to the video buffer.
  The image passed in must be of size WIDTH * HEIGHT.
  This function can be completed using a single DMA call.
*/
void drawFullScreenImageDMA(const u16 *image) {
  drawImageDMA(0, 0, 240, 160, image);
  UNUSED(image);
}

/*
  Draws an image to the video buffer.
  The width and height, as well as the top left corner of the image, are passed as parameters.
  The image passed in must be of size width * height.
  Completing this function is required.
  This function can be completed using `height` DMA calls. Solutions that use more DMA calls will not get credit.
*/
void drawImageDMA(int row, int col, int width, int height, const u16 *image) {
  for (int i = 0; i < height; i++) {
    DMA[3].src = &image[OFFSET(i, 0, width)];
		DMA[3].dst = &videoBuffer[OFFSET(row + i, col, 240)];
		DMA[3].cnt = (width) | DMA_ON;
	}
}

/*
  Draws a rectangular chunk of a fullscreen image to the video buffer.
  The width and height, as well as the top left corner of the chunk to be drawn, are passed as parameters.
  The image passed in must be of size WIDTH * HEIGHT.
  This function can be completed using `height` DMA calls.
*/
void undrawImageDMA(int row, int col, int width, int height, const u16 *image) {
  // TODO: IMPLEMENT
  UNUSED(row);
  UNUSED(col);
  UNUSED(width);
  UNUSED(height);
  UNUSED(image);
}

/*
  Fills the video buffer with a given color.
  This function can be completed using a single DMA call.
*/
void fillScreenDMA(volatile u16 color) {
  DMA[3].src = &color;
  DMA[3].dst = videoBuffer;
  DMA[3].cnt = 2400000000000000 | DMA_ON | DMA_16 | DMA_SOURCE_FIXED | DMA_DESTINATION_INCREMENT;
}

/* STRING-DRAWING FUNCTIONS (provided) */
void drawChar(int row, int col, char ch, u16 color) {
  for(int r = 0; r<8; r++) {
      for(int c=0; c<6; c++) {
          if(fontdata_6x8[OFFSET(r, c, 6) + ch*48]) {
              setPixel(col+c, row+r, color);
          }
      }
  }
}

void drawString(int row, int col, char *str, u16 color) {
  while (*str) {
    drawChar(row, col, *str++, color);
    row += 6;
  }
}

void drawCenteredString(int row, int col, int width, int height, char *str, u16 color) {
  u32 len = 0;
  char *strCpy = str;
  while (*strCpy) {
    len++;
    strCpy++;
  }

  u32 strWidth = 6 * len;
  u32 strHeight = 8;

  int new_row = row + ((height - strHeight) >> 1);
  int new_col = col + ((width - strWidth) >> 1);
  drawString(new_row, new_col, str, color);
}

void drawStar(int row, int col) {
  setPixel(row, col, ORANGE);
  col++;
  for (int i = 0; i < 2; i++) {
    setPixel(row - 1, col, ORANGE);
    setPixel(row, col, YELLOW);
    setPixel(row + 1, col, ORANGE);
    col++;
  }
  for (int i = 0; i < 2; i++) {
    setPixel(row - 2, col, ORANGE);
    setPixel(row - 1, col, YELLOW);
    setPixel(row, col, YELLOW);
    setPixel(row + 1, col, YELLOW);
    setPixel(row + 2, col, ORANGE);
    col++;
  }
  int newRow = row - 7;
  for (int i = 0; i < 4; i++) {
    setPixel(newRow, col, ORANGE);
    newRow++;
  }
  for (int i = 0; i < 7; i++) {
    setPixel(newRow, col, YELLOW);
    newRow++;
  }
  for (int i = 0; i < 4; i++) {
    setPixel(newRow, col, ORANGE);
    newRow++;
  }
  col++;
  newRow = row - 10;
  for (int i = 0; i < 3; i++) {
    setPixel(newRow, col, ORANGE);
    newRow++;
  }
  for (int i = 0; i < 15; i++) {
    setPixel(newRow, col, YELLOW);
    newRow++;
  }
  for (int i = 0; i < 3; i++) {
    setPixel(newRow, col, ORANGE);
    newRow++;
  }
  col++;
  newRow = row - 9;
  setPixel(newRow, col, ORANGE);
  for (int i = 0; i < 17; i++) {
    setPixel(newRow + 1, col, YELLOW);
    newRow++;
  }
  setPixel(newRow + 1, col, ORANGE);
  col++;
  newRow = row - 8;
  setPixel(newRow, col, ORANGE);
  for (int i = 0; i < 15; i++) {
    setPixel(newRow + 1, col, YELLOW);
    newRow++;
  }
  setPixel(newRow + 1, col, ORANGE);
  col++;
  newRow = row - 7;
  setPixel(newRow, col, ORANGE);
  for (int i = 0; i < 13; i++) {
    setPixel(newRow + 1, col, YELLOW);
    newRow++;
  }
  setPixel(newRow + 1, col, ORANGE);
  col++;
  for (int j = 0; j < 2; j++) {
    newRow = row - 6;
    setPixel(newRow, col, ORANGE);
    for (int i = 0; i < 11; i++) {
      setPixel(newRow + 1, col, YELLOW);
      newRow++;
    }
    setPixel(newRow + 1, col, ORANGE);
    col++;
  }
  int rowNumber = 7;
  int iNumber = 13;
  for (int j = 0; j < 2; j++) {
    newRow = row - rowNumber;
    setPixel(newRow, col, ORANGE);
    for (int i = 0; i < iNumber; i++) {
      setPixel(newRow + 1, col, YELLOW);
      newRow++;
    }
    setPixel(newRow + 1, col, ORANGE);
    col++;
    rowNumber++;
    iNumber += 2;
  }
  newRow = row - rowNumber + 1;
  setPixel(newRow, col, ORANGE);
  for (int i = 0; i < (iNumber - 2); i++) {
    setPixel(newRow + 1, col, YELLOW);
    newRow++;
  }
  setPixel(row - 1, col - 1, ORANGE);
  setPixel(row + 1, col - 1, ORANGE);
  setPixel(row, col - 1, ORANGE);
  setPixel(row, col, BLACK);
  setPixel(row - 1, col, BLACK);
  setPixel(row - 2, col, ORANGE);
  setPixel(row + 1, col, BLACK);
  setPixel(row + 2, col, ORANGE);
  setPixel(row - 3, col, ORANGE);
  setPixel(row + 3, col, ORANGE);
  setPixel(newRow + 1, col, ORANGE);
  setPixel(newRow, col + 1, ORANGE);
  setPixel(newRow - 1, col + 1, ORANGE);
  setPixel(newRow - 2, col + 1, ORANGE);
  col++;
  newRow = row - rowNumber + 2;
  setPixel(newRow, col, ORANGE);
  setPixel(newRow + 1, col, ORANGE);
  setPixel(newRow + 2, col, ORANGE);
}

void drawSprite(int row, int col, u16 color) {
  setPixel(row, col, BLUE);
  col++;
  for (int i = 0; i < 2; i++) {
    setPixel(row - 1, col, BLUE);
    setPixel(row, col, color);
    setPixel(row + 1, col, BLUE);
    col++;
  }
  for (int i = 0; i < 2; i++) {
    setPixel(row - 2, col, BLUE);
    setPixel(row - 1, col, color);
    setPixel(row, col, color);
    setPixel(row + 1, col, color);
    setPixel(row + 2, col, BLUE);
    col++;
  }
  int newRow = row - 7;
  for (int i = 0; i < 4; i++) {
    setPixel(newRow, col, BLUE);
    newRow++;
  }
  for (int i = 0; i < 7; i++) {
    setPixel(newRow, col, color);
    newRow++;
  }
  for (int i = 0; i < 4; i++) {
    setPixel(newRow, col, BLUE);
    newRow++;
  }
  col++;
  newRow = row - 10;
  for (int i = 0; i < 3; i++) {
    setPixel(newRow, col, BLUE);
    newRow++;
  }
  for (int i = 0; i < 15; i++) {
    setPixel(newRow, col, color);
    newRow++;
  }
  for (int i = 0; i < 3; i++) {
    setPixel(newRow, col, BLUE);
    newRow++;
  }
  col++;
  newRow = row - 9;
  setPixel(newRow, col, BLUE);
  for (int i = 0; i < 17; i++) {
    setPixel(newRow + 1, col, color);
    newRow++;
  }
  setPixel(newRow + 1, col, BLUE);
  col++;
  newRow = row - 8;
  setPixel(newRow, col, BLUE);
  for (int i = 0; i < 15; i++) {
    setPixel(newRow + 1, col, color);
    newRow++;
  }
  setPixel(newRow + 1, col, BLUE);
  col++;
  newRow = row - 7;
  setPixel(newRow, col, BLUE);
  for (int i = 0; i < 13; i++) {
    setPixel(newRow + 1, col, color);
    newRow++;
  }
  setPixel(newRow + 1, col, BLUE);
  col++;
  for (int j = 0; j < 2; j++) {
    newRow = row - 6;
    setPixel(newRow, col, BLUE);
    for (int i = 0; i < 11; i++) {
      setPixel(newRow + 1, col, color);
      newRow++;
    }
    setPixel(newRow + 1, col, BLUE);
    col++;
  }
  int rowNumber = 7;
  int iNumber = 13;
  for (int j = 0; j < 2; j++) {
    newRow = row - rowNumber;
    setPixel(newRow, col, BLUE);
    for (int i = 0; i < iNumber; i++) {
      setPixel(newRow + 1, col, color);
      newRow++;
    }
    setPixel(newRow + 1, col, BLUE);
    col++;
    rowNumber++;
    iNumber += 2;
  }
  newRow = row - rowNumber + 1;
  setPixel(newRow, col, BLUE);
  for (int i = 0; i < (iNumber - 2); i++) {
    setPixel(newRow + 1, col, color);
    newRow++;
  }
  setPixel(row - 1, col - 1, BLUE);
  setPixel(row + 1, col - 1, BLUE);
  setPixel(row, col - 1, BLUE);
  if ((row > 200) & (col > 140)) {
    setPixel(row, col, GREEN);
    setPixel(row - 1, col, GREEN);
    setPixel(row + 1, col, GREEN);
  } else {
    setPixel(row, col, BLACK);
    setPixel(row - 1, col, BLACK);
    setPixel(row + 1, col, BLACK);
  }
  setPixel(row - 2, col, BLUE);
  setPixel(row + 2, col, BLUE);
  setPixel(row - 3, col, BLUE);
  setPixel(row + 3, col, BLUE);
  setPixel(newRow + 1, col, BLUE);
  setPixel(newRow, col + 1, BLUE);
  setPixel(newRow - 1, col + 1, BLUE);
  setPixel(newRow - 2, col + 1, BLUE);
  col++;
  newRow = row - rowNumber + 2;
  setPixel(newRow, col, BLUE);
  setPixel(newRow + 1, col, BLUE);
  setPixel(newRow + 2, col, BLUE);
}

void drawGoalTile(u16 color) {
  for (int i = 200; i < 240; i++) {
    for (int j = 140; j < 160; j++) {
      setPixel(i, j, color);
    }
  }
}

void unDrawStar(int row, int col) {
  setPixel(row, col, BLACK);
  col++;
  for (int i = 0; i < 2; i++) {
    setPixel(row - 1, col, BLACK);
    setPixel(row, col, BLACK);
    setPixel(row + 1, col, BLACK);
    col++;
  }
  for (int i = 0; i < 2; i++) {
    setPixel(row - 2, col, BLACK);
    setPixel(row - 1, col, BLACK);
    setPixel(row, col, BLACK);
    setPixel(row + 1, col, BLACK);
    setPixel(row + 2, col, BLACK);
    col++;
  }
  int newRow = row - 7;
  for (int i = 0; i < 4; i++) {
    setPixel(newRow, col, BLACK);
    newRow++;
  }
  for (int i = 0; i < 7; i++) {
    setPixel(newRow, col, BLACK);
    newRow++;
  }
  for (int i = 0; i < 4; i++) {
    setPixel(newRow, col, BLACK);
    newRow++;
  }
  col++;
  newRow = row - 10;
  for (int i = 0; i < 3; i++) {
    setPixel(newRow, col, BLACK);
    newRow++;
  }
  for (int i = 0; i < 15; i++) {
    setPixel(newRow, col, BLACK);
    newRow++;
  }
  for (int i = 0; i < 3; i++) {
    setPixel(newRow, col, BLACK);
    newRow++;
  }
  col++;
  newRow = row - 9;
  setPixel(newRow, col, BLACK);
  for (int i = 0; i < 17; i++) {
    setPixel(newRow + 1, col, BLACK);
    newRow++;
  }
  setPixel(newRow + 1, col, BLACK);
  col++;
  newRow = row - 8;
  setPixel(newRow, col, BLACK);
  for (int i = 0; i < 15; i++) {
    setPixel(newRow + 1, col, BLACK);
    newRow++;
  }
  setPixel(newRow + 1, col, BLACK);
  col++;
  newRow = row - 7;
  setPixel(newRow, col, BLACK);
  for (int i = 0; i < 13; i++) {
    setPixel(newRow + 1, col, BLACK);
    newRow++;
  }
  setPixel(newRow + 1, col, BLACK);
  col++;
  for (int j = 0; j < 2; j++) {
    newRow = row - 6;
    setPixel(newRow, col, BLACK);
    for (int i = 0; i < 11; i++) {
      setPixel(newRow + 1, col, BLACK);
      newRow++;
    }
    setPixel(newRow + 1, col, BLACK);
    col++;
  }
  int rowNumber = 7;
  int iNumber = 13;
  for (int j = 0; j < 2; j++) {
    newRow = row - rowNumber;
    setPixel(newRow, col, BLACK);
    for (int i = 0; i < iNumber; i++) {
      setPixel(newRow + 1, col, BLACK);
      newRow++;
    }
    setPixel(newRow + 1, col, BLACK);
    col++;
    rowNumber++;
    iNumber += 2;
  }
  newRow = row - rowNumber + 1;
  setPixel(newRow, col, BLACK);
  for (int i = 0; i < (iNumber - 2); i++) {
    setPixel(newRow + 1, col, BLACK);
    newRow++;
  }
  setPixel(row - 1, col - 1, BLACK);
  setPixel(row + 1, col - 1, BLACK);
  setPixel(row, col - 1, BLACK);
  setPixel(row, col, BLACK);
  setPixel(row - 1, col, BLACK);
  setPixel(row - 2, col, BLACK);
  setPixel(row + 1, col, BLACK);
  setPixel(row + 2, col, BLACK);
  setPixel(row - 3, col, BLACK);
  setPixel(row + 3, col, BLACK);
  setPixel(newRow + 1, col, BLACK);
  setPixel(newRow, col + 1, BLACK);
  setPixel(newRow - 1, col + 1, BLACK);
  setPixel(newRow - 2, col + 1, BLACK);
  col++;
  newRow = row - rowNumber + 2;
  setPixel(newRow, col, BLACK);
  setPixel(newRow + 1, col, BLACK);
  setPixel(newRow + 2, col, BLACK);
}