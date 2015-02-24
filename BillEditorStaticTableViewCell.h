//
//  BillEditorStaticTableViewCell.h
//  ReceiptCapsule
//
//  Created by yanglu on 14-4-23.
//  Copyright (c) 2014年 cmu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillEditorStaticTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@end
