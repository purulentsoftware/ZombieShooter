//
//  MainMenu.h
//  Computer Lab Zombie Shooter
//
//  Created by Chris Mays on 9/23/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Player.h"
#import "laser.h"

@protocol MainMenuDelegate
-(void)playButtonSelected;
-(void)multiplayerButtonPressed;

@end
@interface MainMenu : SKScene<SKPhysicsContactDelegate>{
    SKLabelNode *playButton;
    SKLabelNode *multiplayerButton;
    SKLabelNode *about;
    Player *player;
}
@property (nonatomic, assign) id  delegate;

@end
