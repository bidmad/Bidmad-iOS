//
//  RewardInterstitialViewController.swift
//  BidmadSDKTest
//
//  Created by ADOP_Mac on 2021/07/14.
//  Copyright © 2021 전혜연. All rights reserved.
//

import UIKit
import BidmadSDK

@objc
class RewardInterstitialViewControllerSwift: UIViewController {
    var rewardInterstititial: BIDMADRewardInterstitial!
    var appOpen: BIDMADAppOpenAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appOpen = BIDMADAppOpenAd()
        appOpen.zoneID = "0ddd6401-0f19-49ee-b1f9-63e910f92e77"
        appOpen.delegate = self
        appOpen.request()
        
        appOpen.delegate = self
        appOpen.registerForAppOpenAd(forZoneID: "0ddd6401-0f19-49ee-b1f9-63e910f92e77")
        appOpen.deregisterForAppOpenAd()
        
        rewardInterstititial = BIDMADRewardInterstitial()
        rewardInterstititial.zoneID = "ee6e601d-2232-421b-a429-2e7163a8b41f"
        rewardInterstititial.parentViewController = self
        rewardInterstititial.delegate = self
        rewardInterstititial.request()
    }
    
    func adShow() {
        if (rewardInterstititial.isLoaded) {
            rewardInterstititial.showView()
        }
    }
    
    func removeAd() {
        rewardInterstititial.removeAds()
        rewardInterstititial = nil
    }
}

extension RewardInterstitialViewControllerSwift: BIDMADRewardInterstitialDelegate {
    func bidmadRewardInterstitialLoad(_ core: BIDMADRewardInterstitial!) {
        print("bidmadRewardInterstitialLoad")
        self.adShow()
    }
    func bidmadRewardInterstitialShow(_ core: BIDMADRewardInterstitial!) {
        print("bidmadRewardInterstitialShow")
    }
    func bidmadRewardInterstitialClose(_ core: BIDMADRewardInterstitial!) {
        print("bidmadRewardInterstitialClose")
    }
    func bidmadRewardInterstitialSkipped(_ core: BIDMADRewardInterstitial!) {
        print("bidmadRewardInterstitialSkipped")
    }
    func bidmadRewardInterstitialSuccess(_ core: BIDMADRewardInterstitial!) {
        print("bidmadRewardInterstitialSuccess")
    }
    func bidmadRewardInterstitialAllFail(_ core: BIDMADRewardInterstitial!) {
        print("bidmadRewardInterstitialAllFail")
    }
}

extension RewardInterstitialViewControllerSwift: BIDMADAppOpenAdDelegate {
    func bidmadAppOpenAdLoad(_ core: BIDMADAppOpenAd!) {
        print("bidmadAppOpenAdLoad")
        if (appOpen.isLoaded) {
            self.appOpen.show()
        }
    }
    
    func bidmadAppOpenAdShow(_ core: BIDMADAppOpenAd!) {
        print("bidmadAppOpenAdShow")
    }
    
    func bidmadAppOpenAdClose(_ core: BIDMADAppOpenAd!) {
        print("bidmadAppOpenAdClose")
    }
    
    func bidmadAppOpenAdAllFail(_ core: BIDMADAppOpenAd!, code error: String!) {
        print("bidmadAppOpenAdAllFail")
    }
}
