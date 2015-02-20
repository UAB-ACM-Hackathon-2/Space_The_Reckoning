//
//  STRCharacter.m
//  Space The Reckoning
//
//  Created by Joshua Matthews on 1/31/15.
//  Copyright (c) 2015 Joshua Matthews. All rights reserved.
//

#import "STRCharacter.h"

@interface STRCharacter ()

@end

@implementation STRCharacter

- (instancetype) initWithSize:(CGSize) size atPosition:(CGPoint) location andImage:(NSString *)image withType:(char) t
{
    if (self = [super init])
    {
        self.isAlive = YES;
        self.type = t;
        [self createCharacter:size atPosition:location andImage:image];
    }
    return self;
}

- (void) createCharacter: (CGSize) size atPosition:(CGPoint) location andImage:(NSString*) image
{
    self.mainGuy = [SKSpriteNode spriteNodeWithImageNamed:image];
    self.mainGuy.size = size;
    self.position = location;
    self.mainGuy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    self.mainGuy.physicsBody.allowsRotation = NO;
    self.mainGuy.physicsBody.collisionBitMask = NoMask;
    if (_type == 'g')
    {
        self.mainGuy.physicsBody.categoryBitMask = heroEnum;
        self.mainGuy.physicsBody.contactTestBitMask = doritoEnum;
    }
    else if (_type == 'b')
    {
        self.mainGuy.physicsBody.categoryBitMask = enemyEnum;
        self.mainGuy.physicsBody.contactTestBitMask = weaponEnum | wallEnum;
    }
    else if (_type == 'S')
    {
        self.mainGuy.physicsBody.categoryBitMask = superBad;
        self.mainGuy.physicsBody.contactTestBitMask = weaponEnum | wallEnum;
    }
    
    [self addChild:self.mainGuy];
    
}

- (void)moveNow
{
    if (_move == 'w')
    {
        [self runAction:[SKAction moveBy:CGVectorMake(0.0, 10.0) duration:0.7]];
    }
    if (_move == 's')
    {
        [self runAction:[SKAction moveBy:CGVectorMake(0.0, -10.0) duration:0.7]];
    }
    if (_move == 'a')
    {
        [self runAction:[SKAction moveBy:CGVectorMake(-10.0, 0.0) duration:0.7]];
    }
    if (_move == 'd')
    {
        [self runAction:[SKAction moveBy:CGVectorMake(10.0, 0.0) duration:0.7]];
    }

}

- (void) createWeaponOnScreen:(SKNode *)view 
{
    Weapons * mainWeapon = [[Weapons alloc] initWithSize:CGSizeMake(20, 30)
                                         atPosition:CGPointMake(self.position.x,
                                                                self.position.y +
                                                                (self.mainGuy.size.height / 2) + 5)];
    [mainWeapon moveToLocation:CGPointMake(self.position.x,
                                                view.frame.size.height +
                                                mainWeapon.frame.size.height +
                                                20)
                       onCompletion:^(BOOL finished)
    {
        if (finished)
        {
            [mainWeapon removeFromParent];
        }
    }];
    [view addChild:mainWeapon];
    
}





@end
