//
//  CoinTableViewCell.m
//  Silverhound
//
//  Created by ejd on 3/12/15.
//  Copyright (c) 2015 devinney. All rights reserved.
//

#import "CoinTableViewCell.h"
#import "CoinDetailViewController.h"
#import "AppDelegate.h"

@implementation CoinTableViewCell;

@synthesize denominationLabel;
@synthesize descriptionLabel;
@synthesize yearLabel;
@synthesize scrapValueLabel;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"showCoinDetail1"]){
        CoinDetailViewController *cdvc = (CoinDetailViewController *)[segue destinationViewController];
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the cell for each coin. These compound strings need i18n help.
    self.denominationLabel.text = self.coin.denomination;
    self.yearLabel.text = [NSString stringWithFormat:@"%@ - %@",[self.coin.startYear stringValue], [self.coin.endYear stringValue]];

    self.descriptionLabel.text = [NSString stringWithFormat:@"%.3fg total, %.3f fine",
                                  [self.coin.mass_g floatValue],
                                  [self.coin.percentAg floatValue]
                           ];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    float scrapValue = [self.coin.fineweightAg_g floatValue] * (appDelegate.lastSilverQuote /31.1034768);
    
    NSNumberFormatter *oneShotNumberFormatter = [[NSNumberFormatter alloc] init];
    [oneShotNumberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    oneShotNumberFormatter.currencyCode = @"USD";
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [oneShotNumberFormatter setGroupingSeparator:groupingSeparator];
    [oneShotNumberFormatter setGroupingSize:3];
    [oneShotNumberFormatter setAlwaysShowsDecimalSeparator:NO];
    [oneShotNumberFormatter setUsesGroupingSeparator:YES];
    NSString *scrapValueString = [oneShotNumberFormatter stringFromNumber:[NSNumber numberWithFloat:scrapValue]];

    self.accessoryType = UITableViewCellAccessoryNone;

    self.scrapValueLabel.text = scrapValueString;

    NSData *obverseImage = self.coin.obverseImage;
    NSUInteger dataBytes = obverseImage.length;
    if (dataBytes>0) {
        self.accessoryType = UITableViewCellAccessoryDetailButton;
    }
}

@end
