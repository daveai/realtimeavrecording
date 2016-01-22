//
//  SettingsViewController.h
//  OurdrumHarry
//
//  Created by Ria and Dev on 17/09/15.
//  Copyright (c) 2015 Digicrazers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *telePromptText;

@property (weak, nonatomic) IBOutlet UISwitch *telePromptSwitch;
- (IBAction)actionEnableTelePromptChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@end
