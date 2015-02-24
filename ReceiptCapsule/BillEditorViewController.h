//
//  BillEditorViewController.h
//  ReceiptCapsule
//
//  Created by yanglu on 14-4-22.
//  Copyright (c) 2014年 cmu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillEditorTableViewCell.h"
#import "BillEditorStaticTableViewCell.h"
#import "RecognizeViewController.h"
#import "Database.h"
#import "Bill.h"
#import "Item.h"

@interface BillEditorViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
- (IBAction)twitter:(id)sender;
- (IBAction)facebook:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UITableView *staticTableView;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSArray *types;

- (IBAction)saveBill:(id)sender;

@property UIImage *imageForSave;
@property Bill *bill;
- (IBAction)addItemButtonPressed:(id)sender;
- (IBAction)takePhoto:(UIButton *)sender;
@end
