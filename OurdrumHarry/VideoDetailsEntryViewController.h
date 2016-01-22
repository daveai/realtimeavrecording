//
//  VideoDetailsEntryViewController.h
//  OurdrumHarry
//
//  Created by Ria and Dev on 13/09/15.
//  Copyright (c) 2015 Digicrazers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AFHTTPRequestOperationManager.h>
#import "Constants.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"
@interface VideoDetailsEntryViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *drumDetails;
@property (weak, nonatomic) IBOutlet UITextView *drumDescription;
- (IBAction)actionSubmit:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) NSURL *videoURL;

@property (weak, nonatomic) NSString *listOfCatIDs;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end
