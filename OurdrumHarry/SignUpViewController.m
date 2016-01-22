//
//  SignUpViewController.m
//  OurdrumHarry
//
//  Created by Ria and Dev on 17/09/15.
//  Copyright (c) 2015 Digicrazers. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:NO];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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


- (IBAction)actionSignUp:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (![self.cpassword.text isEqual:self.password.text]) {
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Validation error occured" message:@"Confirm password does not match to password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [al show];
        
        return;
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"user_email": self.email.text,@"user_name": self.email.text, @"user_pass":self.password.text};
    [manager POST:[NSString stringWithFormat:@"%@%@", BASEURL, @"signup.html"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([[[responseObject valueForKeyPath:@"success"] stringValue] isEqualToString:@"1"]) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                //[self performSegueWithIdentifier:@"segLogin" sender:self];
                UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Success" message:@"You account is created. Please login to proceed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [al show];
                
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
@end
