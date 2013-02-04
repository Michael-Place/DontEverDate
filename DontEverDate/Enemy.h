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
    
}

@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int minMoveDuration;
@property (nonatomic, assign) int maxMoveDuration;

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