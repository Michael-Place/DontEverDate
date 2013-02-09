//
//  Enemy.m
//  DontEverDate
//
//  Created by Michael Place on 2/3/13.
//
//

#import "Enemy.h"

@implementation Enemy
@synthesize actionCoolDown = _actionCoolDown;

- (id)initWithFile:(NSString *)file hp:(int)hp minMoveDuration:(int)minMoveDuration maxMoveDuration:(int)maxMoveDuration {
    if ((self = [super initWithFile:file])) {
        self.hp = hp;
        self.minMoveDuration = minMoveDuration;
        self.maxMoveDuration = maxMoveDuration;
        self.currentActionCoolDown = 5;
        self.currentAction = wander;        //init enemy to wander
        self.adjustedActionCoolDown = self.currentAction * 1000;
    }
    return self;
}

@end

@implementation Cupid 

- (id)init {
    if ((self = [super initWithFile:@"Cupid.png" hp:1 minMoveDuration:3 maxMoveDuration:5])) {
       
        self.actionCoolDown = [[NSMutableDictionary alloc]initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithFloat:5.0],[NSNumber numberWithFloat:7.0], [NSNumber numberWithFloat:9.0], [NSNumber numberWithFloat:3.0], [NSNumber numberWithFloat:0.5], nil] forKeys:[NSArray arrayWithObjects:[NSNumber numberWithInt:wander],[NSNumber numberWithInt:seek], [NSNumber numberWithInt:flee], [NSNumber numberWithInt:fire], [NSNumber numberWithInt:tired], nil]];
        
    }
    return self;
}

@end


@implementation BruteCupid

- (id)init {
    if ((self = [super initWithFile:@"BruteCupid.png" hp:3 minMoveDuration:6 maxMoveDuration:12])) {
        
//        self.actionCoolDown = [[NSMutableDictionary alloc]initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithFloat:2.0],[NSNumber numberWithFloat:3.0], [NSNumber numberWithFloat:5.0], [NSNumber numberWithFloat:1.0], [NSNumber numberWithFloat:0.01], nil] forKeys:[NSArray arrayWithObjects:wander,seek, flee, fire, tired, nil]];
        
        self.actionCoolDown = [NSMutableDictionary dictionaryWithDictionary:@{@"test": @"win"}];

        
    }
    return self;
}

@end
