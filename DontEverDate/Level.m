//
//  Level.m
//  DontEverDate
//
//  Created by Michael Place on 2/3/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import "Level.h"

@implementation Level

- (id)initWithLevelNum:(int)levelNum secsPerSpawn:(float)secsPerSpawn backgroundColor:(ccColor4B)backgroundColor {
    if ((self = [super init])) {
        self.levelNum = levelNum;
        self.secsPerSpawn = secsPerSpawn;
        self.backgroundColor = backgroundColor;
    }
    return self;
}

@end
