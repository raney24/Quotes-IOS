//
//  User.m
//  Quotes2.0
//
//  Created by Kyle Raney on 2/21/16.
//  Copyright © 2016 Kyle Raney. All rights reserved.
//

#import "User.h"

@implementation User

+(RKObjectMapping *)mapping {
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[User class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"name": @"name",
                                                  @"password": @"password"
                                                  }];
    return mapping;
}

@end
