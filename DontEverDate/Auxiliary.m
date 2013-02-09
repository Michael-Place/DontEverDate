//
//  Auxiliary.m
//  DontEverDate
//
//  Created by Michael Place on 2/8/13.
//
//

#import "Auxiliary.h"
#import "cocos2d.h"

@implementation Auxiliary


+(float)generateRandomBetween:(float)start andFinish:(float)finish {
    float randomFloat = (arc4random()%1000)/1000;
    return randomFloat*(finish-start)+start;
}

+(CGPoint)normalizeVector:(CGPoint)vector {
    float length = sqrtf(vector.x * vector.x + vector.y * vector.y);
    if (length<0.000001) return ccp(0, 1);
    return ccpMult(vector, 1/length);
}

+(float)angleForVector:(CGPoint)vector {
    float alfa = atanf(vector.x/vector.y)*180/3.14;
    if (vector.y<0) alfa=alfa+180;
    return alfa;
}
+(NSNumber *) findDistanceFrom:(CGPoint) point1 to:(CGPoint) point2{
    float xdist;
    float ydist;
    float dist;
    xdist = fabs(point1.x - point2.x);
    ydist = fabs(point1.y - point2.y);
    dist = sqrtf((xdist*xdist)+(ydist*ydist));
    
    return [NSNumber numberWithFloat:dist];
    
}

+(CGPoint) findMidPointFrom:(CGPoint) point1 to:(CGPoint) point2{
    CGFloat xdist;
    CGFloat ydist;
    CGPoint midPoint;
    xdist = fabs(point1.x - point2.x);
    ydist = fabs(point1.y - point2.y);
    
    if (point1.x < point2.x) {
        if (point1.y < point2.y) {
            xdist = point1.x + (CGFloat)(xdist/2);
            ydist = point1.y + (CGFloat)(ydist/2);
            midPoint = CGPointMake(xdist,ydist);
        }else {
            xdist = point1.x + (CGFloat)(xdist/2);
            ydist = point1.y - (CGFloat)(ydist/2);
            midPoint = CGPointMake(xdist,ydist);
        }
    }else {
        if (point1.y < point2.y) {
            xdist = point1.x - (CGFloat)(xdist/2);
            ydist = point1.y + (CGFloat)(ydist/2);
            midPoint = CGPointMake(xdist,ydist);
        }else {
            xdist = point1.x - (CGFloat)(xdist/2);
            ydist = point1.y - (CGFloat)(ydist/2);
            midPoint = CGPointMake(xdist,ydist);
        }
        
    }
    
    return midPoint;
}


@end
