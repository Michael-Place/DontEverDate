//
//  Level.h
//  DontEverDate
//
//  Created by Michael Place on 2/3/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Level : NSObject

@property (nonatomic, assign) int levelNum;
@property (nonatomic, assign) float secsPerSpawn;
@property (nonatomic, assign) ccColor4B backgroundColor;

- (id)initWithLevelNum:(int)levelNum secsPerSpawn:(float)secsPerSpawn backgroundColor:(ccColor4B)backgroundColor;

@end
