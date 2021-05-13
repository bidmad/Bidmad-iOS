# iOS 14 이상 대응

iOS 14 이상에서 BidmadSDK를 사용하는데 필요한 변경사항을 설명합니다.

###### 사용 SDK 버전
- BidmadSDK 2.5.0 이상<br>

### 1. 앱 추적 투명성 승인 요청

iOS 14이상에서는 IDFA에 엑세스 하기 위해 사용자로부터 앱 추적 투명성 승인을 받아야 합니다.

#### info.plist에 NSUserTrackingUsageDescription 추가
```cpp
<key>NSUserTrackingUsageDescription</key>
<string>개인 맞춤 광고를 제공하는데 사용됩니다.</string>
```
#### 승인 요청을 위한 팝업 호출
BidmadSDK에서는 [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler]에 대한 Wrapper Function을 제공합니다.<br>
사용자가 앱 추적 투명성 승인에 동의하는 경우 광고 요청에 IDFA를 사용할 수 있도록 광고를 로드하기 전 팝업에 대한 콜백 처리를 완료해야합니다.
```cpp
    [[BIDMADSetting sharedInstance] reqAdTrackingAuthorizationWithCompletionHandler:^(BidmadTrackingAuthorizationStatus status) {
        if(status == BidmadAuthorizationStatusAuthorized){
            NSLog(@" IDFA 수집 동의 ");
        }else if(status == BidmadAuthorizationStatusDenied) {
            NSLog(@" IDFA 수집 거부 ");
        }else if(status == BidmadAuthorizationStatusLessThaniOS14) {
            NSLog(@" iOS 14 이하 버전 ");
        }
    }];
```
Wrapper Function를 사용하지 않고 [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler]를 사용하여 팝업을 호출하는 경우 팝업 호출 결과에 따라 아래의 함수를 호출 바랍니다.
```cpp
    [[BIDMADSetting sharedInstance] setAdvertiserTrackingEnabled:false]; //팝업 호출 결과 비동의 시 호출

    [[BIDMADSetting sharedInstance] setAdvertiserTrackingEnabled:true]; //팝업 호출 결과 동의 시 호출
```


### 2. SKAdNetwork 사용설정

BidmadSDK에서 제공하는 AdNetwork들을 사용하기 위해 Info.plist에 SKAdNetworkIdentifier 추가가 필요합니다.
아래의 SKAdNetworkItems를 info.plist에 추가 바랍니다.

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
