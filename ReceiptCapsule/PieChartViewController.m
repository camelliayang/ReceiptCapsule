//
//  PieChartViewController.m
//  ReceiptCapsule
//
//  Created by yanglu on 14-4-21.
//  Copyright (c) 2014年 cmu. All rights reserved.
//

#import "PieChartViewController.h"
#import "PCPieChart.h"

@interface PieChartViewController ()

@end

@implementation PieChartViewController

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
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //StatisticViewController *categoryView= (StatisticViewController *)[self.tabBarController.viewControllers objectAtIndex:0];
    UINavigationController *navigationController = (UINavigationController* )[self.tabBarController.viewControllers objectAtIndex:0];

    NSMutableArray *array;
    if ([navigationController.topViewController class] == [StatisticViewController class]){
        StatisticViewController *destinationController = (StatisticViewController *)navigationController.topViewController;
        array = [NSMutableArray arrayWithObjects:nil];
        for (NSString *key in destinationController.categoryType) {
            [array addObject:[[NSDictionary alloc] initWithObjectsAndKeys:key,@"title",[destinationController.categoryTotal valueForKey:key], @"value",nil,nil]];

        }

        NSLog(@"pie chart category:%f",[destinationController.total doubleValue]);
    }
    else if ([navigationController.topViewController class] == [StatisticDetailViewController class]){
        StatisticDetailViewController *destinationController = (StatisticDetailViewController *)navigationController.topViewController;
        NSLog(@"pie chart details data:%lu",[destinationController.bills count]);
    }
    //NSLog(@"pie chart:%f",[destinationController.total doubleValue]);
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
//    [self setTitle:@"Pie Chart"];
    
    
    int height = [self.view bounds].size.width/3*2.; // 220;
    int width = [self.view bounds].size.width; //320;
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(([self.view bounds].size.width-width)/2,([self.view bounds].size.height-height)/2,width,height)];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:width/2];
    [pieChart setSameColorLabel:YES];
    
    [self.view addSubview:pieChart];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        pieChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30];
        pieChart.percentageFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50];
    }
    
    NSDictionary *pieChartData = [[NSDictionary alloc] initWithObjectsAndKeys:array,@"data",nil,nil];
    NSMutableArray *components = [NSMutableArray array];
    NSLog(@"%@",pieChartData);
    for (int i=0; i<[[pieChartData objectForKey:@"data"] count]; i++)
    {
        NSDictionary *item = [[pieChartData objectForKey:@"data"] objectAtIndex:i];
        PCPieComponent *component = [PCPieComponent pieComponentWithTitle:[item objectForKey:@"title"] value:[[item objectForKey:@"value"] floatValue]];
        [components addObject:component];
        
        if (i==0)
        {
            [component setColour:PCColorYellow];
        }
        else if (i==1)
        {
            [component setColour:PCColorGreen];
        }
        else if (i==2)
        {
            [component setColour:PCColorOrange];
        }
        else if (i==3)
        {
            [component setColour:PCColorRed];
        }
        else if (i==4)
        {
            [component setColour:PCColorBlue];
        }
    }
    [pieChart setComponents:components];


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
@end
