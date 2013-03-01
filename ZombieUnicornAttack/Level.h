//
//  Level.h
//  ZombieUnicornAttack
//
//  Created by Isabel Pfab on 2/20/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Level : NSObject

@property (nonatomic, assign) int lvlNum;        // level number
@property (nonatomic, assign) float secsPerSpawn; // seconds per spawn
@property (nonatomic, assign) ccColor4B bgColor; //background color

-(id)initWithLvlNum:(int)lvlNum secsPerSpawn:(float)secsPerSpawn bgColor:(ccColor4B)bgColor;

@end
