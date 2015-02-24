//
//  Database.m
//  SQLite
//
//  Created by yanglu on 14-4-19.
//  Copyright (c) 2014年 cmu. All rights reserved.
//

#import "Database.h"
#import "Bill.h"
#import "Item.h"

@implementation Database
static sqlite3 *database;


//Drop Table
+(void)dropTable:(NSString *)tableName{
    NSString *sqlDropTable = nil;
    if([tableName isEqualToString:@"Bill"]){
        sqlDropTable = @"DELETE FROM BILL";
    }
    else if([tableName isEqualToString:@"Item"]){
        sqlDropTable = @"DELETE FROM ITEM";
    }
    [self execSql:sqlDropTable];
}

//Get database location
+(NSString *)getDatabasePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"NNYY.db"];
}

//Create bill and item table
+(void)createTalbe:(NSString *)tableName{
    NSString *sqlCreateTable = nil;
    if([tableName isEqualToString:@"Bill"]){
        sqlCreateTable = @"CREATE TABLE IF NOT EXISTS BILL (ID INTEGER PRIMARY KEY AUTOINCREMENT, MERCHANTNAME TEXT, DATE DATETIME, LOCATION TEXT, CATEGORY TEXT, COMMENT TEXT, TOTAL REAL, IMAGE BLOB)";
    }
    else if([tableName isEqualToString:@"Item"]){
         sqlCreateTable = @"CREATE TABLE IF NOT EXISTS ITEM (ID INTEGER PRIMARY KEY AUTOINCREMENT, BILLID INTEGER, NAME TEXT, PRICE REAL, FOREIGN KEY(BILLID) REFERENCES BILL(ID))";
    }
    [self execSql:sqlCreateTable];
}

//Open NNYY Database
+(void)openDatabase{
    // generate path for the database
    NSString *databasePath = [self getDatabasePath];
    if(sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK){
        sqlite3_close(database);
        NSLog(@"Open Database Error");
    }
    //open foreign key
    [self execSql:@"PRAGMA foreign_keys=ON"];
    return;
}

//ExecSql command
//Return last operated row id
//parameter is sql command
+(NSNumber *)execSql:(NSString*)sql{
    if(database == nil){
        [self openDatabase];
        [self createTalbe:@"Bill"];
        [self createTalbe:@"Item"];
    }
    char *err;
    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Exec Sql Error");
    }
    else NSLog(@"Exec Sql Success");
    return [NSNumber numberWithLongLong:sqlite3_last_insert_rowid(database)];
}

//Save bill
//parameter is bill object
+(void)saveBill:(Bill *)bill{
    NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO BILL (MERCHANTNAME,DATE,LOCATION,CATEGORY,COMMENT,TOTAL) VALUES ('%@', '%@', '%@', '%@', '%@', %@)", bill.merchantName, bill.date, bill.location, bill.category, bill.comment, [bill.total stringValue]];
    NSLog(@"bill insert sql: %@", sqlInsert);
    NSNumber *billID = [self execSql:sqlInsert];
    // update bill id for each item
    [bill updateBillID:billID];
    // insert item
    for(Item *item in bill.items){
        [self saveItem:item];
    }
    return;
}

//Save item
//parameter is item object
+(void)saveItem:(Item *)item{
    NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO ITEM (BILLID,NAME,PRICE) VALUES (%@, '%@', %@)",[item.billID stringValue], item.name, [item.price stringValue]];
    NSLog(@"item insert sql: %@", sqlInsert);
    //update item id
    item.itemID = [self execSql:sqlInsert];
    return;
}

//Update bill
//parameter is bill object
+(void)updateBill:(Bill *)bill{
    NSString *sqlUpdate = [NSString stringWithFormat:@"UPDATE BILL SET MERCHANTNAME = '%@', DATE = '%@', LOCATION = '%@', CATEGORY = '%@', COMMENT = '%@', TOTAL = %@ WHERE ID = %@",bill.merchantName, bill.date, bill.location, bill.category, bill.comment, [bill.total stringValue], [bill.billID stringValue]];
    NSLog(@"bill update sql: %@", sqlUpdate);
    [self execSql:sqlUpdate];
    return;
}

