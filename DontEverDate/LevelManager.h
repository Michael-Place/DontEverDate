//
//  LevelManager.h
//  DontEverDate
//
//  Created by Michael Place on 2/3/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Level.h"

@interface LevelManager : NSObject {
    int _scoreForSession;
    int _healthForSession;
}

@property int scoreForSession;
@property int healthForSession;

+ (LevelManager *)sharedInstance;
- (Level *)curLevel;
- (int)curLevelNumber;
- (void)nextLevel;
- (void)reset;

@end
