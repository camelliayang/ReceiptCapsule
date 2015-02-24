//
//  Bill.h
//  SQLite
//
//  Created by yanglu on 14-4-19.
//  Copyright (c) 2014年 cmu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface Bill : NSObject
@property(strong, nonatomic) NSNumber *billID;
@property(strong, nonatomic) NSString *merchantName;
@property(strong, nonatomic) NSString *date;
@property(strong, nonatomic) NSString *category;
@property(strong, nonatomic) NSString *location;
@property(strong, nonatomic) NSString *comment;
@property(strong, nonatomic) NSNumber *total;
@property(strong, nonatomic) UIImage *image;
@property(strong, nonatomic) NSMutableArray *items;

-(Bill *)initWithID:(NSNumber *) billID MerchantName:(NSString *) merchantName Date:(NSString *)date Categoty:(NSString *)category Location:(NSString *)location Comment:(NSString *)comment Total:(NSNumber*)total Image:(UIImage *)image;
-(void)addItem:(Item *)item;
-(void)updateBillID:(NSNumber *)billID;
@end
