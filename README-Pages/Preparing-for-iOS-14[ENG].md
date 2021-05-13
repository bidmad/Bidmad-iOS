# Preparing for iOS 14

Describes the changes required to use BidmadSDK on iOS 14 or higher.

###### SDK version.
- BidmadSDK 2.5.0 or higher<br>

### 1. Request App Tracking Transparency authorization

On iOS 14 and higher, access to IDFA requires app tracking transparency approval from the user.

#### Add NSUserTrackingUsageDescription to info.plist
```cpp
<key>NSUserTrackingUsageDescription</key>
<string>Used to provide personalized advertising.</string>
```
#### Popup call to request approval
BidmadSDK provides a wrapper function for [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler].<br>
If the user agrees to the app tracking transparency approval, you must complete the callback processing for the popup before loading the ad so that IDFA can be used for ad requests.
```cpp
    [[BIDMADSetting sharedInstance] reqAdTrackingAuthorizationWithCompletionHandler:^(BidmadTrackingAuthorizationStatus status) {
        if(status == BidmadAuthorizationStatusAuthorized){
            NSLog(@" IDFA collection agree ");
        }else if(status == BidmadAuthorizationStatusDenied) {
            NSLog(@" IDFA collection denial ");
        }else if(status == BidmadAuthorizationStatusLessThaniOS14) {
            NSLog(@" Less than iOS14 ");
        }
    }];
```
When calling popup using [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler] without using Wrapper Function, call the following function according to the result of calling the popup.
```cpp
    [[BIDMADSetting sharedInstance] setAdvertiserTrackingEnabled:false]; //Call when popup call result denial

    [[BIDMADSetting sharedInstance] setAdvertiserTrackingEnabled:true]; //Call when popup call result agree
```


### 2. Setting SKAdNetwork

To use AdNetworks provided by BidmadSDK, you need to add SKAdNetworkIdentifier to Info.plist.
Please add SKAdNetworkItems below to info.plist.

```
<key>SKAdNetworkItems</key>
<array>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>cstr6suwn9.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>v9wttpbfk9.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>n38lu8286q.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>4dzt52r2t5.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>bvpn9ufa9b.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>2u9pt9hc89.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>4468km3ulz.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>4fzdc2evr5.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>7ug5zh24hu.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>8s468mfl3y.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>9rd848q2bz.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>9t245vhmpl.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>av6w8kgt66.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>f38h382jlk.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>hs6bdukanm.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>kbd757ywx3.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>ludvb6z3bs.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>m8dbw4sv7c.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>mlmmfzh3r3.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>prcb7njmu6.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>t38b2kh725.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>tl55sbb4fm.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>wzmmz9fp6w.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>yclnxrl5pm.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>ydx93a7ass.skadnetwork</string>
    </dict>
</array>
```
