#ifndef MAIN_H
#define MAIN_H

#include "gba.h"

// TODO: Create any necessary structs

struct Sprite {
    int row;
    int col;
    int score;
    int goingRight;
    u16 color;
};

struct GoalTile {
    int row;
    int col;
    int rowEnd;
    int colEnd;
};

struct Star {
    int row;
    int col;
    int caught;
};

/*
* For example, for a Snake game, one could be:
*
* struct snake {
*   int heading;
*   int length;
*   int row;
*   int col;
* };
*
* Example of a struct to hold state machine data:
*
* struct state {
*   int currentState;
*   int nextState;
* };
*
*/

#endif
