//
//  AppController.m
//  Quotes2.0
//
//  Created by Kyle Raney on 2/29/16.
//  Copyright © 2016 Kyle Raney. All rights reserved.
//

#import "AppController.h"
#import "KRObjectManager.h"
#import <RestKit/RestKit.h>
#import "User.h"

static AppController *_sharedController = nil;

@implementation AppController

+(AppController *)sharedController {
    if (!_sharedController) {
        _sharedController = [[AppController alloc] init];
        
        [_sharedController setup];
    }
    
    return _sharedController;
}

-(void)setup {
    RKObjectManager *objectManager = [KRObjectManager sharedObjectManager].objectManager;
    if (self.user != nil) {
        // bypass login
    } else if (self.savedAuthToken.length == 0) {
        // go to login
        
    } else {
        // call login api (send token)
        
        // if success, go past login
        // if ! success, go to login
    }
}

-(BOOL)isAuthenticated {
    return (self.user != nil); // return answer to condition (yes if auth or no)
}

-(void)processLoginWithUser:(User *)user {
    self.user = user;
    RKObjectManager *objectManager = [KRObjectManager sharedObjectManager].objectManager;

    [objectManager.HTTPClient setDefaultHeader:@"Authorization" value:[AppController sharedController].user.token];
    
    
    
    self.savedAuthToken = self.user.token;
    
}

-(void)processLogout {
    self.user = nil;
//    [objectManager.HTTPClient clearAuthorizationHeader];
    
}

- (NSString *)savedAuthToken {
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    return [userPreferences objectForKey:@"stockLoginAuthToken"];
}

- (void)setSavedAuthToken:(NSString *)value {
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    [userPreferences setObject:value forKey:@"stockLoginAuthToken"];
    [userPreferences synchronize];
}


@end
