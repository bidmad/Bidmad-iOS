//
//  NativeAdViewController.m
//  BidmadSDK-DevSuite
//
//  Created by Seungsub Oh on 2022/04/15.
//

#import <ADOPUtility/ADOPUtility.h>
#import "NativeAdViewController.h"
#import <ADOPUtility/ADOPLog.h>

@interface NativeAdViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *callbackLabel;
@property (strong, nonatomic) BidmadNativeAdLoader *adLoader;
@property (nonatomic) int adsCount;
@property (nonatomic) int adsCallbackCount;
@end

@implementation NativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NativeAd" bundle:nil] forCellReuseIdentifier:@"NativeAdCell"];
    
    self.adsCount = 0;
    
    self.adLoader = [BidmadNativeAdLoader new];
    self.adLoader.delegate = self;
    self.adLoader.numberOfAds = 5;
    
    [self.adLoader requestAd:@"7fe8f6de-cd99-4769-9ae6-a471cfd7e2b1"];
}

- (IBAction)backButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClickAd:(BIDMADNativeAd *)bidmadAd {
    ADOPLog.printInfo(@"Native Ad Click: %@", bidmadAd.adData.description);
    [self.callbackLabel setText:[NSString stringWithFormat:@"CLICK (%@)", bidmadAd.adData.headline]];
}

- (void)onLoadAd:(BIDMADNativeAd *)bidmadAd {
    ADOPLog.printInfo(@"Native Ad Load: %@", bidmadAd.adData.description);
    
    self.adsCount += 1;
    [self.tableView reloadData];
    [self.callbackLabel setText:[NSString stringWithFormat:@"LOAD (%@)", bidmadAd.adData.headline]];
}

- (void)onLoadFailAd:(BIDMADNativeAd *)bidmadAd error:(NSError *)error {
    ADOPLog.printInfo(@"Native Ad Fail: %@", error.localizedDescription);
    [self.callbackLabel setText:[NSString stringWithFormat:@"FAIL (%@)", error.localizedDescription]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NativeAdCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    BIDMADNativeAdView *adView =
        [cell.subviews filterForADOP:^BOOL(__kindof UIView *view) {
            return [view isKindOfClass:BIDMADNativeAdView.class];
        }].firstObject;
    [self.adLoader setAdView:self adView:adView];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    BIDMADNativeAdView *adView =
        [cell.subviews filterForADOP:^BOOL(__kindof UIView *view) {
            return [view isKindOfClass:BIDMADNativeAdView.class];
        }].firstObject;
    [self.adLoader removeAdView:adView];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.adsCount;
}

@end
