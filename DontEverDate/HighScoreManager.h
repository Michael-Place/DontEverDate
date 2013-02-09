//
//  HighScoreManager.h
//  DontEverDate
//
//  Created by Michael Place on 2/8/13.
//
//

#import <Foundation/Foundation.h>

@interface HighScoreManager : NSObject

+(NSDictionary*)getHighScoreDictionary;
+(void)addEntryToHighScoreDictionaryWith:(NSString*)name andScore:(NSNumber*)score;
@end
