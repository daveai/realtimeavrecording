//
//  LoginViewController.h
//  OurdrumHarry
//
//  Created by Subhr Roy on 02/09/15.
//  Copyright (c) 2015 Digicrazers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFHTTPRequestOperationManager.h>
#import "MBProgressHUD.h"
#import "Constants.h"
@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *contentView;


@end
