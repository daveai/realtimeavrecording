//
//  CameraViewController.m
//  OurdrumHarry
//
//  Created by debashisandria on 07/04/15.
//  Copyright (c) 2015 Digicrazers. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end
int h, pretimerCounter;

CameraViewController *refToSelf;

void volumeListenerCallback ( void *inClientData, AudioSessionPropertyID    inID, UInt32                    inDataSize, const void                *inData){
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [refToSelf startStopRecording];
    });
}


@implementation CameraViewController {
    NSTimer *preTimer;
    NSTimer *t;
    NSTimer *recordingTimer;
    
    int recordTime;
    
    int maxRecordTime;
    
    
    NSURL *videoURL;
    
    BOOL isMenuShown;
}
@synthesize PreviewLayer;
-(void)viewWillAppear:(BOOL)animated {
    
    
    [super viewDidAppear:animated];
    
    h=0;
    pretimerCounter=6;
    recordTime=0;
    
    self.timerLabel.text = @"5";
    
    
    
    
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"telePromptText"] length]) {
        
        
        
        self.telePromptTextView.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"telePromptText"];
    } else {
        self.telePromptTextView.text = @"";
    }
    
    [self.telePromptTextView setFont:[UIFont systemFontOfSize:30]];
    [self.telePromptTextView setTextColor:[UIColor greenColor]];
    
    BOOL isTelePrompt = [[[NSUserDefaults standardUserDefaults] valueForKey:@"isTelePromptEnable"] boolValue];
    
    if (!isTelePrompt) {
        self.telePromptTextView.hidden = YES;
    } else {
        self.telePromptTextView.hidden = NO;
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.telePromptTextView.contentOffset = CGPointMake(0,0);
    });
    
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionSetActive(YES);
    AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume, volumeListenerCallback, (__bridge void *)(self));
        
    refToSelf = self;
}




-(void)viewDidLayoutSubviews {
    
    
    
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}



- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    
    
    
    pretimerCounter = 6;
    
    isMenuShown = NO;
    
    self.timerView.hidden = YES;
    
    maxRecordTime = [[[NSUserDefaults standardUserDefaults] valueForKey:@"max_video_time"] integerValue];
    
    //maxRecordTime = 15;
    
    //---------------------------------
    //----- SETUP CAPTURE SESSION -----
    //---------------------------------
    NSLog(@"Setting up capture session");
    CaptureSession = [[AVCaptureSession alloc] init];
    
    //----- ADD INPUTS -----
    NSLog(@"Adding video input");
    
    //ADD VIDEO INPUT
    AVCaptureDevice *VideoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (VideoDevice)
    {
        NSError *error;
        VideoInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:VideoDevice error:&error];
        if (!error)
        {
            if ([CaptureSession canAddInput:VideoInputDevice])
                [CaptureSession addInput:VideoInputDevice];
            else
                NSLog(@"Couldn't add video input");
        }
        else
        {
            NSLog(@"Couldn't create video input");
        }
    }
    else
    {
        NSLog(@"Couldn't create video capture device");
    }
    
    //ADD AUDIO INPUT
    NSLog(@"Adding audio input");
    AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error = nil;
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
    if (audioInput)
    {
        [CaptureSession addInput:audioInput];
    }
    
    
    //----- ADD OUTPUTS -----
    
    //ADD VIDEO PREVIEW LAYER
    NSLog(@"Adding video preview layer");
    [self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:CaptureSession]];
    
    //PreviewLayer.orientation = AVCaptureVideoOrientationLandscapeRight;		//<<SET ORIENTATION.  You can deliberatly set this wrong to flip the image and may actually need to set it wrong to get the right image
    
    PreviewLayer.connection.videoOrientation = [self deviceOrientationDidChange];
    
    [[self PreviewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    self.PreviewLayer.frame = self.view.frame;
    
    [self.preview.layer addSublayer:PreviewLayer];
    
    
    self.btnFlip.layer.zPosition = 9999;
    self.btnPrompt.layer.zPosition = 9999;
    self.btnRecord.layer.zPosition = 9999;
    self.btnUpload.layer.zPosition = 9999;
    self.telePromptView.layer.zPosition = 9999;
    self.btnMenuFlip.layer.zPosition = 99999;
    self.menuContainer.layer.zPosition = 99999;
    //ADD MOVIE FILE OUTPUT
   NSLog(@"Adding movie file output");
    MovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    Float64 TotalSeconds = 60;			//Total seconds
    int32_t preferredTimeScale = 30;	//Frames per second
    CMTime maxDuration = CMTimeMakeWithSeconds(TotalSeconds, preferredTimeScale);	//<<SET MAX DURATION
    MovieFileOutput.maxRecordedDuration = maxDuration;
    
    MovieFileOutput.minFreeDiskSpaceLimit = 1024 * 1024;						//<<SET MIN FREE SPACE IN BYTES FOR RECORDING TO CONTINUE ON A VOLUME
    
    if ([CaptureSession canAddOutput:MovieFileOutput])
        [CaptureSession addOutput:MovieFileOutput];
    
    //SET THE CONNECTION PROPERTIES (output properties)
    [self CameraSetOutputProperties];			//(We call a method as it also has to be done after changing camera)
    
    
    
    //----- SET THE IMAGE QUALITY / RESOLUTION -----
    //Options:
    //	AVCaptureSessionPresetHigh - Highest recording quality (varies per device)
    //	AVCaptureSessionPresetMedium - Suitable for WiFi sharing (actual values may change)
    //	AVCaptureSessionPresetLow - Suitable for 3G sharing (actual values may change)
    //	AVCaptureSessionPreset640x480 - 640x480 VGA (check its supported before setting it)
    //	AVCaptureSessionPreset1280x720 - 1280x720 720p HD (check its supported before setting it)
    //	AVCaptureSessionPresetPhoto - Full photo resolution (not supported for video output)
    NSLog(@"Setting image quality");
    //[CaptureSession setSessionPreset:AVCaptureSessionPresetMedium];
    if ([CaptureSession canSetSessionPreset:AVCaptureSessionPreset1280x720])		//Check size based configs are supported before setting them
        [CaptureSession setSessionPreset:AVCaptureSessionPreset1280x720];
    
    
    
   
    
    
    //----- START THE CAPTURE SESSION RUNNING -----
    [CaptureSession startRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"segCategory"]) {
        SelectCategoryViewController *dest = (SelectCategoryViewController *)[segue destinationViewController];
        
        dest.videoURL = videoURL;
    }
    
}




