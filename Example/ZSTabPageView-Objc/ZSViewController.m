//
//  ZSViewController.m
//  ZSTabPageView-Objc
//
//  Created by zhangsen093725 on 11/26/2020.
//  Copyright (c) 2020 zhangsen093725. All rights reserved.
//

#import "ZSViewController.h"
#import "ZSTabPageViewController.h"
#import "ZSCategoryPageViewController.h"
#import "ZSTabPageSectionViewController.h"

@interface ZSViewController ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;


@end

@implementation ZSViewController

- (UIButton *)button {
    
    if (!_button)
    {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        [_button setTitle:@"TabPageView" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(on_button:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_button];
    }
    return _button;
}

- (UIButton *)button2 {
    
    if (!_button2)
    {
        _button2 = [UIButton buttonWithType:UIButtonTypeSystem];
        [_button2 setTitle:@"TabPageSectionView" forState:UIControlStateNormal];
        [_button2 addTarget:self action:@selector(on_button:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_button2];
    }
    return _button2;
}

- (UIButton *)button3 {
    
    if (!_button3)
    {
        _button3 = [UIButton buttonWithType:UIButtonTypeSystem];
        [_button3 setTitle:@"TabPageView-Vertical" forState:UIControlStateNormal];
        [_button3 addTarget:self action:@selector(on_button:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_button3];
    }
    return _button3;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    
    CGFloat buttonW = 150;
    CGFloat buttonH = 60;
    CGFloat buttonX = (self.view.frame.size.width - buttonW) * 0.5;
    
    self.button.frame = CGRectMake(buttonX, 60, buttonW, buttonH);
    self.button2.frame = CGRectMake(buttonX, CGRectGetMaxY(self.button.frame) + 20, buttonW, buttonH);
    self.button3.frame = CGRectMake(buttonX, CGRectGetMaxY(self.button2.frame) + 20, buttonW, buttonH);
}

- (void)on_button:(UIButton *)sender {
    
    if (sender == _button2)
    {
        [self.navigationController pushViewController:[ZSTabPageSectionViewController new] animated:YES];
    }
    else if (sender == _button3)
    {
        [self.navigationController pushViewController:[ZSCategoryPageViewController new] animated:YES];
    }
    else
    {
        [self.navigationController pushViewController:[ZSTabPageViewController new] animated:YES];
    }
    
}

@end
