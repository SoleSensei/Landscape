#ifndef DIAMOND_H
#define DIAMOND_H

#include <cmath>
#include <cstdlib>
#include <ctime>
#include <algorithm>
#include <assert.h>
#include "landscape.h"

void square_step(int x, int y, int step);
void diamond_step(int x, int y, int step);

void diamond_square(const int size){
    
    assert(terrain_size > std::min(m_rows, m_cols));
    if (isRandom)
        srand(time(NULL)); 
    map[0][0] = 1;
    map[0][terrain_size-1] = -5;
    map[terrain_size-1][0] = 20;
    map[terrain_size-1][terrain_size-1] = 10;

    int step_size = size - 1;

    while(step_size > 1) {
        
        for(uint x = 0; x < size-1; x += step_size)
            for(uint y = 0; y < size-1; y += step_size)
                square_step(x, y, step_size); 
        
        for(uint x = step_size/2; x < size-1; x += step_size)
            for(uint y = step_size/2; y < size-1; y += step_size)
                diamond_step(x, y, step_size);

        step_size /= 2;
    }
}

void square_step(int x, int y, int step) {
    
    float r = roughness;
    int half = step / 2;

    float a = map[x][y]; 
    float b = map[x+step][y]; 
    float c = map[x][y+step]; 
    float d = map[x+step][y+step]; 

    float average = (a + b + c + d) / 4;
    float random_range = -r * half + rand() % int(2*r*half + 1); 
    
    map[x + half][y + half] = average + random_range;
}

void diamond_step(int x, int y, int step) {
    
    float r = roughness;    
    int half = step / 2;
    float a,b,c;    
    float random_range = -r * half + rand() % int(2*r*half + 1); 
    float average;
    
    a = map[x][y]; 
    
    b = map[x-half][y-half]; 
    c = map[x-half][y+half]; 
    average = (a + b + c) / 3;
    random_range = -r * half + rand() % int(2*r*half + 1);     
    map[x-half][y] = average + random_range;

    c = map[x+half][y-half]; 
    average = (a + b + c) / 3;
    random_range = -r * half + rand() % int(2*r*half + 1);     
    map[x][y-half] = average + random_range;

    b = map[x+half][y+half]; 
    average = (a + b + c) / 3;
    random_range = -r * half + rand() % int(2*r*half + 1);     
    map[x+half][y] = average + random_range;

    c = map[x-half][y+half]; 
    average = (a + b + c) / 3;
    random_range = -r * half + rand() % int(2*r*half + 1);     
    map[x][y+half] = average + random_range;
}

#endif