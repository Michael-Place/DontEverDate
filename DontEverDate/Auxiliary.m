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

@end
