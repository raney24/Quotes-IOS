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
#import "User.h"
#import "UserManager.h"

@interface StockTableViewController ()

@property(nonatomic, strong) NSMutableArray *stocks;
@property(nonatomic, strong) User *user;

@end

@implementation StockTableViewController

- (void)viewDidLoad {
//    [self getStocks];
    [[UserManager alloc] loginWithUserName:@"raney24" password:@"sfenfcb@$"];
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(User*)loginUser
{
    NSString *alertTitle = @"Enter Credentials";
    //    NSString *alertMessage = @"(lowercase is fine)";
    
    User *user = [[User alloc] init];
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"Username", @"username");
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"Password", @"password");
    }];
    
    UIAlertAction *addAction = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Login", @"login")
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action) {
                                    UITextField *username = alertController.textFields[0];
                                    UITextField *password = alertController.textFields[1];
                                    user.username = username.text;
                                    user.password = password.text;
                                }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:
                                   UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [alertController dismissViewControllerAnimated:YES completion:nil];
                                                         }];
    
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    return user;
}

- (BOOL)isUserLoggedIn:(User *)user
{
    return YES;
}

- (void)postStock:(NSString *)symbolToAdd
{
    // initialize AFNetworking HTTPClient
    
    NSURL *baseURL = [NSURL URLWithString:@"https://evening-everglades-1560.herokuapp.com"];
    NSString *token = @" Token 898bd6a21b9a1efa9619209e2dbd8d5ae001a57d";
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"symbol"]];
    
    RKResponseDescriptor *indivResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:requestMapping method:RKRequestMethodAny pathPattern:@"/api/v1/stocks/" keyPath:nil statusCodes:statusCodes];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[Stock class] rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
    [objectManager addResponseDescriptorsFromArray:@[indivResponseDescriptor]];
    
    [objectManager.HTTPClient setDefaultHeader:@"Authorization" value:token];
    
    [objectManager addRequestDescriptorsFromArray:@[requestDescriptor]];
    
    
    Stock *newStock = [Stock new];
    newStock.symbol = symbolToAdd;
    
    [objectManager postObject:newStock path:@"/api/v1/stocks/" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

    }failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failed w error: %@", [error localizedDescription]);
    }];


}

-(void)deleteStock:(NSString *)stockId
{
    NSURL *baseURL = [NSURL URLWithString:@"https://evening-everglades-1560.herokuapp.com"];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"stockId"]];
    
    RKResponseDescriptor *indivResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:requestMapping method:RKRequestMethodAny pathPattern:@"/api/v1/stocks/" keyPath:nil statusCodes:statusCodes];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[Stock class] rootKeyPath:nil method:RKRequestMethodAny];
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
    [objectManager addResponseDescriptor:indivResponseDescriptor];
    
//    [objectManager.HTTPClient setAuthorizationHeaderWithUsername:@"raney24" password:@"sfenfcb@$"];
    [objectManager.HTTPClient setAuthorizationHeaderWithToken:@"898bd6a21b9a1efa96192"];
    
    [objectManager addRequestDescriptor:requestDescriptor];
    
    Stock *stockToDelete = [Stock new];
    stockToDelete.stockId = stockId;
    
    NSString *delURL = [NSString stringWithFormat:@"https://evening-everglades-1560.herokuapp.com/api/v1/stocks/%@", stockId];
    
    NSLog(@"%@", delURL);
    
    [objectManager deleteObject:stockToDelete path:delURL parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"Success");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failure");
    }];
    
//    [objectManager postObject:newStock path:@"/api/v1/stocks/" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    
//    }failure:^(RKObjectRequestOperation *operation, NSError *error) {
//        NSLog(@"failed w error: %@", [error localizedDescription]);
//    }];

}

- (void)getStocks
{
    // initialize AFNetworking HTTPClient
    
    NSURL *baseURL = [NSURL URLWithString:@"https://evening-everglades-1560.herokuapp.com"];
    
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
    
    
    RKResponseDescriptor *indivResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:stockMapping method:RKRequestMethodAny pathPattern:@"/api/v1/stocks/" keyPath:nil statusCodes:statusCodes];
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    [objectManager addResponseDescriptorsFromArray:@[indivResponseDescriptor]];
    
    [objectManager getObjectsAtPath:@"/api/v1/stocks/" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        _stocks = [[NSMutableArray alloc] initWithArray:mappingResult.array];
        [self.tableView reloadData];
    }failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failed w error: %@", [error localizedDescription]);
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
    NSString *symbol = stock.symbol;
    
    cell.textLabel.text = fullTitle;
    cell.detailTextLabel.text = symbol;
    
    return cell;
}

- (IBAction)addStockButtonPressed:(id)sender {
    NSString *alertTitle = @"Enter Stock Symbol";
//    NSString *alertMessage = @"(lowercase is fine)";
    
    UIAlertController *alertController = [UIAlertController
                                alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"Symbol", @"Login");
    }];
    
    UIAlertAction *addAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Add", @"OK Action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   UITextField *symbol = alertController.textFields.firstObject;
                                   [self postStock:symbol.text];
                                   [_stocks addObject:symbol.text];
                                   [self getStocks];
                               }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:
                            UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action) {
                                [alertController dismissViewControllerAnimated:YES completion:nil];
                            }];
    
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (IBAction)loginUserButtonPressed:(UIBarButtonItem *)sender {
    [self loginUser];
}

- (IBAction)refresh:(UIRefreshControl *)sender {
    [self getStocks];
    [sender endRefreshing];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Stock *stockToDelete = [_stocks objectAtIndex:indexPath.row];
        NSString *stockId = stockToDelete.stockId;
        NSLog(@"id in swipe: %@", stockToDelete.stockId);
        [self deleteStock:stockId];
        [_stocks removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
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
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        StockDetailViewController *destViewController = segue.destinationViewController;
        destViewController.stock = stock;
                    
//        StockDetailViewController *controller = (StockDetailViewController *)[[segue destinationViewController] topViewController];
        
    }
}
@end
