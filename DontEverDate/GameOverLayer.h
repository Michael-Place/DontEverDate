//
//  GameOverLayer.h
//  DontEverDate
//
//  Created by Michael Place on 2/3/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor

+(CCScene *) sceneWithWon:(BOOL)won;
- (id)initWithWon:(BOOL)won;

@end
