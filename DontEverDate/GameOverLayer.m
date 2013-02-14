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

@implementation GameOverLayer
@synthesize gameEndScore = _gameEndScore;

+(CCScene *) sceneWithWon:(BOOL)won andScore:(int)score{
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[[GameOverLayer alloc] initWithWon:won andScore:[NSNumber numberWithInt:score]] autorelease];
    [scene addChild: layer];
    return scene;
}

- (id)initWithWon:(BOOL)won andScore:(NSNumber*)score{
    if ((self = [super initWithColor:ccc4(255, 255, 255, 255)])) {
        NSString * message;
        self.gameEndScore = score;
        if (won) {
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
                message = @"You Won!";
                [self addGameOverButtonsToLayer];
                [self addHighScoreEntry];
            }
        } else {
            message = @"You Lose :[";
            [self addGameOverButtonsToLayer];
            [self addHighScoreEntry];
        }


        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:16];
        label.color = ccc3(0,0,0);
        label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:label];
    }
    return self;
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
    [HighScoreManager addEntryToHighScoreDictionaryWith:@"Static Name" andScore:self.gameEndScore];
}

-(void)playAgain {
    [[LevelManager sharedInstance] reset];
    [self runAction:
     [CCSequence actions:
      [CCDelayTime actionWithDuration:1],
      [CCCallBlockN actionWithBlock:^(CCNode *node) {
         [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[GamePlayLayer scene] withColor:ccWHITE]];
     }],
      nil]];
}

-(void)addGameOverButtonsToLayer {
    CCMenuItem *playAgain = [CCMenuItemImage itemWithNormalImage:@"Button1.png" selectedImage:@"Button1Sel.png" target:self selector:@selector(playAgain)];
    playAgain.position = ccp(60, 30);
    CCMenu *playAgainMenu = [CCMenu menuWithItems:playAgain, nil];
    playAgainMenu.position = ccp(60,30);
    [self addChild:playAgainMenu];
    
    CCMenuItem *callMichael = [CCMenuItemImage itemWithNormalImage:@"Button2.png" selectedImage:@"Button2Sel.png" target:self selector:@selector(callMichael)];
    callMichael.position = ccp(180, 30);
    CCMenu *callMichaelMenu = [CCMenu menuWithItems:callMichael, nil];
    callMichaelMenu.position = ccp(180,30);
    [self addChild:callMichaelMenu];
}

@end
