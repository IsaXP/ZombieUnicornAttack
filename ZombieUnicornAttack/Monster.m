//
//  Monster.m
//  ZombieUnicornAttack
//
//  Created by Isabel Pfab on 2/20/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Monster.h"


@implementation Monster

-(id)initWithFile:(NSString *)file hp:(int)hp minMoveDuration:(int)minMoveDuration maxMoveDuration:(int)maxMoveDuration {
    if ((self = [super initWithFile:file])) {
        self.hp =hp;
        self.minMoveDuration = minMoveDuration;
        self.maxMoveDuration = maxMoveDuration;
    }
    return self;
}
@end

@implementation Enemy1

-(id)init {
    if ((self = [super initWithFile:@"zombie1-hd.png" hp:1 minMoveDuration:6 maxMoveDuration:10])) {
    }
    return self;
}
@end

@implementation Enemy2

-(id)init {
    if ((self = [super initWithFile:@"zombie2-hd.png" hp:3 minMoveDuration:20 maxMoveDuration:30])) { //replace image
    }
    return self;
}

@end