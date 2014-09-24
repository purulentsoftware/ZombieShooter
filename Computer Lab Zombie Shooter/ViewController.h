//
//  ViewController.h
//  Computer Lab Zombie Shooter
//

//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "MainMenu.h"
#import "PeerLobbyViewController.h"
@interface ViewController : UIViewController<MainMenuDelegate, PeerLobbyDelegate, UIActionSheetDelegate>
@property (nonatomic, strong) AppDelegate *appDelegate;

@end
