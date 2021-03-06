/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Subclass of UINavigationBar that displays a button above the
  navigation bar's contents.
 */

#import "AppDelegate.h"
#import "CustomNavigationBar.h"

@implementation CustomNavigationBar

//| ----------------------------------------------------------------------------
//  A navigation bar subclass should override -sizeThatFits: to pad the fitting
//  height for the navigation bar, creating space for the extra elements that
//  will be added.  UINavigationController calls this method to retrieve the
//  size of the navigation bar, which it then uses when computing the bar's
//  frame.
//
- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize navigationBarSize = [super sizeThatFits:size];
    
    // Pad the base navigation bar height by the fitting height of our button.
    CGSize buttonSize = [self.customButton sizeThatFits:CGSizeMake(size.width, 0)];
    navigationBarSize.height += buttonSize.height;
    
    return navigationBarSize;
}


//| ----------------------------------------------------------------------------
- (void) updateQuoteTitle {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSNumberFormatter *oneShotNumberFormatter = [[NSNumberFormatter alloc] init];
    [oneShotNumberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    oneShotNumberFormatter.currencyCode = @"USD";
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [oneShotNumberFormatter setGroupingSeparator:groupingSeparator];
    [oneShotNumberFormatter setGroupingSize:3];
    [oneShotNumberFormatter setAlwaysShowsDecimalSeparator:NO];
    [oneShotNumberFormatter setUsesGroupingSeparator:YES];
    NSString *quoteString = [oneShotNumberFormatter stringFromNumber:[NSNumber numberWithFloat:appDelegate.lastSilverQuote]];

    
    self.topItem.title = [NSString stringWithFormat:@"Spot Silver: %@/oz t", quoteString];
    
    NSDateFormatter *oneShotDateFormatter = [[NSDateFormatter alloc]init];
    [oneShotDateFormatter setDateFormat:@"dd MMM yyyy"];
    
    self.topItem.prompt = [NSString stringWithFormat:@"Last Packetizer quote: %@",[oneShotDateFormatter stringFromDate: appDelegate.lastSilverQuoteDate]];
    
    appDelegate.customNavBar = self;
}

- (void)layoutSubviews
{
    // UINavigationBar positions its elements along the bottom edge of the
    // bar's bounds.  This allows our subclass to position our custom elements
    // at the top of the navigation bar, in the extra space we created by
    // padding the height returned from -sizeThatFits:
    [super layoutSubviews];
    
    [self updateQuoteTitle];

    
    // NOTE: You do not need to account for the status bar height in your
    //       layout.  The navigation bar is positioned just below the
    //       status bar by the navigation controller.
    
    // Retrieve the button's fitting height and position the button along the
    // top edge of the navigation bar.  The button is sized to the full
    // width of the navigation bar as it will automatically center its contents.
    CGSize buttonSize = [self.customButton sizeThatFits:CGSizeMake(self.bounds.size.width, 0)];
    self.customButton.frame = CGRectMake(0, 0, self.bounds.size.width, buttonSize.height);
}

-(void)pushNavigationItem:(UINavigationItem *)item animated:(BOOL)animated {
    
}

-(UINavigationItem *) popNavigationItemAnimated:(BOOL)animated {
    return self.topItem;
}


//| ----------------------------------------------------------------------------
//  Custom implementation of the setter for the customButton property.
//
- (void)setCustomButton:(UIButton *)customButton
{
    // Remove the previous button
    [_customButton removeFromSuperview];
    
    _customButton = customButton;
    
    [self addSubview:customButton];
    
    // Force our -sizeThatFits: method to be called again and flag the
    // navigation bar as needing layout.
    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout];
}

@end
