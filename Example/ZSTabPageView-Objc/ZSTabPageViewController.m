//
//  ZSTabPageViewController.m
//  ZSTabPageView_Example
//
//  Created by Josh on 2020/12/23.
//  Copyright © 2020 zhangsen093725. All rights reserved.
//

#import "ZSTabPageViewController.h"
#import "ZSTableViewController.h"

#import "ZSTabPageViewServe.h"
#import "ZSTabLabelCollectionViewCell.h"

@interface ZSTabPageViewController ()<ZSTabPageViewServeDelegate, ZSTabPageViewServeDataSource>

@property (nonatomic, strong) ZSTabPageView *tabPageView;

@property (nonatomic, strong) ZSTabPageViewServe *tabPageViewServe;

@end

@implementation ZSTabPageViewController

- (ZSTabPageView *)tabPageView {
    
    if (!_tabPageView)
    {
        _tabPageView = [[ZSTabPageView alloc] initWithScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _tabPageView.tabView.sliderView.image = [UIImage imageNamed:@"ic_tab_selected"];
        _tabPageView.tabView.sliderView.backgroundColor = [UIColor clearColor];
        _tabPageView.tabView.sliderHeight = 14;
        _tabPageView.tabView.sliderWidth = 24;
        _tabPageView.tabView.sliderAnimation = ZSTabViewSliderAnimationSynchronize;
        _tabPageView.tabView.sliderVerticalAlignment = ZSTabViewSliderVerticalBottom;
        _tabPageView.tabView.sliderHorizontalAlignment = ZSTabViewSliderHorizontalRight;
        _tabPageView.tabView.sliderInset = UIEdgeInsetsMake(0, 0, 10, 0);
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
        _tabPageViewServe.tabViewServe.tabViewInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _tabPageViewServe.tabViewServe.minimumSpacing = 18;
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
    
    return CGSizeMake(30 + index * 10, 20);
}

@end
