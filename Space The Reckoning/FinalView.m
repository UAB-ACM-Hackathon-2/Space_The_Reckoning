//
//  FinalView.m
//  Space The Reckoning
//
//  Created by Joshua Matthews on 1/31/15.
//  Copyright (c) 2015 Joshua Matthews. All rights reserved.
//


#import "FinalView.h"
#import "gameEnums.h"
#import "GameScene.h"



@interface FinalView ()
@property BOOL didCreate;
@property (nonatomic, strong) SKLabelNode *back;

@end

@implementation FinalView

- (void)didMoveToView:(SKView *)view
{
    if (!_didCreate)
    {
        [self createScene];
    }
    _didCreate = YES;
}

- (void) createScene
{
    self.backgroundColor = [SKColor whiteColor];
    
    NSMutableDictionary *saveFile = [NSMutableDictionary dictionaryWithContentsOfFile:@"./save.plist"];
    
    
    SKSpriteNode *map = [SKSpriteNode spriteNodeWithImageNamed:@"outSpace.jpg"];
    map.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    map.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:map];
    
    
    SKLabelNode *score = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    score.fontColor = [SKColor greenColor];
    score.fontSize = 65;
    score.text = [NSString stringWithFormat:@"Score: %d", [[saveFile objectForKey:@"HighScore"] intValue]];
    score.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 40);
    [self addChild:score];
    
    
    SKLabelNode * time = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    time.fontSize = 65;
    time.fontColor = [SKColor greenColor];
    if (isMLG)
        time.text = [NSString stringWithFormat:@"Doritos Collected: %d", [[saveFile objectForKey:@"doritoPoints"] intValue]];
    else
        time.text = [NSString stringWithFormat:@"Extra Points Collected: %d", [[saveFile objectForKey:@"doritoPoints"] intValue]];
    time.position = CGPointMake(score.position.x, score.position.y + 80);
    
    [self addChild:time];
    
    _back = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    _back.fontColor = [SKColor blueColor];
    _back.fontSize = 65;
    _back.text = @"Try Again?";
    
    _back.position = CGPointMake(score.position.x, score.position.y - 80);
    [self addChild:_back];
    
}

- (void) mouseDown:(NSEvent *)theEvent
{
    CGPoint location = [theEvent locationInNode:self];
    
    if (CGRectContainsPoint(_back.frame, location))
    {
        SKTransition *door = [SKTransition doorsOpenHorizontalWithDuration:0.5];
        GameScene *theScene = [[GameScene alloc] initWithSize:self.size];
        [self.view presentScene:theScene transition:door];
    }

}


@end
