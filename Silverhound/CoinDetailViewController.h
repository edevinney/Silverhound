//
//  CoinDetailViewController.h
//  Silverhound
//
//  Created by ejd on 3/25/15.
//  Copyright (c) 2015 devinney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coin.h"

@interface CoinDetailViewController : UIViewController <UIPopoverControllerDelegate> {
    Coin *coin;
    IBOutlet UILabel *descriptionLabel;
    IBOutlet UILabel *diameterLabel;
    IBOutlet UILabel *notesLabel;
    
    CGPoint startTouchPosition;
    IBOutlet UIView *frontView, *backView;
    IBOutlet UIImageView *frontImage, *backImage;
    CGFloat scale;
    NSInteger distortion;
}

@property (nonatomic, retain) IBOutlet UIView *frontView;
@property (nonatomic, retain) IBOutlet UIView *backView;
@property (nonatomic, retain) IBOutlet UIImageView *frontImage;
@property (nonatomic, retain) IBOutlet UIImageView *backImage;

@property (nonatomic, retain) IBOutlet Coin *coin;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *diameterLabel;
@property (nonatomic, retain) IBOutlet UILabel *notesLabel;

@property (nonatomic) CGPoint startTouchPosition;

@property (nonatomic) CGFloat scale;
@property (nonatomic) NSInteger distortion;

@end
