//
//  SettingsViewController.m
//  OurdrumHarry
//
//  Created by Ria and Dev on 17/09/15.
//  Copyright (c) 2015 Digicrazers. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController {
    BOOL isTelePromptEnable;
}

-(void)viewWillAppear:(BOOL)animated {
    self.telePromptText.layer.borderWidth = 1.0f;
    self.telePromptText.layer.borderColor = [[UIColor orangeColor] CGColor];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"telePromptText"] length]) {
        
        self.telePromptText.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"telePromptText"];
    } else {
        self.telePromptText.text = @"";
    }
    
    
    
    isTelePromptEnable = [[[NSUserDefaults standardUserDefaults] valueForKey:@"isTelePromptEnable"] boolValue];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    if (isTelePromptEnable) {
        self.telePromptSwitch.on = YES;
    } else {
        self.telePromptSwitch.on = false;
    }
    
    if ([self.telePromptText.text isEqualToString:@""]) {
        self.telePromptText.text = @"Please enter your drum script...";
        self.telePromptText.textColor = [UIColor lightGrayColor]; //optional
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap:)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self.telePromptText resignFirstResponder];
    
    [[NSUserDefaults standardUserDefaults] setValue:self.telePromptText.text forKey:@"telePromptText"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionEnableTelePromptChanged:(UISwitch*)sender {
    
    if (sender.on) {
        
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isTelePromptEnable"];
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:NO forKey:@"isTelePromptEnable"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)didTap:(UITapGestureRecognizer *)sender {
    
    [self.telePromptText resignFirstResponder];
    
    [[NSUserDefaults standardUserDefaults] setValue:self.telePromptText.text forKey:@"telePromptText"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Please enter your drum script..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Please enter your drum script...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    
    [self.scrollView setContentSize:CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height + 50)];
    
    
    
    
}
@end
