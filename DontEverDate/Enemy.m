//
//  Enemy.m
//  DontEverDate
//
//  Created by Michael Place on 2/3/13.
//
//

#import "Enemy.h"

@implementation Enemy
- (id)initWithFile:(NSString *)file hp:(int)hp minMoveDuration:(int)minMoveDuration maxMoveDuration:(int)maxMoveDuration {
    if ((self = [super initWithFile:file])) {
        self.hp = hp;
        self.minMoveDuration = minMoveDuration;
        self.maxMoveDuration = maxMoveDuration;
    }
    return self;
}

@end

@implementation Cupid

- (id)init {
    if ((self = [super initWithFile:@"Cupid.png" hp:1 minMoveDuration:3 maxMoveDuration:5])) {
    }
    return self;
}

@end


@implementation BruteCupid

- (id)init {
    if ((self = [super initWithFile:@"BruteCupid.png" hp:3 minMoveDuration:6 maxMoveDuration:12])) {
    }
    return self;
}

@end
