//
//  TutorialViewController.m
//  OurdrumHarry
//
//  Created by Ria and Dev on 01/10/15.
//  Copyright © 2015 Digicrazers. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController {
    MPMoviePlayerController * moviePlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)actionNoThanks:(id)sender {
    
    [self performSegueWithIdentifier:@"segCamView" sender:self];
}




-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    
    [self.scrollView setContentSize:CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height + 50)];
    
    
    
    
}
- (IBAction)play:(id)sender {
    NSString *filepath   =   [[NSBundle mainBundle] pathForResource:@"tut.mov" ofType:nil];
    NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
    [self.view addSubview:moviePlayer.view];
    moviePlayer.fullscreen = YES;
    [moviePlayer play];
    
}

- (IBAction)actionGotIt:(id)sender {
    
    [self performSegueWithIdentifier:@"segCamView" sender:self];
}
@end
