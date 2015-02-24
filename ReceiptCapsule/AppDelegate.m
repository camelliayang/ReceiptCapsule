//
//  AppDelegate.m
//  ReceiptCapsule
//
//  Created by yanglu on 14-4-21.
//  Copyright (c) 2014年 cmu. All rights reserved.
//

#import "AppDelegate.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >>
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"headline.png"] forBarMetrics:UIBarMetricsDefault];
    // Override point for customization after application launch.
    [Database openDatabase];
    
    //[Database dropTable:@"Bill"];
    //[Database dropTable:@"Item"];
    
    //initialize dump database for testing
    [Database openDatabase];
    
    //[Database dropTable:@"Bill"];
    //[Database dropTable:@"Item"];
  
    [Database createTalbe:@"Bill"];
    [Database createTalbe:@"Item"];
    
  /*
    Bill *bill = [[Bill alloc] initWithID:nil MerchantName:@"Test" Date:@"2014-04-25" Categoty:@"Food" Location:@"Test1" Comment:@"Test1" Total:[NSNumber numberWithFloat:10] Image:nil];
    Item *item = [[Item alloc] initWithItemID:nil BillID:nil Name:@"Test" Price:[NSNumber numberWithFloat:1.23]];
    Item *item1 = [[Item alloc] initWithItemID:nil BillID:nil Name:@"Test" Price:[NSNumber numberWithFloat:1.23]];
    [bill addItem:item];
    [bill addItem:item1];
    [Database saveBill:bill];
    
    bill = [[Bill alloc] initWithID:nil MerchantName:@"Test" Date:@"2014-04-25" Categoty:@"Food" Location:@"Test2" Comment:@"Test2" Total:[NSNumber numberWithFloat:20] Image:nil];
    item = [[Item alloc] initWithItemID:nil BillID:nil Name:@"Test" Price:[NSNumber numberWithFloat:1.23]];
    item1 = [[Item alloc] initWithItemID:nil BillID:nil Name:@"Test" Price:[NSNumber numberWithFloat:1.23]];
    [bill addItem:item];
    [bill addItem:item1];
    [Database saveBill:bill];
    
    bill = [[Bill alloc] initWithID:nil MerchantName:@"Test" Date:@"2014-04-23" Categoty:@"Food" Location:@"Test2" Comment:@"Test2" Total:[NSNumber numberWithFloat:15] Image:nil];
    item = [[Item alloc] initWithItemID:nil BillID:nil Name:@"Test" Price:[NSNumber numberWithFloat:1.23]];
    item1 = [[Item alloc] initWithItemID:nil BillID:nil Name:@"Test" Price:[NSNumber numberWithFloat:1.23]];
    [bill addItem:item];
    [bill addItem:item1];
    [Database saveBill:bill];
    
    bill = [[Bill alloc] initWithID:nil MerchantName:@"Test" Date:@"2014-04-03" Categoty:@"Food" Location:@"Test2" Comment:@"Test2" Total:[NSNumber numberWithFloat:66] Image:nil];
    item = [[Item alloc] initWithItemID:nil BillID:nil Name:@"Test" Price:[NSNumber numberWithFloat:1.23]];
    item1 = [[Item alloc] initWithItemID:nil BillID:nil Name:@"Test" Price:[NSNumber numberWithFloat:1.23]];
    [bill addItem:item];
    [bill addItem:item1];
    [Database saveBill:bill];
    
    bill = [[Bill alloc] initWithID:nil MerchantName:@"Test" Date:@"2014-02-03" Categoty:@"Food" Location:@"Test2" Comment:@"Test2" Total:[NSNumber numberWithFloat:77] Image:nil];
    item = [[Item alloc] initWithItemID:nil BillID:nil Name:@"Test" Price:[NSNumber numberWithFloat:1.23]];
    item1 = [[Item alloc] initWithItemID:nil BillID:nil Name:@"Test" Price:[NSNumber numberWithFloat:1.23]];
    [bill addItem:item];
    [bill addItem:item1];
    [Database saveBill:bill];

*/
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
