//
//  HighScoreManager.m
//  DontEverDate
//
//  Created by Michael Place on 2/8/13.
//
//

#import "HighScoreManager.h"

@implementation HighScoreManager

+(NSString*)getHighScorePlistPath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"HighScore.plist"];
    
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"HighScore.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"HighScore" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:destPath error:nil];
    }
    
    return destPath;
}

+(NSDictionary*)getHighScoreDictionary {
    NSString *highScorePlistPath = [self getHighScorePlistPath];
    NSDictionary *highScore = [[NSDictionary alloc] initWithContentsOfFile:highScorePlistPath];
    return highScore;
}

+(void)addEntryToHighScoreDictionaryWith:(NSString*)name andScore:(NSNumber*)score {
    NSMutableArray *keys = [NSMutableArray array];
    NSMutableArray *topValues = [NSMutableArray arrayWithArray:[[HighScoreManager getHighScoreDictionary] allValues]];
    NSMutableArray *scores = [NSMutableArray array];
    
    for (NSDictionary *d in topValues) {
        [scores addObject:[[d allValues] objectAtIndex:0]];
        [keys addObject:[[d allKeys] objectAtIndex:0]];
    }
    
    [scores addObject:score];
    [keys addObject:name];
    
    for (int i = 0; i < scores.count; i++) {
        for (int j = 0; j < scores.count; j++) {
            if ([[scores objectAtIndex:i]integerValue] > [[scores objectAtIndex:i]integerValue]) {
                NSString *tmpName = [keys objectAtIndex:j];
                NSNumber *tmpScore = [scores objectAtIndex:j];
                keys[j] = keys[i];
                scores[j] = scores[i];
                keys[i] = tmpName;
                scores[i] = tmpScore;
            }
        }
    }
    
    NSMutableDictionary *highScoreFinal = [NSMutableDictionary dictionary];
    for (int i = [scores count] -1; i > -1; i--) {
        [highScoreFinal setObject:@{keys[i] : scores[i]} forKey:[NSString stringWithFormat:@"%i",i]];
    }
    
//    NSMutableDictionary *highScoreDictionary = [NSMutableDictionary dictionaryWithDictionary:[HighScoreManager getHighScoreDictionary]];
    
//    [highScoreDictionary setObject:score forKey:name];
//
//    [highScoreDictionary addEntriesFromDictionary:@{name : score}];
//    [highScoreDictionary setObject:score forKey:name];
    [highScoreFinal writeToFile:[self getHighScorePlistPath] atomically:TRUE];
}
@end
