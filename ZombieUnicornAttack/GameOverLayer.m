//
//  GameOverLayer.m
//  ZombieUnicornAttack
//
//  Created by Isabel Pfab on 2/20/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"
#import "HelloWorldLayer.h"
#import "LvlManager.h"
#import "Level.h"

@implementation GameOverLayer

+(CCScene *) winner:(BOOL)won {
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[[ GameOverLayer alloc] initWinner:won] autorelease];
    [scene addChild:layer];
    return scene;
}


-(id)initWinner:(BOOL)won{
    if ((self = [super initWithColor:ccc4(255,255,255,255)])) {
        
        // success / fail message
        NSString *message;
        if (won) {
            [[LvlManager sharedInstance] nextLvl];
            Level * currentLvl = [[LvlManager sharedInstance] currentLvl];
            
            if (currentLvl ) {
                message = [NSString stringWithFormat:
                @"Move on to the next level (%d)!", currentLvl.lvlNum];
            }
            else {
            message = @"Winning!";
            [[LvlManager sharedInstance] reset];
            }
        }
        else {
            message = @"Nope!";
            [[LvlManager sharedInstance] reset];
        }
        
        //displayed by label in the center of the screen
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:message fontName:@"Helvetica" fontSize:22];
        label.color = ccc3(0,0,0);        
        label.position = ccp(size.width/2, size.height/2);
        [self addChild:label];
        
        [self runAction:
            [CCSequence actions:
             [CCDelayTime actionWithDuration:3],
             [CCCallBlockN actionWithBlock:^(CCNode *node) {
                [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
            }],
             nil]];
         }
         return self;
}

@end
