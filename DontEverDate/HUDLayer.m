//
//  HUDLayer.m
//  DontEverDate
//
//  Created by Michael Place on 2/3/13.
//
//

#import "HUDLayer.h"
#import "GamePlayLayer.h"


@implementation HUDLayer

- (id)init {
    
    if ((self = [super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        _brokenHeartScoreLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:(16)];
        _playerHealthLabel = [CCLabelTTF labelWithString:@"Health:" fontName:@"Arial" fontSize:(16)];
        [_brokenHeartScoreLabel setColor:ccBLACK];
        [_playerHealthLabel setColor:ccBLACK];
        _brokenHeartScoreLabel.position = ccp(winSize.width* 0.70, winSize.height * 0.95);
        _playerHealthLabel.position = ccp(winSize.width*0.08, winSize.height * 0.95);
        _healthBar = [[UIProgressView alloc] initWithFrame:CGRectMake(winSize.width*0.15, winSize.height * 0.04, 90, 30)];
        [_healthBar setTrackTintColor:[UIColor purpleColor]];
        [_healthBar setProgress:1 animated:YES];
        
        [[[CCDirector sharedDirector] view] addSubview:_healthBar];
        [self addChild:_brokenHeartScoreLabel];
        [self addChild:_playerHealthLabel];
    }
    return self;
}

- (void)setBrokenHeartScoreString:(NSString *)string {
    _brokenHeartScoreLabel.string = string;
}

-(void)setPlayerHealthProgress:(int)currHealth {
    float totalHealth = 20;
    float progress = currHealth/totalHealth;
    [_healthBar setProgress:progress animated:YES];
}

@end
