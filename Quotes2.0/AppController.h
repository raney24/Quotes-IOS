//
//  AppController.h
//  Quotes2.0
//
//  Created by Kyle Raney on 2/29/16.
//  Copyright © 2016 Kyle Raney. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^KRCompletionBlock)(BOOL success, NSDictionary *userInfo);

@class User;

@interface AppController : NSObject

@property (nonatomic, strong) User *user;

@property (nonatomic, readwrite) NSString *savedAuthToken;

-(BOOL)isAuthenticated;

-(void)processLoginWithUser:(User *)user;
-(void)processLogout;

// singleton methods
+ (AppController *)sharedController;

@end