//Update item
//parameter is item object
+(void)updateItem:(Item *)item{
    NSString *sqlUpdate = [NSString stringWithFormat:@"UPDATE ITEM SET BILLID = %@, PRICE = %@, NAME = '%@' WHERE ID = %@",[item.billID stringValue], [item.price stringValue], item.name, [item.itemID stringValue]];
    NSLog(@"item update sql: %@", sqlUpdate);
    [self execSql:sqlUpdate];
    return;
}

//Delete item
//parameter is bill object
+(void)deleteBill:(Bill *)bill{
    for(Item *item in bill.items){
        [self deleteItem:item];
    }
    NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM BILL WHERE ID = %d;",[bill.billID intValue]];
    NSLog(@"bill delete sql: %@", sqlDelete);
    [self execSql:sqlDelete];
    
    // delete item
    for(Item *item in bill.items){
        [self deleteItem:item];
    }
    
    return;
}

//Delete item
//parameter is item object
+(void)deleteItem:(Item *)item{
    NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM ITEM WHERE ID = %d;",[item.itemID intValue]];
    NSLog(@"item delete sql: %@", sqlDelete);
    [self execSql:sqlDelete];
    return;
}



//Search item with with col name and its value
//return a list of bill
//current support search by date
//parameter is @"DATE", @"1990-01-01"(start date), @"2014-01-01"(end date)
+(NSMutableArray *)searchBillWithColName:(NSString *)colName AndValue1:(NSString *)value1 AndValue2:(NSString *)value2{
    if(database == nil) [self openDatabase];
    NSString *sqlSearch = nil;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    //sql result
    sqlite3_stmt *statement;
    if([colName isEqualToString:@"DATE"]){
        sqlSearch = [NSString stringWithFormat:@"SELECT * FROM BILL WHERE  DATE >= '%@' AND DATE <= '%@';", value1, value2];
    }
    if(sqlite3_prepare_v2(database, [sqlSearch UTF8String], -1, &statement, nil) == SQLITE_OK){
        while(sqlite3_step(statement) == SQLITE_ROW){
            int billID = sqlite3_column_int(statement, 0);
            char* merchantName = (char*)sqlite3_column_text(statement, 1);
            char* date = (char*)sqlite3_column_text(statement, 2);
            char* location = (char*)sqlite3_column_text(statement, 3);
            char* category = (char*)sqlite3_column_text(statement, 4);
            char* comment = (char*)sqlite3_column_text(statement, 5);
            double total= sqlite3_column_double(statement, 6);
            //generate bill object
            Bill *bill = [[Bill alloc] initWithID:[NSNumber numberWithInt:billID]
                                     MerchantName:[NSString stringWithUTF8String:merchantName]
                                             Date:[NSString stringWithUTF8String:date]
                                         Categoty:[NSString stringWithUTF8String:category]
                                         Location:[NSString stringWithUTF8String:location]
                                          Comment:[NSString stringWithUTF8String:comment]
                                            Total:[NSNumber numberWithDouble:total]
                                            Image:nil];
            //get items of this bill
            for(Item *item in [self searchItemWithBillID:[NSNumber numberWithInt:billID]]){
                [bill addItem:item];
            }
            [result addObject:bill];
        }
    }
    return result;
}


//Search item with with bill ID
//return a list of item
//parameter is billID
+(NSMutableArray *)searchItemWithBillID:(NSNumber *)billID{
    NSString *sqlSearch = [NSString stringWithFormat:@"SELECT * FROM ITEM WHERE BILLID = %d", [billID intValue]];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(database, [sqlSearch UTF8String], -1, &statement, nil) == SQLITE_OK){
        while(sqlite3_step(statement) == SQLITE_ROW){
            int itemID = sqlite3_column_int(statement, 0);
            int billID = sqlite3_column_int(statement, 1);
            char* name = (char*)sqlite3_column_text(statement, 2);
            double price= sqlite3_column_double(statement, 3);
            Item *item = [[Item alloc] initWithItemID:[NSNumber numberWithInt:itemID]
                                               BillID:[NSNumber numberWithInt:billID]
                                                 Name:[NSString stringWithUTF8String:name]
                                                Price:[NSNumber numberWithDouble:price]];
            [result addObject:item];
            
        }
    }
    return result;
}
@end
