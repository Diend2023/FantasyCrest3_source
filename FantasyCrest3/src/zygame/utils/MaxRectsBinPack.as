package zygame.utils
{
   import flash.geom.Rectangle;
   
   public class MaxRectsBinPack
   {
      
      public static const BESTSHORTSIDEFIT:int = 0;
      
      public static const BESTLONGSIDEFIT:int = 1;
      
      public static const BESTAREAFIT:int = 2;
      
      public static const BOTTOMLEFTRULE:int = 3;
      
      public static const CONTACTPOINTRULE:int = 4;
      
      public var binWidth:int = 0;
      
      public var binHeight:int = 0;
      
      public var allowRotations:Boolean = false;
      
      public var usedRectangles:Vector.<Rectangle> = new Vector.<Rectangle>();
      
      public var freeRectangles:Vector.<Rectangle> = new Vector.<Rectangle>();
      
      private var score1:int = 0;
      
      private var score2:int = 0;
      
      private var bestShortSideFit:int;
      
      private var bestLongSideFit:int;
      
      public function MaxRectsBinPack(width:int, height:int, rotations:Boolean = false)
      {
         super();
         init(width,height,rotations);
      }
      
      private function init(width:int, height:int, rotations:Boolean = false) : void
      {
         if(count(width) % 1 != 0 || count(height) % 1 != 0)
         {
            throw new Error("Must be 2,4,8,16,32,...512,1024,...");
         }
         binWidth = width;
         binHeight = height;
         allowRotations = rotations;
         var n:Rectangle = new Rectangle();
         n.x = 0;
         n.y = 0;
         n.width = width;
         n.height = height;
         usedRectangles.length = 0;
         freeRectangles.length = 0;
         freeRectangles.push(n);
      }
      
      private function count(n:Number) : Number
      {
         if(n >= 2)
         {
            return count(n / 2);
         }
         return n;
      }
      
      public function insert(width:int, height:int, method:int) : Rectangle
      {
         var newNode:Rectangle = new Rectangle();
         score1 = 0;
         score2 = 0;
         switch(method)
         {
            case 0:
               newNode = findPositionForNewNodeBestShortSideFit(width,height);
               break;
            case 1:
               newNode = findPositionForNewNodeBestLongSideFit(width,height,score2,score1);
               break;
            case 2:
               newNode = findPositionForNewNodeBestAreaFit(width,height,score1,score2);
               break;
            case 3:
               newNode = findPositionForNewNodeBottomLeft(width,height,score1,score2);
               break;
            case 4:
               newNode = findPositionForNewNodeContactPoint(width,height,score1);
         }
         if(newNode.height == 0)
         {
            return newNode;
         }
         placeRectangle(newNode);
         return newNode;
      }
      
      private function insert2(Rectangles:Vector.<Rectangle>, dst:Vector.<Rectangle>, method:int) : void
      {
         var bestScore1:* = 0;
         var bestScore2:* = 0;
         var bestRectangleIndex:* = 0;
         var bestNode:* = null;
         var i:int = 0;
         var score1:int = 0;
         var score2:int = 0;
         var newNode:Rectangle = null;
         dst.length = 0;
         while(Rectangles.length > 0)
         {
            bestScore1 = 2147483647;
            bestScore2 = 2147483647;
            bestRectangleIndex = -1;
            bestNode = new Rectangle();
            for(i = 0; i < Rectangles.length; )
            {
               score1 = 0;
               score2 = 0;
               newNode = scoreRectangle(Rectangles[i].width,Rectangles[i].height,method,score1,score2);
               if(score1 < bestScore1 || score1 == bestScore1 && score2 < bestScore2)
               {
                  bestScore1 = score1;
                  bestScore2 = score2;
                  bestNode = newNode;
                  bestRectangleIndex = i;
               }
               i++;
            }
            if(bestRectangleIndex == -1)
            {
               return;
            }
            placeRectangle(bestNode);
            Rectangles.splice(bestRectangleIndex,1);
         }
      }
      
      private function placeRectangle(node:Rectangle) : void
      {
         var i:int = 0;
         var numRectanglesToProcess:int = int(freeRectangles.length);
         for(i = 0; i < numRectanglesToProcess; )
         {
            if(splitFreeNode(freeRectangles[i],node))
            {
               freeRectangles.splice(i,1);
               i--;
               numRectanglesToProcess--;
            }
            i++;
         }
         pruneFreeList();
         usedRectangles.push(node);
      }
      
      private function scoreRectangle(width:int, height:int, method:int, score1:int, score2:int) : Rectangle
      {
         var newNode:Rectangle = new Rectangle();
         score1 = 2147483647;
         score2 = 2147483647;
         switch(method)
         {
            case 0:
               newNode = findPositionForNewNodeBestShortSideFit(width,height);
               break;
            case 1:
               newNode = findPositionForNewNodeBestLongSideFit(width,height,score2,score1);
               break;
            case 2:
               newNode = findPositionForNewNodeBestAreaFit(width,height,score1,score2);
               break;
            case 3:
               newNode = findPositionForNewNodeBottomLeft(width,height,score1,score2);
               break;
            case 4:
               newNode = findPositionForNewNodeContactPoint(width,height,score1);
               score1 = -score1;
         }
         if(newNode.height == 0)
         {
            score1 = 2147483647;
            score2 = 2147483647;
         }
         return newNode;
      }
      
      private function occupancy() : Number
      {
         var i:int = 0;
         var usedSurfaceArea:Number = 0;
         for(i = 0; i < usedRectangles.length; )
         {
            usedSurfaceArea += usedRectangles[i].width * usedRectangles[i].height;
            i++;
         }
         return usedSurfaceArea / (binWidth * binHeight);
      }
      
      private function findPositionForNewNodeBottomLeft(width:int, height:int, bestY:int, bestX:int) : Rectangle
      {
         var rect:Rectangle = null;
         var topSideY:int = 0;
         var i:int = 0;
         var bestNode:Rectangle = new Rectangle();
         bestY = 2147483647;
         for(i = 0; i < freeRectangles.length; )
         {
            rect = freeRectangles[i];
            if(rect.width >= width && rect.height >= height)
            {
               topSideY = rect.y + height;
               if(topSideY < bestY || topSideY == bestY && rect.x < bestX)
               {
                  bestNode.x = rect.x;
                  bestNode.y = rect.y;
                  bestNode.width = width;
                  bestNode.height = height;
                  bestY = topSideY;
                  bestX = rect.x;
               }
            }
            if(allowRotations && rect.width >= height && rect.height >= width)
            {
               topSideY = rect.y + width;
               if(topSideY < bestY || topSideY == bestY && rect.x < bestX)
               {
                  bestNode.x = rect.x;
                  bestNode.y = rect.y;
                  bestNode.width = height;
                  bestNode.height = width;
                  bestY = topSideY;
                  bestX = rect.x;
               }
            }
            i++;
         }
         return bestNode;
      }
      
      private function findPositionForNewNodeBestShortSideFit(width:int, height:int) : Rectangle
      {
         var rect:Rectangle = null;
         var leftoverHoriz:int = 0;
         var leftoverVert:int = 0;
         var shortSideFit:int = 0;
         var longSideFit:int = 0;
         var i:int = 0;
         var flippedLeftoverHoriz:int = 0;
         var flippedLeftoverVert:int = 0;
         var flippedShortSideFit:int = 0;
         var flippedLongSideFit:int = 0;
         var bestNode:Rectangle = new Rectangle();
         bestShortSideFit = 2147483647;
         bestLongSideFit = score2;
         for(i = 0; i < freeRectangles.length; )
         {
            rect = freeRectangles[i];
            if(rect.width >= width && rect.height >= height)
            {
               leftoverHoriz = Math.abs(rect.width - width);
               leftoverVert = Math.abs(rect.height - height);
               shortSideFit = Math.min(leftoverHoriz,leftoverVert);
               longSideFit = Math.max(leftoverHoriz,leftoverVert);
               if(shortSideFit < bestShortSideFit || shortSideFit == bestShortSideFit && longSideFit < bestLongSideFit)
               {
                  bestNode.x = rect.x;
                  bestNode.y = rect.y;
                  bestNode.width = width;
                  bestNode.height = height;
                  bestShortSideFit = shortSideFit;
                  bestLongSideFit = longSideFit;
               }
            }
            if(allowRotations && rect.width >= height && rect.height >= width)
            {
               flippedLeftoverHoriz = Math.abs(rect.width - height);
               flippedLeftoverVert = Math.abs(rect.height - width);
               flippedShortSideFit = Math.min(flippedLeftoverHoriz,flippedLeftoverVert);
               flippedLongSideFit = Math.max(flippedLeftoverHoriz,flippedLeftoverVert);
               if(flippedShortSideFit < bestShortSideFit || flippedShortSideFit == bestShortSideFit && flippedLongSideFit < bestLongSideFit)
               {
                  bestNode.x = rect.x;
                  bestNode.y = rect.y;
                  bestNode.width = height;
                  bestNode.height = width;
                  bestShortSideFit = flippedShortSideFit;
                  bestLongSideFit = flippedLongSideFit;
               }
            }
            i++;
         }
         return bestNode;
      }
      
      private function findPositionForNewNodeBestLongSideFit(width:int, height:int, bestShortSideFit:int, bestLongSideFit:int) : Rectangle
      {
         var rect:Rectangle = null;
         var leftoverHoriz:int = 0;
         var leftoverVert:int = 0;
         var shortSideFit:int = 0;
         var longSideFit:int = 0;
         var i:int = 0;
         var bestNode:Rectangle = new Rectangle();
         bestLongSideFit = 2147483647;
         for(i = 0; i < freeRectangles.length; )
         {
            rect = freeRectangles[i];
            if(rect.width >= width && rect.height >= height)
            {
               leftoverHoriz = Math.abs(rect.width - width);
               leftoverVert = Math.abs(rect.height - height);
               shortSideFit = Math.min(leftoverHoriz,leftoverVert);
               longSideFit = Math.max(leftoverHoriz,leftoverVert);
               if(longSideFit < bestLongSideFit || longSideFit == bestLongSideFit && shortSideFit < bestShortSideFit)
               {
                  bestNode.x = rect.x;
                  bestNode.y = rect.y;
                  bestNode.width = width;
                  bestNode.height = height;
                  bestShortSideFit = shortSideFit;
                  bestLongSideFit = longSideFit;
               }
            }
            if(allowRotations && rect.width >= height && rect.height >= width)
            {
               leftoverHoriz = Math.abs(rect.width - height);
               leftoverVert = Math.abs(rect.height - width);
               shortSideFit = Math.min(leftoverHoriz,leftoverVert);
               longSideFit = Math.max(leftoverHoriz,leftoverVert);
               if(longSideFit < bestLongSideFit || longSideFit == bestLongSideFit && shortSideFit < bestShortSideFit)
               {
                  bestNode.x = rect.x;
                  bestNode.y = rect.y;
                  bestNode.width = height;
                  bestNode.height = width;
                  bestShortSideFit = shortSideFit;
                  bestLongSideFit = longSideFit;
               }
            }
            i++;
         }
         return bestNode;
      }
      
      private function findPositionForNewNodeBestAreaFit(width:int, height:int, bestAreaFit:int, bestShortSideFit:int) : Rectangle
      {
         var rect:Rectangle = null;
         var leftoverHoriz:int = 0;
         var leftoverVert:int = 0;
         var shortSideFit:int = 0;
         var areaFit:int = 0;
         var i:int = 0;
         var bestNode:Rectangle = new Rectangle();
         bestAreaFit = 2147483647;
         for(i = 0; i < freeRectangles.length; )
         {
            rect = freeRectangles[i];
            areaFit = rect.width * rect.height - width * height;
            if(rect.width >= width && rect.height >= height)
            {
               leftoverHoriz = Math.abs(rect.width - width);
               leftoverVert = Math.abs(rect.height - height);
               shortSideFit = Math.min(leftoverHoriz,leftoverVert);
               if(areaFit < bestAreaFit || areaFit == bestAreaFit && shortSideFit < bestShortSideFit)
               {
                  bestNode.x = rect.x;
                  bestNode.y = rect.y;
                  bestNode.width = width;
                  bestNode.height = height;
                  bestShortSideFit = shortSideFit;
                  bestAreaFit = areaFit;
               }
            }
            if(allowRotations && rect.width >= height && rect.height >= width)
            {
               leftoverHoriz = Math.abs(rect.width - height);
               leftoverVert = Math.abs(rect.height - width);
               shortSideFit = Math.min(leftoverHoriz,leftoverVert);
               if(areaFit < bestAreaFit || areaFit == bestAreaFit && shortSideFit < bestShortSideFit)
               {
                  bestNode.x = rect.x;
                  bestNode.y = rect.y;
                  bestNode.width = height;
                  bestNode.height = width;
                  bestShortSideFit = shortSideFit;
                  bestAreaFit = areaFit;
               }
            }
            i++;
         }
         return bestNode;
      }
      
      private function commonIntervalLength(i1start:int, i1end:int, i2start:int, i2end:int) : int
      {
         if(i1end < i2start || i2end < i1start)
         {
            return 0;
         }
         return Math.min(i1end,i2end) - Math.max(i1start,i2start);
      }
      
      private function contactPointScoreNode(x:int, y:int, width:int, height:int) : int
      {
         var rect:Rectangle = null;
         var i:int = 0;
         var score:int = 0;
         if(x == 0 || x + width == binWidth)
         {
            score += height;
         }
         if(y == 0 || y + height == binHeight)
         {
            score += width;
         }
         for(i = 0; i < usedRectangles.length; )
         {
            rect = usedRectangles[i];
            if(rect.x == x + width || rect.x + rect.width == x)
            {
               score += commonIntervalLength(rect.y,rect.y + rect.height,y,y + height);
            }
            if(rect.y == y + height || rect.y + rect.height == y)
            {
               score += commonIntervalLength(rect.x,rect.x + rect.width,x,x + width);
            }
            i++;
         }
         return score;
      }
      
      private function findPositionForNewNodeContactPoint(width:int, height:int, bestContactScore:int) : Rectangle
      {
         var rect:Rectangle = null;
         var score:int = 0;
         var i:int = 0;
         var bestNode:Rectangle = new Rectangle();
         bestContactScore = -1;
         for(i = 0; i < freeRectangles.length; )
         {
            rect = freeRectangles[i];
            if(rect.width >= width && rect.height >= height)
            {
               score = contactPointScoreNode(rect.x,rect.y,width,height);
               if(score > bestContactScore)
               {
                  bestNode.x = rect.x;
                  bestNode.y = rect.y;
                  bestNode.width = width;
                  bestNode.height = height;
                  bestContactScore = score;
               }
            }
            if(allowRotations && rect.width >= height && rect.height >= width)
            {
               score = contactPointScoreNode(rect.x,rect.y,height,width);
               if(score > bestContactScore)
               {
                  bestNode.x = rect.x;
                  bestNode.y = rect.y;
                  bestNode.width = height;
                  bestNode.height = width;
                  bestContactScore = score;
               }
            }
            i++;
         }
         return bestNode;
      }
      
      private function splitFreeNode(freeNode:Rectangle, usedNode:Rectangle) : Boolean
      {
         var newNode:Rectangle = null;
         if(usedNode.x >= freeNode.x + freeNode.width || usedNode.x + usedNode.width <= freeNode.x || usedNode.y >= freeNode.y + freeNode.height || usedNode.y + usedNode.height <= freeNode.y)
         {
            return false;
         }
         if(usedNode.x < freeNode.x + freeNode.width && usedNode.x + usedNode.width > freeNode.x)
         {
            if(usedNode.y > freeNode.y && usedNode.y < freeNode.y + freeNode.height)
            {
               newNode = freeNode.clone();
               newNode.height = usedNode.y - newNode.y;
               freeRectangles.push(newNode);
            }
            if(usedNode.y + usedNode.height < freeNode.y + freeNode.height)
            {
               newNode = freeNode.clone();
               newNode.y = usedNode.y + usedNode.height;
               newNode.height = freeNode.y + freeNode.height - (usedNode.y + usedNode.height);
               freeRectangles.push(newNode);
            }
         }
         if(usedNode.y < freeNode.y + freeNode.height && usedNode.y + usedNode.height > freeNode.y)
         {
            if(usedNode.x > freeNode.x && usedNode.x < freeNode.x + freeNode.width)
            {
               newNode = freeNode.clone();
               newNode.width = usedNode.x - newNode.x;
               freeRectangles.push(newNode);
            }
            if(usedNode.x + usedNode.width < freeNode.x + freeNode.width)
            {
               newNode = freeNode.clone();
               newNode.x = usedNode.x + usedNode.width;
               newNode.width = freeNode.x + freeNode.width - (usedNode.x + usedNode.width);
               freeRectangles.push(newNode);
            }
         }
         return true;
      }
      
      private function pruneFreeList() : void
      {
         var i:int = 0;
         var j:int = 0;
         for(i = 0; i < freeRectangles.length; )
         {
            for(j = i + 1; j < freeRectangles.length; )
            {
               if(isContainedIn(freeRectangles[i],freeRectangles[j]))
               {
                  freeRectangles.splice(i,1);
                  break;
               }
               if(isContainedIn(freeRectangles[j],freeRectangles[i]))
               {
                  freeRectangles.splice(j,1);
               }
               j++;
            }
            i++;
         }
      }
      
      private function isContainedIn(a:Rectangle, b:Rectangle) : Boolean
      {
         return a.x >= b.x && a.y >= b.y && a.x + a.width <= b.x + b.width && a.y + a.height <= b.y + b.height;
      }
   }
}

