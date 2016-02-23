//
//  UserManager.h
//  Quotes2.0
//
//  Created by Kyle Raney on 2/22/16.
//  Copyright © 2016 Kyle Raney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "User.h"

@interface UserManager : NSObject

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) RKObjectManager *objectManager;
@property (nonatomic, strong) AFHTTPClient *client;

-(void)loginWithUserName:(NSString *)username password:(NSString *)password;
- (NSString *)CSRFTokenFromURL:(NSString *)url;

@end
