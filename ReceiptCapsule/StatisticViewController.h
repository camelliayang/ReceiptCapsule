//
//  StatisticViewController.h
//  ReceiptCapsule
//
//  Created by yanglu on 14-4-21.
//  Copyright (c) 2014年 cmu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatisticTableViewCell.h"
#import "StatisticTabBarController.h"
#import "StatisticDetailViewController.h"
#import "Bill.h"

@interface StatisticViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSString *type;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *billArray;
@property (strong, nonatomic) NSNumber *total;
@property (strong, nonatomic) NSArray *categoryType;
@property (strong, nonatomic) NSMutableDictionary *categoryTotal;
@property (strong, nonatomic) NSMutableDictionary *categoryBill;
@property (strong, nonatomic) IBOutlet UILabel *Range;

- (IBAction)nextRange:(id)sender;
- (IBAction)previousRange:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *Spent;
@end
