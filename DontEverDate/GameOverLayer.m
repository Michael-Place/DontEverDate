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
@synthesize cupidTauntAction = _cupidTauntAction;
@synthesize maryDanceAction = _maryDanceAction;
@synthesize danceMary = _danceMary;
@synthesize tauntEnemy1 = _tauntEnemy1;
@synthesize tauntEnemy2 = _tauntEnemy2;
@synthesize tauntEnemy3 = _tauntEnemy3;
@synthesize tauntEnemy4 = _tauntEnemy4;

+(CCScene *) sceneWithWon:(BOOL)won andScore:(int)score andHealth:(float)health{
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[[GameOverLayer alloc] initWithWon:won andScore:[NSNumber numberWithInt:score] andHealth:health] autorelease];
    [scene addChild: layer];
    return scene;
}

-(void) setUpMaryDanceAction {
    CCTexture2D *texture;
    CGSize textureSize;
    CGRect textureRect;
    CCSpriteFrame *spriteFrame;
    NSMutableArray *animationFrames = [NSMutableArray arrayWithCapacity:2];
    
    // Repeat block of code below
    texture = [[CCTextureCache sharedTextureCache] addImage:@"mary_dance_1.png"];
    textureSize = [texture contentSize];
    textureRect = CGRectMake(0, 0, textureSize.width, textureSize.height);
    spriteFrame = [CCSpriteFrame frameWithTexture:texture rect:textureRect];
    [animationFrames addObject:spriteFrame];
    
    texture = [[CCTextureCache sharedTextureCache] addImage:@"mary_dance_2.png"];
    textureSize = [texture contentSize];
    textureRect = CGRectMake(0, 0, textureSize.width, textureSize.height);
    spriteFrame = [CCSpriteFrame frameWithTexture:texture rect:textureRect];
    [animationFrames addObject:spriteFrame];
    
    CCAnimation *animation = [CCAnimation  animationWithFrames:animationFrames delay:.3];
    CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
    self.maryDanceAction = [CCRepeatForever actionWithAction:animate];
}

//-(void)setUpCupidTauntAction {
//    CCTexture2D *texture;
//    CGSize textureSize;
//    CGRect textureRect;
//    CCSpriteFrame *spriteFrame;
//    NSMutableArray *animationFrames = [NSMutableArray arrayWithCapacity:2];
//    
//    // Repeat block of code below
//    texture = [[CCTextureCache sharedTextureCache] addImage:@"cupid_taunt_1.png"];
//    textureSize = [texture contentSize];
//    textureRect = CGRectMake(0, 0, textureSize.width, textureSize.height);
//    spriteFrame = [CCSpriteFrame frameWithTexture:texture rect:textureRect];
//    [animationFrames addObject:spriteFrame];
//    
//    texture = [[CCTextureCache sharedTextureCache] addImage:@"cupid_taunt_2.png"];
//    textureSize = [texture contentSize];
//    textureRect = CGRectMake(0, 0, textureSize.width, textureSize.height);
//    spriteFrame = [CCSpriteFrame frameWithTexture:texture rect:textureRect];
//    [animationFrames addObject:spriteFrame];
//    
//    texture = [[CCTextureCache sharedTextureCache] addImage:@"cupid_taunt_3.png"];
//    textureSize = [texture contentSize];
//    textureRect = CGRectMake(0, 0, textureSize.width, textureSize.height);
//    spriteFrame = [CCSpriteFrame frameWithTexture:texture rect:textureRect];
//    [animationFrames addObject:spriteFrame];
//    
//    CCAnimation *animation = [CCAnimation  animationWithFrames:animationFrames delay:.15];
//    CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
//    self.cupidTauntAction = [CCRepeatForever actionWithAction:animate];
//}

