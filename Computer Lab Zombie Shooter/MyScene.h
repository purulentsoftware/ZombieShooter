//
//  MyScene.h
//  Computer Lab Zombie Shooter
//

//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Player.h"
#import "laser.h"
#import "Zombie.h"
#import "Desk.h"
@interface MyScene : SKScene <SKPhysicsContactDelegate>{
    Player *player;
    NSMutableArray *zombieArray;
    int waveNumber;
    long long score;
    SKLabelNode *scoreLabel;
}

@end
