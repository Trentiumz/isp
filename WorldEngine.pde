// Entities are the main "things" in the world. In this case they're used for collision detection and to store dimensions of other things
class Entity {
  // dimensions of the entity
  float x, y, w, h;
  Entity(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  // return if a point is inside this entity
  boolean inRange(float x, float y) {
    return this.x < x && x < this.x + this.w && this.y < y && y < this.y + this.h;
  }
  
  // returns if this entity is "touching" the Entity other
  boolean collided(Entity other) {
    return boxCollided(x, y, w, h, other.x, other.y, other.w, other.h);
  }
  
  // returns the distance from this entity to the Entity other (note that the entity is a rectangle, so it's slightly different)
  float distance(Entity other) {
    // the minimum horizontal distance to the other entity
    float horizontalDist;
    // if the other entity is either "above" or "below" the current entity, then the horizontal distance is 0
    if (other.x <= this.x + this.w && other.x + other.w >= this.x)
      horizontalDist = 0;
    else
      // otherwise, take the minimum of the distance when the entity is to the right or to the left of the current entity
      horizontalDist = min(abs(other.x + other.w - this.x), abs(this.x + this.w - other.x));

    // the minimumvertical distance
    float verticalDist;
    // if the entity is to the left or right of the current entity, then vertical distance is 0
    if (other.y <= this.y + this.h && other.y + other.h >= this.y)
      verticalDist = 0;
    else
      // otherwise, take the minimum of when the entity is to the top vs when the entity is to the bottom of the current one
      verticalDist = min(abs(other.y + other.h - this.y), abs(this.y + this.h - other.y));
      
    // return the magnitude of the horizontal and vertical components
    return magnitude(horizontalDist, verticalDist);
  }
  
  // returns the distance from this entity to a point
  float distance(float ox, float oy){
   // the minimum horizontal distance
   float horizontalDist;
   // if the point is "inside" the entity, then there is 0 distance
   if(x <= ox && ox <= x + w)
     horizontalDist = 0;
   else
     // get the minimum of its distance from the right and left side
     horizontalDist = min(abs(ox - x), abs(ox - (x + w)));
     
   // vertical distance
   float verticalDist;
   
   if(y <= oy && oy <= y + h)
     // if point is "inside" the box 
     verticalDist = 0;
   else
     // minimum of the right and left sides
     verticalDist = min(abs(oy - y), abs(oy - (y + h)));
     
   // return the magnitude of the horizontal and vertical distances
   return magnitude(horizontalDist, verticalDist);
  }
  
  // returns whether or not the line will intersect this current entity
  boolean lineHits(float sx, float sy, float ex, float ey) {
    // check for whether or not the line hits any one the "edges" of the entity
    boolean hitsTop = lineIntersects(x, y, x + w, y, sx, sy, ex, ey);
    boolean hitsLeft = lineIntersects(x, y, x, y + h, sx, sy, ex, ey);
    boolean hitsRight = lineIntersects(x + w, y, x + w, y + h, sx, sy, ex, ey);
    boolean hitsBot = lineIntersects(x, y + h, x + w, y + h, sx, sy, ex, ey);
    
    // if the line doesn't intersect, it might be because the entire line is inside the entity
    boolean lineInside = x <= sx && sx <= x + w && y <= sy && sy <= y + h;

    // return if there is any intersection, or if the line is inside the entity
    return hitsTop || hitsLeft || hitsRight || hitsBot || lineInside;
  }
  
  // returns the x component of the center of this entity
  float centerX() {
    return x + w / 2;
  }
  
  // returns the y component of the center of this entity
  float centerY() {
    return y + h / 2;
  }
  
  // returns whether or not the entity "hits" the box with coordinates (x1, y1) and dimensions (w, h)
  boolean hitsBox(float bx, float by, float bw, float bh){
    return boxCollided(x, y, w, h, bx, by, bw, bh);
  }
}

class World {
  // the entities in this world
  ArrayList<Entity> entities;
  Camera camera; // the camera (used to follow the player)
  final static int gridSize = 50; // a variable for the grid size of this world (should be constant)
  float worldWidth; // the width of this world
  float worldHeight; // the height of this world
  boolean walkable[][]; // tilemapping for whether or not each "tile" is walkable