- (id)initWithWon:(BOOL)won andScore:(NSNumber*)score andHealth:(float)health{
    if ((self = [super initWithColor:ccc4(255, 255, 255, 255)])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
//        [self setUpCupidTauntAction];
        [self setUpMaryDanceAction];
        
        NSString * message;
        self.gameEndScore = score;
        [[LevelManager sharedInstance] setScoreForSession:([[LevelManager sharedInstance] scoreForSession] + [self.gameEndScore integerValue])];
        [[LevelManager sharedInstance] setHealthForSession:health];
        if (won) {
            _winStatus = 1;
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
                _winStatus = 2;
                CCSprite *background = [CCSprite spriteWithFile:@"win_anim.png" rect:CGRectMake(0, 0, winSize.width, winSize.height)];
                
                background.position = CGPointMake(winSize.width/2, winSize.height/2);
                [self addChild:background z:0];
                message = @"";
                self.danceMary = [[Player alloc] initWithFile:@"mary_dance_1.png" hp:5];
                [self.danceMary setPosition:ccp(220, 60)];
                [self.danceMary runAction:self.maryDanceAction];
                [self addChild:self.danceMary z:1];
                
                [self addGameOverButtonsToLayer];
                [self addHighScoreEntry];
                [self clearSessionValues];  
            }
        } else {
            _winStatus = 3;
            message = @"";
            CCSprite *background = [CCSprite spriteWithFile:@"lose_no_anim.png" rect:CGRectMake(0, 0, winSize.width, winSize.height)];
            
            background.position = CGPointMake(winSize.width/2, winSize.height/2);
            [self addChild:background z:0];
            
//            [self launchTauntingCupids];
            
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

//-(void)launchTauntingCupids {
//    self.tauntEnemy1 = [[Enemy alloc] initWithFile:@"cupid_taunt_1.png" hp:1 minMoveDuration:1 maxMoveDuration:1];
//    [self.tauntEnemy1 setPosition:ccp(130, 35)];
//    [self.tauntEnemy1 runAction:self.cupidTauntAction];
//    [self addChild:self.tauntEnemy1];
//    
//    self.tauntEnemy2 = [[Enemy alloc] initWithFile:@"cupid_taunt_1.png" hp:1 minMoveDuration:1 maxMoveDuration:1];
//    [self.tauntEnemy2 setPosition:ccp(135, 50)];
//    [self.tauntEnemy2 runAction:self.cupidTauntAction];
//    [self addChild:self.tauntEnemy2];
//    
//    self.tauntEnemy3 = [[Enemy alloc] initWithFile:@"cupid_taunt_1.png" hp:1 minMoveDuration:1 maxMoveDuration:1];
//    [self.tauntEnemy3 setPosition:ccp(190, 65)];
//    [self.tauntEnemy3 runAction:self.cupidTauntAction];
//    [self addChild:self.tauntEnemy3];
//    
//    self.tauntEnemy4 = [[Enemy alloc] initWithFile:@"cupid_taunt_1.png" hp:1 minMoveDuration:1 maxMoveDuration:1];
//    [self.tauntEnemy4 setPosition:ccp(180, 30)];
//    [self.tauntEnemy4 runAction:self.cupidTauntAction];
//    [self addChild:self.tauntEnemy4];
//}

- (void)removeAnimationSprites {
    if (_winStatus == 3) {
        [self removeChild:self.danceMary cleanup:YES];
    }else if (_winStatus == 2) {
//        [self removeChild:self.tauntEnemy1 cleanup:YES];
//        [self removeChild:self.tauntEnemy2 cleanup:YES];
//        [self removeChild:self.tauntEnemy3 cleanup:YES];
//        [self removeChild:self.tauntEnemy4 cleanup:YES];
    }
    else {
        
    }

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
    [self removeAnimationSprites];
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
    [self removeAnimationSprites];
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

- (void)dealloc
{
    self.danceMary = nil;
    [self.danceMary release];
    self.tauntEnemy1 = nil;
    [self.tauntEnemy1 release];
    self.tauntEnemy2 = nil;
    [self.tauntEnemy2 release];
    self.tauntEnemy3 = nil;
    [self.tauntEnemy3 release];
    self.tauntEnemy4 = nil;
    [self.tauntEnemy4 release];
    
    self.maryDanceAction = nil;
    [self.maryDanceAction release];
    self.cupidTauntAction = nil;
    [self.cupidTauntAction release];
    
    [super dealloc];
}

@end
