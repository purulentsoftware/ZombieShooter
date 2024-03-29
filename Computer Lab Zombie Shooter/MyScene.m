//
//  MyScene.m
//  Computer Lab Zombie Shooter
//
//  Created by Chris Mays on 9/17/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "MyScene.h"
#import "Desktop.h"
@implementation MyScene
static const uint32_t laserCat     =  0x1 << 0;
static const uint32_t zombieCat        =  0x1 << 1;
static const uint32_t playerCat        =  0x1 << 2;
static const uint32_t deskCat        =  0x1 << 2;
static const uint32_t compCat        =  0x1 << 3;
static const uint32_t wallCat        =  0x1 << 4;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        scoreLabel=[[SKLabelNode alloc] init];
        scoreLabel.text=[NSString stringWithFormat:@"Score: %lld", score];
        scoreLabel.fontColor=[UIColor blackColor];
        scoreLabel.fontSize=50;
        scoreLabel.position=CGPointMake(220, 450);
        [self addChild: scoreLabel];
        scoreLabel.zPosition=1000;
        zombieArray=[[NSMutableArray alloc] init];
        /* Setup your scene here */
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        SKSpriteNode *floor=[[SKSpriteNode alloc] initWithImageNamed:@"floor.png"];
        [self addChild:floor];
        [floor setScale:1.3];
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        player=[[Player alloc] init];
        player.anchorPoint=CGPointMake(0.5, 0.2);
        player.zPosition=10;
        player.scale=0.6;
        player.zRotation=M_PI*(3/2);
        player.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:player.size];
        player.physicsBody.dynamic=YES;
        player.physicsBody.categoryBitMask=playerCat;
        player.physicsBody.collisionBitMask = 0;
        [self addChild:player];
        Zombie *zom=[[Zombie alloc] init];
        zom.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:zom.size]; // 1
        zom.physicsBody.dynamic = YES; // 2
        zom.physicsBody.categoryBitMask = zombieCat; // 3
        zom.physicsBody.contactTestBitMask = laserCat; // 4
        zom.physicsBody.collisionBitMask = playerCat;
        zom.physicsBody.allowsRotation=false;
        [self addChild:zom];
        [zom runAction:[SKAction moveTo:CGPointMake(0, 500) duration:10]];
        zom.position=CGPointMake(0, -500);
        waveNumber=0;
        [self initDesks];
        score=0;
        SKSpriteNode *leftWall=[[SKSpriteNode alloc] initWithImageNamed:@"computer.png"];
        leftWall.position=CGPointMake((-self.scene.size.width/2)-90, 0);
        leftWall.size=CGSizeMake(20, self.size.height);
        leftWall.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:leftWall.size];
        leftWall.physicsBody.dynamic=false;
        leftWall.physicsBody.categoryBitMask=wallCat;
        leftWall.physicsBody.collisionBitMask=zombieCat |deskCat;
        [self addChild:leftWall];
        SKSpriteNode *rightWall=[[SKSpriteNode alloc] initWithImageNamed:@"computer.png"];
        rightWall.position=CGPointMake((self.scene.size.width/2)+90, 0);
        rightWall.size=CGSizeMake(20, self.size.height);
        rightWall.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:rightWall.size];
        rightWall.physicsBody.dynamic=false;
        rightWall.physicsBody.categoryBitMask=wallCat;
        rightWall.physicsBody.collisionBitMask=zombieCat |deskCat;
        [self addChild:rightWall];
        
        
    }
    return self;
}

-(void)initDesks{
    Desk   *frontLeftDesk=[[Desk alloc] init];
    frontLeftDesk.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:frontLeftDesk.size]; // 1
    frontLeftDesk.physicsBody.dynamic = YES; // 2
    frontLeftDesk.physicsBody.categoryBitMask = deskCat; // 3
    frontLeftDesk.physicsBody.contactTestBitMask = zombieCat; // 4
    frontLeftDesk.physicsBody.collisionBitMask = zombieCat | deskCat | wallCat | laserCat;
    frontLeftDesk.position=CGPointMake(-100, 0);
    [self addChild:frontLeftDesk];
  
    Desk   *middleLeftDesk=[[Desk alloc] init];
    middleLeftDesk.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:middleLeftDesk.size]; // 1
    middleLeftDesk.physicsBody.dynamic = YES; // 2
    middleLeftDesk.physicsBody.categoryBitMask = deskCat; // 3
    middleLeftDesk.physicsBody.contactTestBitMask = zombieCat; // 4
    middleLeftDesk.physicsBody.collisionBitMask = zombieCat | deskCat | wallCat | laserCat;
    middleLeftDesk.position=CGPointMake(-200, 200);
    [self addChild:middleLeftDesk];
    
    
    Desk   *frontRightDesk=[[Desk alloc] init];
    frontRightDesk.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:frontRightDesk.size]; // 1
    frontRightDesk.physicsBody.dynamic = YES; // 2
    frontRightDesk.physicsBody.categoryBitMask = deskCat; // 3
    frontRightDesk.physicsBody.contactTestBitMask = zombieCat; // 4
    frontRightDesk.physicsBody.collisionBitMask = zombieCat | deskCat | playerCat | laserCat;
    frontRightDesk.position=CGPointMake(100, 0);
    [self addChild:frontRightDesk];
    
    Desk   *middleRightDesk=[[Desk alloc] init];
    middleRightDesk.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:middleRightDesk.size]; // 1
    middleRightDesk.physicsBody.dynamic = YES; // 2
    middleRightDesk.physicsBody.categoryBitMask = deskCat; // 3
    middleRightDesk.physicsBody.contactTestBitMask = zombieCat; // 4
    middleRightDesk.physicsBody.collisionBitMask = zombieCat | deskCat | playerCat | laserCat;
    middleRightDesk.position=CGPointMake(200, 200);
    [self addChild:middleRightDesk];
    
    
    
    
    Desktop *desk=[[Desktop alloc] init];
    desk.position=CGPointMake(0, 400);
    [self addChild:desk];
    
    
    
}

