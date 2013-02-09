//
//  Enemy.h
//  DontEverDate
//
//  Created by Michael Place on 2/3/13.
//
//

#import "CCSprite.h"

// Enemy is the base class for all enemies on screen
@interface Enemy : CCSprite {
    NSMutableDictionary *_actionCoolDown;
}
enum {
    wander = 1,
    seek = 2,
    flee = 3,
    fire = 4,
    tired = 5
};
typedef NSUInteger action;

@property (nonatomic, assign) action currentAction;
@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int minMoveDuration;
@property (nonatomic, assign) int maxMoveDuration;
@property (nonatomic, retain) NSMutableDictionary *actionCoolDown;    //copy for mutable pointer (retain for pointers)
@property (nonatomic, assign) int currentActionCoolDown;
@property (nonatomic, assign) int adjustedActionCoolDown;



- (id)initWithFile:(NSString *)file hp:(int)hp minMoveDuration:(int)minMoveDuration maxMoveDuration:(int)maxMoveDuration;

@end

// Cupid is a type of enemy, weakest type of cupid
@interface Cupid : Enemy {
    
}

@end

//BruteCupid is a type of enemy, stronger than cupid
@interface BruteCupid : Enemy {
    
}

@end