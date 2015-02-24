//
//  RecognizeViewController.m
//  ReceiptCapsule
//
//  Created by yanglu on 4/23/14.
//  Copyright (c) 2014 cmu. All rights reserved.
//

#import "RecognizeViewController.h"
#import "OCRDemoClient.h"

// Modify this constants to change the recognition languages and export format
static NSString * const kRecognitionLanguages = @"English";
static NSString * const kExportFormat = @"txt";

@interface RecognizeViewController ()

@end

@implementation RecognizeViewController

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
    self.imageView.image = _imageToShow;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveImage:(UIButton *)sender {
    UIImageWriteToSavedPhotosAlbum(self.imageView.image,
                                   self,
                                   @selector(image:save:contextInfo:),
                                   nil);
}

- (IBAction)recognizeImage:(UIButton *)sender {
    CGRect croppedRect = [self transferRectWithCropViewRect:self.cropBounds.frame andImageSize:self.imageView.image.size];
    CGImageRef tmp = CGImageCreateWithImageInRect([self.imageView.image CGImage], croppedRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:tmp];
    self.imageView.frame = self.cropBounds.frame;
    self.imageView.image = croppedImage;
    
    
    self.alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Authorizing...", @"Authorizing...")
												message:@"\n\n"
											   delegate:self
									  cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
									  otherButtonTitles:nil];
	
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[self.alertView addSubview:activityIndicator];
	[self.alertView show];
	activityIndicator.center = CGPointMake(self.alertView.bounds.size.width / 2, self.alertView.bounds.size.height - 90);
	
	[activityIndicator startAnimating];
	
	[[OCRDemoClient sharedClient] activateInstallationWithDeviceId:[[[UIDevice currentDevice] identifierForVendor] UUIDString] success:^{
		self.alertView.title = NSLocalizedString(@"Uploading image...", @"Uploading image...");
		
		NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.5);
		NSDictionary *processingParams = @{@"language": kRecognitionLanguages, @"exportFormat": kExportFormat};
		
		[[OCRDemoClient sharedClient] startTaskWithImageData:imageData withParams:processingParams progressBlock:nil success:^(NSDictionary *taskInfo) {
			[self updateTaskStatus:[taskInfo objectForKey:OCRSDKTaskId]];
		} failure:^(NSError *error) {
			[self showError:error];
		}];
	} failure:^(NSError *error) {
		[self showError:error];
	} force:NO];
    
    NSLog(@"finish recognize");
    
    

}

- (void)updateTaskStatus:(NSString *)taskId
{
	self.alertView.title = NSLocalizedString(@"Processing image...", @"Processing image...");
	
	[[OCRDemoClient sharedClient] getTaskInfo:taskId success:^(NSDictionary *taskInfo) {
		NSString *status = [taskInfo objectForKey:OCRSDKTaskStatus];
		
		if ([status isEqualToString:OCRSDKTaskStatusCompleted]) {
			NSString *downloadURLString = [taskInfo objectForKey:OCRSDKTaskResultURL];
			
			[self downloadResult:[NSURL URLWithString:downloadURLString]];
		} else if ([status isEqualToString:OCRSDKTaskStatusProcessingFailed] || [status isEqualToString:OCRSDKTaskStatusNotEnoughCredits]) {
			NSError *error = [NSError errorWithDomain:@"com.abbyy.ocrsdk.demo" code:666 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Error processing image", @"Error processing image")}];
			[self showError:error];
		} else {
			[self performSelector:@selector(updateTaskStatus:) withObject:taskId afterDelay:1.0];
		}
	} failure:^(NSError *error) {
		[self showError:error];
	}];
}


- (void)downloadResult:(NSURL *)url
{
	self.alertView.title = NSLocalizedString(@"Downloading result...", @"Downloading result...");
    [[OCRDemoClient sharedClient] downloadRecognizedData:url success:^(NSData *downloadedData) {
		[self.alertView dismissWithClickedButtonIndex:-1 animated:YES];
		
		
		
        NSString* text = [[NSString alloc] initWithData:downloadedData encoding:NSUTF8StringEncoding];
        NSLog(text);
		[self parseText: text];

	} failure:^(NSError *error) {
		[self showError:error];
	}];
}

- (void)parseText:(NSString *)text {
    NSArray *stack = self.navigationController.viewControllers;
    BillEditorViewController *prevViewController =(BillEditorViewController *)[stack objectAtIndex:[stack count]-2];
    

    double sum = 0;
    NSArray* array = [text componentsSeparatedByString:@"\n"];
    for (NSString* textline in array) {
        NSArray* contents = [textline componentsSeparatedByString:@"\t"];
        int len = [contents count];
        if (len > 1) {
            NSMutableString * product_name = [[NSMutableString alloc] init];
            for (int i = 0; i < (len - 1); i++)
            {
                [product_name appendString:[contents objectAtIndex:i]];
                [product_name appendString:@" "];
            }
            NSMutableString * price = [NSMutableString stringWithString:[contents lastObject]];
            if ([price characterAtIndex:0] == '$') {
                [price deleteCharactersInRange:NSMakeRange(0, 1)];
            }
            NSLog(@"Product Name: %@", product_name);
            NSLog(@"Price: $%@", price);
            
            sum = sum+[price doubleValue];
            
            Item *item = [[Item alloc] initWithItemID:[NSNumber numberWithInt:1] BillID:[NSNumber numberWithInt:1] Name:product_name Price:[NSNumber numberWithFloat:[price floatValue]]];
            //[prevViewController.items addObject:item];
            [prevViewController.bill.items addObject:item];
            
            
        }
    }
    prevViewController.bill.total = [NSNumber numberWithDouble:sum];
    NSLog(@"Sum: $%f",sum);
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -

- (void)showError:(NSError *)error
{
	if (error.code != NSURLErrorCancelled) {
		[self.alertView dismissWithClickedButtonIndex:-1 animated:YES];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
														message:[error localizedDescription]
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"Ok", @"Ok")
											  otherButtonTitles:nil];
		
		[alert show];
	}
}

