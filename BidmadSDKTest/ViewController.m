//
//  ViewController.m
//  AdopSDKTest
//
//  Created by 김선정 on 2017. 9. 13..
//  Copyright © 2017년 김선정. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)cancelAppOpenAdButtonPressed:(id)sender {
    [(AppDelegate *) [[UIApplication sharedApplication] delegate] cancelAppOpenAd];
}

- (IBAction)reloadAppOpenAdButtonPressed:(id)sender {
    [(AppDelegate *) [[UIApplication sharedApplication] delegate] reloadAppOpenAd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

