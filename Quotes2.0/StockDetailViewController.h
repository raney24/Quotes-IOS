//
//  StockDetailViewController.h
//  Quotes2.0
//
//  Created by Kyle Raney on 2/11/16.
//  Copyright © 2016 Kyle Raney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stock.h"
#import "BEMSimpleLineGraphView.h"

@interface StockDetailViewController : UIViewController <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *BEMGraphView;

@property (strong, nonatomic) Stock *stock;

@property (weak, nonatomic) IBOutlet UILabel *stockTitleLabel;

@end
