import processing.sound.*;
// returns whether or not a box defined by (x1, y1, w1, h1) is touching the box defined by (x2, y2, w2, h2)
boolean boxCollided(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
  return x1 + w1 > x2 && x1 < x2 + w2 && y1 + h1 > y2 && y1 < y2 + h2;
}

// returns whether or not the line segment (x1, y1)-(x1, y2) touches the line segment (sx2, sy2)-(ex2, ey2)
boolean lineIntersectsVertical(float x1, float y1, float y2, float sx2, float sy2, float ex2, float ey2) {
  // if the two slopes are equal, then they touch only if they have the same x value
  if (ex2==sx2) {
    return sx2 == x1;
  }
  
  // get the slope and intersect of the second line
  float l2slope = (ey2 - sy2)/(ex2-sx2);
  float l2intersect = sy2 - l2slope * sx2;
  
  // get the intersection point of the two lines
  float yAtIntersect = l2slope * x1 + l2intersect;
  
  // return if the intersection point is "inside" both of the line segments
  return sx2 < x1 && x1 < ex2 && y1 < yAtIntersect && yAtIntersect < y2;
}

// returns if the line segment defined by (sx1, sy1)-(ex1, ey1) intersects with the line defined by (sx2, sy2)-(ex2, ey2)
boolean lineIntersects(float sx1, float sy1, float ex1, float ey1, float sx2, float sy2, float ex2, float ey2) {
  // if sx1 is the same as ex1, then the first line is vertical
  if (sx1 == ex1)
    return lineIntersectsVertical(sx1, sy1, ey1, sx2, sy2, ex2, ey2);
  // if sx2 = ex2, then the second line is vertical
  if (sx2 == ex2)
    return lineIntersectsVertical(sx2, sy2, ey2, sx1, sy1, ex1, ey1);
    
  // get the slope and intersects of both line (to define them as an equation)
  float l1slope = (ey1-sy1)/(ex1-sx1);
  float l2slope = (ey2-sy2)/(ex2-sx2);
  float l1intersect = sy1 - l1slope * sx1;
  float l2intersect = sy2 - l2slope * sx2;

  // if the two slopes are equal, then they are parallel. They are equal if and only if they have a common point at x=0
  if (l1slope == l2slope)
    return l1intersect == l2intersect;
    
  // a formula for calculating the y coordinate of the intersect of the two lines 
  float intersectY = (l1intersect*l2slope-l2intersect*l1slope)/(l2slope-l1slope);
  float intersectX;
  if (l1slope != 0) {
    // if the first line does not have a slope of 0, then we can solve for the intersection point of the x coordinate
    intersectX = (intersectY - l1intersect) / l1slope;
  } else {
    // if the x coordinate is 0, then we can just use the second slope to calculate the intersection point (note that they can't both be equal to 0 since we checked for equality earlier)
    intersectX = (intersectY - l2intersect) / l2slope;
  }
  
  // we return if the intersection point is "inside" both of the lines
  return (sy1 < intersectY) == (intersectY < ey1) && (sy2 < intersectY) == (intersectY < ey2) && (sx1 < intersectX) == (intersectX < ex1) && (sx2 < intersectX) == (intersectX < ex2);
}

// returns the distance from (x1,y1) to (x2, y2)
float pointDistance(float x1, float y1, float x2, float y2) {
  return magnitude(x2 - x1, y2 - y1);
}

// returns the clockwise angle of the vector defined by (x,y) from the vector in the direction "right"
float angleOf(float x, float y) {
  if (x > 0)
    return asin(y / sqrt(pow(x, 2) + pow(y, 2)));
  else
    return PI - asin(y / sqrt(pow(x, 2) + pow(y, 2)));
}

// gets the track (usually sound effects or music) at filePath
SoundFile getTrack(String filePath){
  return new SoundFile(this, filePath);
}

// returns the magnitude of the vector (x,y)
float magnitude (float x, float y){
 return sqrt(pow(x, 2) + pow(y, 2)); 
}
