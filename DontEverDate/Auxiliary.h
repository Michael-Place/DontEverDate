//
//  Auxiliary.h
//  DontEverDate
//
//  Created by Michael Place on 2/8/13.
//
//

#import <Foundation/Foundation.h>

@interface Auxiliary : NSObject {
    
}

+(float)generateRandomBetween:(float)start andFinish:(float)finish;
+(CGPoint)normalizeVector:(CGPoint)vector;
+(float)angleForVector:(CGPoint)vector;

@end
