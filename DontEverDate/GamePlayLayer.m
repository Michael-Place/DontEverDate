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
    
    Enemy * enemy;
    if (arc4random() % 2 == 0) {
        enemy = [[[Cupid alloc] init] autorelease];
    } else {
        enemy = [[[BruteCupid alloc] init] autorelease];
    }
    
//    // Determine where to spawn the enemy along the Y axis
    CGSize winSize = [CCDirector sharedDirector].winSize;
//    int minY = enemy.contentSize.height / 2;
//    int maxY = winSize.height - enemy.contentSize.height/2;
//    int rangeY = maxY - minY;
//    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the enemy slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    enemy.position = ccp(100,100);
    [self addChild:enemy];
    
    // Determine speed of the enemy
//    int minDuration = enemy.minMoveDuration; //2.0;
//    int maxDuration = enemy.maxMoveDuration; //4.0;
//    int rangeDuration = maxDuration - minDuration;
//    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
//    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-enemy.contentSize.width/2, -enemy.contentSize.height/2)];
//    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
//        [_enemies removeObject:node];
//        [node removeFromParentAndCleanup:YES];
//        
//        CCScene *gameOverScene = [GameOverLayer sceneWithWon:NO];
//        [[CCDirector sharedDirector] replaceScene:gameOverScene];
//    }];
//    [enemy runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    enemy.tag = 1;
    [_enemies addObject:enemy];
    
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
        
        [self setParameters];
        [self scheduleUpdate];
        
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

    NSMutableArray *enemiesToDelete = [[NSMutableArray alloc] init];
    for (Enemy *e in _enemies) {
        BOOL enemyHit = FALSE;
        if (CGRectIntersectsRect(self.player.boundingBox, e.boundingBox)) {
            enemyHit = TRUE;
            e.hp --;
            if (e.hp <= 0) {
                [enemiesToDelete addObject:e];
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
    [enemiesToDelete release];

    
    for (Enemy *e in _enemies) {
        targetLoc = _player.position;
        int distX = abs(e.position.x - _player.position.x);
        int distY = abs(e.position.y - _player.position.y);
        int distH = sqrt((distX*distX)+(distY*distY));
        if (distH > 100) {
            targetLoc = _player.position;
        }
        else{
            targetLoc = CGPointMake(e.position.x + [self generateRandomBetween:-500 and:500], e.position.y + [self generateRandomBetween:-500 and:500]);
        }
                         
        CGPoint desiredDirection=[self normalizeVector:ccpSub(targetLoc, e.position)];
        velocity=ccpMult(desiredDirection, speed);
        e.position=ccpAdd(e.position, velocity);
        e.rotation=[self angleForVector:velocity];
        [self keepEnemyOnScreen:e];
        
        // find the center of the circle
        CGPoint circleLoc=[self normalizeVector:velocity];
        circleLoc=ccpMult(circleLoc, distance);
        circleLoc=ccpAdd(e.position, circleLoc);
        
        // find a point on the circle's perimiter for our target
        angle=angle+[self generateRandomBetween:-angleNoise and:angleNoise];
        CGPoint perimiterPoint=ccp(cosf(angle), sinf(angle));
        perimiterPoint=ccpMult(perimiterPoint, radius);
        targetLoc=ccpAdd(circleLoc, perimiterPoint);
    }
    
    
//    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
//    for (CCSprite *projectile in _projectiles) {
//        
//        BOOL enemyHit = FALSE;
//        NSMutableArray *enemiesToDelete = [[NSMutableArray alloc] init];
//        for (Enemy *enemy in _enemies) {
//            
//            if (CGRectIntersectsRect(projectile.boundingBox, enemy.boundingBox)) {
//                enemyHit = TRUE;
//                enemy.hp --;
//                if (enemy.hp <= 0) {
//                    [enemiesToDelete addObject:enemy];
//                }
//                break;
//            }
//        }
//        
//        for (CCSprite *enemy in enemiesToDelete) {
//            
//            [_enemies removeObject:enemy];
//            [self removeChild:enemy cleanup:YES];
//            
//            _enemiesDestroyed++;
//            [_hud setBrokenHeartScoreString:[NSString stringWithFormat:@"Broken Hearts: %i", _enemiesDestroyed]];
//            if (_enemiesDestroyed > 30) {
//                CCScene *gameOverScene = [GameOverLayer sceneWithWon:YES];
//                [[CCDirector sharedDirector] replaceScene:gameOverScene];
//            }
//        }
//        
//        if (enemyHit) {
//            [projectilesToDelete addObject:projectile];
////            [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.caf"];
//        }
//        [enemiesToDelete release];
//    }
//    
//    for (CCSprite *projectile in projectilesToDelete) {
//        [_projectiles removeObject:projectile];
//        [self removeChild:projectile cleanup:YES];
//    }
//    [projectilesToDelete release];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [_enemies release];
    _enemies = nil;
    [_projectiles release];
    _projectiles = nil;
    self.player = nil;
    [super dealloc];
    
}

#pragma mark - Math Methods

-(void) setParameters {
    radius = 10.0f;
    distance = 300.0f;
    angleNoise = 0.1f;
    speed = 1.0f;
}


-(float)generateRandomBetween:(float)start and:(float)finish {
    float randomFloat = (arc4random()%1000)/1000;
    return randomFloat*(finish-start)+start;
}

-(CGPoint)normalizeVector:(CGPoint)vector {
    float length = sqrtf(vector.x * vector.x + vector.y * vector.y);
    if (length<0.000001) return ccp(0, 1);
    return ccpMult(vector, 1/length);
}

-(float)angleForVector:(CGPoint)vector {
    float alfa = atanf(vector.x/vector.y)*180/3.14;
    if (vector.y<0) alfa=alfa+180;
    return alfa;
}

-(void)keepEnemyOnScreen:(Enemy*)enemy {
    if (enemy.position.x>480) enemy.position=ccp(enemy.position.x-480, enemy.position.y);
    if (enemy.position.x<0) enemy.position=ccp(enemy.position.x+480, enemy.position.y);
    if (enemy.position.y>320) enemy.position=ccp(enemy.position.x, enemy.position.y-320);
    if (enemy.position.y<0) enemy.position=ccp(enemy.position.x, enemy.position.y+320);
}

@end
