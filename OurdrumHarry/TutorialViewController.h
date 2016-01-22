//
//  TutorialViewController.h
//  OurdrumHarry
//
//  Created by Ria and Dev on 01/10/15.
//  Copyright © 2015 Digicrazers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface TutorialViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *video_image;

- (IBAction)actionNoThanks:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)play:(id)sender;

- (IBAction)actionGotIt:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;

@end
