//
//  Earnings.h
//  Quotes2.0
//
//  Created by Kyle Raney on 2/11/16.
//  Copyright © 2016 Kyle Raney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Earnings : NSObject

@property (strong, nonatomic) NSString *before_price;
@property (strong, nonatomic) NSString *after_price;
@property (strong, nonatomic) NSString *er_date;
@property (strong, nonatomic) NSString *er_quarter;
@property (strong, nonatomic) NSString *percent_change;

@end
