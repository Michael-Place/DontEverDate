//
//  Player.h
//  DontEverDate
//
//  Created by Michael Place on 2/3/13.
//
//

#import "CCSprite.h"

@interface Player : CCSprite {
    
}

@property (nonatomic, assign) int hp;

- (id)initWithFile:(NSString *)file hp:(int)hp;

@end
