//
//  CountryHeaderViewCellTableViewCell.m
//  Silverhound
//
//  Created by ejd on 3/25/15.
//  Copyright (c) 2015 devinney. All rights reserved.
//

#import "CountryHeaderViewCell.h"

@implementation CountryHeaderViewCell

@synthesize coin;
@synthesize countryLabel;
@synthesize flagImageView;
@synthesize cellContentView;

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
