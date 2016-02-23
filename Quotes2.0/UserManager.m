//
//  UserManager.m
//  Quotes2.0
//
//  Created by Kyle Raney on 2/22/16.
//  Copyright © 2016 Kyle Raney. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

-(void)loginWithUserName:(NSString *)username password:(NSString *)password
{
    User *user = [[User alloc] init];
    [user setUsername:username];
    [user setPassword:password];
    
    NSURL *baseURL = [NSURL URLWithString:@"https://evening-everglades-1560.herokuapp.com"];
    
    NSString *csrf = [self CSRFTokenFromURL:@"https://evening-everglades-1560.herokuapp.com/login"];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:baseURL];
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    [client setDefaultHeader:@"X-CSRFToken" value:csrf];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"username", @"password"]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[User class] rootKeyPath:nil];

    [objectManager addRequestDescriptor:requestDescriptor];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:requestMapping method:RKRequestMethodPOST pathPattern:@"/api-auth/login/" keyPath:nil statusCodes:statusCodes];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    [objectManager postObject:user path:@"/api-auth/login/" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"It worked: %@", [mappingResult array]);
    }failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failed w error: %@", [error localizedDescription]);
    }];
    
}


@end
