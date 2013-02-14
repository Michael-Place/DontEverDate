//
//  HUDLayer.h
//  DontEverDate
//
//  Created by Michael Place on 2/3/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HUDLayer : CCLayer {
    CCLabelTTF * _brokenHeartScoreLabel;
    CCLabelTTF * _playerHealthLabel;
    UIProgressView *_healthBar;
}

@property (nonatomic,retain)UIProgressView *healthBar;

- (void)setBrokenHeartScoreString:(NSString *)string;
- (void)setPlayerHealthProgress:(int)currHealth;
@end
