//
//  GameScene.m
//  Space The Reckoning
//
//  Created by Joshua Matthews on 1/31/15.
//  Copyright (c) 2015 Joshua Matthews. All rights reserved.
//

#import "GameScene.h"
#import "STRCharacter.h"
#import "FinalView.h"

NSString *fontStyle = @"Courier";

@interface GameScene ()
@property BOOL MLG_Mode;
@property BOOL didCreate;
@property (nonatomic, strong) SKLabelNode *myLabel;
@property (nonatomic, strong) SKLabelNode *scoreLabel;
@property (nonatomic, strong) SKLabelNode *healthLabel;
@property (nonatomic, strong) STRCharacter * tempGuy;
@property (nonatomic, strong) STRCharacter * secGuy;
@property BOOL isShoot;
@property (nonatomic, strong) AVAudioPlayer * background_music;
@property (nonatomic, strong) AVAudioPlayer * second_music;
@property int BossHealth;
@end


@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    if (!_didCreate)
    {
        isMLG = false;
    
        Health = 25;
        HighScore = 0;
        [self setUpScreen];
        [self handleLabels];
        [self setupBackGroundSong];
        self.tempGuy = [[STRCharacter alloc] initWithSize:CGSizeMake(80, 80)
                                               atPosition:CGPointMake(CGRectGetMidX(self.frame), 40) andImage:@"Spaceship.png" withType:'g'];
        
        [self addChild:self.tempGuy];
    }
    _didCreate = YES;
    
}

- (void) setUpScreen
{
    self.backgroundColor = [SKColor blackColor];
    SKSpriteNode *temp = [SKSpriteNode spriteNodeWithImageNamed:@"Space.jpg"];
    temp.size = self.size;
    temp.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    temp.zPosition = -1;
    [self addChild:temp];
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    
    
    CGSize size = CGSizeMake(self.frame.size.width + 200, 10);
    SKSpriteNode * wall = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
    wall.position = CGPointMake(CGRectGetMidY(self.frame), 0);
    wall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    wall.physicsBody.categoryBitMask = wallEnum;
    wall.physicsBody.contactTestBitMask = enemyEnum;
    wall.physicsBody.collisionBitMask = NoMask;
    [self addChild:wall];
}

- (void) setupBackGroundSong
{
    NSString *tempStr = [[NSBundle mainBundle] pathForResource:@"09 Selection" ofType:@"m4a"];
    NSData * music_data = [NSData dataWithContentsOfFile:tempStr];
    
    NSError *err = nil;
    self.background_music = [[AVAudioPlayer alloc] initWithData:music_data error:&err];
    
    self.background_music.volume = 0.7;
    self.background_music.numberOfLoops = -1;
    [self.background_music play];
    
    NSString *tempStr2 = [[NSBundle mainBundle] pathForResource:@"Snoop Dogg Smoke weed every day (dubstep remix)" ofType:@"mp3"];
    NSData * music_data2 = [NSData dataWithContentsOfFile:tempStr2];
    
    NSError *err2 = nil;
    self.second_music = [[AVAudioPlayer alloc] initWithData:music_data2 error:&err2];
    
    self.second_music.volume = 0.7;
    self.second_music.numberOfLoops = -1;
}


- (void) handleLabels
{

    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:fontStyle];
    self.scoreLabel.fontSize = 40;
    self.scoreLabel.fontColor = [SKColor redColor];
    self.scoreLabel.text = [NSString stringWithFormat:@"score: %d",HighScore];
    self.scoreLabel.alpha = 0.0;
    self.scoreLabel.position = CGPointMake(120, self.frame.size.height - 40);
    
    [self addChild:self.scoreLabel];

    self.myLabel = [SKLabelNode labelNodeWithFontNamed:fontStyle];
    
    self.myLabel.text = @"Start";
    _myLabel.fontColor = [SKColor blueColor];
    _myLabel.fontSize = 65;
    _myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                    CGRectGetMidY(self.frame));
    
    [self addChild:_myLabel];
    
    self.healthLabel = [SKLabelNode labelNodeWithFontNamed:fontStyle];
    self.healthLabel.fontColor = [SKColor redColor];
    self.healthLabel.fontSize = 40;
    self.healthLabel.text = [NSString stringWithFormat:@"Health: %d",Health];
    self.healthLabel.alpha = 0.0;
    self.healthLabel.position = CGPointMake(self.frame.size.width - 140, self.frame.size.height - 40);
    
    [self addChild:self.healthLabel];
    
}

