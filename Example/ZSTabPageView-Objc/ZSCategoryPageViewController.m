//
//  ZSCategoryPageViewController.m
//  ZSTabPageView_Example
//
//  Created by Josh on 2020/12/29.
//  Copyright © 2020 zhangsen093725. All rights reserved.
//

#import "ZSCategoryPageViewController.h"
#import "ZSTableViewController.h"

#import "ZSTabPageViewServe.h"
#import "ZSTabLabelCollectionViewCell.h"

@interface ZSCategoryPageViewController ()<ZSTabPageViewServeDelegate, ZSTabPageViewServeDataSource>

@property (nonatomic, strong) ZSTabPageView *tabPageView;

@property (nonatomic, strong) ZSTabPageViewServe *tabPageViewServe;

@end

@implementation ZSCategoryPageViewController

- (ZSTabPageView *)tabPageView {
    
    if (!_tabPageView)
    {
        _tabPageView = [[ZSTabPageView alloc] initWithScrollDirection:UICollectionViewScrollDirectionVertical];
        _tabPageView.tabView.sliderWidth = 2;
        _tabPageView.tabView.sliderAnimation = ZSTabViewSliderAnimationSynchronize;
        _tabPageView.tabView.sliderHidden = NO;
        [self.view addSubview:_tabPageView];
    }
    return _tabPageView;
}

- (ZSTabPageViewServe *)tabPageViewServe {
    
    if (!_tabPageViewServe)
    {
        _tabPageViewServe = [[ZSTabPageViewServe alloc] initWithSelectedIndex:0 bindTabPageView:self.tabPageView registerTabCellClass:ZSTabLabelCollectionViewCell.class];
        _tabPageViewServe.delegate = self;
        _tabPageViewServe.dataSource = self;
        _tabPageViewServe.tabViewServe.tabViewInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tabPageViewServe.tabViewServe.minimumSpacing = 0;
    }
    return _tabPageViewServe;
}

- (NSArray *)tabTexts {
    
    return @[@"0", @"1", @"2", @"3", @"4", @"5", @"6"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        self.tabPageViewServe.tabCount = self.tabTexts.count;
//        [self.tabPageViewServe zs_setSelectedIndex:5];
    });
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    self.tabPageViewServe.tabPageView.frame = self.view.bounds;
}

// ZSPageViewServeDelegate
- (UIView *)zs_pageViewCellForItemAtIndex:(NSInteger)index {
    
    ZSTableViewController *controller = [ZSTableViewController new];
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    return controller.view;
}

- (void)zs_pageViewWillAppearAtIndex:(NSInteger)index {
    
}

- (void)zs_pageViewWillDisappearAtIndex:(NSInteger)index {
    
}

// ZSTabViewServeDataSource
- (void)zs_configTabViewCell:(ZSTabCollectionViewCell *)cell forItemAtIndex:(NSInteger)index {
    
    ZSTabLabelCollectionViewCell *labelCell = (ZSTabLabelCollectionViewCell *)cell;
    
    BOOL isSelected = index == self.tabPageViewServe.selectIndex;
    
    labelCell.lbTitle.text = [self tabTexts][index];
}

- (CGSize)zs_tabViewCellSizeForItemAtIndex:(NSInteger)index {
    
    return CGSizeMake(44, 30 + index * 10);
}

@end
