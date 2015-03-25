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
    UILabel *startYearLabel;
    UILabel *endYearLabel;
    UILabel *silverGramsLabel;
    UILabel *scrapValueLabel;
    UILabel *synonymLabel;
}
@property (nonatomic, strong) Coin *coin;
@property (nonatomic, retain) IBOutlet UILabel *denominationLabel;
@property (nonatomic, retain) IBOutlet UILabel *startYearLabel;
@property (nonatomic, retain) IBOutlet UILabel *endYearLabel;
@property (nonatomic, retain) IBOutlet UILabel *silverGramsLabel;
@property (nonatomic, retain) IBOutlet UILabel *scrapValueLabel;
@property (nonatomic, retain) IBOutlet UILabel *synonymLabel;

@end
