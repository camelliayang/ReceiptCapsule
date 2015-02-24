//
//  StatisticDetailViewController.h
//  ReceiptCapsule
//
//  Created by yanglu on 14-4-21.
//  Copyright (c) 2014年 cmu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatisticTabBarController.h"
#import "StatisticDetailTableViewCell.h"
#import "BillEditorViewController.h"
#import "Bill.h"

@interface StatisticDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *bills;
@end
