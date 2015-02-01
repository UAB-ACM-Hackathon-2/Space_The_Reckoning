//
//  Weapons.m
//  Space The Reckoning
//
//  Created by Joshua Matthews on 1/31/15.
//  Copyright (c) 2015 Joshua Matthews. All rights reserved.
//

#import "Weapons.h"

@implementation Weapons

- (instancetype) initWithSize:(CGSize) size atPosition:(CGPoint) location
{
    
    if (self = [super init])
    {
        _weaponToUse = @"bullet";
        [self createWeaponWithSize:size atPosition:location];
    }
    return self;

}

- (void) createWeaponWithSize:(CGSize) size atPosition: (CGPoint) location
{
    if ([_weaponToUse isEqualToString:@"bullet"])
        [self bulletWithSize:size atPosition:location];
}

- (void) moveToLocation:(CGPoint) location onCompletion:(myCompletion) block
{
    [self runAction: [SKAction moveTo:location duration:0.5] completion:^{
        block(YES);
    }];
}

- (void) bulletWithSize:(CGSize) size atPosition:(CGPoint) location
{
    self.weapon = [SKSpriteNode spriteNodeWithImageNamed:@"bullet.png"];
    self.weapon.size = size;
    self.weapon.color = [SKColor blueColor];
    self.weapon.colorBlendFactor = 0.6;
    self.position = location;
    self.weapon.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    self.weapon.physicsBody.categoryBitMask = weaponEnum;
    self.weapon.physicsBody.collisionBitMask = NoMask;
    self.weapon.physicsBody.contactTestBitMask = enemyEnum;
    
    [self addChild:self.weapon];
}

@end
