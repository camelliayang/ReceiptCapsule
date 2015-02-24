//
//  BillEditorViewController.m
//  ReceiptCapsule
//
//  Created by yanglu on 14-4-22.
//  Copyright (c) 2014年 cmu. All rights reserved.
//

#import "BillEditorViewController.h"
#import <Social/Social.h>
@interface BillEditorViewController ()

@end

UIToolbar* numberToolbar;
UITextField *dateTextField;
UITextField *typeTextField;
UITextField *totalTextField;
UITextField *merchantTextField;
UITextField *commentTextField;
NSDateFormatter *dateFormatter;

CGFloat animatedDistance;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@implementation BillEditorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Register Custom Nib
    UINib *cellNib = [UINib nibWithNibName:@"BillEditorTableViewCell" bundle:nil];
    [self.itemTableView registerNib:cellNib forCellReuseIdentifier:@"BillEditorTableViewCell"];
    UINib *staticCellNib = [UINib nibWithNibName:@"BillEditorStaticTableViewCell" bundle:nil];
    [self.staticTableView registerNib:staticCellNib forCellReuseIdentifier:@"BillEditorStaticTableViewCell"];
    
    // Set delegate
    self.staticTableView.delegate = self;
    self.staticTableView.dataSource = self;
    self.itemTableView.delegate = self;
    self.itemTableView.dataSource = self;
    //invisible header and footer
    self.itemTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.itemTableView.bounds.size.width, 0.01f)];
    self.staticTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.staticTableView.bounds.size.width, 0.01f)];
    self.itemTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.itemTableView.bounds.size.width, 0.01f)];
    self.staticTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.staticTableView.bounds.size.width, 0.01f)];
    
    
    // set keyboard toolbar
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad:)],
                           nil];
    
    // initialize data
//    self.items = [NSMutableArray arrayWithObjects:@"1",@"2",nil];
    self.items = [NSMutableArray arrayWithObjects:nil];
    [self.itemTableView reloadData];
    
    // initialize dateFormatter
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    // initialize types array
    self.types = [NSArray arrayWithObjects:@"Food", @"Entertainment", @"Education", nil];
    
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    NSDate* today =[[NSDate alloc] init];
    NSString* strToday = [dateFormatter stringFromDate:today];
    
    if(!self.bill){
        Bill *bill = [[Bill alloc] initWithID:nil MerchantName:@"" Date:strToday Categoty:@"Food" Location:@"Test1" Comment:@"Test1" Total:[NSNumber numberWithFloat:0.0] Image:nil];
        self.bill=bill;
    }
    
    
    self.items = self.bill.items;
    self.imageForSave = self.bill.image;
    
    [self.staticTableView reloadData];
    [self.itemTableView reloadData];
}

- (IBAction)addItemButtonPressed:(id)sender{
    //[self.items addObject:@"3"];
     Item *item = [[Item alloc] initWithItemID:[NSNumber numberWithInt:1] BillID:[NSNumber numberWithInt:1] Name:@"new product" Price:[NSNumber numberWithFloat:0.0]];
    
    
    
    [self.bill.items addObject:item];
    //[self.items addObject:item];
    
    
    [self.itemTableView reloadData];
}

