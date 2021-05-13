# Requesting Consent from European Users(GDPR)

Interface for GDPR (EU General Data Protection Regulation) provided by AdNetwork SDK linked with Bidmad is provided.<br>
As there are different interfaces depending on the Ad Network, Bidmad provide a total of two interfaces, so please use the interface that suits your network.<br>

*Some networks do not provide the GDPR Interface, so please inquire before applying the GDPR.

------

### Google GDPR Interface

Google sets up a user consent pop-up through the Funding Choices platform and exposes it to users through the UMP SDK.<br>
Google GDPR Interface is a wrapper interface for UMP SDK provided by Google (Admob / Admanager).<br>
If you applied Google GDPR through UMP SDK before Bidmad, you don't need to change to the interface provided by Bidmad.<br>

After creating the user consent pop-up form in Funding Choices, follow the instructions below to request the user consent.

#### Initial 'ViewController Header Interface' Setting
```cpp
#import <BidmadSDK/BIDMADGDPRforGoogle.h>
...
@interface SampleViewController : UIViewController<..., BIDMADGDPRforGoogleProtocol>
```

#### Intiali 'ViewController, Listener' Setting
```cpp
BIDMADGDPRforGoogle *gdprUMP;
...
gdprUMP = [[BIDMADGDPRforGoogle alloc] initWith:self];
[gdprUMP setListener:self];
```

#### Google GDPR goes through the following steps
    1. Request a consent popup to Google GDPR SDK.
    2. Request to load the consent popup.
    3. Check if GDPR consent is necessary and display the consent popup form to user.
    4. Receive the results from consent popup form.

#### 1. Request Consent Popup
```cpp
[gdprUMP requestConsentInfoUpdate];
```

#### 2. Request to Load Consent Popup Form
```cpp
// 1. a callback that you will be receiving after the consent request is done
-(void)onConsentInfoUpdateSuccess {
    NSLog(@"onConsentInfoUpdateSuccess");
    
    // 2. Check if the consent form is loadable
    if([gdprUMP isConsentFormAvailable]) {
    
        // 3. Load the consent form
        [gdprUMP loadForm];
    }
}
```

#### 3. Check if GDPR Consent is necessary and display the Consent form
```cpp
// 1. a callback that you will be receiving after the consent form is loaded
-(void)onConsentFormLoadSuccess{
    NSLog(@"onConsentFormLoadSuccess");
    
    // 2. Check if the GDPR Consent is necessary (required state)
    if ([gdprUMP getConsentStatus] == BIDMAD_UMPConsentStatusRequired) {
    
        // 3. Because consent is required, we need to show the consent form. 
        [gdprUMP showForm];
        
    // Consent Request has not been made
    } else if ([gdprUMP getConsentStatus] == BIDMAD_UMPConsentStatusUnknown) {
        NSLog(@"ConsentStatusUnknown");
    // Already received a consent status from user
    } else if ([gdprUMP getConsentStatus] == BIDMAD_UMPConsentStatusObtained) {
        NSLog(@"ConsentStatusObtained");
    // GDPR consent is not necessary
    } else if ([gdprUMP getConsentStatus] == BIDMAD_UMPConsentStatusNotRequired) {
        NSLog(@"ConsentStatusNotRequired");
    }
}
```

#### 4. Checking the consent form result
```cpp
// A callback that sends a result after an interaction with the user. If formError is null, it means that you have successfully received either 'consent' or 'do not consent'.
-(void)onConsentFormDismissed: (NSError*)formError {
    NSLog(@"onConsentFormDismissed error: %@ code: %li", formError.localizedDescription, (long)formError.code);
}
```

#### Request and Form Loading Failure Callback

```cpp
// Consent Popup Request Failure
-(void)onConsentInfoUpdateFailure: (NSError*)formError {
    NSLog(@"onConsentInfoUpdateFailure error: %@ code: %li", formError.localizedDescription, (long)formError.code);
}

// Consent Popup Form Loading Failure
-(void)onConsentFormLoadFailure: (NSError*)formError {
    NSLog(@"onConsentFormLoadFailure error: %@ code: %li", formError.localizedDescription, (long)formError.code);
}
```

#### Initial Debugging and Test Setting 
1. Once you are done with all the settings above, please request consent form Google GDPR 
2. And you will be seeing the following log on the Xcode console.
```cpp
<UMP SDK> To enable debug mode for this device, set: UMPDebugSettings.testDeviceIdentifiers = @[ @"Test Device Unique ID" ];
```
3. Insert the Test Device Unique ID to the following code and include the code in your initial settings explained above.
```cpp
[gdprUMP setDebug:@"Test Device Unique ID" isTestEurope:YES];
```

------

### GDPR Interface

This is an interface to the GDPR provided by other ad networks excluding Google (Admob / Admanager).<br>
In other ad networks, the interface is configured to deliver the value of the user consent result (agree / disagree) to the SDK when requesting an advertisement.<br>
The GDPR Interface provided by Bidmad delivers the result of user consent to each Ad Network's SDK.

If you want to use the GDPR Interface, develop a pop-up to obtain user consent and then call the GDPR Interface according to the pop-up result.

#### GDPR Europe Area Setting (If in Europe, set the following code to YES)
```cpp
[BIDMADGDPR setUseArea:YES];
```

#### GDPR Consent Setting (If consented, set the following code to YES)
```cpp
[BIDMADGDPR setGDPRSetting:YES];
```

#### Getting GDPR Setting Value
```cpp
GDPRConsentStatus gdprConsentStatus = [BIDMADGDPR getGDPRSetting];
```

#### GDPR Setting Values (GDPRConsentStatus: Enum)
```cpp
GDPRConsentStatusYES = 1,
GDPRConsentStatusNO = 0,
GDPRConsentStatusUNKNOWN = -1,
GDPRConsentStatusUNUSE = -2
```
