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
#import "Player.h"
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
    Player *_player;
    CCSprite *_nextProjectile;
    CCAction *_moveAction;
    CCAction *_walkAction;
    CCAction *_kickAction;
    BOOL _moving;
}

@property (nonatomic, retain) CCAction *moveAction;
@property (nonatomic, retain) CCAction *walkAction;
@property (nonatomic, retain) CCAction *kickAction;
@property (nonatomic, retain) CCSprite *player;

// returns a CCScene that contains the GamePlayLayer as the only child
+(CCScene *) scene;

- (id)initWithHUD:(HUDLayer *)hud;


@end
