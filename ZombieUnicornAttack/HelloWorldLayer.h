//
//  HelloWorldLayer.h
//  ZombieUnicornAttack
//
//  Created by Isabel Pfab on 2/19/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor
{
}


// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end

// store info about monsters and projectiles location
NSMutableArray * _monsters;
NSMutableArray * _projectiles;
int _monstersKilled;
