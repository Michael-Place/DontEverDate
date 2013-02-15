//
//  GameOverLayer.h
//  DontEverDate
//
//  Created by Michael Place on 2/3/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import "cocos2d.h"
#import "Player.h"
#import "Enemy.h"

@interface GameOverLayer : CCLayerColor {
    int _winStatus;
    NSNumber *_gameEndScore;
    CCAction *_maryDanceAction;
    CCAction *_cupidTauntAction;
    Player *_danceMary;
    Enemy *_tauntEnemy1;
    Enemy *_tauntEnemy2;
    Enemy *_tauntEnemy3;
    Enemy *_tauntEnemy4;
}

@property (nonatomic, retain) NSNumber *gameEndScore;
@property (nonatomic, retain) CCAction *maryDanceAction;
@property (nonatomic, retain) CCAction *cupidTauntAction;
@property (nonatomic, retain) Enemy *tauntEnemy1;
@property (nonatomic, retain) Enemy *tauntEnemy2;
@property (nonatomic, retain) Enemy *tauntEnemy3;
@property (nonatomic, retain) Enemy *tauntEnemy4;
@property (nonatomic, retain) Player *danceMary;

+(CCScene *) sceneWithWon:(BOOL)won andScore:(int)score andHealth:(float)health;
- (id)initWithWon:(BOOL)won andScore:(NSNumber*)score andHealth:(float)health;

@end
