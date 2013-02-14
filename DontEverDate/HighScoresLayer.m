//
//  HighScoresLayer.m
//  DontEverDate
//
//  Created by Michael Place on 2/8/13.
//
//

#import "HighScoresLayer.h"
#import "HighScoreManager.h"
#import "UIColor+UIColor_Helper.h"
#import "IntroLayer.h"

@implementation HighScoresLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HighScoresLayer *layer = [[HighScoresLayer alloc] init];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id)init {
    if (self = [super initWithColor:ccc4(255, 255, 255, 255)]) {
        int margin = 40;
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCSprite *background = [CCSprite spriteWithFile:@"game_background.png" rect:CGRectMake(0, 0, winSize.width, winSize.height)];
        
        background.position = CGPointMake(winSize.width/2, winSize.height/2);
        [self addChild:background z:0];
        
         _highScoreTableView = [[UITableView alloc] initWithFrame:CGRectMake(margin,0,[[CCDirector sharedDirector] winSize].width - 2*margin,[[CCDirector sharedDirector] winSize].height) style:UITableViewStylePlain];
        // Set TableView Attributes
        _highScoreTableView.backgroundColor = [UIColor clearColor];
        _highScoreTableView.dataSource = self;
        _highScoreTableView.delegate = self;
        _highScoreTableView.opaque = YES;
        
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake( 0 , [[CCDirector sharedDirector] winSize].height/2, 40, 40)];
        [_backButton addTarget:self action:@selector(backToGameMenu) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"back_Sel.png"] forState:UIControlStateNormal];
        
        // Add View To Scene
        [[[CCDirector sharedDirector] view] addSubview:_highScoreTableView];
        [[[CCDirector sharedDirector] view] addSubview:_backButton];
    }
    return self;
}

-(void)backToGameMenu {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2 scene:[IntroLayer scene] withColor:ccBLACK]];
    [_highScoreTableView removeFromSuperview];
    [_backButton removeFromSuperview];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    NSArray *keys = [[HighScoreManager getHighScoreDictionary] allKeys];
    NSDictionary *tmp = [[HighScoreManager getHighScoreDictionary] valueForKey:[NSString stringWithFormat:@"%i",[indexPath row] ]];
    cell.textLabel.text = [NSString stringWithFormat:@"%i:  %@      -      %@",[indexPath row] + 1, [[tmp allKeys] objectAtIndex:0], [[tmp allValues] objectAtIndex:0]];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[HighScoreManager getHighScoreDictionary] count];
}

-(void)dealloc {
    [_highScoreTableView release];
    _highScoreTableView = nil;
    [super dealloc];
}
@end
