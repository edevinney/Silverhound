//
//  CountryHeaderViewCellTableViewCell.h
//  Silverhound
//
//  Created by ejd on 3/25/15.
//  Copyright (c) 2015 devinney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coin.h"

@interface CountryHeaderViewCell : UITableViewCell {
    UILabel *countryLabel;
    UIImageView *flagImageView;
    UIView *cellContentView;
}
@property (nonatomic, strong) Coin *coin;
@property (nonatomic, retain) IBOutlet UILabel *countryLabel;
@property (nonatomic, retain) IBOutlet UIImageView *flagImageView;
@property (nonatomic, retain) IBOutlet UIView *cellContentView;

@end
