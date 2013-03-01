//
//  HelloWorldLayer.m
//  ZombieUnicornAttack
//
//  Created by Isabel Pfab on 2/19/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//  After the tutorial http://www.raywenderlich.com/25736/how-to-make-a-simple-iphone-game-with-cocos2d-2-x-tutorial


// Import the interfaces
#import "HelloWorldLayer.h"
#import "Monster.h"
#import "GameOverLayer.h"
#import "LvlManager.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(void) addMonster {    //responisble for creating monsters
    
//    CCSprite * monster = [CCSprite spriteWithFile:@"monster.png"]; one type of monster only
    
    Monster * monster = nil;
    if (arc4random()%2 == 0) {
        monster = [[[Enemy1 alloc] init] autorelease];
    }
    else {
        monster = [[[Enemy2 alloc] init] autorelease];
    }
    
    //determine where to spawn monster along Y aixs //?
    CGSize size = [[CCDirector sharedDirector] winSize];
    int minY = monster.contentSize.height/2;
    int maxY = size.height - monster.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;   //select random within range
    
    //use of array
    monster.tag = 1;
    [_monsters addObject:monster];
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    monster.position = ccp(size.width + monster.contentSize.width/2, actualY);
    [self addChild:monster];
    
    
    //monster speed
    int minDuration = monster.minMoveDuration;  //6.0;
    int maxDuration = monster.maxMoveDuration;//10.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    //actions
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-monster.contentSize.width/2, actualY)];
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        [_monsters removeObject:node];
        
    }];
    [monster runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
}


- (void) gameLogic:(ccTime)dt {
    [self addMonster];
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // choose touch
    UITouch *touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    // inital position projectiles
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCSprite *projectile = [CCSprite spriteWithFile:@"arrow.png"];
    projectile.position = ccp(20, size.height/2);
    
    // offset location projectile
    CGPoint offset = ccpSub(location, projectile.position);
    
    // backwards shooting fix
    if (offset.x <= 0) {
        return;
    }
    
    // add projectiles
    [self addChild:projectile];
    projectile.tag = 2;
    [_projectiles addObject:projectile];
    
    //point 
    int realX = size.width + (projectile.contentSize.width/2);
    float ratio = (float) offset.y / (float) offset.x;
    int realY = (realX * ratio) + projectile.position.y;
    CGPoint realDest = ccp(realX, realY);
    
    //shooting length (how far)
    int offRealX = realX - projectile.position.x;
    int offRealY = realY - projectile.position.y;
    float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
    float velocity = 480/1; // 480pixels/1sec
    float realMoveDuration = length/velocity;
    
    //shoot (move projectile)
    [projectile runAction:
     [CCSequence actions:[CCMoveTo actionWithDuration:realMoveDuration position:realDest],
      [CCCallBlockN actionWithBlock:^(CCNode *node){
         [node removeFromParentAndCleanup:YES];
         [_projectiles removeObject:node];
           }],
//       Target:self selector:@selector(spriteMoveFinished)],
     nil]];
 
}

//// callback function, removes sprite after leaving screen (to prevent memory-leakage)
//-(void) spriteMoveFinished: (id)sender {
//    CCSprite *sprite = (CCSprite *)sender;
//    [self removeChild:sprite cleanup:YES];
//
//}


-(void) update:(ccTime)dt {
    
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    
    for (CCSprite *projectile in _projectiles) {
       
        BOOL monsterHit = FALSE;
        NSMutableArray  *monstersToDelete = [[NSMutableArray alloc] init];
        for (Monster *monster in _monsters) {
        
            if (CGRectIntersectsRect(projectile.boundingBox, monster.boundingBox)) {    //collision
                monsterHit = TRUE;
                monster.hp--;
                
                if (monster.hp <= 0) {
                    [monstersToDelete addObject:monster];
                }
                break;
            }
        }
        
    for (CCSprite *monster in monstersToDelete) {
        [_monsters removeObject:monster];
        [self removeChild:monster cleanup:YES];
        
        // kill counter (winning?)     
        _monstersKilled++;
        
#pragma mark @To Do Level design 
        if (_monstersKilled > 10){
            CCScene *gameOver = [GameOverLayer winner:YES];
            [[CCDirector sharedDirector] replaceScene:gameOver];
        }
    }
    
    if (monsterHit) {         //if (monstersToDelete.count > 0) { for one monster type only
        [projectilesToDelete addObject:projectile];
    }
   
    [monstersToDelete release];
    
    }
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value, set background color
	if ((self = [super initWithColor:[LvlManager sharedInstance].currentLvl.bgColor])) {
		
//		// create and initialize a Label
//		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        //create and position player 
        CCSprite *player = [CCSprite spriteWithFile:@"player.png"];
        player.position = ccp(player.contentSize.width/2, size.height/2);
        [self addChild:player];
	
//		// position the label on the center of the screen
//		label.position =  ccp( size.width /2 , size.height/2 );
//		
//		// add the label as a child to this Layer
//		[self addChild: label];
		
		//enable touch
        [self setIsTouchEnabled:YES];
        
        //initialize arrays for mosters and projectiles
        _monsters = [[NSMutableArray alloc] init];
        _projectiles = [[NSMutableArray alloc] init];
        
        //update
        [self schedule:@selector(update:)];
		
		//
//		// Leaderboards and Achievements
//		//
//		
//		// Default font size will be 28 points.
//		[CCMenuItemFont setFontSize:28];
//		
//		// Achievement Menu Item using blocks
//		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
//			
//			
//			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
//			achivementViewController.achievementDelegate = self;
//			
//			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//			
//			[[app navController] presentModalViewController:achivementViewController animated:YES];
//			
//			[achivementViewController release];
//		}
//									   ];
//
//		// Leaderboard Menu Item using blocks
//		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
//			
//			
//			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
//			leaderboardViewController.leaderboardDelegate = self;
//			
//			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//			
//			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
//			
//			[leaderboardViewController release];
//		}
//									   ];
//		
//		CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
//		
//		[menu alignItemsHorizontallyWithPadding:20];
//		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
//		
//		// Add the menu to the layer
//		[self addChild:menu];
//
        
        // spawn monsters over time
        [self schedule:@selector(gameLogic:) interval:[LvlManager sharedInstance].currentLvl.secsPerSpawn ];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [_monsters release];
    _monsters = nil;
    [_projectiles release];
    _projectiles = nil;
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