- (void) createBadGuys
{
    
    CGPoint tempP = CGPointMake(arc4random_uniform(self.frame.size.width - 100) + 50, self.frame.size.height);
    STRCharacter * badguy = [[STRCharacter alloc] initWithSize:CGSizeMake(90, 90) atPosition:tempP andImage:@"Spaceship_tut.png" withType:'b'];
    [badguy runAction:[SKAction moveTo:CGPointMake(tempP.x, tempP.y - self.frame.size.height) duration:4.5] completion:^{
        [badguy removeFromParent];
    }];
    [self addChild:badguy];
    
    if (arc4random_uniform(20) == 5)
    {
        STRCharacter * superBadGuy = [[STRCharacter alloc] initWithSize:CGSizeMake(300, 450) atPosition:CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height + 170) andImage:@"Spaceship_tut_thin.png" withType:'S'];
        
        self.BossHealth = 10;
        
        [superBadGuy runAction:[SKAction moveTo:CGPointMake(superBadGuy.position.x, -170) duration:10.0] completion:^{
            [superBadGuy removeFromParent];
        }];
        [self addChild:superBadGuy];
    }
}


-(void)mouseDown:(NSEvent *)theEvent {
     /* Called when a mouse click occurs */
    
    CGPoint location = [theEvent locationInNode:self];
    
    if (CGRectContainsPoint(self.myLabel.frame, location))
    {
        [self.myLabel runAction:[SKAction fadeAlphaTo:0.0 duration:0.5]];
        [self.myLabel removeFromParent];
        [self.scoreLabel runAction:[SKAction fadeAlphaTo:1.0 duration:1.0]];
        [self.healthLabel runAction:[SKAction fadeAlphaTo:1.0 duration:1.0]];
        SKAction * bad = [SKAction repeatActionForever:
                          [SKAction sequence:@[
                                               [SKAction performSelector:
                                                @selector(createBadGuys)
                                                                onTarget:self],
                                               [SKAction waitForDuration:1.5 withRange:2.5]
                                                                            ]]];
        
        [self runAction:bad];

    }
    
    
    
}

- (void) keyDown:(NSEvent *)theEvent
{
    
    if ([[theEvent characters] isEqualToString:@"d"])
    {
        self.tempGuy.move = 'd';
    }
    if ([[theEvent characters] isEqualToString:@"a"])
    {
        self.tempGuy.move = 'a';
    }
    if ([[theEvent characters] isEqualToString:@" "])
    {
        [self.tempGuy createWeaponOnScreen:self];
        _isShoot = YES;
    }
    if ([[theEvent characters] isEqualToString:@"M"])
    {
        [self.background_music stop];
        [self.second_music play];
        self.MLG_Mode = YES;
        isMLG = true;
        
    }

    if ([[theEvent characters] isEqualToString:@"J"])
    {
        [self.second_music stop];
        [self.background_music play];
        self.MLG_Mode = NO;
        isMLG = false;
    }
    
}


- (void) keyUp:(NSEvent *)theEvent
{

    if ([[theEvent characters] isEqualToString:@"d"])
    {
        self.tempGuy.move = '0';
    }
    if ([[theEvent characters] isEqualToString:@"a"])
    {
        self.tempGuy.move = '0';
    }
    if ([[theEvent characters] isEqualToString:@" "])
    {
        _isShoot = NO;
    }

}

-(void)update:(CFTimeInterval)currentTime {

    [self.tempGuy moveNow];

    self.healthLabel.text = [NSString stringWithFormat:@"Health: %d",Health];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",HighScore];
    
}

