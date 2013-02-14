//
//  GameOverLayer.h
//  DontEverDate
//
//  Created by Michael Place on 2/3/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor {
    NSNumber *_gameEndScore;
}

@property (nonatomic, retain) NSNumber *gameEndScore;

+(CCScene *) sceneWithWon:(BOOL)won andScore:(int)score andHealth:(float)health;
- (id)initWithWon:(BOOL)won andScore:(NSNumber*)score andHealth:(float)health;

@end
