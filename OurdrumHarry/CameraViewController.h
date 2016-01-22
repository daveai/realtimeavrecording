//
//  CameraViewController.h
//  OurdrumHarry
//
//  Created by debashisandria on 07/04/15.
//  Copyright (c) 2015 Digicrazers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AFHTTPRequestOperationManager.h>
#import "Constants.h"
#import "SelectCategoryViewController.h"
#import "MBProgressHUD.h"

@interface CameraViewController : UIViewController <AVCaptureFileOutputRecordingDelegate, UIAlertViewDelegate, UITextViewDelegate> {
    BOOL WeAreRecording;
    
    AVCaptureSession *CaptureSession;
    AVCaptureMovieFileOutput *MovieFileOutput;
    AVCaptureDeviceInput *VideoInputDevice;
}
@property (retain) AVCaptureVideoPreviewLayer *PreviewLayer;

@property (weak, nonatomic) IBOutlet UIView *preview;



@property (weak, nonatomic) IBOutlet UIButton *btnRecord;

@property (weak, nonatomic) IBOutlet UIButton *btnFlip;

@property (weak, nonatomic) IBOutlet UIButton *btnUpload;

@property (weak, nonatomic) IBOutlet UIButton *btnPrompt;

@property (weak, nonatomic) IBOutlet UIView *telePromptView;

@property (weak, nonatomic) IBOutlet UITextView *telePromptTextView;

@property (weak, nonatomic) IBOutlet UIView *timerView;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@property (weak, nonatomic) IBOutlet UILabel *tMin;

@property (weak, nonatomic) IBOutlet UILabel *tSec;

@property (weak, nonatomic) IBOutlet UIButton *btnMenuFlip;

- (IBAction)actionMenuFlip:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnFlipTopSpace;

@property (weak, nonatomic) IBOutlet UIView *menuContainer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuContainerVerticalSpace;


-(void)startStopRecording;

@end
