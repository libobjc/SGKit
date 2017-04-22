//
//  SGImagePlayerExample.m
//  SGDemo
//
//  Created by Single on 2016/11/17.
//  Copyright © 2016年 single. All rights reserved.
//

#import "SGImagePlayerExample.h"
#import <SGKit/SGKit.h>

@interface SGImagePlayerExample () <SGImagePlayerDelegate>

@property (nonatomic, strong) SGImagePlayer * imagePlayer;
@property (nonatomic, strong) UIButton * reloadButton;

@end

@implementation SGImagePlayerExample

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imagePlayer = [[SGImagePlayer alloc] initWithFrame:CGRectZero];
    self.imagePlayer.delegate = self;
    
    self.reloadButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.reloadButton setTitle:@"Reload" forState:UIControlStateNormal];
    [self.reloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.reloadButton addTarget:self action:@selector(reloadButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.imagePlayer];
    [self.view addSubview:self.reloadButton];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self updateLayout];
}

- (void)updateLayout
{
    self.imagePlayer.frame = self.view.bounds;
    self.reloadButton.frame = CGRectMake(0,
                                         CGRectGetHeight(self.view.bounds) - 20 - 20,
                                         80,
                                         20);
}

- (void)reloadButtonAction
{
    [self.imagePlayer reloadData];
}

- (NSInteger)numberOfImagesInImagePlayer:(SGImagePlayer *)imagePlayer
{
    return 5;
}

- (void)imagePlayer:(SGImagePlayer *)imagePlayer imageView:(UIImageView *)imageView atIndex:(NSInteger)index
{
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"moto_%ld", index+1]];
}

- (void)imagePlayerDidFinishLoad:(SGImagePlayer *)imagePlayer currentIndex:(NSInteger)index
{
    NSLog(@"%s", __func__);
}

- (void)imagePlayer:(SGImagePlayer *)imagePlayer didTapAtIndex:(NSInteger)index
{
    NSLog(@"%s, index : %ld", __func__, index);
}

@end
