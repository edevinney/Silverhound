//
//  CoinTableViewCell.h
//  Silverhound
//
//  Created by ejd on 3/12/15.
//  Copyright (c) 2015 devinney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coin.h"

@interface CoinTableViewCell : UITableViewCell {
    UILabel *denominationLabel;
}
@property (nonatomic, strong) Coin *coin;
@property (nonatomic, retain) IBOutlet UILabel *denominationLabel;
@property (nonatomic, retain) IBOutlet UILabel *yearLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *scrapValueLabel;

@end
