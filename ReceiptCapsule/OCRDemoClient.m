#import "OCRDemoClient.h"

//#error Provide Application ID and Password
static NSString * const kApplicationId = @"receiptcap";
static NSString * const kPassowrd = @"EMR5a8+FYs3OgLDDHyUKoP53";

@implementation OCRDemoClient

+ (instancetype)sharedClient
{
	static OCRDemoClient* sharedClient;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedClient = [[OCRDemoClient alloc] initWithApplicationId:kApplicationId password:kPassowrd];
	});
	
	return sharedClient;
}

@end
