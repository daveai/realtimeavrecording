//
//  SignUpViewController.h
//  OurdrumHarry
//
//  Created by Ria and Dev on 17/09/15.
//  Copyright (c) 2015 Digicrazers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFHTTPRequestOperationManager.h>
#import "MBProgressHUD.h"
#import "Constants.h"
@interface SignUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *email;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UITextField *cpassword;


@end