- (IBAction)takePhoto:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    _imageForSave = info[UIImagePickerControllerEditedImage];
    self.bill.image = _imageForSave;
    [picker dismissViewControllerAnimated:YES completion:^(){
        [self performSegueWithIdentifier:@"showReg" sender:(nil)];
    }];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    RecognizeViewController *destinationController = (RecognizeViewController *)[segue destinationViewController];
    if ([segue.identifier isEqualToString:@"showReg"]){
        NSLog(@"set imageView image");
        destinationController.imageToShow = _imageForSave;
        
//        // get info user input already
//        // get Total:
//        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        BillEditorStaticTableViewCell* cell = (BillEditorStaticTableViewCell *)[self.staticTableView cellForRowAtIndexPath:indexPath];
//        NSString* text = cell.valueTextField.text;
//        NSString* total = [text substringWithRange:NSMakeRange(1, [text length])];
//        // get category
//        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
//        cell = (BillEditorStaticTableViewCell *)[self.staticTableView cellForRowAtIndexPath:indexPath];
//        NSString* category = cell.valueTextField.text;
//        // get date
//        indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
//        cell = (BillEditorStaticTableViewCell *)[self.staticTableView cellForRowAtIndexPath:indexPath];
//        NSString* date = cell.valueTextField.text;
//        
//        
//        destinationController.bill = [[Bill alloc] initWithID:nil MerchantName:@"Test" Date:date Categoty:category Location:@"Test" Comment:@"Test" Total:[NSNumber numberWithFloat:[total floatValue]] Image:nil];



    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.staticTableView) {
        return 5;
    }
    else if (tableView == self.itemTableView){
        return [self.items count]+1;
    }
    else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BillEditorTableViewCell";
    static NSString *StaticCellIdentifier = @"BillEditorStaticTableViewCell";
    if (tableView == self.staticTableView) {
        BillEditorStaticTableViewCell *cell = (BillEditorStaticTableViewCell *)[tableView dequeueReusableCellWithIdentifier:StaticCellIdentifier];
        cell.valueTextField.inputAccessoryView = numberToolbar;
        cell.valueTextField.delegate = self;
        cell.valueTextField.tag = indexPath.row;
        
        if (indexPath.row == 0) {
            totalTextField = cell.valueTextField;
            cell.typeTextField.text = @"Total";
            cell.typeTextField.placeholder = @"";
            cell.typeTextField.enabled = FALSE;
            [cell.valueTextField setKeyboardType:UIKeyboardTypeDecimalPad];
            cell.valueTextField.text = [self.bill.total stringValue];
            [cell.valueTextField addTarget:self
                          action:@selector(textFieldDidChange:)
                forControlEvents:UIControlEventEditingChanged];
            
          //  [cell.valueTextField setFont:[UIFont systemFontOfSize:36]];
        }
        else if (indexPath.row == 1) {
            typeTextField = cell.valueTextField;
            cell.typeTextField.text = @"Type";
            cell.typeTextField.enabled = FALSE;
            cell.valueTextField.text = self.bill.category;
            UIPickerView *picker = [[UIPickerView alloc] init];
            picker.delegate = self;
            picker.dataSource = self;
            [cell.valueTextField setInputView:picker];
        }
        else if(indexPath.row == 2){
            dateTextField = cell.valueTextField;
            cell.typeTextField.text = @"Date";
            cell.typeTextField.enabled = FALSE;
            cell.valueTextField.text = self.bill.date;
            //initialize datepicker
            UIDatePicker *datePicker = [[UIDatePicker alloc]init];
            datePicker.datePickerMode = UIDatePickerModeDate;
            [datePicker setDate:[NSDate date]];
            [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
            [cell.valueTextField setInputView:datePicker];
        }
        else if (indexPath.row == 3) {
            merchantTextField = cell.valueTextField;
            cell.typeTextField.text = @"Merchant";
            cell.typeTextField.placeholder = @"";
            cell.typeTextField.enabled = FALSE;
            cell.valueTextField.text = self.bill.merchantName;
            [cell.valueTextField addTarget:self
                                    action:@selector(merchantFieldDidChange:)
                          forControlEvents:UIControlEventEditingChanged];
            
            //[cell.valueTextField setFont:[UIFont systemFontOfSize:36]];
        }
        else if (indexPath.row == 4) {
            commentTextField = cell.valueTextField;
            cell.typeTextField.text = @"Comment";
            cell.typeTextField.placeholder = @"";
            cell.typeTextField.enabled = FALSE;
            cell.valueTextField.text = self.bill.comment;
            [cell.valueTextField addTarget:self
                                    action:@selector(commentFieldDidChange:)
                          forControlEvents:UIControlEventEditingChanged];
            
            //[cell.valueTextField setFont:[UIFont systemFontOfSize:36]];
        }
        return cell;
    }
    else if(tableView == self.itemTableView){
        BillEditorTableViewCell *cell = (BillEditorTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.itemTextField.inputAccessoryView = numberToolbar;
        cell.priceTextField.inputAccessoryView = numberToolbar;
        cell.itemTextField.delegate = self;
        cell.priceTextField.delegate = self;
        cell.itemTextField.tag = indexPath.row;
        cell.priceTextField.tag = indexPath.row;
        
        if (indexPath.row == 0) {
            cell.itemTextField.text = @"Item";
            cell.itemTextField.enabled = FALSE;
            cell.priceTextField.text = @"";
            cell.priceTextField.placeholder = @"";
            cell.priceTextField.enabled = FALSE;
        }
        else{
            Item *item = (Item *)[self.bill.items objectAtIndex:indexPath.row-1];
            cell.itemTextField.text = item.name;
            cell.priceTextField.text = [item.price stringValue];
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

-(void)doneWithNumberPad:(id)sender{
    for (int row = 0; row < [self.itemTableView numberOfRowsInSection:0]; row++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        BillEditorTableViewCell* cell = (BillEditorTableViewCell *)[self.itemTableView cellForRowAtIndexPath:indexPath];
        if ([cell.priceTextField isFirstResponder]){
            [cell.priceTextField resignFirstResponder];
            Item* item = [self.bill.items objectAtIndex:row-1];
            item.price = [NSNumber numberWithFloat:[cell.priceTextField.text floatValue]];
        }
        if ([cell.itemTextField isFirstResponder]) {
            [cell.itemTextField resignFirstResponder];
            Item* item = [self.bill.items objectAtIndex:row-1];
            item.name = cell.itemTextField.text;
        }
    }
    

    for (int row = 0; row < [self.staticTableView numberOfRowsInSection:0]; row++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        BillEditorStaticTableViewCell* cell = (BillEditorStaticTableViewCell *)[self.staticTableView cellForRowAtIndexPath:indexPath];
        if ([cell.valueTextField isFirstResponder]) [cell.valueTextField resignFirstResponder];
    }

    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    
    
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    /*
    int offset = textField.tag*40;
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
     */
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)updateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)dateTextField.inputView;
    dateTextField.text = [dateFormatter stringFromDate:picker.date];
    self.bill.date =dateTextField.text;
}

-(void)textFieldDidChange:(id)sender
{
    
    self.bill.total = [NSNumber numberWithFloat:[totalTextField.text floatValue]];
}

-(void)merchantFieldDidChange:(id)sender
{
    
    self.bill.merchantName = merchantTextField.text;
}

-(void)commentFieldDidChange:(id)sender
{
    
    self.bill.comment = commentTextField.text;
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.types count];
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.types objectAtIndex:row];
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    typeTextField.text = [self.types objectAtIndex:row];
    self.bill.category = typeTextField.text;
}
- (IBAction)saveBill:(id)sender {
     NSLog(@"save press");
    [Database deleteBill:self.bill];
    [Database saveBill:self.bill];
   
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Save Complete!"
                                                      message:@"Your bill is updated and recorded in the system."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
}
- (IBAction)twitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        if (self.bill.total != 0) {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            // The tweets is here.
            NSString *tweet = [[NSString alloc] initWithString:
                               [NSString stringWithFormat: @"My %@ Expense on %@ is %@ in %@.", self.bill.category, self.bill.date,
                                self.bill.total, self.bill.location]];
            [tweetSheet setInitialText:tweet];
            
            [self presentViewController:tweetSheet animated:YES completion:nil];
            
            
        }
        // If the total money is 0, alert them.
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                            message:@"You didn't spend money yet, now you can't share."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }
    // If the user didn't login twitter, alert them to login.
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You should Login Twitter"
                                                        message:@"You must login twitter first.Go to settings to set."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }

}

- (IBAction)facebook:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        if (self.bill.total != 0) {
            // Initialize Compose View Controller
            SLComposeViewController *vc = nil;
            vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            NSString *text = [[NSString alloc] initWithString:
                              [NSString stringWithFormat: @"My %@ Expense on %@ is %@ in %@.", self.bill.category, self.bill.date,
                               self.bill.total, self.bill.location]];
            [vc setInitialText:text];
            
            // Present Compose View Controller
            [self presentViewController:vc animated:YES completion:nil];
        }
        // If the total money is 0, alert them.
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                            message:@"You didn't spend money yet, now you can't share."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }
    else {
        NSString *message = @"It seems that we cannot share to Facebook at the moment or you have not yet added your Facebook account to this device. Go to the Settings application to add your Facebook account to this device.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    

}

    
@end
