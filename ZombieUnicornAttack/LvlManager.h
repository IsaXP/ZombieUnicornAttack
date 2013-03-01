//
//  LvlManager.h
//  ZombieUnicornAttack
//
//  Created by Isabel Pfab on 2/21/13.
//
//

#import <Foundation/Foundation.h>
#import "Level.h"


@interface LvlManager : NSObject

+(LvlManager *) sharedInstance;
-(Level *) currentLvl;
-(void) nextLvl;
-(void) reset;

@end
