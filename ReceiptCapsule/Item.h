//
//  Item.h
//  SQLite
//
//  Created by yanglu on 14-4-19.
//  Copyright (c) 2014年 cmu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject
@property(strong, nonatomic) NSNumber *itemID;
@property(strong, nonatomic) NSNumber *billID;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSNumber *price;
-(Item *)initWithItemID:(NSNumber *)itemID BillID:(NSNumber *)billID Name:(NSString *)name Price:(NSNumber *)price;
@end
