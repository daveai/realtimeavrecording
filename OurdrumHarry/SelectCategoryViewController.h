//
//  SelectCategoryViewController.h
//  OurdrumHarry
//
//  Created by Ria and Dev on 06/09/15.
//  Copyright (c) 2015 Digicrazers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryTableViewCell.h"
#import "Constants.h"
#import <AFHTTPRequestOperationManager.h>
#import "VideoDetailsEntryViewController.h"
#import "MBProgressHUD.h"
@interface SelectCategoryViewController : UIViewController <UITableViewDataSource, UITableViewDataSource,UISearchBarDelegate, UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableCategory;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;


@property (weak, nonatomic) IBOutlet UISearchBar *searchBox;

@property (weak, nonatomic) NSURL *videoURL;

- (IBAction)actionSubmit:(id)sender;


@end
