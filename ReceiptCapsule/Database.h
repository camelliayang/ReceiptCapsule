//
//  Database.h
//  SQLite
//
//  Created by yanglu on 14-4-19.
//  Copyright (c) 2014年 cmu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Bill.h"
#import "Item.h"

@interface Database : NSObject
+(void)dropTable:(NSString *)tableName;
+(void)createTalbe:(NSString *)tableName;
+(void)openDatabase;
+(void)saveBill:(Bill *)bill;
+(void)updateBill:(Bill *)bill;
+(void)updateItem:(Item *)item;
+(void)deleteBill:(Bill *)bill;
+(void)deleteItem:(Item *)item;
+(NSMutableArray *)searchBillWithColName:(NSString *)colName AndValue1:(NSString *)value1 AndValue2:(NSString *)value2;
+(NSMutableArray *)searchItemWithBillID:(NSNumber *)billID;
@end
