//
//  User.h
//  Quotes2.0
//
//  Created by Kyle Raney on 2/21/16.
//  Copyright © 2016 Kyle Raney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Restkit/Restkit.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

+ (RKObjectMapping*)mapping;

@end
