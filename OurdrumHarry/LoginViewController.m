//
//  LoginViewController.m
//  OurdrumHarry
//
//  Created by Subhr Roy on 02/09/15.
//  Copyright (c) 2015 Digicrazers. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController {
    BOOL keyboardIsShown;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.email.delegate = self;
    self.password.delegate = self;
    
    self.contentView.frame = self.view.bounds;
   
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)login:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"email": self.email.text, @"password":self.password.text};
    [manager POST:[NSString stringWithFormat:@"%@%@", BASEURL, @"user_login.html"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([[[responseObject valueForKeyPath:@"success"] stringValue] isEqualToString:@"1"]) {
            
            
            
            NSLog(@"%@",[[responseObject valueForKeyPath:@"user_id"] stringValue]);
            NSLog(@"%@",[[responseObject valueForKeyPath:@"max_video_time"] stringValue]);
            
            
            [[NSUserDefaults standardUserDefaults] setValue:[[responseObject valueForKeyPath:@"user_id"] stringValue] forKey:@"user_id"];
            
            [[NSUserDefaults standardUserDefaults] setValue:[[responseObject valueForKeyPath:@"max_video_time"] stringValue] forKey:@"max_video_time"];
            
            //[[NSUserDefaults standardUserDefaults] setValue:@"15" forKey:@"max_video_time"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [self performSegueWithIdentifier:@"segLogin" sender:self];
                
            });
            
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // time-consuming task
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[responseObject valueForKey:@"msg"]
                                                                    message:[responseObject valueForKey:@"details"]
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                });
            });
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // time-consuming task
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                                message:@"Some internal server error occured. We will be right back shortly!"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            });
        });
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y - 100);
    [self.scrollView setContentOffset:scrollPoint animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    return YES;
}

@end
