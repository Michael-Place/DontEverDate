//
//  IntroLayer.m
//  DontEverDate
//
//  Created by Michael Place on 2/3/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "GamePlayLayer.h"
#import "HighScoresLayer.h"


#pragma mark - IntroLayer

@implementation IntroLayer

// Helper class method that creates a Scene with the GamePlayLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(void) onEnter
{
	[super onEnter];

	// ask director for the window size
	CGSize size = [[CCDirector sharedDirector] winSize];

	CCSprite *background;
	
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
		background = [CCSprite spriteWithFile:@"Default.png"];
		background.rotation = 90;
	} else {
		background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
	}
	background.position = ccp(size.width/2, size.height/2);

	// add the label as a child to this Layer
	[self addChild: background];
    
    [self addGameNavigationButtonsToLayer];
}

-(void) makeTransition:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:dt scene:[GamePlayLayer scene] withColor:ccWHITE]];
}

-(void)play {
    [self makeTransition:1];
}

-(void)showHighScoresMenu {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[HighScoresLayer scene] withColor:ccWHITE]];
}

-(void)addGameNavigationButtonsToLayer {
    CCMenuItem *play = [CCMenuItemImage itemWithNormalImage:@"Button1.png" selectedImage:@"Button1Sel.png" target:self selector:@selector(play)];
    play.position = ccp(60, 30);
    CCMenu *playMenu = [CCMenu menuWithItems:play, nil];
    playMenu.position = ccp(60,30);
    [self addChild:playMenu];
    
    CCMenuItem *showHighScores = [CCMenuItemImage itemWithNormalImage:@"Button2.png" selectedImage:@"Button2Sel.png" target:self selector:@selector(showHighScoresMenu)];
    showHighScores.position = ccp(180, 30);
    CCMenu *showHighScoresMenu = [CCMenu menuWithItems:showHighScores, nil];
    showHighScoresMenu.position = ccp(180,30);
    [self addChild:showHighScoresMenu];
}
@end