- (CGRect) transferRectWithCropViewRect:(CGRect) cropViewRect andImageSize:(CGSize) imageSize{
    CGRect screenRect = self.imageView.frame;
    float newX = cropViewRect.origin.x*(imageSize.width/screenRect.size.width);
    float newY = (cropViewRect.origin.y-screenRect.origin.y)*(imageSize.height/screenRect.size.height);
    float newHeight = cropViewRect.size.height*(imageSize.height/screenRect.size.height);
    float newWidth = cropViewRect.size.width*(imageSize.width/screenRect.size.width);
    return CGRectMake(newX, newY, newWidth, newHeight);
}

- (IBAction)handleMoveCropBounds:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    sender.view.center = CGPointMake(sender.view.center.x, sender.view.center.y+translation.y);
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
    
    // check not out of boundary
    float topEdgePosition = CGRectGetMinY(sender.view.frame);
    float bottomEdgePosition = CGRectGetMaxY(sender.view.frame);
    if(topEdgePosition <= 40){
        sender.view.frame = CGRectMake(sender.view.frame.origin.x, 40, sender.view.frame.size.width, sender.view.frame.size.height);
    }
    
    if(bottomEdgePosition >= [[UIScreen mainScreen] bounds].size.height-20){
        sender.view.frame = CGRectMake(sender.view.frame.origin.x, [[UIScreen mainScreen] bounds].size.height-sender.view.frame.size.height-20, sender.view.frame.size.width, sender.view.frame.size.height);
    }

}

- (IBAction)handleResizeCropBounds:(UIPinchGestureRecognizer *)sender {
    if([sender state] == UIGestureRecognizerStateBegan){
        self.originalSize = sender.view.frame.size;
        self.originalPosition = sender.view.frame.origin;
    }
    float newHeight = self.originalSize.height*(([sender scale]-1)+1);
    float offset = fabsf(self.originalSize.height-newHeight)/2;
    //    NSLog(@"%f %f %f %f" , [recognizer scale], self.originalSize.height, newHeight, offset);
    if([sender scale] >= 1){
        sender.view.frame = CGRectMake(self.originalPosition.x, self.originalPosition.y-offset, self.originalSize.width, newHeight);
    }
    else{
        sender.view.frame = CGRectMake(self.originalPosition.x, self.originalPosition.y+offset, self.originalSize.width, newHeight);
    }

}

-(void)image:(UIImage *)image
        save:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    NSLog(@"image saved to album");
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == alertView.cancelButtonIndex) {
		[NSObject cancelPreviousPerformRequestsWithTarget:self];
		[[[OCRDemoClient sharedClient] operationQueue] cancelAllOperations];
	}
}

@end
