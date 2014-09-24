//
//  PeerLobbyViewController.h
//  Computer Lab Zombie Shooter
//
//  Created by Chris Mays on 9/23/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
@protocol PeerLobbyDelegate
-(void)goToHosting;
-(void)goToNonHost;
@end
@interface PeerLobbyViewController : UIViewController<MCBrowserViewControllerDelegate, MCSessionDelegate,MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate>{
    NSMutableArray *connectedDevice;
}
@property (nonatomic, strong) AppDelegate *appDelegate;

@end
