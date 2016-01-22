//
//  WebViewController.m
//  OurdrumHarry
//
//  Created by Ria and Dev on 18/11/15.
//  Copyright © 2015 Digicrazers. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *fullURL = @"http://ourdrum.com";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    self.navigationController.delegate = self;
    
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *backBtn =[[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(popAlertAction:)];
    self.navigationItem.leftBarButtonItem=backBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popAlertAction:(UIBarButtonItem*)sender
{
    [self performSegueWithIdentifier:@"backToCam" sender:self];
}

@end
