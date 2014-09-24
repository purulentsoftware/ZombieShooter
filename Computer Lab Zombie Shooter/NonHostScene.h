//
//  NonHostScene.h
//  Computer Lab Zombie Shooter
//
//  Created by Chris Mays on 9/24/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Player.h"
#import "laser.h"
#import "Zombie.h"
#import "Desk.h"
#import "AppDelegate.h"
@interface NonHostScene : SKScene{
    Player *player;
    NSMutableArray *zombieArray;
    int waveNumber;
    long long score;
    SKLabelNode *scoreLabel;
}
@property (nonatomic, strong) AppDelegate *appDelegate;


@end
