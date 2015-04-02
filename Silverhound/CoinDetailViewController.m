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

@synthesize descriptionLabel, diameterLabel, notesLabel;

@synthesize coin;
@synthesize startTouchPosition;
@synthesize distortion, scale;
@synthesize frontView, backView;
@synthesize frontImage, backImage;


- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.coin.synonyms.length>0)
        self.descriptionLabel.text = [NSString stringWithFormat:@"%@, %@",
                                  self.coin.denomination,
                                  self.coin.synonyms];
    else
        self.descriptionLabel.text = self.coin.denomination;

    self.diameterLabel.text = [NSString stringWithFormat:@"%.2f mm %.2fg fine silver",
                               [self.coin.diameter_mm floatValue],
                               [self.coin.fineweightAg_g floatValue]];

    self.notesLabel.text = self.coin.notes;
    
    NSData *coinImage = self.coin.obverseImage;
    NSUInteger dataBytes = coinImage.length;
    if (dataBytes>0) {
        NSString *imageFile = [[NSString alloc] initWithBytes:[coinImage bytes] length: dataBytes encoding:NSASCIIStringEncoding];
        self.frontImage.image = [UIImage imageNamed:imageFile];
    }
    coinImage = self.coin.reverseImage;
    dataBytes = coinImage.length;
    if (dataBytes>0) {
        NSString *imageFile = [[NSString alloc] initWithBytes:[coinImage bytes] length: dataBytes encoding:NSASCIIStringEncoding];
        self.backImage.image = [UIImage imageNamed:imageFile];
    }

    
    // Do any additional setup after loading the view.
    /*
     * spin/flip
     */

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

#pragma mark -
#pragma mark Gesture operations
#define HORIZ_SWIPE_DRAG_MIN  12
#define VERT_SWIPE_DRAG_MAX    4

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    startTouchPosition = [touch locationInView:self.view];
    [self flip];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.view];
    
    // If the swipe tracks correctly.
    if (fabsf(startTouchPosition.x - currentTouchPosition.x) >= HORIZ_SWIPE_DRAG_MIN &&
        fabsf(startTouchPosition.y - currentTouchPosition.y) <= VERT_SWIPE_DRAG_MAX)
    {
        // It appears to be a swipe.
        if (startTouchPosition.x < currentTouchPosition.x)
            ;//           [self myProcessRightSwipe:touches withEvent:event];
        else
            ;//            [self myProcessLeftSwipe:touches withEvent:event];
    }
    else
    {
        // Process a non-swipe event.
    }
}

#pragma mark -
#pragma mark Spin/Flip
// This was all taken directly from Michael Lee's MFFlipView and then beaten mercilessly into submission

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag;
{
    // This delegate method allows us to clean up our state
    if (![animation isKindOfClass:[CAAnimationGroup class]])
        return;
    
    // Our animation is one-way and has been expended, so we can remove them
    [frontView.layer removeAnimationForKey:@"flipGroup"];
    [backView.layer removeAnimationForKey:@"flipGroup"];
    
    // Although the "back" layer seemed to rotate forward, in reality it's still flipped.
    [CATransaction begin];
    // Since this is already our assumed state, do not animate this
    [CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
    // Remove all transforms by setting the identity (standard) transform
    frontView.layer.transform = CATransform3DIdentity;
    backView.layer.transform = CATransform3DIdentity;
    [CATransaction commit];
    
}


#pragma mark Actions

- (void) flip {
    
#define ANIMATION_DURATION_IN_SECONDS (1.0)
    // Hold the shift key to flip the window in slo-mo. It's really cool!
    CGFloat flipDuration = ANIMATION_DURATION_IN_SECONDS;
    
    // The hidden layer is "in the back" and will be rotating forward. The visible layer is "in the front" and will be rotating backward
    CALayer *hiddenLayer = [frontView.isHidden ? frontView : backView layer];
    CALayer *visibleLayer = [frontView.isHidden ? backView : frontView layer];
    
    // Before we can "rotate" the window, we need to make the hidden view look like it's facing backward by rotating it pi radians (180 degrees). We make this its own transaction and supress animation, because this is already the assumed state
    [CATransaction begin]; {
        [CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
        [hiddenLayer setValue:[NSNumber numberWithDouble:M_PI] forKeyPath:@"transform.rotation.y"];
        
    } [CATransaction commit];
    
    // There's no way to know when we are halfway through the animation, so we have to use a timer. On a sufficiently fast machine (like a Mac) this is close enough. On something like an iPhone, this can cause minor drawing glitches
    [self performSelector:@selector(swapViews) withObject:nil afterDelay:flipDuration / 2.0];
    
    // Both layers animate the same way, but in opposite directions (front to back versus back to front)
    [CATransaction begin]; {
        [hiddenLayer addAnimation:[self flipAnimationWithDuration:flipDuration isFront:NO] forKey:@"flipGroup"];
        [visibleLayer addAnimation:[self flipAnimationWithDuration:flipDuration isFront:YES] forKey:@"flipGroup"];
    } [CATransaction commit];
    
}

#pragma mark Private

- (void ) swapViews;
{
    // At the point the window flips, change which view is visible, thus bringing it "to the front"
    [frontView setHidden:![frontView isHidden]];
    [backView setHidden:![backView isHidden]];
}



- (CAAnimationGroup *) flipAnimationWithDuration:(CGFloat)duration isFront:(BOOL)isFront;
{
    // Rotating halfway (pi radians) around the Y axis gives the appearance of flipping
    CABasicAnimation *flipAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    
    // The hidden view rotates from negative to make it look like it's in the back
#define LEFT_TO_RIGHT (isFront ? -M_PI : M_PI)
#define RIGHT_TO_LEFT (isFront ? M_PI : -M_PI)
    flipAnimation.toValue = [NSNumber numberWithDouble:[backView isHidden] ? LEFT_TO_RIGHT : RIGHT_TO_LEFT];
    
    // Shrinking the view makes it seem to move away from us, for a more natural effect
    CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    shrinkAnimation.toValue = [NSNumber numberWithDouble:self.scale];
    
    // We only have to animate the shrink in one direction, then use autoreverse to "grow"
    shrinkAnimation.duration = duration / 2.0;
    shrinkAnimation.autoreverses = YES;
    
    // Combine the flipping and shrinking into one smooth animation
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:flipAnimation, shrinkAnimation, nil];
    
    // As the edge gets closer to us, it appears to move faster. Simulate this in 2D with an easing function
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // Set ourselves as the delegate so we can clean up when the animation is finished
    animationGroup.delegate = self;
    animationGroup.duration = duration;
    
    // Hold the view in the state reached by the animation until we can fix it, or else we get an annoying flicker
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    
    return animationGroup;
}


@end
