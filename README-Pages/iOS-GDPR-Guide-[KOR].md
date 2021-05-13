# 유럽사용자 동의 요청(GDPR)

Bidmad와 연동된 AdNetwork SDK에서 제공하는 GDPR(EU 온라인 개인정보보호지침 및 개인정보 보호법)에 대한 Interface를 제공하고 있습니다.<br>
Ad Network에 따라 인터페이스가 상이한 부분이 있어 총 두 가지 Interface를 제공하고 있으므로 사용하시는 네트워크에 맞는 Interface를 사용 바랍니다.<br>

*일부 네트워크의 경우 GDPR Interface를 제공하지 않는 경우가 있으므로 GDPR 적용 전에 문의를 부탁 드립니다.

------

### Google GDPR Interface

Google에서는 Funding Choices 플랫폼을 통해 사용자 동의 팝업을 설정하고 UMP SDK를 통해 사용자에게 노출 시킵니다.<br>
Google GDPR Interface는 Google(Admob / Admanager)에서 제공하는 UMP SDK에 대한 Wrapper Interface 입니다.<br>
Bidmad 이전에 UMP SDK를 통해 Google GDPR을 적용하였다면, Bidmad에서 제공하는 Interface로 변경하여 작업을 하지 않아도 괜찮습니다.<br>

Funding Choices에서 사용자 동의 팝업 양식 생성 후 아래 사용법에 따라 사용자 동의 요청을 수행하세요.

#### 초기 ViewController Header Interface 세팅
```cpp
#import <BidmadSDK/BIDMADGDPRforGoogle.h>
...
@interface SampleViewController : UIViewController<..., BIDMADGDPRforGoogleProtocol>
```

#### 초기 ViewController, Listener 세팅
```cpp
BIDMADGDPRforGoogle *gdprUMP;
...
gdprUMP = [[BIDMADGDPRforGoogle alloc] initWith:self];
[gdprUMP setListener:self];
```

#### Google GDPR은 다음과 같은 스텝을 거칩니다.
    1. Google GDPR SDK에게 동의 팝업을 요청합니다.
    2. 동의 팝업 폼 로드를 요청합니다.
    3. GDPR 동의가 필요한지에 대해 확인하고 동의 팝업 폼을 사용자에게 보여줍니다.
    4. 동의 팝업 폼의 결과를 받습니다.

#### 1. 동의 팝업 요청
```cpp
[gdprUMP requestConsentInfoUpdate];
```

#### 2. 동의 팝업 폼 로드 요청
```cpp
// 1. 동의 요청이 완료된 이후 들어오는 콜백.
-(void)onConsentInfoUpdateSuccess {
    NSLog(@"onConsentInfoUpdateSuccess");
    
    // 2. 동의 팝업 로드 가능 여부를 확인합니다.
    if([gdprUMP isConsentFormAvailable]) {
    
        // 3. 동의 팝업을 로드합니다.
        [gdprUMP loadForm];
    }
}
```

#### 3. GDPR 동의 필요 여부 확인 및 동의 팝업 폼 디스플레이
```cpp
// 1. 동의 팝업 로드가 완료된 이후 들어오는 콜백.
-(void)onConsentFormLoadSuccess{
    NSLog(@"onConsentFormLoadSuccess");
    
    // 2. 동의가 필요한지에 대한 여부를 확인합니다 (동의가 필요한 상태)
    if ([gdprUMP getConsentStatus] == BIDMAD_UMPConsentStatusRequired) {
    
        // 3. 동의가 필요하기 때문에 동의 팝업을 디스플레이 합니다.
        [gdprUMP showForm];
        
    // 동의 요청이 들어오지 않은 상태입니다.
    } else if ([gdprUMP getConsentStatus] == BIDMAD_UMPConsentStatusUnknown) {
        NSLog(@"ConsentStatusUnknown");
    // GDPR 동의를 이미 받은 상태입니다.
    } else if ([gdprUMP getConsentStatus] == BIDMAD_UMPConsentStatusObtained) {
        NSLog(@"ConsentStatusObtained");
    // GDPR 동의가 필요 없는 상태입니다.
    } else if ([gdprUMP getConsentStatus] == BIDMAD_UMPConsentStatusNotRequired) {
        NSLog(@"ConsentStatusNotRequired");
    }
}
```

#### 4. 동의 팝업 폼 결과 확인
```cpp
// 사용자와의 상호작용이 끝나고 결과를 보내는 콜백. formError가 null 일 경우, 동의 혹은 미동의 수신을 성공했음을 뜻합니다. 
-(void)onConsentFormDismissed: (NSError*)formError {
    NSLog(@"onConsentFormDismissed error: %@ code: %li", formError.localizedDescription, (long)formError.code);
}
```

#### 요청 및 폼 로드 실패 콜백

```cpp
// 동의 팝업 요청 실패
-(void)onConsentInfoUpdateFailure: (NSError*)formError {
    NSLog(@"onConsentInfoUpdateFailure error: %@ code: %li", formError.localizedDescription, (long)formError.code);
}

// 동의 팝업 폼 로드 실패
-(void)onConsentFormLoadFailure: (NSError*)formError {
    NSLog(@"onConsentFormLoadFailure error: %@ code: %li", formError.localizedDescription, (long)formError.code);
}
```

#### 초기 디버깅 및 테스트 세팅
1. 위 세팅이 모두 완료된 이후,  GDPR for Google 팝업 요청을 실행하십시오
2. 다음과 같은 로그가 콘솔에 기록될 것입니다.
```cpp
<UMP SDK> To enable debug mode for this device, set: UMPDebugSettings.testDeviceIdentifiers = @[ @"테스트 디바이스 고유 ID" ];
```
3. 주어진 테스트 디바이스 고유 ID를 삽입한 다음 코드를 초기 세팅에 포함시키십시오
```cpp
[gdprUMP setDebug:@"테스트 디바이스 고유 ID" isTestEurope:YES];
```

-----

### GDPR Interface

Google(Admob / Admanager)를 제외한 타 Ad Network에서 제공하는 GDPR Interface에 대한 대응 Interface입니다.<br>
타 Ad Network에서는 광고 요청 시 사용자 동의 결과(동의 / 비동의)에 대한 값을 SDK에 전달하도록 Interface가 구성되어 있으며<br>
Bidmad에서 제공하는 GDPR Interface는 사용자 동의 결과를 각 Ad Network의 SDK에 전달하는 역할을 수행합니다.<br>

GDPR Interface를 사용하고자 하시는 경우 사용자 동의를 받기 위한 팝업을 개발 하신 후 팝업 결과에 따라 GDPR Interface를 호출바랍니다.

#### GDPR 유럽 지역 세팅 (유럽일 경우, YES / 아닐 경우, NO)
```cpp
[BIDMADGDPR setUseArea:YES];
```

#### GDPR 동의 세팅 (동의 했을 경우, YES / 아닐 경우, NO)
```cpp
[BIDMADGDPR setGDPRSetting:YES];
```

#### GDPR 세팅 값 가져오기
```cpp
GDPRConsentStatus gdprConsentStatus = [BIDMADGDPR getGDPRSetting];
```

#### GDPR 세팅 값 (GDPRConsentStatus: Enum)
```cpp
GDPRConsentStatusYES = 1,
GDPRConsentStatusNO = 0,
GDPRConsentStatusUNKNOWN = -1,
GDPRConsentStatusUNUSE = -2
```
