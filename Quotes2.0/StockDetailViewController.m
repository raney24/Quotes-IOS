//
//  StockDetailViewController.m
//  Quotes2.0
//
//  Created by Kyle Raney on 2/11/16.
//  Copyright © 2016 Kyle Raney. All rights reserved.
//

#import "StockDetailViewController.h"
#import <RestKit/RestKit.h>
#import "Stock.h"
#import "Earnings.h"

@interface StockDetailViewController ()

@property(nonatomic, strong) NSArray *earnings;

@end

@implementation StockDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureRestKit];
    
    NSString *stockTitle = _stock.full_title;
    
    _stockTitleLabel.text = stockTitle;
}

- (void)configureRestKit
{
    // initialize AFNetworking HTTPClient
    
    NSString *stockId = _stock.stockId;
    
    //    NSURL *baseURL = [NSURL URLWithString:@"https://evening-everglades-1560.herokuapp.com"];
    
    RKObjectMapping *earningsMapping = [RKObjectMapping mappingForClass:[Earnings class]];
    [earningsMapping addAttributeMappingsFromArray:@[
                                                       @"before_price",
                                                       @"after_price",
                                                       @"er_date",
                                                       @"er_quarter",
                                                       @"percent_change"
                                                       ]];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKResponseDescriptor *indivResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:earningsMapping method:RKRequestMethodAny pathPattern:@"/api/v1/stocks/:id/earnings/" keyPath:nil statusCodes:statusCodes];
    
    NSString *strURL = [NSString stringWithFormat:@"https://evening-everglades-1560.herokuapp.com/api/v1/stocks/%@/earnings/", stockId];
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[indivResponseDescriptor]];
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        _earnings = result.array;
        Earnings *firstOne = result.firstObject;
        NSLog(@"%@, %i", firstOne.before_price, _earnings.count);
//        [self.view reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failed w error: %@", [error localizedDescription]);
    }];
    [operation start];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
