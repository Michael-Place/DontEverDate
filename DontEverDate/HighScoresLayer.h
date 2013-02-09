//
//  HighScoresLayer.h
//  DontEverDate
//
//  Created by Michael Place on 2/8/13.
//
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "GamePlayLayer.h"

@interface HighScoresLayer : CCLayerColor <UITableViewDataSource, UITableViewDelegate>{
    UITableView *_highScoreTableView;
    UIButton *_backButton;
}

+(CCScene *) scene;

@end
