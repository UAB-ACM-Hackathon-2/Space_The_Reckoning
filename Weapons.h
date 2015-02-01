//
//  Weapons.h
//  Space The Reckoning
//
//  Created by Joshua Matthews on 1/31/15.
//  Copyright (c) 2015 Joshua Matthews. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "gameEnums.h"

typedef void(^myCompletion)(BOOL);

@interface Weapons : SKNode 
@property (nonatomic, strong) NSString *weaponToUse;
@property (nonatomic, strong) SKSpriteNode * weapon;

- (instancetype) initWithSize:(CGSize) size atPosition:(CGPoint) location;
- (void) moveToLocation:(CGPoint) location onCompletion:(myCompletion) block;
- (void) createWeaponWithSize:(CGSize) size atPosition: (CGPoint) location;
@end