- (AVCaptureVideoOrientation)deviceOrientationDidChange{
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    AVCaptureVideoOrientation newOrientation;
    
    if (deviceOrientation == UIDeviceOrientationPortrait){
        NSLog(@"deviceOrientationDidChange - Portrait");
        newOrientation = AVCaptureVideoOrientationPortrait;
    }
    else if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown){
        NSLog(@"deviceOrientationDidChange - UpsideDown");
        newOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
    }
    
    // AVCapture and UIDevice have opposite meanings for landscape left and right (AVCapture orientation is the same as UIInterfaceOrientation)
    else if (deviceOrientation == UIDeviceOrientationLandscapeLeft){
        NSLog(@"deviceOrientationDidChange - LandscapeLeft");
        newOrientation = AVCaptureVideoOrientationLandscapeRight;
    }
    else if (deviceOrientation == UIDeviceOrientationLandscapeRight){
        NSLog(@"deviceOrientationDidChange - LandscapeRight");
        newOrientation = AVCaptureVideoOrientationLandscapeLeft;
    }
    
    else if (deviceOrientation == UIDeviceOrientationUnknown){
        NSLog(@"deviceOrientationDidChange - Unknown ");
        newOrientation = AVCaptureVideoOrientationPortrait;
    }
    
    else{
        NSLog(@"deviceOrientationDidChange - Face Up or Down");
        newOrientation = AVCaptureVideoOrientationPortrait;
    }
    
    return newOrientation;
}


- (IBAction)CameraToggleButtonPressed:(id)sender
{
    if ([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1)		//Only do if device has multiple cameras
    {
        NSLog(@"Toggle camera");
        NSError *error;
        //AVCaptureDeviceInput *videoInput = [self videoInput];
        AVCaptureDeviceInput *NewVideoInput;
        AVCaptureDevicePosition position = [[VideoInputDevice device] position];
        if (position == AVCaptureDevicePositionBack)
        {
            if ([CaptureSession canSetSessionPreset:AVCaptureSessionPresetMedium])		//Check size based configs are supported before setting them
                [CaptureSession setSessionPreset:AVCaptureSessionPresetMedium];
            NewVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self CameraWithPosition:AVCaptureDevicePositionFront] error:&error];
        }
        else if (position == AVCaptureDevicePositionFront)
        {
            if ([CaptureSession canSetSessionPreset:AVCaptureSessionPresetiFrame1280x720])		//Check size based configs are supported before setting them
                [CaptureSession setSessionPreset:AVCaptureSessionPresetiFrame1280x720];
            NewVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self CameraWithPosition:AVCaptureDevicePositionBack] error:&error];
        }
        
        if (NewVideoInput != nil)
        {
            [CaptureSession beginConfiguration];		//We can now change the inputs and output configuration.  Use commitConfiguration to end
            [CaptureSession removeInput:VideoInputDevice];
            
            if ([CaptureSession canAddInput:NewVideoInput])
            {
                
                [CaptureSession addInput:NewVideoInput];
                VideoInputDevice = NewVideoInput;
            }
            else
            {
                [CaptureSession addInput:VideoInputDevice];
            }
            
           
            
            
            [CaptureSession commitConfiguration];
            
        }
    }
    
}

