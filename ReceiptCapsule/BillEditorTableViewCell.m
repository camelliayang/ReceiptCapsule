//
//  BillEditorTableViewCell.m
//  ReceiptCapsule
//
//  Created by yanglu on 14-4-22.
//  Copyright (c) 2014年 cmu. All rights reserved.
//

#import "BillEditorTableViewCell.h"

@implementation BillEditorTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.itemTextField.delegate = self;
        self.priceTextField.delegate = self;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:NO];

    // Configure the view for the selected state
}

- (void)endEditing{
    [self.itemTextField endEditing:YES];
    [self.priceTextField endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
