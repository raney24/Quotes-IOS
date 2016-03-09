//
//  KRObjectManager.m
//  Quotes2.0
//
//  Created by Kyle Raney on 3/1/16.
//  Copyright © 2016 Kyle Raney. All rights reserved.
//

#import "KRObjectManager.h"
#import "Stock.h"
#import "Earnings.h"
#import "User.h"
#import "AppController.h"

static KRObjectManager *_sharedObjectManager = nil;

@implementation KRObjectManager

+(KRObjectManager *)sharedObjectManager {
    if (!_sharedObjectManager) {
        _sharedObjectManager = [[KRObjectManager alloc] init];
        
        [_sharedObjectManager setup];
    }
    
    return _sharedObjectManager;
}

-(void)setup {
    NSURL *baseURL = [NSURL URLWithString:@"https://evening-everglades-1560.herokuapp.com"];
    
    _objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    // Mappings
    
    RKObjectMapping *stockMapping = [RKObjectMapping mappingForClass:[Stock class]];

    [stockMapping addAttributeMappingsFromDictionary:@{
                                                           @"id": @"stockId",
                                                           @"submitter": @"submitter",
                                                           @"projected_er_date": @"projected_er_date",
                                                           @"full_title": @"full_title",
                                                           @"symbol": @"symbol",
                                                           @"submitted_on": @"submitted_on"
                                                           }];
    
//    RKObjectMapping *addStockMapping = [RKObjectMapping requestMapping];
//    [stockMapping addAttributeMappingsFromArray:@[@"symbol"]];
    
    RKObjectMapping *earningsMapping = [RKObjectMapping mappingForClass:[Earnings class]];
    [earningsMapping addAttributeMappingsFromArray:@[
                                                     @"before_price",
                                                     @"after_price",
                                                     @"er_date",
                                                     @"er_quarter",
                                                     @"percent_change"
                                                     ]];
    
    RKObjectMapping *deleteStockRequestMapping = [RKObjectMapping requestMapping];
    [deleteStockRequestMapping addAttributeMappingsFromArray:@[@"stockId"]];
    
    RKObjectMapping *addStockRequestMapping = [RKObjectMapping requestMapping];
    [addStockRequestMapping addAttributeMappingsFromArray:@[@"symbol"]];
    
    RKObjectMapping *userRequestMapping = [RKObjectMapping requestMapping];
    [userRequestMapping addAttributeMappingsFromArray:@[@"username", @"password", @"token"]];
    
    // Response Descriptors
    
    RKResponseDescriptor *stockListResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:stockMapping method:RKRequestMethodAny pathPattern:@"/api/v1/stocks/" keyPath:nil statusCodes:statusCodes];
    
    RKResponseDescriptor *userResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userRequestMapping method:RKRequestMethodAny pathPattern:@"/api-token-auth/" keyPath:nil statusCodes:statusCodes];
    
    // Request Descriptors
    
    RKRequestDescriptor *stockRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:addStockRequestMapping objectClass:[Stock class] rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKRequestDescriptor *userRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:userRequestMapping objectClass:[User class] rootKeyPath:nil method:RKRequestMethodPOST];
    
    // add descriptors
    [_objectManager addResponseDescriptorsFromArray:@[stockListResponseDescriptor, userResponseDescriptor]];
    
    [_objectManager addRequestDescriptorsFromArray:@[stockRequestDescriptor, userRequestDescriptor]];
    
    NSString *token = [AppController sharedController].user.token;
    
    [_objectManager.HTTPClient setDefaultHeader:@"Authorization" value:token];
    
}

@end
