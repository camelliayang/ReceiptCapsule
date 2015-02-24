//
//  RecognizeViewController.h
//  ReceiptCapsule
//
//  Created by yanglu on 4/23/14.
//  Copyright (c) 2014 cmu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import "Bill.h"
#import "Item.h"
#import "BillEditorViewController.h"

@interface RecognizeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *cropBounds;
@property UIImage *imageToShow;
@property Bill *bill;
@property CGSize originalSize;
@property CGPoint originalPosition;
@property (strong, nonatomic) UIAlertView *alertView;
- (IBAction)saveImage:(UIButton *)sender;
- (IBAction)recognizeImage:(UIButton *)sender;
- (IBAction)handleMoveCropBounds:(UIPanGestureRecognizer *)sender;
- (IBAction)handleResizeCropBounds:(UIPinchGestureRecognizer *)sender;
@end
