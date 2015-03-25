//
//  CoinTableViewCell.m
//  Silverhound
//
//  Created by ejd on 3/12/15.
//  Copyright (c) 2015 devinney. All rights reserved.
//

#import "CoinTableViewCell.h"

@implementation CoinTableViewCell;

@synthesize denominationLabel;
@synthesize descriptionLabel;
@synthesize synonymLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.descriptionLabel.text = [self.coin.startYear stringValue];
    self.denominationLabel.text = self.coin.denomination;
    self.synonymLabel.text = self.coin.synonyms;
}

@end
