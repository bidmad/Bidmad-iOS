//
//  SceneDelegate.m
//  BidmadSDKTest
//

#import "SceneDelegate.h"
#import "AppDelegate.h"

@implementation SceneDelegate

// The window and its root view controller come from Main.storyboard
// (UISceneStoryboardFile in Info.plist), so there is nothing to build here.
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {}

// With scenes, UIKit no longer calls applicationDidBecomeActive: on the app
// delegate; the App Tracking Transparency prompt is requested from here instead.
- (void)sceneDidBecomeActive:(UIScene *)scene {
    AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    [appDelegate requestTrackingAuthorizationIfNeeded];
}

@end
