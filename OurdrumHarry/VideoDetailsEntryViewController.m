#import "VideoDetailsEntryViewController.h"

@interface VideoDetailsEntryViewController ()

@end

@implementation VideoDetailsEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.drumDescription.layer.borderWidth = 1.0f;
    self.drumDescription.layer.borderColor = [[UIColor orangeColor] CGColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)actionSubmit:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableData *videoData = [NSMutableData dataWithContentsOfURL:self.videoURL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    
    NSDictionary *parameters = @{@"video_name": self.drumDetails.text, @"video_desc": self.drumDescription.text,@"video_thumb": @"",@"category":self.listOfCatIDs,@"lat":@"0",@"lng":@"0",@"user_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]};
    
    [manager POST:[NSString stringWithFormat:@"%@%@", BASEURL, @"submit_video.html"] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:videoData name:@"video" fileName:@"video_joe_4.mp4" mimeType:@"video/quicktime"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"Success: %@", responseObject);
            
            if ([[responseObject valueForKey:@"success"] isEqualToString:@"1"]) {
                UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Congratulations!" message:@"\"Drum was\" uploaded successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Visit Web Site", nil];
                
                al.delegate = self;
                
                [al show];
                
                
            } else {
                UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Opps!" message:@"Some internal server error occured. Plase try later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [al show];
            }
            
            
            
            
            
        });
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"Error: %@", error);
            
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Opps!" message:@"Some internal server error occured. Plase try later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [al show];
            
            
        });
        
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.scrollView.contentOffset = CGPointMake(0, textField.frame.origin.y + 20);
}



-(void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Write some words for your drum..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
    self.scrollView.contentOffset = CGPointMake(0, textView.frame.origin.y + 10);
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Write some words for your drum...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.scrollView setContentSize:CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height + 50)];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self performSegueWithIdentifier:@"webview" sender:nil];
    } else if (buttonIndex == 0){
        [self performSegueWithIdentifier:@"segCameraView" sender:self];
    }
}

@end
