//
//  ScanHelper.m
//  MCDemo
//
//  Created by Ben Whittle on 7/12/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

#import "ScanHelper.h"

static NSString * const baseURL = @"http://54.69.227.168:8080/users/";

@implementation ScanHelper


-(id)init{

    self.foundUsersArray = [[NSMutableArray alloc] init];
    
    //    self.peerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].identifierForVendor.UUIDString];
    self.peerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    
    // Fuck this for now
    //    // Get your own user obj
    //    [self getFoundUser:self.peerID];
    
    _mcManager = [[MCManager alloc] init];
    
    [_mcManager setupPeerAndSessionWithDisplayName:self.peerID.displayName];
    [_mcManager advertiseSelf:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveMessage:)
                                                 name:@"receiveMessage"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFoundUser:) name:@"foundUser" object:nil];
    
    _arrConnectedDevices = [[NSMutableArray alloc] init];
    
    [_mcManager setupMCBrowser];
    
    return self;
}


-(void)getFoundUser:(NSNotification *)notification {
    
    MCPeerID *peerID = [notification.object valueForKey:@"peerID"];
    
    [self.foundUsersArray addObject:peerID];
    [self connectWithPeer:peerID];
    _mcManager.chattingWithID = peerID;
    
}

-(void) connectWithPeer:(MCPeerID *)peerID {
    
    NSData *data = [[NSData alloc] init];
    NSTimeInterval time = 30.0;
    
    if (self.foundUsersArray.count > 0) {
        [self.mcManager.browser.browser invitePeer:peerID toSession:self.mcManager.session withContext:data timeout:time];
    }
    
}

-(NSArray *) getChattingWithID {
    NSArray *arr = [[NSArray alloc] initWithObjects:[self.foundUsersArray objectAtIndex:0], nil];
    return arr;
}


-(void)sendMessage:(NSString *)text {
    [_mcManager sendMyMessage:text];
}

-(void)receiveMessage:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"grabMessage"
                                                        object:nil
                                                      userInfo:notification.object];
    
   
}


#pragma mark - Private method implementation

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    NSLog(@"peerDidChangeStateWithNotification : %@", peerDisplayName);
    
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            
            [_arrConnectedDevices addObject:peerDisplayName];
            
            NSLog(@"Adding peer to list of connected devices: %@", peerDisplayName);
        }
        else if (state == MCSessionStateNotConnected){
            if ([_arrConnectedDevices count] > 0) {
                NSUInteger indexOfPeer = [_arrConnectedDevices indexOfObject:peerDisplayName];
                [_arrConnectedDevices removeObjectAtIndex:indexOfPeer];
                NSLog(@"Removing peer from list of connected devices: %@", peerDisplayName);
                
            }
        }
        
        NSLog(@"Would have refreshed the table of connected devices, %@", _arrConnectedDevices);
        
    }
    
}

@end