- (void) CameraSetOutputProperties
{
    //SET THE CONNECTION PROPERTIES (output properties)
    AVCaptureConnection *CaptureConnection = [MovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    
    //Set landscape (if required)
    if ([CaptureConnection isVideoOrientationSupported])
    {
        AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationPortrait;		//<<<<<SET VIDEO ORIENTATION IF LANDSCAPE
        [CaptureConnection setVideoOrientation:orientation];
    }
    
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    AVCaptureConnection *videoConnection = self.PreviewLayer.connection;
    [videoConnection setVideoOrientation:(AVCaptureVideoOrientation)toInterfaceOrientation];
    
    
    //SET THE CONNECTION PROPERTIES (output properties)
    AVCaptureConnection *CaptureConnection = [MovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    
    
    if ([CaptureConnection isVideoOrientationSupported])
    {
        AVCaptureVideoOrientation orientation = (AVCaptureVideoOrientation)toInterfaceOrientation;
        [CaptureConnection setVideoOrientation:orientation];
    }
    self.PreviewLayer.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    
    
}

//********** GET CAMERA IN SPECIFIED POSITION IF IT EXISTS **********
- (AVCaptureDevice *) CameraWithPosition:(AVCaptureDevicePosition) Position
{
    NSArray *Devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *Device in Devices)
    {
        if ([Device position] == Position)
        {
            return Device;
        }
    }
    return nil;
}

//********** START STOP RECORDING BUTTON **********
- (IBAction)StartStopButtonPressed:(id)sender
{
    
    
    [self startStopRecording];
    
    
    
    
}

-(void)startStopRecording {
    self.btnFlip.enabled = NO;
    self.btnPrompt.enabled = NO;
    self.btnUpload.enabled = NO;
    [self.btnRecord setImage:[UIImage imageNamed:@"btnstop"] forState:UIControlStateNormal];
    
    pretimerCounter = 6;
    
    
    if (!WeAreRecording) {
        
        self.timerView.hidden = NO;
        
        WeAreRecording = YES;
        
        preTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showPretimer) userInfo:nil repeats:YES];
        
        
    } else {
        [self stopRecording];
        
        
    }
}

-(void) stopRecording {
    
    NSLog(@"STOP RECORDING");
    
    [preTimer invalidate];
    
    WeAreRecording = NO;
    
    [MovieFileOutput stopRecording];
    
    [t invalidate];
    [recordingTimer invalidate];
    
    
    self.timerView.hidden = YES;
    
    self.btnFlip.enabled = YES;
    self.btnPrompt.enabled = YES;
    self.btnUpload.enabled = YES;
    
    h=0;
    pretimerCounter=6;
    recordTime=0;
    self.timerLabel.text = @"5";
    
    
    videoURL = nil;
    
    [self.btnRecord setImage:[UIImage imageNamed:@"btnrecord"] forState:UIControlStateNormal];
    
}


- (void) onTimer {
    
    // Updates the variable h, adding 100 (put your own value here!)
    h += 2;
    
    //This makes the scrollView scroll to the desired position
    
    if (h < self.telePromptTextView.contentSize.height - 200) {
         self.telePromptTextView.contentOffset = CGPointMake(0, h);
    }
    //NSLog(@"Height: %f, h: %d",self.telePromptTextView.contentSize.height,h);
   
    
}

-(void) showPretimer {
    pretimerCounter--;
    
    self.timerLabel.text = [NSString stringWithFormat:@"%d",pretimerCounter];
    
    if (pretimerCounter == 0) {
        [preTimer invalidate];
        
        recordingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(increaseRecordingTime) userInfo:nil repeats:YES];
        
        self.timerView.hidden = YES;
        t = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        
        
        NSLog(@"START RECORDING");
        WeAreRecording = YES;
        
        //Create temporary URL to record to
        NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
        NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:outputPath])
        {
            NSError *error;
            if ([fileManager removeItemAtPath:outputPath error:&error] == NO)
            {
                //Error - handle if requried
            }
        }
        
        //Start recording
        [MovieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
        
        
    }
    
    
}

