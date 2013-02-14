//
//  LevelManager.m
//  DontEverDate
//
//  Created by Michael Place on 2/3/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import "LevelManager.h"

@implementation LevelManager {
    NSArray * _levels;
    int _curLevelIdx;
}
@synthesize scoreForSession = _scoreForSession;
@synthesize healthForSession = _healthForSession;

+ (LevelManager *)sharedInstance {
    static dispatch_once_t once;
    static LevelManager * sharedInstance; dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance setHealthForSession:20];
    });
    return sharedInstance;
}

- (id)init {
    if ((self = [super init])) {
        _curLevelIdx = 0;
        Level * level1 = [[[Level alloc] initWithLevelNum:1 secsPerSpawn:3 backgroundColor:ccc4(255, 255, 255, 255)] autorelease];
        Level * level2 = [[[Level alloc] initWithLevelNum:2 secsPerSpawn:2 backgroundColor:ccc4(255, 255, 255, 255)] autorelease];
        Level * level3 = [[[Level alloc] initWithLevelNum:3 secsPerSpawn:1 backgroundColor:ccc4(255, 255, 255, 255)] autorelease];
        _levels = [@[level1, level2, level3] retain];
    }
    return self;
}

- (Level *)curLevel {
    if (_curLevelIdx >= _levels.count) {
        return nil;
    }
    return _levels[_curLevelIdx];
}

- (int)curLevelNumber {
    return _curLevelIdx;
}

- (void)nextLevel {
    _curLevelIdx++;
}

- (void)reset {
    _curLevelIdx = 0;
}

- (void)dealloc {
    [_levels release];
    _levels = nil;
    [super dealloc];
}

@end
