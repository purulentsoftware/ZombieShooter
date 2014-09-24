//
//  PeerLobbyViewController.m
//  Computer Lab Zombie Shooter
//
//  Created by Chris Mays on 9/23/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "PeerLobbyViewController.h"
#import "MCManager.h"

@interface PeerLobbyViewController ()

@end

@implementation PeerLobbyViewController
static NSString * const XXServiceType = @"chat-files";
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    connectedDevice=[[NSMutableArray alloc] init];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[_appDelegate mcManager] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
    [super viewDidLoad];
    
    UIButton *host=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [host setTitle:@"Host" forState:UIControlStateNormal];
    UIButton *look=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [host setTitle:@"host" forState:UIControlStateNormal];
    [look setTitle:@"look" forState:UIControlStateNormal];

    [host setFrame:CGRectMake(0, 0, 300, 300)];
    [look setFrame:CGRectMake(300, 300, 300, 300)];
    [self.view addSubview:host];
    [host addTarget:self action:@selector(host) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:look];
    [look addTarget:self action:@selector(browse) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
-(void)browse{
    [[_appDelegate mcManager] setupMCBrowser];
    [[[_appDelegate mcManager] browser] setDelegate:self];
    [self presentViewController:[[_appDelegate mcManager] browser] animated:YES completion:nil];
}
-(void)host{
    [[_appDelegate mcManager] advertiseSelf:TRUE];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private method implementation

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            [connectedDevice addObject:peerDisplayName];
                [[[_appDelegate mcManager] browser] dismissViewControllerAnimated:YES completion:NULL];
            NSLog(@"connected");

        }
        else if (state == MCSessionStateNotConnected){
            if ([connectedDevice count] > 0) {
                int indexOfPeer = [connectedDevice indexOfObject:peerDisplayName];
                [connectedDevice removeObjectAtIndex:indexOfPeer];
            }
        }
        
    
    }
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser
didReceiveInvitationFromPeer:(MCPeerID *)peerID
       withContext:(NSData *)context
 invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
