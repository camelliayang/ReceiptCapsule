//
//  BillEditorTableViewCell.h
//  ReceiptCapsule
//
//  Created by yanglu on 14-4-22.
//  Copyright (c) 2014年 cmu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillEditorTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *itemTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
- (void)endEditing;
@end
