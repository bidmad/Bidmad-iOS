//
//  SegueInterimAdVIew.m
//  BidmadSDKTest
//
//  Created by ADOP_Mac on 2021/07/05.
//  Copyright © 2021 전혜연. All rights reserved.
//

#import "SegueInterimAdVIew.h"
#import <QuartzCore/QuartzCore.h>

@implementation SegueInterimAdVIew {
    NSNumber *autoAdCall;
    UILabel *defaultLabel;
    UILabel *secondsDisplay;
    UIButton *skipButton;
    UIView *realFrame;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isAdReadyForDisplay = NO;
        autoAdCall = [[NSNumber alloc] initWithInt:0];
        [self uiSetting];
        
        [self performSelector:@selector(reflectEachSecond) withObject:nil afterDelay:1];
    }
    return self;
}

- (void)uiSetting {
    self.frame = CGRectMake(0, 0, 310, 160);
    [self setClipsToBounds: NO];
//    self.backgroundColor = UIColor.redColor;
    
    realFrame = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 300, 150)];
    [realFrame setTranslatesAutoresizingMaskIntoConstraints:NO];
    [realFrame setBackgroundColor: UIColor.whiteColor];
    [realFrame setClipsToBounds: NO];
    [self addSubview: realFrame];
    
    defaultLabel = [[UILabel alloc] init];
    [defaultLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [defaultLabel setText: @"Video Ad Starting In..."];
    [defaultLabel setMinimumScaleFactor:20];
    [defaultLabel setAdjustsFontSizeToFitWidth:YES];
    [defaultLabel.layer setCornerRadius:10];
    [self addSubview: defaultLabel];
    
    secondsDisplay = [[UILabel alloc] init];
    [secondsDisplay setTranslatesAutoresizingMaskIntoConstraints:NO];
    [secondsDisplay setFont: [UIFont systemFontOfSize:50]];
    [secondsDisplay setText: autoAdCall.stringValue];
    [secondsDisplay setTextAlignment:NSTextAlignmentCenter];
    [self addSubview: secondsDisplay];
    
    skipButton = [[UIButton alloc] init];
    [skipButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [skipButton setTitle:@"SKIP AD" forState:UIControlStateNormal];
    [skipButton addTarget:self action:@selector(skipAdClicked) forControlEvents:UIControlEventTouchUpInside];
    [skipButton setBackgroundColor:UIColor.systemBlueColor];
    [skipButton.layer setCornerRadius:10];
    [skipButton.layer setMaskedCorners:kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner];
    [self addSubview: skipButton];
    
    [NSLayoutConstraint activateConstraints:
     @[
         [realFrame.centerXAnchor constraintEqualToAnchor: self.centerXAnchor],
         [realFrame.centerYAnchor constraintEqualToAnchor: self.centerYAnchor],
         [realFrame.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.8],
         [realFrame.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.8],
         [defaultLabel.centerXAnchor constraintEqualToAnchor: realFrame.centerXAnchor],
         [defaultLabel.topAnchor constraintEqualToAnchor: realFrame.topAnchor],
         [defaultLabel.bottomAnchor constraintEqualToAnchor: secondsDisplay.topAnchor],
         [secondsDisplay.centerXAnchor constraintEqualToAnchor: realFrame.centerXAnchor],
         [secondsDisplay.topAnchor constraintEqualToAnchor: defaultLabel.bottomAnchor],
         [secondsDisplay.bottomAnchor constraintEqualToAnchor: skipButton.topAnchor],
         [skipButton.centerXAnchor constraintEqualToAnchor: realFrame.centerXAnchor],
         [skipButton.widthAnchor constraintEqualToAnchor:realFrame.widthAnchor],
         [skipButton.topAnchor constraintEqualToAnchor:secondsDisplay.bottomAnchor],
         [skipButton.bottomAnchor constraintEqualToAnchor: realFrame.bottomAnchor]
     ]];
    
    [realFrame.layer setCornerRadius: 10];
    [realFrame.layer setShadowColor:UIColor.grayColor.CGColor];
    [realFrame.layer setShadowOffset:CGSizeMake(0, 2)];
    [realFrame.layer setShadowOpacity:0.3];
    [realFrame.layer setShadowRadius:3];
}

- (void)skipAdClicked {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if (self.adAvailableDelegate != nil) {
        [self.adAvailableDelegate adShowCancelled];
    }
    
    [self removeFromSuperview];
}

- (void)reflectEachSecond {
    autoAdCall = [[NSNumber alloc] initWithInt:[autoAdCall intValue] + 1];
    [self setNeedsDisplay];
    if (autoAdCall != [[NSNumber alloc] initWithInt:5]) {
        [self performSelector:@selector(reflectEachSecond) withObject:nil afterDelay:1];
    } else {
        self.isAdReadyForDisplay = YES;
        if (self.adAvailableDelegate != nil) {
            [self.adAvailableDelegate adAvailable];
        }
        [self removeFromSuperview];
    }
}

- (void)drawRect:(CGRect)rect {
    [defaultLabel setText: @"Video Ad Starting In..."];
    [secondsDisplay setText: [[NSString alloc] initWithFormat:@"%d", 5-[autoAdCall intValue]]];
    [skipButton setTitle:@"SKIP AD" forState:UIControlStateNormal];
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self removeFromSuperview];
}

@end
