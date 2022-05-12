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
@property (strong, nonatomic) BidmadNativeAdLoader *adLoader;
@property (strong, nonatomic) NSMutableArray<BIDMADNativeAd *>* ads;
@property (nonatomic) int adsCallbackCount;
@end

@implementation NativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NativeAd" bundle:nil] forCellReuseIdentifier:@"NativeAdCell"];
    
    self.ads = [NSMutableArray new];
    
    self.adLoader = [[BidmadNativeAdLoader alloc] init];
    self.adLoader.delegate = self;
    
    for (int i = 0; i < 5; i++) {
        [self.adLoader loadFor:@"7fe8f6de-cd99-4769-9ae6-a471cfd7e2b1"];
    }
}

- (IBAction)backButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)bidmadNativeAdWithLoadedAd:(BIDMADNativeAd *)loadedAd {
    NSLog(@"Loaded Ad is %@", [loadedAd description]);
    
    self.adsCallbackCount++;
    
    [self.callbackLabel setText:[NSString stringWithFormat:@"LOAD (%@)", loadedAd.headline]];
    [self.ads insertObject:loadedAd atIndex:self.ads.count];
    
    if (self.adsCallbackCount == 5) {
        [self.tableView reloadData];
    }
}

- (void)bidmadNativeAdWithClickedAd:(BIDMADNativeAd *)clickedAd {
    [self.callbackLabel setText:[NSString stringWithFormat:@"CLICK (%@)", clickedAd.headline]];
    NSLog(@"Native Ad %@ is clicked.", clickedAd.description);
}

- (void)bidmadNativeAdAllFail:(NSError *)error {
    self.adsCallbackCount++;
    
    [self.callbackLabel setText:[NSString stringWithFormat:@"ALL FAIL (%@)", error.description]];
    NSLog(@"Native Ad Mediation all failed.");
    
    if (self.adsCallbackCount == 5) {
        [self.tableView reloadData];
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NativeAdCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BIDMADNativeAd *adData = [self.ads objectAtIndex:indexPath.row];
    BIDMADNativeAdView *adView = [cell viewWithTag:123321];
    
    [BidmadNativeAdLoader setupFor:adData viewController:self adView:adView];
    
    if (adData.headline != nil) {
        [adView.headlineViewCustom setHidden:NO];
        [adView.headlineViewCustom setText:adData.headline];
    } else {
        [adView.headlineViewCustom setHidden:YES];
    }
    
    if (adData.body != nil) {
        [adView.bodyViewCustom setHidden:NO];
        [adView.bodyViewCustom setText:adData.body];
    } else {
        [adView.bodyViewCustom setHidden:YES];
    }
    
    if (adData.callToAction != nil) {
        [adView.callToActionViewCustom setHidden:NO];
        [adView.callToActionViewCustom setTitle:adData.callToAction forState:UIControlStateNormal];
    } else {
        [adView.callToActionViewCustom setHidden:YES];
    }
    
    if (adData.icon != nil) {
        [adView.iconViewCustom setHidden:NO];
        [adView.iconViewCustom setImage:adData.icon];
    } else {
        [adView.iconViewCustom setHidden:YES];
    }
    
    if (adData.starRating != nil) {
        [adView.starRatingViewCustom setHidden:NO];
        [adView.starRatingViewCustom performSelector:@selector(setText:) withObject:[NSString stringWithFormat:@"%@ ⭐️", adData.starRating]];
    } else {
        [adView.starRatingViewCustom setHidden:YES];
    }
    
    if (adData.store != nil) {
        [adView.storeViewCustom setHidden:NO];
        [adView.storeViewCustom setText:adData.store];
    } else {
        [adView.storeViewCustom setHidden:YES];
    }
    
    if (adData.price != nil) {
        [adView.priceViewCustom setHidden:NO];
        [adView.priceViewCustom setText:adData.price];
    } else {
        [adView.priceViewCustom setHidden:YES];
    }
    
    if (adData.advertiser != nil) {
        [adView.advertiserViewCustom setHidden:NO];
        [adView.advertiserViewCustom setText:adData.advertiser];
    } else {
        [adView.advertiserViewCustom setHidden:YES];
    }
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    BIDMADNativeAd *adData = [self.ads objectAtIndex:indexPath.row];
    BIDMADNativeAdView *adView = [cell viewWithTag:123321];
    
    [BidmadNativeAdLoader cleanUpFor:adData adView:adView];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ads.count;
}

@end
