//
//  Bill.m
//  SQLite
//
//  Created by yanglu on 14-4-19.
//  Copyright (c) 2014年 cmu. All rights reserved.
//

#import "Bill.h"

@implementation Bill
-(Bill *)initWithID:(NSNumber *) billID MerchantName:(NSString *) merchantName Date:(NSString *)date Categoty:(NSString *)category Location:(NSString *)location Comment:(NSString *)comment Total:(NSNumber*)total Image:(UIImage *)image{
    self = [super init];
    self.billID = billID;
    self.merchantName = merchantName;
    self.date = date;
    self.category = category;
    self.location = location;
    self.comment = comment;
    self.total = total;
    self.image = image;
    self.items = [[NSMutableArray alloc] init];
    return self;
}

-(void)addItem:(Item *)item{
    [self.items addObject:item];
}

-(void)updateBillID:(NSNumber *)billID{
    self.billID = billID;
    for(Item *item in self.items){
        item.billID = billID;
    }
    return;
}
@end
