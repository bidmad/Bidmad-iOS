//
//  FullscreenAdViewController.m
//  BidmadSDKTest
//
//  Created by Seungsub Oh on 7/24/25.
//  Copyright © 2025 전혜연. All rights reserved.
//

#import "FullscreenAdViewController.h"

@implementation FullscreenAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.ad = [[BidmadFullscreenAd alloc]
        initWithZoneID:@"dcd42036-e54c-4b63-bdce-295bbfdc2ed6"];

    [self.ad setDelegate:self];

    [self.loadAd addTarget:self
                    action:@selector(invokeLoadAd)
          forControlEvents:UIControlEventTouchUpInside];

    [self.showAd addTarget:self
                    action:@selector(invokeShowAd)
          forControlEvents:UIControlEventTouchUpInside];

    [self.autoReloadToggle addTarget:self
                              action:@selector(invokeToggleAutoReloadForButton:)
                    forControlEvents:UIControlEventTouchUpInside];
}

- (void)invokeLoadAd {
    [self.ad load];
}

- (void)invokeShowAd {
    [self.ad showOn:self];
}

- (void)invokeToggleAutoReloadForButton:(UIButton *)button {
    if ([button.currentTitle containsString:@"Off"]) {
        NSString *title =
            [button.currentTitle stringByReplacingOccurrencesOfString:@"On"
                                                           withString:@"Off"];
        [button setTitle:title forState:UIControlStateNormal];
        [self.ad setIsAutoReload:NO];
    } else {
        NSString *title =
            [button.currentTitle stringByReplacingOccurrencesOfString:@"Off"
                                                           withString:@"On"];
        [button setTitle:title forState:UIControlStateNormal];
        [self.ad setIsAutoReload:YES];
    }
}

- (void)bidmadFullscreenLoadWithAd:(BidmadFullscreenAd *)ad
                              info:(BidmadInfo *)info {
    NSLog(@"FullscreenAd: LOAD");
    [self.callbacks setText:@"LOAD"];
}

- (void)bidmadFullscreenLoadFailWithAd:(BidmadFullscreenAd *)ad
                                 error:(NSError *)error {
    NSLog(@"FullscreenAd: LOAD FAIL");
    [self.callbacks setText:@"LOAD FAIL"];
}

- (void)bidmadFullscreenShowWithAd:(BidmadFullscreenAd *)ad
                              info:(BidmadInfo *)info {
    NSLog(@"FullscreenAd: SHOW");
    [self.callbacks setText:@"SHOW"];
}

- (void)bidmadFullscreenShowFailWithAd:(BidmadFullscreenAd *)ad
                                  info:(BidmadInfo *)info
                                 error:(NSError *)error {
    NSLog(@"FullscreenAd: SHOW FAIL");
    [self.callbacks setText:@"SHOW FAIL"];
}

- (void)bidmadFullscreenClickWithAd:(BidmadFullscreenAd *)ad
                               info:(BidmadInfo *)info {
    NSLog(@"FullscreenAd: CLICK");
    [self.callbacks setText:@"CLICK"];
}

- (void)bidmadFullscreenSkipWithAd:(BidmadFullscreenAd *)ad
                              info:(BidmadInfo *)info {
    NSLog(@"FullscreenAd: SKIP");
    [self.callbacks setText:@"SKIP"];
}

- (void)bidmadFullscreenCompleteWithAd:(BidmadFullscreenAd *)ad
                                  info:(BidmadInfo *)info {
    NSLog(@"FullscreenAd: COMPLETE");
    [self.callbacks setText:@"COMPLETE"];
}

- (void)bidmadFullscreenCloseWithAd:(BidmadFullscreenAd *)ad
                               info:(BidmadInfo *)info {
    NSLog(@"FullscreenAd: CLOSE");
    [self.callbacks setText:@"CLOSE"];
}

@end
