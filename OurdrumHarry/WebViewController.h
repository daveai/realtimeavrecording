//
//  WebViewController.h
//  OurdrumHarry
//
//  Created by Ria and Dev on 18/11/15.
//  Copyright © 2015 Digicrazers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UINavigationControllerDelegate, UINavigationBarDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
