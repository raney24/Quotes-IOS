//
//  StockTableViewController.h
//  Quotes2.0
//
//  Created by Kyle Raney on 2/11/16.
//  Copyright © 2016 Kyle Raney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface StockTableViewController : UITableViewController <UITableViewDataSource, NSFetchedResultsControllerDelegate>

- (IBAction)addStockButtonPressed:(id)sender;
- (IBAction)loginUserButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)refresh:(UIRefreshControl *)sender;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
