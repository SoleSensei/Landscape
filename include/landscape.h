#ifndef MAP_H
#define MAP_H


const int m_rows = 200;
const int m_cols = 200;
//  log2(std::max(m_rows, m_cols)) + 1;
const int terrain_size = 2*2*2*2*2*2*2*2+1; // terrain_size < max(rows,cols)  
float map[terrain_size][terrain_size];
const float roughness = 0.3;
bool isRandom = true;



#endif