//
//  StatisticViewController.m
//  ReceiptCapsule
//
//  Created by yanglu on 14-4-21.
//  Copyright (c) 2014年 cmu. All rights reserved.
//

#import "StatisticViewController.h"

@interface StatisticViewController ()

@end
NSDateComponents *components;
NSDate *date1;
NSDate *date2;
NSCalendar *cal;
NSDateFormatter *dateFormatter;
@implementation StatisticViewController

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
    UINib *nib = [UINib nibWithNibName:@"StatisticTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"StatisticTableViewCell"];
    // Set delegate
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    // initialize types array
    self.categoryType = [NSArray arrayWithObjects:@"Food", @"Entertainment", @"Education", nil];
    
    
    cal = [NSCalendar currentCalendar];
    components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    
    
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    //date1 = today;
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
   
    
    if([self.type isEqualToString:@"Today"]){
        date2 = [cal dateFromComponents:components];
        date1 = [date2 copy];
    }
    else if([self.type isEqualToString:@"Week"]){
        [components setDay:([components day] - ([components weekday] - 1))];
        date2 = [cal dateFromComponents:components];
        date1 = [date2 addTimeInterval:6*24*60*60];
        
    }
    else if([self.type isEqualToString:@"Month"]){
        [components setDay:([components day] - ([components day] -1))];
        date2 = [cal dateFromComponents:components];
        [components setMonth:[components month]+1];
        [components setDay:0];
        date1 = [cal dateFromComponents:components];
    }
    else{
        [components setDay:1];
        [components setMonth:1];
        date2 = [cal dateFromComponents:components];
        [components setDay:31];
        [components setMonth:12];
        date1 = [cal dateFromComponents:components];
    }
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    
    [self.tableView reloadData];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    NSString* dateFrom = [dateFormatter stringFromDate:date2];
    NSString* dateTo = [dateFormatter stringFromDate:date1];
    
     self.billArray = [Database searchBillWithColName:@"DATE" AndValue1:dateFrom AndValue2:dateTo];
    
    self.Range.text = [NSString stringWithFormat:@"%@ to %@", dateFrom, dateTo];
    
    // initialize types array
    self.categoryType = [NSArray arrayWithObjects:@"Food", @"Entertainment", @"Education", nil];
    
    self.categoryBill = [[NSMutableDictionary alloc] init];
    self.categoryTotal = [[NSMutableDictionary alloc] init];
    
    double sum = 0.0;
    
    for (NSString *key in self.categoryType) {
        NSMutableArray *tmp = [[NSMutableArray alloc] init];
        NSNumber *total = [NSNumber numberWithDouble:0.0];
        [self.categoryBill setObject:tmp forKey:key];
        [self.categoryTotal setObject:total forKey:key];
    }
    
    for (Bill *bill in self.billArray){
        NSString *cat = bill.category;
        NSMutableArray *catArr = [self.categoryBill objectForKey:cat];
        NSNumber *total = [self.categoryTotal objectForKey:cat];
        [catArr addObject:bill];
        
        sum = sum+[bill.total doubleValue];
        
        total = [NSNumber numberWithFloat:([total doubleValue] + [bill.total doubleValue])];
        [self.categoryTotal setObject:total forKey:cat];
        // NSLog([total stringValue]);
    }
    
    //NSNumber *value = [myDictionary objectForKey];
    self.Spent.text = [NSString stringWithFormat:@"%.02f", sum];;
    
    [self.tableView reloadData];

    [self.parentViewController.navigationController setNavigationBarHidden:NO];
    
    NSLog(@"StatisticViewController:%@",self.type);
    NSLog(@"TotalSpent:%f",sum);
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.parentViewController.navigationController setNavigationBarHidden:YES];
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
    return self.categoryType.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StatisticTableViewCell";
    StatisticTableViewCell *cell = (StatisticTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //[cell.cellImageView setImage:[UIImage imageNamed:@"CalenderIcon.jpeg"]];
    int sub = indexPath.row;
    cell.categoryLabel.text = [self.categoryType objectAtIndex:sub];
    cell.moneyLabel.text = [[self.categoryTotal objectForKey:cell.categoryLabel.text] stringValue];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showStatistic"]){
    }
    else if ([segue.identifier isEqualToString:@"showDetailStatistic"]){
        StatisticTableViewCell *selectedTableCell = (StatisticTableViewCell *)sender;
        
        
        StatisticDetailViewController *destinatonController = (StatisticDetailViewController *)[segue destinationViewController];
        
        NSString *key = selectedTableCell.categoryLabel.text;
       
        destinatonController.bills = [self.categoryBill objectForKey:key];
        
        
        
        // NSLog(@"count=%d",[navigationController.viewControllers count]);
        // NSLog([navigationController description]);
        //destinationController.type = selectedTableCell.titleLabel.text;

    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StatisticTableViewCell *selectedTableCell = (StatisticTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    

    
    NSString *key = selectedTableCell.categoryLabel.text;
    
    
    if ([[self.categoryBill objectForKey:key] count] != 0){
        [self performSegueWithIdentifier:@"showDetailStatistic" sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
    
    
}


- (IBAction)nextRange:(id)sender {
    
    if([self.type isEqualToString:@"Today"]){
      //  date1 = [date2 addTimeInterval:24*60*60];
        date2 = [date1 addTimeInterval:24*60*60];
        date1 = [date2 copy];
        
    }
    else if([self.type isEqualToString:@"Week"]){
        date2 = [date1 addTimeInterval:24*60*60];
        date1 = [date2 addTimeInterval:6*24*60*60];
       
        
    }
    else if([self.type isEqualToString:@"Month"]){
        components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date2];
        [components setDay:([components day] - ([components day] -1))];
        [components setMonth:([components month]+1) ];
        date2 = [cal dateFromComponents:components];
        [components setMonth:[components month]+1];
        [components setDay:0];
        date1 = [cal dateFromComponents:components];
        
    }
    else{
        components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date2];

        [components setYear:[components year]+1];
        [components setDay:1];
        [components setMonth:1];
        date2 = [cal dateFromComponents:components];
        [components setDay:31];
        [components setMonth:12];
        date1 = [cal dateFromComponents:components];
    }
    
    
    [self viewWillAppear:TRUE];
}

- (IBAction)previousRange:(id)sender {
    if([self.type isEqualToString:@"Today"]){
        //  date1 = [date2 addTimeInterval:24*60*60];
        date2 = [date1 addTimeInterval:-24*60*60];
        date1 = [date2 copy];
        
    }
    else if([self.type isEqualToString:@"Week"]){
        date1 = [date2 addTimeInterval:-24*60*60];
        date2 = [date1 addTimeInterval:-6*24*60*60];
        
        
    }
    else if([self.type isEqualToString:@"Month"]){
        components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date2];
        //[components setDay:([components day] - ([components day] -1))];
        //[components setMonth:([components month]+1) ];
        [components setDay:0];
        date1 = [cal dateFromComponents:components];
        [components setMonth:[components month]-1];
        [components setDay:1];
        date2 = [cal dateFromComponents:components];
        
    }
    else{
        components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date2];
        //[components setDay:([components day] - ([components day] -1))];
        //[components setMonth:([components month]+1) ];
        [components setDay:1];
        [components setMonth:1];
        [components setYear:[components year]-1];
        date2 = [cal dateFromComponents:components];
        [components setMonth:12];
        [components setDay:31];
       
        date1 = [cal dateFromComponents:components];
        
    }
    
    
    [self viewWillAppear:TRUE];
}
@end
