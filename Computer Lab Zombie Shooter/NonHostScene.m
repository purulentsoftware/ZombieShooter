//
//  NonHostScene.m
//  Computer Lab Zombie Shooter
//
//  Created by Chris Mays on 9/24/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "NonHostScene.h"

@implementation NonHostScene
static const uint32_t laserCat     =  0x1 << 0;
static const uint32_t zombieCat        =  0x1 << 1;
static const uint32_t playerCat        =  0x1 << 2;
static const uint32_t deskCat        =  0x1 << 2;
static const uint32_t compCat        =  0x1 << 3;
static const uint32_t wallCat        =  0x1 << 4;
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(peerDidChangeStateWithNotification:)
                                                     name:@"MCDidChangeStateNotification"
                                                   object:nil];
          _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
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
        waveNumber=0;
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        Zombie *zom=[[Zombie alloc] init];
        zom.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:zom.size]; // 1
        zom.physicsBody.dynamic = YES; // 2
        zom.physicsBody.categoryBitMask = zombieCat; // 3
        zom.physicsBody.contactTestBitMask = laserCat; // 4
        zom.physicsBody.collisionBitMask = playerCat | zombieCat;
        [self addChild:zom];
        zom.position=location;
        zom.physicsBody.allowsRotation=false;
        [zom runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(location.x, 600) duration:4],[SKAction runBlock:^(void){
            NSData *dataToSend = [[NSString stringWithFormat:@"%d",(int)location.x] dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
            NSError *error;
            
            [_appDelegate.mcManager.session sendData:dataToSend
                                             toPeers:allPeers
                                            withMode:MCSessionSendDataReliable
                                               error:&error];
            NSLog(@"sent");

        }],[SKAction removeFromParent]]]];

    }
}
@end
