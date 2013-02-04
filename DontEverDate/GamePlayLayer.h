//
//  GamePlayLayer.h
//  DontEverDate
//
//  Created by Michael Place on 2/3/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "cocos2d.h"

@interface GamePlayLayer: CCLayerColor
{
    NSMutableArray * _enemies;
    NSMutableArray * _projectiles;
    int _enemiesDestroyed;
    CCSprite *_player;
    CCSprite *_nextProjectile;
}

// returns a CCScene that contains the GamePlayLayer as the only child
+(CCScene *) scene;

@end
