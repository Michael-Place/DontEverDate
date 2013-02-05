//
//  GamePlayLayer.m
//  DontEverDate
//
//  Created by Michael Place on 2/3/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "GamePlayLayer.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#import "GameOverLayer.h"
#import "Enemy.h"
#import "LevelManager.h"

#pragma mark - GamePlayLayer

@implementation GamePlayLayer
static CGRect screenRect;

// Helper class method that creates a Scene with the GamePlayLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
    HUDLayer *hud = [HUDLayer node];
    [scene addChild:hud z:1];
    
	// 'layer' is an autorelease object.
	GamePlayLayer *layer = [[GamePlayLayer alloc] initWithHUD:hud];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


- (void) addEnemy {
    
    Enemy * enemy = nil;
    if (arc4random() % 2 == 0) {
        enemy = [[[Cupid alloc] init] autorelease];
    } else {
        enemy = [[[BruteCupid alloc] init] autorelease];
    }
    
    // Determine where to spawn the enemy along the Y axis
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int minY = enemy.contentSize.height / 2;
    int maxY = winSize.height - enemy.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the enemy slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    enemy.position = ccp(winSize.width + enemy.contentSize.width/2, actualY);
    [self addChild:enemy];
    
    // Determine speed of the enemy
    int minDuration = enemy.minMoveDuration; //2.0;
    int maxDuration = enemy.maxMoveDuration; //4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-enemy.contentSize.width/2, -enemy.contentSize.height/2)];
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [_enemies removeObject:node];
        [node removeFromParentAndCleanup:YES];
        
        CCScene *gameOverScene = [GameOverLayer sceneWithWon:NO];
        [[CCDirector sharedDirector] replaceScene:gameOverScene];
    }];
    [enemy runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    enemy.tag = 1;
    [_enemies addObject:enemy];
    
}

// override setPosition to keep it within screen bounds
-(void) setPosition:(CGPoint)pos
{
	// If the current position is (still) outside the screen no adjustments should be made!
	// This allows it to move into the screen from outside.
	if (CGRectContainsRect(screenRect, [self boundingBox]))
	{
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		float halfWidth = self.contentSize.width * 0.5f;
		float halfHeight = self.contentSize.height * 0.5f;
        
		// Cap the position so the Ship's sprite stays on the screen
		if (pos.x < halfWidth)
		{
			pos.x = halfWidth;
		}
		else if (pos.x > (screenSize.width - halfWidth))
		{
			pos.x = screenSize.width - halfWidth;
		}
        
		if (pos.y < halfHeight)
		{
			pos.y = halfHeight;
		}
		else if (pos.y > (screenSize.height - halfHeight))
		{
			pos.y = screenSize.height - halfHeight;
		}
	}
    
	[super setPosition:pos];
}

-(void)gameLogic:(ccTime)dt {
    [self addEnemy];
}

- (id)initWithHUD:(HUDLayer *)hud {
    if ((self = [super initWithColor:[LevelManager sharedInstance].curLevel.backgroundColor])) {
        [self setIsTouchEnabled:YES];
        if (CGRectIsEmpty(screenRect)){
            CGSize screenSize = [[CCDirector sharedDirector] winSize];
            screenRect = CGRectMake(0, 0, screenSize.width, screenSize.height);
        }
        // Initialize HUD
        _hud = hud;
        [_hud setPlayerHealthString:[NSString stringWithFormat:@"Health: 3"]];
        [_hud setBrokenHeartScoreString:[NSString stringWithFormat:@"Broken Hearts: %i", _enemiesDestroyed]];
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        _player = [CCSprite spriteWithFile:@"Player.png"];
        _player.position = ccp(_player.contentSize.width/2, winSize.height/2);
        [self addChild:_player];
        
        [self schedule:@selector(gameLogic:) interval:[LevelManager sharedInstance].curLevel.secsPerSpawn];
        
        _enemies = [[NSMutableArray alloc] init];
        _projectiles = [[NSMutableArray alloc] init];
        
        [self schedule:@selector(update:)];
        
        //        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf"];
        
    }
    return self;
}

-(void) registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0
                                              swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInView: [touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    
    float playerVelocity = 480.0/3.0;
    CGPoint moveDifference = ccpSub(touchLocation, _player.position);
    float distanceToMove = ccpLength(moveDifference);
    float moveDuration = distanceToMove / playerVelocity;

    if (moveDifference.x < 0) {
        _player.flipX = NO;
    } else {
        _player.flipX = YES;
    }
    
    [_player stopAction:_moveAction];
        
    self.moveAction = [CCSequence actions:
                       [CCMoveTo actionWithDuration:moveDuration position:touchLocation],
                       [CCCallFunc actionWithTarget:self selector:@selector(playerMoveEnded)],
                       nil];
    
    [_player runAction:_moveAction];
    _moving = TRUE;
}

//- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    if (_nextProjectile != nil) return;
//    
//    // Choose one of the touches to work with
//    UITouch *touch = [touches anyObject];
//    CGPoint location = [self convertTouchToNodeSpace:touch];
//    
//    // Set up initial location of projectile
//    CGSize winSize = [[CCDirector sharedDirector] winSize];
//    _nextProjectile = [[CCSprite spriteWithFile:@"Projectile.png"] retain];
//    _nextProjectile.position = ccp(20, winSize.height/2);
//    
//    // Determine offset of location to projectile
//    CGPoint offset = ccpSub(location, _nextProjectile.position);
//    
//    // Bail out if you are shooting down or backwards
//    if (offset.x <= 0) return;
//    
//    // Determine where you wish to shoot the projectile to
//    int realX = winSize.width + (_nextProjectile.contentSize.width/2);
//    float ratio = (float) offset.y / (float) offset.x;
//    int realY = (realX * ratio) + _nextProjectile.position.y;
//    CGPoint realDest = ccp(realX, realY);
//    
//    // Determine the length of how far you're shooting
//    int offRealX = realX - _nextProjectile.position.x;
//    int offRealY = realY - _nextProjectile.position.y;
//    float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
//    float velocity = 480/1; // 480pixels/1sec
//    float realMoveDuration = length/velocity;
//    
//    // Determine angle to face
//    float angleRadians = atanf((float)offRealY / (float)offRealX);
//    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
//    float cocosAngle = -1 * angleDegrees;
//    float rotateDegreesPerSecond = 180 / 0.5; // Would take 0.5 seconds to rotate 180 degrees, or half a circle
//    float degreesDiff = _player.rotation - cocosAngle;
//    float rotateDuration = fabs(degreesDiff / rotateDegreesPerSecond);
//    [_player runAction:
//     [CCSequence actions:
//      [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
//      [CCCallBlock actionWithBlock:^{
//         // OK to add now - rotation is finished!
//         [self addChild:_nextProjectile];
//         [_projectiles addObject:_nextProjectile];
//         
//         // Release
//         [_nextProjectile release];
//         _nextProjectile = nil;
//     }],
//      nil]];
//    
//    // Move projectile to actual endpoint
//    [_nextProjectile runAction:
//     [CCSequence actions:
//      [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
//      [CCCallBlockN actionWithBlock:^(CCNode *node) {
//         [_projectiles removeObject:node];
//         [node removeFromParentAndCleanup:YES];
//     }],
//      nil]];
//    
//    _nextProjectile.tag = 2;
//    
////    [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
//}

-(void)playerMoveEnded {
    _moving = FALSE;
}

- (void)update:(ccTime)dt {
    
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    for (CCSprite *projectile in _projectiles) {
        
        BOOL enemyHit = FALSE;
        NSMutableArray *enemiesToDelete = [[NSMutableArray alloc] init];
        for (Enemy *enemy in _enemies) {
            
            if (CGRectIntersectsRect(projectile.boundingBox, enemy.boundingBox)) {
                enemyHit = TRUE;
                enemy.hp --;
                if (enemy.hp <= 0) {
                    [enemiesToDelete addObject:enemy];
                }
                break;
            }
        }
        
        for (CCSprite *enemy in enemiesToDelete) {
            
            [_enemies removeObject:enemy];
            [self removeChild:enemy cleanup:YES];
            
            _enemiesDestroyed++;
            [_hud setBrokenHeartScoreString:[NSString stringWithFormat:@"Broken Hearts: %i", _enemiesDestroyed]];
            if (_enemiesDestroyed > 30) {
                CCScene *gameOverScene = [GameOverLayer sceneWithWon:YES];
                [[CCDirector sharedDirector] replaceScene:gameOverScene];
            }
        }
        
        if (enemyHit) {
            [projectilesToDelete addObject:projectile];
//            [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.caf"];
        }
        [enemiesToDelete release];
    }
    
    for (CCSprite *projectile in projectilesToDelete) {
        [_projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
    [projectilesToDelete release];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [_enemies release];
    _enemies = nil;
    [_projectiles release];
    _projectiles = nil;
    self.walkAction = nil;
    self.player = nil;
    [super dealloc];
    
}

@end
