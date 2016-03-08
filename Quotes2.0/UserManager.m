//
//  UserManager.m
//  Quotes2.0
//
//  Created by Kyle Raney on 2/22/16.
//  Copyright © 2016 Kyle Raney. All rights reserved.
//

#import "UserManager.h"


@implementation UserManager

-(void)loginWithUserName:(NSString *)username password:(NSString *)password onComplete:(KRCompletionBlock)onComplete
{
    User *user = [[User alloc] init];
    [user setUsername:username];
    [user setPassword:password];
    
    NSURL *baseURL = [NSURL URLWithString:@"https://evening-everglades-1560.herokuapp.com"];
//    NSString *token = @" Token 898bd6a21b9a1efa9619209e2dbd8d5ae001a57d";
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"username", @"password", @"token"]];
    
    RKResponseDescriptor *indivResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:requestMapping method:RKRequestMethodAny pathPattern:@"/api-token-auth/" keyPath:nil statusCodes:statusCodes];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[User class] rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
    [objectManager addResponseDescriptorsFromArray:@[indivResponseDescriptor]];
    
//    [objectManager.HTTPClient setDefaultHeader:@"Authorization" value:token];
    
    [objectManager.HTTPClient setAuthorizationHeaderWithUsername:user.username password:user.password];
    
    [objectManager addRequestDescriptor:requestDescriptor];
    
//    __block NSString *token = [NSString alloc];
    
    
    [objectManager postObject:user path:@"/api-token-auth/" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSString *token = [@"token " stringByAppendingString:mappingResult.firstObject[@"token"]];
        NSDictionary *tokenDict = @{@"token" : token };
        onComplete(YES, tokenDict);
    }failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failed w error: %@", [error localizedDescription]);
    }];
    
//    return token;
    
}


@end
