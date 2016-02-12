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

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
