//
//  SummaryViewController.h
//  ReceiptCapsule
//
//  Created by yanglu on 14-4-21.
//  Copyright (c) 2014年 cmu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SummaryTableViewCell.h"
#import "StatisticTabBarController.h"
#import "StatisticViewController.h"
#import "PieChartViewController.h"
#import "Database.h"
#import "Bill.h"
#import "Item.h"
@interface SummaryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *billToday;
@property (strong, nonatomic) NSMutableArray *billWeek;
@property (strong, nonatomic) NSMutableArray *billMonth;
@property (strong, nonatomic) NSMutableArray *billYear;
@property (strong, nonatomic) NSNumber *totalToday;
@property (strong, nonatomic) NSNumber *totalWeek;
@property (strong, nonatomic) NSNumber *totalMonth;
@property (strong, nonatomic) NSNumber *totalYear;

@property (strong, nonatomic) NSString *dateToday;
@property (strong, nonatomic) NSString *dateWeek;
@property (strong, nonatomic) NSString *dateMonth;
@property (strong, nonatomic) NSString *dateYear;

@end