  World(boolean[][] walkable) {
    // initialize variables
    this.walkable = walkable;
    worldHeight = walkable.length * gridSize;
    worldWidth = walkable[0].length * gridSize; // we can calculate the width and height of this world from the tilemapping and grid size
    entities = new ArrayList<Entity>();
    camera = new Camera(0, 0);
  }
  // returns if the screen clicked the Entity wanted
  boolean clicked(Entity wanted, float screenX, float screenY) {
    return wanted.inRange(camera.getRealX(screenX), camera.getRealY(screenY));
  }
  
  // adds an entity to the world
  void addEntity(Entity toAdd) {
    this.entities.add(toAdd);
  }

  // move an entity as long as it won't result in the entity "colliding" into another
  void moveEntitySoft(Entity toMove, float xDiff, float yDiff) {
    if (!willCollideIntoEntity(toMove, xDiff, 0) && !willCollideIntoWall(toMove, xDiff, 0))
      toMove.x += xDiff;
    if (!willCollideIntoEntity(toMove, 0, yDiff) && !willCollideIntoWall(toMove, 0, yDiff))
      toMove.y += yDiff;
  }

  // move the entity forcefully, but stay within the constraints of the map
  void moveEntity(Entity toMove, float xDiff, float yDiff) {
    if (!willCollideIntoWall(toMove, xDiff, 0))
      toMove.x += xDiff;

    if (!willCollideIntoWall(toMove, 0, yDiff))
      toMove.y += yDiff;
  }

  // forcefully move the entity
  void moveEntityHard(float xDiff, float yDiff, Entity toMove) {
    toMove.x += xDiff;
    toMove.y += yDiff;
  }

  // returns whether or not a move will result in an entity colliding into the wall
  boolean willCollideIntoWall(Entity toMove, float xDiff, float yDiff) {
    // get which "path squares" are within the range of the player
    int startX = (int) (toMove.x / gridSize);
    int startY = (int) (toMove.y / gridSize);
    int endX = (int) ((toMove.x + toMove.w) / gridSize);
    int endY = (int) ((toMove.y + toMove.h) / gridSize);

    // loop through all of these squares
    for (int y = max(0, startY - 1); y <= min(walkable.length - 1, endY + 1); ++y)
      for (int x = max(0, startX - 1); x <= min(walkable[y].length - 1, endX + 1); ++x)
        // if the square is a wall, and we haven't collided into it, but will collide into it, then we return that we will collide into a wall
        //    we check to make sure we aren't inside the wall right now because moving won't result in a collision, and it helps us to "break out" of a wall if we're stuck in it
        if (!walkable[y][x] && 
          !boxCollided(toMove.x, toMove.y, toMove.w, toMove.h, x * gridSize, y * gridSize, gridSize, gridSize) && 
          boxCollided(toMove.x + xDiff, toMove.y + yDiff, toMove.w, toMove.h, x * gridSize, y * gridSize, gridSize, gridSize))
          return true;
    return false;
  }

  // returns whether or not moving an entity will result in it colliding into another entity
  boolean willCollideIntoEntity(Entity toMove, float xDiff, float yDiff) {
    for (Entity other : this.entities)
      // If you weren't "inside" the other entity, but moving will result in you colliding
      //   we check to make sure that we aren't currently "collided" because it helps prevent "locks" where an entity is stuck inside another
      if (other != toMove && !toMove.collided(other) && 
        boxCollided(toMove.x + xDiff, toMove.y + yDiff, toMove.w, toMove.h, other.x, other.y, other.w, other.h))
        return true;
    return false;
  }
}

// the camera for drawing a larger world onto the screen
class Camera {
  float x, y; // x and y values for the camera
  Camera(float x, float y) {
    // initialize variables
    this.x = x;
    this.y = y;
  }
  
  // alters the matrix so that drawing onto the world "using normal graphic functions" will result in its proper position relative to the screen
  void alterMatrix() {
    translate(-x, -y);
  }
  
  // update coordinates so that it's centered on an Entity
  void centerOnEntity(Entity toCenter) {
    this.x = toCenter.x + toCenter.w / 2 - width / 2;
    this.y = toCenter.y + toCenter.h / 2 - height / 2;
  }
  
  // get the x value in the world of a coordinate on the screen
  float getRealX(float curX) {
    return curX + x;
  }
  
  // get the y value in the world of a coordinate on the screen
  float getRealY(float curY) {
    return curY + y;
  }
}
