//
//  StockTableViewController.m
//  Quotes2.0
//
//  Created by Kyle Raney on 2/11/16.
//  Copyright © 2016 Kyle Raney. All rights reserved.
//

#import "StockTableViewController.h"
#import "StockDetailViewController.h"
#import <RestKit/RestKit.h>
#import "Stock.h"

@interface StockTableViewController ()

@property(nonatomic, strong) NSArray *stocks;

@end

@implementation StockTableViewController

- (void)viewDidLoad {
    [self configureRestKit];
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)configureRestKit
{
    // initialize AFNetworking HTTPClient
    
    //    NSURL *baseURL = [NSURL URLWithString:@"https://evening-everglades-1560.herokuapp.com"];
    
    RKObjectMapping *stockMapping = [RKObjectMapping mappingForClass:[Stock class]];
    [stockMapping addAttributeMappingsFromDictionary:@{
                                                       @"id": @"stockId",
                                                       @"submitter": @"submitter",
                                                       @"projected_er_date": @"projected_er_date",
                                                       @"full_title": @"full_title",
                                                       @"symbol": @"symbol",
                                                       @"submitted_on": @"submitted_on"
                                                       }];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    //    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:stockMapping method:RKRequestMethodAny pathPattern:@"/api/v1/stocks/:stockId" keyPath:nil statusCodes:statusCodes];
    
    RKResponseDescriptor *indivResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:stockMapping method:RKRequestMethodAny pathPattern:@"/api/v1/stocks/" keyPath:nil statusCodes:statusCodes];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://evening-everglades-1560.herokuapp.com/api/v1/stocks/"]];
    
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[indivResponseDescriptor]];
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        _stocks = result.array;
        Stock *firstOne = result.firstObject;
        NSLog(@"%@, %i", firstOne.full_title, _stocks.count);
                [self.tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failed w error: %@", [error localizedDescription]);
    }];
    [operation start];
    
}

- (void)loadStocks
{
    NSLog(@"Hello");
    [[RKObjectManager sharedManager] getObjectsAtPath:@"https://evening-everglades-1560.herokuapp.com/api/v1/stocks/"
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation,
                                                        RKMappingResult *stocksMappingResult) {
                                                  _stocks = stocksMappingResult.array;
                                                  NSLog(@"stocks: %@", _stocks);
                                                  //                                                  [self.tableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"No results: %@", error);
                                              }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _stocks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stockCell" forIndexPath:indexPath];
    
    Stock *stock = _stocks[indexPath.row];
    
    NSString *fullTitle = stock.full_title;
    
    cell.textLabel.text = fullTitle;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showStockDetail"]) {

        Stock *stock = [_stocks objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        
//        StockDetailViewController *nextVC = segue.destinationViewController;
        
//        nextVC.stockTitleLabel.text = stock.full_title;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        StockDetailViewController *destViewController = segue.destinationViewController;
        destViewController.stock = stock;
                    
//        StockDetailViewController *controller = (StockDetailViewController *)[[segue destinationViewController] topViewController];
        
    }
}


@end
