//
//  IntroLayer.h
//  DontEverDate
//
//  Created by Michael Place on 2/3/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@interface IntroLayer : CCLayer
{
    UIButton *_howToButton;
}

@property (nonatomic, retain) UIButton *howToButton;

// returns a CCScene that contains the GamePlayLayer as the only child
+(CCScene *) scene;

@end
