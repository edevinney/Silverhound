//
//  CoinDetailViewController.m
//  Silverhound
//
//  Created by ejd on 3/25/15.
//  Copyright (c) 2015 devinney. All rights reserved.
//

#import "CoinDetailViewController.h"

@interface CoinDetailViewController ()

@end

@implementation CoinDetailViewController

@synthesize coin;
@synthesize startTouchPosition;
@synthesize distortion, scale;
@synthesize frontView, backView;
@synthesize frontImage, backImage;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
     * spin/flip
     */
/*
    CGRect frame = CGRectMake(frontView.frame.origin.x, frontView.frame.origin.y, CGRectGetWidth(frontView.frame), CGRectGetHeight(frontView.frame));
    [frontView setHidden:FALSE];
    //	[frontView setFrameOrigin:CGPointMake(0, 0)];
    frontView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    frontView.layer.frame = frame;
    //   frontView.layer.backgroundColor = [UIColor blueColor];
    
    [backView setHidden:TRUE];
    
    //    [backView setFrameOrigin:CGPointMake(0, 0)];
    backView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    backView.layer.frame = frame;
    //    backView.layer.backgroundColor = [UIColor blueColor];
    
    [self willChangeValueForKey:@"distortion"];
    CATransform3D perspectiveTransform = CATransform3DIdentity;
    perspectiveTransform.m34 = 1.0 / 555;
    scale = 0.85;
    
    self.view.layer.sublayerTransform = perspectiveTransform;
    [self didChangeValueForKey:@"distortion"];
*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
