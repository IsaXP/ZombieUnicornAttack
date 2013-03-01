//
//  Level.m
//  ZombieUnicornAttack
//
//  Created by Isabel Pfab on 2/20/13.
//
//

#import "Level.h"

@implementation Level

-(id)initWithLvlNum:(int)lvlNum secsPerSpawn:(float)secsPerSpawn bgColor:(ccColor4B)bgColor {
    if ((self = [super init])) {
        self.lvlNum = lvlNum;
        self.secsPerSpawn = secsPerSpawn;
        self.bgColor = bgColor;
    
    }
    return self;
}

@end