- (void) displayFinalScreen
{
    SKTransition *door = [SKTransition doorsCloseHorizontalWithDuration:0.5];
    FinalView *thescene = [[FinalView alloc] initWithSize:self.size];
    [self.view presentScene:thescene transition:door];
}

- (void) didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody * firstBody;
    SKPhysicsBody * secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & enemyEnum) != 0 && (secondBody.categoryBitMask & weaponEnum) != 0)
    {
        [self handleBadGuy:(STRCharacter*)secondBody.node andWeapon:firstBody.node];
    }
    if ((firstBody.categoryBitMask & enemyEnum) != 0 && (secondBody.categoryBitMask & wallEnum) != 0)
    {
        [self subtractHealth];
    }
    if ((firstBody.categoryBitMask & heroEnum) != 0 && (secondBody.categoryBitMask & doritoEnum)!=0)
    {
        [self reward:firstBody.node kill:secondBody.node];
    }
    if ((firstBody.categoryBitMask & wallEnum) != 0 && (secondBody.categoryBitMask & superBad) != 0)
    {
        [self subtractHealth];
    }
    if ((firstBody.categoryBitMask & weaponEnum) != 0 && (secondBody.categoryBitMask & superBad) != 0)
    {
        [self attackBoss:secondBody.node withMissle:firstBody.node];
    }


    
}

- (void) attackBoss:(SKNode*) thing withMissle:(SKNode*) thing2
{
    self.BossHealth--;
    if(self.BossHealth <= 0)
    {
        [thing removeFromParent];
        HighScore += 10;
    }
    [thing2 removeFromParent];
}

- (void) subtractHealth
{
    Health--;
    if (Health <= 0)
    {
        [self.background_music stop];
        [self displayFinalScreen];
    }
}

- (void) reward:(SKNode*)thing kill:(SKNode*) thing2
{
    if (self.MLG_Mode)
    {
        SKAction *spin = [SKAction repeatAction:[SKAction rotateByAngle:5 duration:0.1] count:40];
        [thing runAction:spin completion:^{
            thing.zRotation = 0.0;
        }];
    }
    else
    {
        
    }
    [thing2 removeFromParent];
    doritoCount++;
    HighScore += 5;
}

- (void) handleBadGuy:(STRCharacter*) enemy andWeapon:(SKNode*) weapon
{
    if (arc4random_uniform(2) == 1)
    {
        SKLabelNode *mlg = [SKLabelNode labelNodeWithFontNamed:fontStyle];
        mlg.fontSize = 70;
        mlg.fontColor = [SKColor magentaColor];
        if (self.MLG_Mode)
            mlg.text = @"MLG PRO!!!";
        else
            mlg.text = @"Extra Points!!";
        mlg.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        mlg.zRotation = 0.2;
        
        SKAction *temp = [SKAction sequence:@[
                                              [SKAction waitForDuration:0.5],
                                              [SKAction fadeAlphaTo:0.0 duration:0.5]
                                              ]];
        [mlg runAction:temp completion:^{
            [mlg removeFromParent];
        }];
        [self addChild:mlg];
        SKSpriteNode *dorito;
        if (self.MLG_Mode)
             dorito = [SKSpriteNode spriteNodeWithImageNamed:@"dorito.png"];
        else
            dorito = [SKSpriteNode spriteNodeWithImageNamed:@"Orange.png"];
        dorito.size = CGSizeMake(60, 60);
        dorito.position = CGPointMake(arc4random_uniform(self.frame.size.width - 150) + 100, mlg.position.y);
        dorito.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:dorito.size];
        
        dorito.physicsBody.collisionBitMask = NoMask;
        dorito.physicsBody.categoryBitMask = doritoEnum;
        dorito.physicsBody.contactTestBitMask = heroEnum;
        
        [dorito runAction:[SKAction moveTo:CGPointMake(dorito.position.x, -80) duration:4.0]];
        [self addChild:dorito];
    }

    [enemy removeAllActions];
    [enemy removeFromParent];
    [weapon removeFromParent];
    HighScore++;
    
}

@end
