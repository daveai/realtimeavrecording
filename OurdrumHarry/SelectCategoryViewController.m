//
//  SelectCategoryViewController.m
//  OurdrumHarry
//
//  Created by Ria and Dev on 06/09/15.
//  Copyright (c) 2015 Digicrazers. All rights reserved.
//

#import "SelectCategoryViewController.h"

@interface SelectCategoryViewController ()

@end

@implementation SelectCategoryViewController{
    
    NSMutableArray *categories;
    NSMutableArray *filteredArray;
    BOOL isSearching;
    NSString *listOfCatIDs;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    listOfCatIDs = @"";
    
    self.tableCategory.allowsMultipleSelection = YES;
    
    isSearching = NO;
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    
    
    categories = [[NSMutableArray alloc]init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:[NSString stringWithFormat:@"%@%@", BASEURL, @"get_video_category.html"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        categories = [responseObject valueForKey:@"categories"];
        
        filteredArray = [NSMutableArray arrayWithCapacity:[categories count]];
        
        [self.tableCategory reloadData];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        NSLog(@"Error: %@", error);
        
        
    }];
    
    
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        //count number of row from counting array hear cataGorry is An Array
    
    if (isSearching) {
        return filteredArray.count;
    }
    return categories.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"category";
    
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    cell.categoryCheckBox.tag = indexPath.row;
    
    [cell.categoryCheckBox addTarget:self action:@selector(didTapOnCheckBox:) forControlEvents:UIControlEventTouchUpInside];
    
    if (cell == nil)
    {
        cell = [[CategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier];
    }
    
    // Here we use the provided setImageWithURL: method to load the web image
    // Ensure you use a placeholder image otherwise cells will be initialized with no image
    
    if (isSearching) {
        cell.categoryName.text = [[filteredArray objectAtIndex:indexPath.row] valueForKey:@"cat_name"];
        //cell.categoryCheckBox.tag = [[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"cat_id"] integerValue];
    } else {
        cell.categoryName.text = [[categories objectAtIndex:indexPath.row] valueForKey:@"cat_name"];
        //cell.categoryCheckBox.tag = [[[categories objectAtIndex:indexPath.row] valueForKey:@"cat_id"] integerValue];
    }
    
    
    
    
    return cell;
}

-(void)didTapOnCheckBox:(UIButton *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    [self.tableCategory selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.tableCategory didSelectRowAtIndexPath:indexPath];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    
    [self.searchBox resignFirstResponder];
    
    
    
}





- (IBAction)actionSubmit:(id)sender {
    
    NSArray *indexPathArray = [self.tableCategory indexPathsForSelectedRows];
    
    
    
    for(NSIndexPath *index in indexPathArray)
    {
        
        NSString *catIDs = [[[categories objectAtIndex:index.row] valueForKey:@"cat_id"] stringValue];
        if([indexPathArray lastObject]!=index)
        {
            listOfCatIDs = [listOfCatIDs stringByAppendingString:[catIDs stringByAppendingString:@", "]];
        }
        else
        {
            listOfCatIDs = [listOfCatIDs stringByAppendingString:catIDs];
            
        }
    }
    
    NSLog(@"Your comma separated string is %@",listOfCatIDs);
    
    
    
    if (listOfCatIDs.length) {
        
        /**/
        
        [self performSegueWithIdentifier:@"segVideoDetails" sender:self];
        
    } else {
        
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Please select atleast one categories" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [al show];
    }
}



#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [filteredArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.cat_name BEGINSWITH[c] %@",searchText];
    filteredArray = [NSMutableArray arrayWithArray:[categories filteredArrayUsingPredicate:predicate]];
}


#pragma mark - UISearchDisplayController Delegate Methods
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
    [self filterContentForSearchText:text scope:@""];
    if (text.length) {
        isSearching = YES;
        [self.tableCategory reloadData];
    } else {
        isSearching = NO;
        [self.tableCategory reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    // Do the search...
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"segVideoDetails"]) {
        VideoDetailsEntryViewController *dest = [segue destinationViewController];
        
        dest.listOfCatIDs = listOfCatIDs;
        
        dest.videoURL = self.videoURL;
    }
}
@end


