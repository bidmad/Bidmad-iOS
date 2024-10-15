//
//  NativeAdViewController.m
//  BidmadSDK-DevSuite
//
//  Created by Seungsub Oh on 2022/04/15.
//

#import "NativeAdViewController.h"

@interface NativeAdViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *callbackLabel;
@property (strong, nonatomic) NSArray<BidmadNativeAd *> *ads;
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
    
    self.ads = @[
        [BidmadNativeAd adWithZoneID:@"7fe8f6de-cd99-4769-9ae6-a471cfd7e2b1"],
        [BidmadNativeAd adWithZoneID:@"7fe8f6de-cd99-4769-9ae6-a471cfd7e2b1"],
        [BidmadNativeAd adWithZoneID:@"7fe8f6de-cd99-4769-9ae6-a471cfd7e2b1"]
    ];
    
    [self.ads enumerateObjectsUsingBlock:^(BidmadNativeAd * _Nonnull ad, NSUInteger idx, BOOL * _Nonnull stop) {
        [ad setDelegate:self];
        [ad load];
    }];
}

- (IBAction)backButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClickAd:(BidmadNativeAd *)bidmadAd info:(BidmadInfo *)info {
    [self.callbackLabel setText:@"CLICK"];
}

- (void)onLoadAd:(BidmadNativeAd *)bidmadAd info:(BidmadInfo *)info {
    self.adsCount += 1;
    [self.tableView reloadData];
    [self.callbackLabel setText:@"LOAD"];
}

- (void)onLoadFailAd:(BidmadNativeAd *)bidmadAd error:(NSError *)error {
    [self.callbackLabel setText:[NSString stringWithFormat:@"FAIL (%@)", error.localizedDescription]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NativeAdCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    BIDMADNativeAdView *adView = [BidmadNativeAd findAdViewFromSuperview:cell];
    [self.ads[indexPath.row] setRootViewController:self adView:adView];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    BIDMADNativeAdView *adView = [BidmadNativeAd findAdViewFromSuperview:cell];
    [self.ads[indexPath.row] removeAdView:adView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 290;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.adsCount;
}

@end
