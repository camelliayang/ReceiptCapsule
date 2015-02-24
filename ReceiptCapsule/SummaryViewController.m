//
//  SummaryViewController.m
//  ReceiptCapsule
//
//  Created by yanglu on 14-4-21.
//  Copyright (c) 2014年 cmu. All rights reserved.
//

#import "SummaryViewController.h"

@interface SummaryViewController ()

@end
NSDateFormatter *dateFormatter;

@implementation SummaryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.billToday = [[NSMutableArray alloc] init];
        self.billWeek = [[NSMutableArray alloc] init];
        self.billMonth = [[NSMutableArray alloc] init];
        self.billYear = [[NSMutableArray alloc] init];
        self.totalToday = [NSNumber numberWithDouble:0.0];
        self.totalWeek = [NSNumber numberWithDouble:0.0];
        self.totalMonth = [NSNumber numberWithDouble:0.0];
        self.totalYear = [NSNumber numberWithDouble:0.0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Register Custom Nib
    UINib *nib = [UINib nibWithNibName:@"SummaryTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"SummaryTableViewCell"];
    // Set delegate
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    

    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{

    
    // Set date
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    // NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
    
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    NSDate *thisWeek  = [cal dateFromComponents:components];
    
    //[components setDay:([components day] - 7)];
    //NSDate *lastWeek  = [cal dateFromComponents:components];
    
    [components setDay:([components day] - ([components day] -1))];
    NSDate *thisMonth = [cal dateFromComponents:components];
    
    //[components setMonth:([components month] - 1)];
    //NSDate *lastMonth = [cal dateFromComponents:components];
    
    [components setDay:1];
    [components setMonth:1];
    NSDate *thisYear = [cal dateFromComponents:components];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.dateToday = [dateFormatter stringFromDate:today];
    //NSString *dateLastWeek = [dateFormatter stringFromDate:lastWeek];
    //NSString *dateLastMonth = [dateFormatter stringFromDate:lastMonth];
    //NSString *dateLastYear = [dateFormatter stringFromDate:lastYear];
    self.dateWeek = [dateFormatter stringFromDate:thisWeek];
    self.dateMonth = [dateFormatter stringFromDate:thisMonth];
    self.dateYear = [dateFormatter stringFromDate:thisYear];
    
    self.billToday = [Database searchBillWithColName:@"DATE" AndValue1:self.dateToday AndValue2:self.dateToday];
    self.billWeek = [Database searchBillWithColName:@"DATE" AndValue1:self.dateWeek AndValue2:self.dateToday];
    self.billMonth = [Database searchBillWithColName:@"DATE" AndValue1:self.dateMonth AndValue2:self.dateToday];
    self.billYear = [Database searchBillWithColName:@"DATE" AndValue1:self.dateYear AndValue2:self.dateToday];
    
    NSLog(@"today=%@",self.dateToday);
    NSLog(@"this week=%@",self.dateWeek);
    NSLog(@"this month=%@",self.dateMonth);
    NSLog(@"this year=%@",self.dateYear);
    
    
    self.totalToday = [self getTotal:self.billToday];
    self.totalWeek = [self getTotal:self.billWeek];
    self.totalMonth = [self getTotal:self.billMonth];
    self.totalYear = [self getTotal:self.billYear];
    
    // NSLog(self.billToday);
    
    NSLog(@"today total=%f",[self.totalToday doubleValue]);
    NSLog(@"week total=%f",[self.totalWeek doubleValue]);
    NSLog(@"month total=%f",[self.totalMonth doubleValue]);
    NSLog(@"year total=%f",[self.totalYear doubleValue]);
    //NSLog(self.totalWeek);
    //NSLog(self.totalMonth);
    //NSLog(self.totalYear);
    
    [self.tableView reloadData];
}

// return sum of all cost in bill

- (NSNumber*)getTotal:(NSMutableArray*)array{
    double sum=0;
    for (Bill* object in array) {
        // do something with object
        //NSLog(@"object=%f",object.total.doubleValue);
        sum+= object.total.doubleValue;
    }
    return [NSNumber numberWithDouble:sum];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [self.navigationController setNavigationBarHidden:TRUE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SummaryTableViewCell";
    SummaryTableViewCell *cell = (SummaryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    [cell.cellImageView setImage:[UIImage imageNamed:@"CalenderIcon.jpeg"]];
    
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"Today";
        cell.dateLabel.text = self.dateToday;
        cell.moneyLabel.text = [self.totalToday stringValue];
    }
    else if (indexPath.row == 1) {
        cell.titleLabel.text = @"Week";
        cell.dateLabel.text = self.dateWeek;
        cell.moneyLabel.text = [self.totalWeek stringValue];
    }
    else if (indexPath.row == 2) {
        cell.titleLabel.text = @"Month";
        cell.dateLabel.text = self.dateMonth;
        cell.moneyLabel.text = [self.totalMonth stringValue];
    }
    else if (indexPath.row == 3) {
        cell.titleLabel.text = @"Year";
        cell.dateLabel.text = self.dateYear;
        cell.moneyLabel.text = [self.totalYear stringValue];
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showStatistic"]){
        SummaryTableViewCell *selectedTableCell = (SummaryTableViewCell *)sender;
       
        
        StatisticTabBarController *tabViewController = (StatisticTabBarController *)[segue destinationViewController];
        
        PieChartViewController *pieChartController = (PieChartViewController *)[[tabViewController viewControllers] objectAtIndex:1];
        
         UINavigationController *navigationController = (UINavigationController* )[[tabViewController viewControllers] objectAtIndex:0];
////        destinationController.type = selectedTableCell.titleLabel.text;
//        UIViewController *theControllerYouWant = [self.navigationController.viewControllers objectAtIndex:(theIndexOfYourViewController)];

        StatisticViewController *destinationController = (StatisticViewController *)navigationController.topViewController;
        
        
        
       // NSLog(@"count=%d",[navigationController.viewControllers count]);
       // NSLog([navigationController description]);
        destinationController.type = selectedTableCell.titleLabel.text;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        if (indexPath.row == 0) {
            destinationController.billArray = self.billToday;
            destinationController.total = self.totalToday;
        }
        else if (indexPath.row == 1) {
            destinationController.billArray = self.billWeek;
            destinationController.total = self.totalWeek;
        }
        else if (indexPath.row == 2) {
            destinationController.billArray = self.billMonth;
            destinationController.total = self.totalMonth;
        }
        else if (indexPath.row == 3) {
            destinationController.billArray = self.billYear;
            destinationController.total = self.totalYear;
        }
       // destinationController.billArray = self.billToday;
       // destinationController.total = self.totalToday;
       // [[segue destinationViewController] setBillArray:self.billToday];
    }
  
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && [self.billToday count] != 0 ) {
        [self performSegueWithIdentifier:@"showStatistic" sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
    
    else if (indexPath.row == 1 && [self.billWeek count] != 0 ) {
        [self performSegueWithIdentifier:@"showStatistic" sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
    else if (indexPath.row == 2 && [self.billMonth count] != 0 ) {
        [self performSegueWithIdentifier:@"showStatistic" sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
    else if (indexPath.row == 3 && [self.billYear count] != 0 ) {
        [self performSegueWithIdentifier:@"showStatistic" sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
    
}
@end
