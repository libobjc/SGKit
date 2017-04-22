//
//  SGGuideViewExample.m
//  SGDemo
//
//  Created by Single on 09/01/2017.
//  Copyright © 2017 single. All rights reserved.
//

#import "SGGuideViewExample.h"
#import <SGKit/SGKit.h>

@interface SGGuideViewExample () <SGGuideViewDelegate>

@property (nonatomic, strong) SGGuideView * guideView;

@end

@implementation SGGuideViewExample

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.guideView = [SGGuideView guideViewWithImageNames:@[@"moto_1", @"moto_2", @"moto_3"]];
    self.guideView.delegate = self;
    [self.view addSubview:self.guideView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self updateLayout];
}

- (void)updateLayout
{
    self.guideView.frame = self.view.bounds;
}

- (void)guideViewWillDisapper:(SGGuideView *)guideView
{
    NSLog(@"%s", __func__);
}

- (void)guideViewDidDisapper:(SGGuideView *)guideView
{
    NSLog(@"%s", __func__);
}

@end
