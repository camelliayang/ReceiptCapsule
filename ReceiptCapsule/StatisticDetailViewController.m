//
//  StatisticDetailViewController.m
//  ReceiptCapsule
//
//  Created by yanglu on 14-4-21.
//  Copyright (c) 2014年 cmu. All rights reserved.
//

#import "StatisticDetailViewController.h"

@interface StatisticDetailViewController ()

@end

@implementation StatisticDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Register Custom Nib
    UINib *nib = [UINib nibWithNibName:@"StatisticDetailTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"StatisticDetailTableViewCell"];
    // Set delegate
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView reloadData];
    
    NSLog(@"StatisticDetailViewController:%@", [self getType]);
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getType{
    StatisticTabBarController *tabBarController = (StatisticTabBarController *)self.tabBarController;
    return tabBarController.type;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bills.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StatisticDetailTableViewCell";
    StatisticDetailTableViewCell *cell = (StatisticDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    [cell.cellImageView setImage:[UIImage imageNamed:@"CalenderIcon.jpeg"]];
    int sub = indexPath.row;
    Bill* bill = [self.bills objectAtIndex:sub];
    cell.dateLabel.text = bill.date;
    cell.moneyLabel.text = [bill.total stringValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-mm-dd"];
    NSDate *date = [formatter dateFromString:bill.date];
    NSLog(@"%@",date);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    cell.dayLabel.text =[dateFormatter stringFromDate:[NSDate date]];
   // NSLog(@"%@", );
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showBill"]){
        //StatisticDetailTableViewCell *selectedTableCell = (StatisticDetailTableViewCell *)sender;
        
        BillEditorViewController *destinatonController = (BillEditorViewController *)[segue destinationViewController];
        
        //NSString *key = selectedTableCell.categoryLabel.text;
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        
        int sub = indexPath.row;
        NSLog(@"subscript=%d",sub);
        destinatonController.bill = [self.bills objectAtIndex:sub];
        
        
        
        // NSLog(@"count=%d",[navigationController.viewControllers count]);
        // NSLog([navigationController description]);
        //destinationController.type = selectedTableCell.titleLabel.text;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showBill" sender:indexPath];
}
@end
