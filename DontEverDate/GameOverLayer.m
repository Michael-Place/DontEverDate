//
//  GameOverLayer.m
//  DontEverDate
//
//  Created by Michael Place on 2/3/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import "GameOverLayer.h"
#import "GamePlayLayer.h"
#import "LevelManager.h"
#import "HighScoreManager.h"
#import "HighScoresLayer.h"

@implementation GameOverLayer
@synthesize gameEndScore = _gameEndScore;

+(CCScene *) sceneWithWon:(BOOL)won andScore:(int)score andHealth:(float)health{
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[[GameOverLayer alloc] initWithWon:won andScore:[NSNumber numberWithInt:score] andHealth:health] autorelease];
    [scene addChild: layer];
    return scene;
}

- (id)initWithWon:(BOOL)won andScore:(NSNumber*)score andHealth:(float)health{
    if ((self = [super initWithColor:ccc4(255, 255, 255, 255)])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;

        NSString * message;
        self.gameEndScore = score;
        [[LevelManager sharedInstance] setScoreForSession:([[LevelManager sharedInstance] scoreForSession] + [self.gameEndScore integerValue])];
        [[LevelManager sharedInstance] setHealthForSession:health];
        if (won) {
            CCSprite *background = [CCSprite spriteWithFile:@"game_background.png" rect:CGRectMake(0, 0, winSize.width, winSize.height)];
            
            background.position = CGPointMake(winSize.width/2, winSize.height/2);
            [self addChild:background z:0];
            [[LevelManager sharedInstance] nextLevel];
            Level * curLevel = [[LevelManager sharedInstance] curLevel];
            if (curLevel) {
                message = [NSString stringWithFormat:@"Get ready for level %d!", curLevel.levelNum];
                [self runAction:
                 [CCSequence actions:
                  [CCDelayTime actionWithDuration:1],
                  [CCCallBlockN actionWithBlock:^(CCNode *node) {
                     [[CCDirector sharedDirector] replaceScene:[GamePlayLayer scene]];
                 }],
                  nil]];
            } else {
                CCSprite *background = [CCSprite spriteWithFile:@"win_no_anim.png" rect:CGRectMake(0, 0, winSize.width, winSize.height)];
                
                background.position = CGPointMake(winSize.width/2, winSize.height/2);
                [self addChild:background z:0];
                message = @"";
                [self addGameOverButtonsToLayer];
                [self addHighScoreEntry];
                [self clearSessionValues];  
            }
        } else {
            message = @"";
            CCSprite *background = [CCSprite spriteWithFile:@"lose_no_anim.png" rect:CGRectMake(0, 0, winSize.width, winSize.height)];
            
            background.position = CGPointMake(winSize.width/2, winSize.height/2);
            [self addChild:background z:0];
            [self addGameOverButtonsToLayer];
            [self addHighScoreEntry];
            [self clearSessionValues];
        }


        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:16];
        label.color = ccc3(0,0,0);
        label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:label];
    }
    return self;
}

-(void)clearSessionValues {
    [[LevelManager sharedInstance] setHealthForSession:20];
    [[LevelManager sharedInstance] setScoreForSession:0];
}

-(void)callMichael {
    if ([UIApplication instancesRespondToSelector:@selector(canOpenURL:)]) {
        NSString *phoneNumber = @"319-573-2759";
        NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
        NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
        if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
            [[UIApplication sharedApplication] openURL:phoneURL];
        }
        else {
            CGSize winSize = [[CCDirector sharedDirector] winSize];
            CCLabelTTF * label = [CCLabelTTF labelWithString:@"Device is not capable of calling Michael." fontName:@"Arial" fontSize:16];
            label.color = ccc3(0,0,0);
            label.position = ccp(winSize.width/2, winSize.height/2 - 30);
            [self addChild:label];
            
        }
    }
}

-(void)addHighScoreEntry {
    [HighScoreManager addEntryToHighScoreDictionaryWith:@"Mary Ohm" andScore:[NSNumber numberWithInt:[[LevelManager sharedInstance] scoreForSession]]];
}

-(void)displayHighScores {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2 scene:[HighScoresLayer scene] withColor:ccBLACK]];
}

-(void)playAgain {
    [[LevelManager sharedInstance] reset];
    [self runAction:
     [CCSequence actions:
      [CCDelayTime actionWithDuration:1],
      [CCCallBlockN actionWithBlock:^(CCNode *node) {
         [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2 scene:[GamePlayLayer scene] withColor:ccBLACK]];
     }],
      nil]];
}

-(void)addGameOverButtonsToLayer {
    CCMenuItem *playAgain = [CCMenuItemImage itemWithNormalImage:@"play_again.png" selectedImage:@"play_againSel.png" target:self selector:@selector(playAgain)];
    playAgain.position = ccp(25, 85);
    CCMenu *playAgainMenu = [CCMenu menuWithItems:playAgain, nil];
    playAgainMenu.position = ccp(25,85);
    [self addChild:playAgainMenu];
    
    CCMenuItem *callMichael = [CCMenuItemImage itemWithNormalImage:@"call_michael.png" selectedImage:@"call_michaelSel.png" target:self selector:@selector(callMichael)];
    callMichael.position = ccp(25, 55);
    CCMenu *callMichaelMenu = [CCMenu menuWithItems:callMichael, nil];
    callMichaelMenu.position = ccp(25,55);
    [self addChild:callMichaelMenu];
    
    
    CCMenuItem *highScore = [CCMenuItemImage itemWithNormalImage:@"highscores.png" selectedImage:@"highscores_Sel.png" target:self selector:@selector(displayHighScores)];
    highScore.position = ccp(25, 25);
    CCMenu *highScoreMenu = [CCMenu menuWithItems:highScore, nil];
    highScoreMenu.position = ccp(25, 25);
    [self addChild:highScoreMenu];
}

@end
