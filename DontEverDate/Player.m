//
//  Player.m
//  DontEverDate
//
//  Created by Michael Place on 2/3/13.
//
//

#import "Player.h"
#import "LevelManager.h"

@implementation Player
- (id)initWithFile:(NSString *)file hp:(int)hp {
    if ((self = [super initWithFile:file])) {
        self.hp = [[LevelManager sharedInstance] healthForSession];
    }
    return self;
}
@end