-(void) increaseRecordingTime {
    
    recordTime++;
    
    self.tMin.text = @"00";
    self.tSec.text = [NSString stringWithFormat:@"%d",recordTime];
    
    if (maxRecordTime <= recordTime) {
        
        
        [self stopRecording];
        
    }
    
    
    
}


#pragma AVfoundation delegates
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    
    /*NSLog(@"didFinishRecordingToOutputFileAtURL - enter");
    
    BOOL RecordedSuccessfully = YES;
    if ([error code] != noErr)
    {
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value)
        {
            RecordedSuccessfully = [value boolValue];
        }
    }
    if (RecordedSuccessfully)
    {
        //----- RECORDED SUCESSFULLY -----
        NSLog(@"didFinishRecordingToOutputFileAtURL - success");
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputFileURL])
        {
            [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
                                        completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 if (error)
                 {
                     
                 }
                 
                 
                 
                 
                 
                 videoURL = outputFileURL;
                 
                 UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Whoa!" message:@"Do you want to upload this Drum ?" delegate:self cancelButtonTitle:@"Discard" otherButtonTitles:@"Yes", nil];
                 al.tag = 1;
                 [al show];
                 
                 
             }];
        }
        
        
        
    }*/
    
    NSLog(@"didFinishRecordingToOutputFileAtURL - enter");
    
    BOOL RecordedSuccessfully = YES;
    if ([error code] != noErr)
    {
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value)
        {
            RecordedSuccessfully = [value boolValue];
        }
    }
    if (RecordedSuccessfully){
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:outputFileURL options:nil];
        AVAssetExportSession  *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
        
        NSURL *exportOutputURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(),@"temp.mp4"]];
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.outputURL = exportOutputURL;
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        /*
         
         var fileManager = NSFileManager.defaultManager()
         
         if fileManager.fileExistsAtPath(outputpath){
         var error:NSError? = nil;
         if (fileManager.removeItemAtPath(outputpath, error:&error) == false)
         {
         print("error saving temp file")
         }
         }
         
        */
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:[exportOutputURL path]]) {
            if (![fileManager removeItemAtURL:exportOutputURL error:nil]) {
                NSLog(@"Error deleting file");
            }
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            NSLog(@" exportSession.status = %ld exportSession.error = %@",  (long)exportSession.status, exportSession.error);
            
            if ( exportSession && (exportSession.status == AVAssetExportSessionStatusCompleted) )
            {
                NSLog(@" exportSession.outputURL = %@",  exportSession.outputURL);
                
                // we need to remove temporary files
                //[[NSFileManager defaultManager] removeItemAtURL:videoUrl error:NULL];
                
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:exportSession.outputURL])
                {
                    [library writeVideoAtPathToSavedPhotosAlbum:exportSession.outputURL
                                                completionBlock:^(NSURL *assetURL, NSError *error)
                     {
                         if (error)
                         {
                             
                         }
                         videoURL = exportSession.outputURL;
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                             UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Let's Go Bananas!" message:@"Do you want to upload this Drum ?" delegate:self cancelButtonTitle:@"Discard" otherButtonTitles:@"Yes", nil];
                             al.tag = 1;
                             [al show];
                         });
                         
                         
                         
                         
                         
                         
                         
                     }];
                }
                
                
                
                
            }
            else 
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //TODO - report error
                NSLog(@"export failed");
            }
            
            
        }];
        
    }
    
    
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    
    
}


- (void)dealloc
{
    
    
}

- (IBAction)actionUpload:(id)sender {
    
    if (videoURL == nil) {
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"It seems you have not recorded a Drum." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [al show];
        
    } else {
        [self performSegueWithIdentifier:@"segCategory" sender:self];
    }
    
    
}


#pragma UIAlertView delegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //discard the video and reset all the timers
    } else if (buttonIndex == 1){
        //go to categroy selector
        
        if (videoURL == nil) {
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"It seems you have not recorded a Drum." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [al show];
            
        } else {
            [self performSegueWithIdentifier:@"segCategory" sender:self];
        }
        
    }
    
    
}



- (IBAction)actionMenuFlip:(id)sender {
    self.menuContainer.layer.zPosition = 99999;
    self.btnMenuFlip.layer.zPosition = 99999;
    if (!isMenuShown) {
        
        self.btnFlipTopSpace.constant = -55;
        self.menuContainerVerticalSpace.constant = 0;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            isMenuShown = YES;
        }];
        
    } else {
        self.menuContainerVerticalSpace.constant = -78;
        self.btnFlipTopSpace.constant = 23;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            isMenuShown = NO;
        }];
    }
    
}
@end