/*
 
 
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        float angleInDegrees = -(atan2(location.x, location.y));
        
        //[player runAction:[SKAction rotateToAngle:angleInDegrees duration:1.0]];
        player.zRotation=angleInDegrees;
        laser *las=[[laser alloc] init];
        las.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:las.size]; // 1
        las.physicsBody.dynamic = YES;
        las.physicsBody.categoryBitMask = laserCat;
        las.physicsBody.contactTestBitMask = zombieCat;
        las.physicsBody.collisionBitMask = 0;
        las.physicsBody.usesPreciseCollisionDetection = YES;
        las.zRotation=angleInDegrees;
        float distance=sqrt(pow((location.x*500-player.position.x), 2)+pow((location.y*500-player.position.y), 2));
        NSLog(@"distance %f", distance);
        [las runAction:[SKAction sequence:@[[SKAction moveByX:location.x*500 y:location.y*500 duration:distance/400], [SKAction removeFromParent]]]];
        [self addChild:las];
        NSLog(@"%f",angleInDegrees);
    }
}
- (void)laser:(SKSpriteNode *)las didCollideWithZombie:(SKSpriteNode *)zombie {
    NSLog(@"Hit");
    [las removeFromParent];
    SKLabelNode *points=[[SKLabelNode alloc] init];
    points.text=@"+100 Point!";
    points.fontSize=50;
    points.fontColor=[UIColor blackColor];
    points.zPosition=100;
    points.position=zombie.position;
    [points setScale:0];
    [points runAction:[SKAction sequence:@[[SKAction scaleTo:1.0 duration:2], [SKAction removeFromParent]]]];
    [self addChild:points];
    [zombie removeFromParent];
     score=score+100;
    [zombieArray removeObject:zombie];
    scoreLabel.text=[NSString stringWithFormat:@"Score: %lld", score];
    
    if ([zombieArray count]==0) {
        waveNumber++;
        [self performSelector:@selector(addZombie:) withObject:[NSNumber numberWithInt:waveNumber] afterDelay:4];
        
    }
}

-(void)addZombie:(NSNumber*)waveNum{
    SKLabelNode *label=[[SKLabelNode alloc] init];
    [self addChild:label];
    label.text=[NSString stringWithFormat:@"Wave %d", [waveNum intValue]];
    label.fontSize=100;
    [label setScale:0.0];
    label.fontColor=[UIColor blackColor];
    [label runAction:[SKAction sequence:@[[SKAction scaleTo:1.0 duration:2.0],[SKAction waitForDuration:2.0],[SKAction scaleTo:0.0 duration:2.0],[SKAction removeFromParent] ]]];
    
    int randomZombieCount=arc4random()%(30*[waveNum intValue])+20;
    for (int i=0; i<randomZombieCount; i++) {
        Zombie *zom=[[Zombie alloc] init];
        zom.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:zom.size]; // 1
        zom.physicsBody.dynamic = YES; // 2
        zom.physicsBody.categoryBitMask = zombieCat; // 3
        zom.physicsBody.contactTestBitMask = laserCat; // 4
        zom.physicsBody.collisionBitMask = playerCat | zombieCat;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i/2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self addChild:zom];
            [zom runAction:[SKAction sequence:@[[SKAction runBlock:^(void){NSLog(@"called");}]
                                                ,[SKAction moveTo:CGPointMake(0, 500) duration:10]]]];

        });
                zom.position=CGPointMake(arc4random()%(int)self.view.frame.size.width-self.view.frame.size.width/2, -500);
        zom.physicsBody.allowsRotation=false;

        [zombieArray addObject:zom];

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
        (secondBody.categoryBitMask & zombieCat) != 0)
    {
        [self laser:(SKSpriteNode *)firstBody.node didCollideWithZombie:(SKSpriteNode *)secondBody.node];
    }
    if ((firstBody.categoryBitMask & zombieCat) != 0 &&
        (secondBody.categoryBitMask & deskCat) != 0)
    {
        [(Desk *)secondBody.node deskHit];
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
    float angleInDegrees = -(atan2(location.x, location.y));
    
    //[player runAction:[SKAction rotateToAngle:angleInDegrees duration:1.0]];
    player.zRotation=angleInDegrees;
    
    }

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
