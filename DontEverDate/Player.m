//
//  Player.m
//  DontEverDate
//
//  Created by Michael Place on 2/3/13.
//
//

#import "Player.h"

@implementation Player
- (id)initWithFile:(NSString *)file hp:(int)hp {
    if ((self = [super initWithFile:file])) {
        self.hp = hp;
    }
    return self;
}
@end
