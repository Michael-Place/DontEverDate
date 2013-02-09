//
//  GamePlayLayer.h
//  DontEverDate
//
//  Created by Michael Place on 2/3/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "HUDLayer.h"
@interface GamePlayLayer: CCLayerColor
{
    float speed;
    float radius;
    float distance;
    float angle;
    float angleNoise;
    CGPoint targetLoc;
    CGPoint velocity;
    
    HUDLayer * _hud;
    
    NSMutableArray * _enemies;
    NSMutableArray * _projectiles;
    int _enemiesDestroyed;
    int _enemyLimit;
    CCSprite *_player;
    CCSprite *_nextProjectile;
    CCAction *_moveAction;
    BOOL _moving;
}

@property (nonatomic, retain) CCAction *moveAction;
@property (nonatomic, retain) CCSprite *player;

// returns a CCScene that contains the GamePlayLayer as the only child
+(CCScene *) scene;

- (id)initWithHUD:(HUDLayer *)hud;


@end
