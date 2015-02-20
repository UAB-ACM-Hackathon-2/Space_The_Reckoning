//
//  STRCharacter.h
//  Space The Reckoning
//
//  Created by Joshua Matthews on 1/31/15.
//  Copyright (c) 2015 Joshua Matthews. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Weapons.h"
#import "gameEnums.h"

@interface STRCharacter : SKNode
@property BOOL isAlive;
@property char type;
@property char move;
@property (nonatomic, strong) SKSpriteNode *mainGuy;

- (instancetype) initWithSize:(CGSize) size atPosition:(CGPoint) location andImage:(NSString*) image withType:(char) t;
- (void) moveNow;
- (void) createWeaponOnScreen:(SKNode*) view;
@end
