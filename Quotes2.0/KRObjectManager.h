//
//  KRObjectManager.h
//  Quotes2.0
//
//  Created by Kyle Raney on 3/1/16.
//  Copyright © 2016 Kyle Raney. All rights reserved.
//

#import <RestKit/RestKit.h>


@interface KRObjectManager : NSObject

@property(strong, nonatomic) RKObjectManager *objectManager;

// singleton methods
+ (KRObjectManager *)sharedObjectManager;

@end
