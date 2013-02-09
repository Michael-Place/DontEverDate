//
//  HighScoresLayer.m
//  DontEverDate
//
//  Created by Michael Place on 2/8/13.
//
//

#import "HighScoresLayer.h"

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
         _highScoreTableView = [[UITableView alloc] initWithFrame:CGRectMake(margin,0,[[CCDirector sharedDirector] winSize].width - 2*margin,[[CCDirector sharedDirector] winSize].height) style:UITableViewStylePlain];
        // Set TableView Attributes
        _highScoreTableView.backgroundColor = [UIColor clearColor];
        _highScoreTableView.dataSource = self;
        _highScoreTableView.delegate = self;
        _highScoreTableView.opaque = YES;
        
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, margin, [[CCDirector sharedDirector] winSize].height)];
        [_backButton addTarget:self action:@selector(backToGameMenu) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setTintColor:[UIColor redColor]];
        [_backButton setBackgroundColor:[UIColor redColor]];
        
        // Add View To Scene
        [[[CCDirector sharedDirector] view] addSubview:_highScoreTableView];
        [[[CCDirector sharedDirector] view] addSubview:_backButton];
    }
    return self;
}

-(void)backToGameMenu {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[GamePlayLayer scene] withColor:ccWHITE]];
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
    
    cell.textLabel.text = @"test";
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(void)dealloc {
    [_highScoreTableView release];
    _highScoreTableView = nil;
    [super dealloc];
}
@end
