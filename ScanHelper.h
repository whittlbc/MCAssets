//
//  ScanHelper.h
//  MCDemo
//
//  Created by Ben Whittle on 7/12/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MCManager.h"

@interface ScanHelper : NSObject

@property (nonatomic) MCManager *mcManager;
@property (nonatomic, strong) NSMutableArray *arrConnectedDevices;
@property (nonatomic, strong) NSString *userID;
@property (strong, nonatomic) NSMutableArray *foundUsersArray;
@property (strong, nonatomic) MCPeerID *peerID;
@property (strong, nonatomic) MCPeerID *chattingWithID;

-(void)getFoundUser:(NSNotification *)notification;
-(void) connectWithPeer:(MCPeerID *)peerID;
-(NSArray *) getChattingWithID;
-(void) setChattingWithID:(MCPeerID *)chattingWithID;
-(void)sendMessage:(NSString *)text;
-(void)receiveMessage:(NSNotification *)notification;

@end

