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
        _playerHealthLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:(16)];
        [_brokenHeartScoreLabel setColor:ccBLACK];
        [_playerHealthLabel setColor:ccBLACK];
        _brokenHeartScoreLabel.position = ccp(winSize.width* 0.70, winSize.height * 0.95);
        _playerHealthLabel.position = ccp(winSize.width*0.15, winSize.height * 0.95);
        
        [self addChild:_brokenHeartScoreLabel];
        [self addChild:_playerHealthLabel];
    }
    return self;
}

- (void)setBrokenHeartScoreString:(NSString *)string {
    _brokenHeartScoreLabel.string = string;
}

-(void)setPlayerHealthString:(NSString *)string {
    _playerHealthLabel.string = string;
}

@end
