//
//  InterstitialViewController.m
//  BidmadSDKTest
//
//  Created by 김선정 on 2017. 9. 13..
//  Copyright © 2017년 김선정. All rights reserved.
//

#import "InterstitialViewController.h"

@interface InterstitialViewController (){
}

@end


@implementation InterstitialViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    /*
        1. 테스트 기기 등록하기
          GoogleAdmob의 경우, 실 코드로 테스트를 자주할 경우 계정이 정지될 수 있기 때문에 실기기에서 테스트를 진행할 경우, 반드시 테스트 기기를 등록하여 테스트를 하시고,
          실제 앱이 릴리즈 단계에서는 테스트기기 등록 코드 (아래참조)를 삭제 처리 해주셔야 합니다.
          아래 문자열을 얻는 방법은, 일단 [interstitial setTestDevice:@"xxxxxx"]; 함수를 삭제하고 아래코드들을 실행한 한 후,하단 Log창에서
          "GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers"를 검색하여 찾은후
          GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[ @"xxxxxx" ] 문구의, xxxxxx(애드몹에서 인식하는 사용자의 폰 ID)  스트링을 복사하여 그대로 setTestDevice 함수의 파라미터로 넣어주시면 됩니다.이때, Simulator에서 실행시에는 kGADSimulatorID를 넣어주시면 됩니다.(아래 코드 참조)
      
        2. LoadInterstitialView를 보통 ViewController(가령, 리워드 광고 상품이 있는 화면 ) 진입할 때 해주고, 실제로 interstitial을 보여줘야하는 상황에서 실제로 showInterstitialView를 호출해줍니다.
        3. 2번에서, 반드시 아래의 BIDMADInterstitialLoad 콜백함수가 호출된 상태여야, load가 완료된 것이니, 콜백에 주의하여 load 콜백의 상태를 파악하여 showInterstitialView를 해주셔야 합니다.
        4. 한번 광고를 시청하고나면,첫번째 광고를 다 보고 난 후 Close 버튼을 통해서 아래의 BIDMADInterstitialClose 콜백함수가 불리게 됩니다. 이때, 미리 다음 광고영상을 loadInterstitialView를 통해서 미리 로드하길 권장합니다.
     */
    
//    [[BIDMADSetting sharedInstance] setTestDeviceId:@"YOUR_TEST_DEVICE_ID"];
    
    [[BIDMADSetting sharedInstance] setIsDebug:YES];
    self.interstitial = [[BIDMADInterstitial alloc] init];
    [self.interstitial setParentViewController:self];
    [self.interstitial setZoneID:@"228b95a9-6f42-46d8-a40d-60f17f751eb1"];
    [self.interstitial setDelegate:self];
}

-(IBAction)loadInterstitial:(UIButton*)sender{
    [self.interstitial loadInterstitialView];
   
}

-(IBAction)showInterstitial:(UIButton*)sender{
    if([self.interstitial isLoaded]){
        [self.interstitial showInterstitialView];
    }
}
- (IBAction)backBtnPressed:(id)sender {
    NSLog(@"Back Button Pressed");
    
    if (self.interstitial != nil) {
//        [self.interstitial removeInterstitialADS];
        self.interstitial = nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        // DO NOTHING;
    }];
}

#pragma mark Interstitial Delegate
- (void)BIDMADAdError:(BIDMADInterstitial *)core code:(NSString *)error
{
    NSLog(@"BIDMADAdError : %@",error);
    self.InterstitialCallbackDisplay.text = @"BIDMADAdError";
}

- (void)BIDMADInterstitialClose:(BIDMADInterstitial *)core
{
    self.InterstitialCallbackDisplay.text = @"BIDMADInterstitialClose";
    NSLog(@"APPUI BIDMADInterstitialClose");
}

- (void)BIDMADInterstitialShow:(BIDMADInterstitial *)core
{
    self.InterstitialCallbackDisplay.text = @"BIDMADInterstitialShow";
    
    self.interstitial = [[BIDMADInterstitial alloc]init];
    [self.interstitial setZoneID:core.zoneID];
    [self.interstitial setParentViewController:self];
    [self.interstitial setDelegate:self];
    [self.interstitial loadInterstitialView];
    NSLog(@"APPUI BIDMADInterstitialShow");
}

-(void)BIDMADInterstitialLoad:(BIDMADInterstitial *)core
{
    self.InterstitialCallbackDisplay.text = @"BIDMADInterstitialLoad";
    NSLog(@"APPUI BIDMADInterstitialLoad");
}
- (void)BIDMADInterstitialAllFail:(BIDMADInterstitial *)core {
    self.InterstitialCallbackDisplay.text = @"BIDMADInterstitialAllFail";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
