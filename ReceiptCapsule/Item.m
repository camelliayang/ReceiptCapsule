//
//  Item.m
//  SQLite
//
//  Created by yanglu on 14-4-19.
//  Copyright (c) 2014年 cmu. All rights reserved.
//

#import "Item.h"

@implementation Item
-(Item *)initWithItemID:(NSNumber *)itemID BillID:(NSNumber *)billID Name:(NSString *)name Price:(NSNumber *)price{
    self = [super init];
    self.itemID = itemID;
    self.billID = billID;
    self.name = name;
    self.price = price;
    return self;
}
@end
