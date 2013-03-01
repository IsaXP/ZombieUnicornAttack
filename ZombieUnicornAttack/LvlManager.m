//
//  LvlManager.m
//  ZombieUnicornAttack
//
//  Created by Isabel Pfab on 2/21/13.
//
//

#import "LvlManager.h"

@implementation LvlManager {
    NSArray * _lvls;    //levels array
    int _currentLvlID;   //current level id
}

+(LvlManager *)sharedInstance {
    static dispatch_once_t once;
    static LvlManager *sharedInstance; dispatch_once(&once, ^ { sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    if ((self = [super init])) {
        _currentLvlID = 1;
        Level * lvl1 = [[[Level alloc] initWithLvlNum:1 secsPerSpawn:5 bgColor:ccc4(255, 255, 255, 255)] autorelease];
        Level * lvl2 = [[[Level alloc] initWithLvlNum:2 secsPerSpawn:3 bgColor:ccc4(123, 123, 133, 123)] autorelease];
        _lvls = [@[lvl1, lvl2] retain];
    }
    return self;
}

-(Level*)currentLvl {
    if(_currentLvlID >=_lvls.count) {
        return nil;
    }
    return _lvls[_currentLvlID];
}

-(void)nextLvl {
    _currentLvlID++;
}

-(void)reset {
    _currentLvlID = 0;
}

-(void)dealloc {
    [_lvls release];
    _lvls = nil;
    [super dealloc];
}

@end
