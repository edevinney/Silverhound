//
//  CoinTableViewCell.m
//  Silverhound
//
//  Created by ejd on 3/12/15.
//  Copyright (c) 2015 devinney. All rights reserved.
//

#import "CoinTableViewCell.h"
#import "AppDelegate.h"

@implementation CoinTableViewCell;

@synthesize denominationLabel;
@synthesize startYearLabel;
@synthesize endYearLabel;
@synthesize silverGramsLabel;
@synthesize scrapValueLabel;
@synthesize synonymLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.startYearLabel.text = [self.coin.startYear stringValue];
    self.endYearLabel.text = [self.coin.endYear stringValue];
    self.denominationLabel.text = self.coin.denomination;
    self.synonymLabel.text = self.coin.synonyms;
    self.silverGramsLabel.text = [NSString stringWithFormat:@"%.3f", [self.coin.fineweightAg_g floatValue]];
    
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

    self.scrapValueLabel.text = scrapValueString;
}

@end
