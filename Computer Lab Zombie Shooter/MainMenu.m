//
//  MainMenu.m
//  Computer Lab Zombie Shooter
//
//  Created by Chris Mays on 9/23/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "MainMenu.h"

@implementation MainMenu
static const uint32_t laserCat     =  0x1 << 0;
static const uint32_t playerCat        =  0x1 << 2;
static const uint32_t menuItem        = 0x1 << 5;
@synthesize delegate;
-(id)initWithSize:(CGSize)size {

    if (self = [super initWithSize:size]) {
        self.backgroundColor=[UIColor redColor];
        [self setAnchorPoint:CGPointMake(0.5, 0.5)];
        /**
         
         
         */
        
        playButton=[[SKLabelNode alloc] init];
        multiplayerButton=[[SKLabelNode alloc] init];
        about=[[SKLabelNode alloc] init];
        
        playButton.text=@"Play";
        multiplayerButton.text=@"Multiplayer";
        about.text=@"About";
        playButton.position=CGPointMake( -200,80);

        [playButton setFontSize:60];
        
        playButton.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:playButton.frame.size];
        playButton.physicsBody.dynamic = true;
        playButton.physicsBody.categoryBitMask = menuItem;
        playButton.physicsBody.contactTestBitMask = laserCat;
        playButton.physicsBody.collisionBitMask = 0;
        playButton.physicsBody.usesPreciseCollisionDetection = YES;
        playButton.physicsBody.affectedByGravity=false;
        
        [multiplayerButton setFontSize:60];
        multiplayerButton.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:multiplayerButton.frame.size];
        multiplayerButton.physicsBody.dynamic = true;
        multiplayerButton.physicsBody.categoryBitMask = menuItem;
        multiplayerButton.physicsBody.contactTestBitMask = laserCat;
        multiplayerButton.physicsBody.collisionBitMask = 0;
        multiplayerButton.physicsBody.usesPreciseCollisionDetection = YES;
        multiplayerButton.physicsBody.affectedByGravity=false;
        
        [about setFontSize:60];

        [playButton setFontColor:[UIColor greenColor]];
        [multiplayerButton setFontColor:[UIColor greenColor]];
        [about setFontColor:[UIColor greenColor]];
        
        multiplayerButton.position=CGPointMake(-200, 0);
        about.position=CGPointMake(-200,-80);
        
        
        SKSpriteNode *floor=[[SKSpriteNode alloc] initWithImageNamed:@"floor.png"];
        [self addChild:floor];
        [floor setScale:1.3];

        
        [self addChild:playButton];
        [self addChild:multiplayerButton];
        [self addChild:about];
        
        player=[[Player alloc] init];
        player.anchorPoint=CGPointMake(0.5, 0.2);
        player.zPosition=10;
        player.position=CGPointMake(200, 0);
        player.scale=0.6;
        player.zRotation=M_PI*(3/2);
        player.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:player.size];
        player.physicsBody.dynamic=false;
        player.physicsBody.categoryBitMask=playerCat;
        player.physicsBody.collisionBitMask = 0;
        [self addChild:player];

        self.physicsWorld.contactDelegate = self;

        
        
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        
        
        float angleInDegrees = -(atan2(location.x-player.position.x, location.y));
        
        //[player runAction:[SKAction rotateToAngle:angleInDegrees duration:1.0]];
        player.zRotation=angleInDegrees;
        laser *las=[[laser alloc] init];
        las.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:las.size]; // 1
        las.physicsBody.dynamic = false;
        las.physicsBody.categoryBitMask = laserCat;
        las.physicsBody.contactTestBitMask = menuItem;
        las.physicsBody.collisionBitMask = menuItem;
        las.physicsBody.usesPreciseCollisionDetection = false;
        las.zRotation=angleInDegrees;
        las.position=player.position;
        float distance=sqrt(pow(((location.x-player.position.x)*500), 2)+pow((location.y*500-player.position.y), 2));
        NSLog(@"distance %f", distance);
        [las runAction:[SKAction sequence:@[[SKAction moveByX:(location.x-player.position.x)*500 y:location.y*500 duration:distance/400], [SKAction removeFromParent]]]];
        [self addChild:las];
        NSLog(@"%f",angleInDegrees);
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
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
    
    if ((firstBody.categoryBitMask & laserCat) != 0 &&
        (secondBody.categoryBitMask & menuItem) != 0)
    {
        SKLabelNode *button=(SKLabelNode *)secondBody.node;
        if([button.text isEqualToString:@"Play"]){
            [firstBody.node runAction:[SKAction fadeAlphaTo:0.0 duration:1.0]];
            [secondBody.node runAction:[SKAction fadeAlphaTo:0.0 duration:1.0]];
            SKSpriteNode *leftdoor=[[SKSpriteNode alloc] initWithImageNamed:@"leftDoor.png"];
            SKSpriteNode *rightdoor=[[SKSpriteNode alloc] initWithImageNamed:@"rightDoor.png"];
            leftdoor.anchorPoint=CGPointMake(1.0, 0.5);
            rightdoor.anchorPoint=CGPointMake(0.0, 0.5);
            [leftdoor setScale:2.5];
            [rightdoor setScale:2.5];
            leftdoor.position=CGPointMake(-400, 0);
            rightdoor.position=CGPointMake(400, 0);
            leftdoor.zPosition=800;
            rightdoor.zPosition=800;
            [leftdoor runAction:[SKAction moveTo:CGPointMake(0, 0) duration:2.0]];
            [rightdoor runAction:[SKAction moveTo:CGPointMake(0, 0) duration:2.0]];
            [self addChild:rightdoor];
            [self addChild:leftdoor];
            [delegate performSelector:@selector(playButtonSelected) withObject:NULL afterDelay:3.5];
        }else if([button.text isEqualToString:@"Multiplayer"]){
            [delegate performSelector:@selector(multiplayerButtonPressed) withObject:NULL afterDelay:0.0];

        }
    }
    NSLog(@"Made Contact");

}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        float angleInDegrees = -(atan2(location.x-player.position.x, location.y));
        
        //[player runAction:[SKAction rotateToAngle:angleInDegrees duration:1.0]];
        player.zRotation=angleInDegrees;
        
    }
    
}
@end
