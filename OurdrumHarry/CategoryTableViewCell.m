//
//  CategoryTableViewCell.m
//  OurdrumHarry
//
//  Created by Ria and Dev on 06/09/15.
//  Copyright (c) 2015 Digicrazers. All rights reserved.
//

#import "CategoryTableViewCell.h"

@implementation CategoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    [self.categoryCheckBox setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    
    if (selected) {
        [self.categoryCheckBox setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    }
}

@end
