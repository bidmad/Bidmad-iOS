//
//  AppOpenAdViewController.m
//  BidmadSDKTest
//
//  Created by ADOP_Mac on 2021/07/06.
//  Copyright © 2021 전혜연. All rights reserved.
//

#import "AppOpenAdViewController.h"
#import <BidmadSDK/BIDMADAppOpenAd.h>

@interface AppOpenAdViewController () <BIDMADAppOpenAdDelegate>
@property (weak, nonatomic) IBOutlet UILabel *callbackLabel;
@property (strong, nonatomic) BIDMADAppOpenAd *bidmadAppOpenAd;
@end

@implementation AppOpenAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.callbackLabel setText:@"No Callback Yet"];
    
    [[BIDMADSetting sharedInstance] setIsDebug:YES];
    
    self.bidmadAppOpenAd = [[BIDMADAppOpenAd alloc] init];
    self.bidmadAppOpenAd.zoneID = @"0ddd6401-0f19-49ee-b1f9-63e910f92e77";
    self.bidmadAppOpenAd.delegate = self;
}

- (IBAction)buttonPressAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"Load"]) {
        [self.bidmadAppOpenAd requestAppOpenAd];
    } else if ([sender.titleLabel.text isEqualToString:@"Show"]) {
        if (self.bidmadAppOpenAd.isLoaded) {
            [self.bidmadAppOpenAd showAppOpenAd];
        }
    }
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)BIDMADAppOpenAdClose:(BIDMADAppOpenAd *)core {
    NSLog(@"Callback → BIDMADAppOpenAdClose");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.callbackLabel setText:@"Close"];
    });
}

- (void)BIDMADAppOpenAdLoad:(BIDMADAppOpenAd *)core {
    NSLog(@"Callback → BIDMADAppOpenAdLoad");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.callbackLabel setText:@"Load"];
    });
    
}

- (void)BIDMADAppOpenAdShow:(BIDMADAppOpenAd *)core {
    NSLog(@"Callback → BIDMADAppOpenAdShow");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.callbackLabel setText:@"Show"];
    });
}

- (void)BIDMADAppOpenAdAllFail:(BIDMADAppOpenAd *)core code:(NSString *)error {
    NSLog(@"Callback → BIDMADAppOpenAdAllFail");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.callbackLabel setText:@"Fail"];
    });
}

@end
