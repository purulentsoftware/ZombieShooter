//
//  ViewController.m
//  Computer Lab Zombie Shooter
//
//  Created by Chris Mays on 9/17/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "MainMenu.h"
#import "PeerLobbyViewController.h"
#import "AppDelegate.h"
#import "HostingScene.h"
#import "NonHostScene.h"
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[_appDelegate mcManager] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [MainMenu sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    ((MainMenu *)scene).delegate=self;
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}
-(void)playButtonSelected{
    SKView * skView = (SKView *)self.view;
    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *tran=[SKTransition doorsOpenHorizontalWithDuration:1.0];
    [skView presentScene:scene transition:tran];
}
-(void)goToHosting{
    
}
-(void)host{
    [[_appDelegate mcManager] advertiseSelf:TRUE];
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [HostingScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    // Present the scene.
    [skView presentScene:scene];
    
}
-(void)multiplayerButtonPressed{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"Host Or Search?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:NULL otherButtonTitles:@"Host", @"Search", nil];
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        NSLog(@"hosT");
        [self host];
    }else if(buttonIndex==1){
        NSLog(@"search");
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(peerDidChangeStateWithNotification:)
                                                     name:@"MCDidChangeStateNotification"
                                                   object:nil];
        [self search];
    }
}
-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            [[[_appDelegate mcManager] browser] dismissViewControllerAnimated:YES completion:NULL];
            SKView * skView = (SKView *)self.view;
            skView.showsFPS = YES;
            skView.showsNodeCount = YES;
            
            // Create and configure the scene.
            SKScene * scene = [NonHostScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            // Present the scene.
            [skView presentScene:scene];

        }
        else if (state == MCSessionStateNotConnected){
            
        }
        
        
    }
}

-(void)search{
    [[_appDelegate mcManager] setupMCBrowser];
    [[[_appDelegate mcManager] browser] setDelegate:self];
    [self presentViewController:[[_appDelegate mcManager] browser] animated:YES completion:nil];
}
- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
