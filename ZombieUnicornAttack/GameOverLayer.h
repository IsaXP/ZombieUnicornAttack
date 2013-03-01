//
//  GameOverLayer.h
//  ZombieUnicornAttack
//
//  Created by Isabel Pfab on 2/20/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor 
    +(CCScene *) winner:(BOOL)won;
    -(id)initWinner:(BOOL)won;

@end
