//
//  ZSTabPageSectionViewController.m
//  ZSTabPageView_Example
//
//  Created by Josh on 2020/12/29.
//  Copyright © 2020 zhangsen093725. All rights reserved.
//

#import "ZSTabPageSectionViewController.h"
#import "ZSTableViewController.h"

@interface ZSTabPageSectionViewController ()<ZSPageViewServeDelegate, ZSTabViewServeDataSource>

@property (nonatomic, strong) ZSTabSectionPageTableView *tableView;
@property (nonatomic, strong) ZSTabSectionPageTableViewServe *tabPageViewServe;

@property (nonatomic, strong) ZSTabView *tabView;
@property (nonatomic, strong) ZSPageView *pageView;
@end

@implementation ZSTabPageSectionViewController

- (ZSTabSectionPageTableView *)tableView {
    
    if (!_tableView)
    {
        _tableView = [[ZSTabSectionPageTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        if (@available(iOS 11.0, *))
        {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        UILabel *header = [UILabel new];
        header.text = @"头部View";
        header.textAlignment = NSTextAlignmentCenter;
        header.frame = CGRectMake(0, 0, 0, 200);
        
        _tableView.tableHeaderView = header;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (ZSTabSectionPageTableViewServe *)tabPageViewServe {
    
    if (!_tabPageViewServe)
    {
        _tabPageViewServe = [[ZSTabSectionPageTableViewServe alloc] initWithSelectedIndex:0
                                                                            bindTableView:self.tableView
                                                                                  tabView:self.tabView
                                                                             tabCellClass:ZSTabLabelCollectionViewCell.class
                                                                                 pageView:self.pageView];
        _tabPageViewServe.delegate = self;
        _tabPageViewServe.dataSource = self;
        _tabPageViewServe.sectionFloatEnable = NO;
        _tabPageViewServe.tabViewServe.tabViewInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return _tabPageViewServe;
}

- (ZSTabView *)tabView {
    
    if (!_tabView)
    {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _tabView = [[ZSTabView alloc] initWithFlowLayout:flowLayout];
        
        if (@available(iOS 11.0, *)) {
            _tabView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        _tabView.backgroundColor = [UIColor clearColor];
        _tabView.sliderVerticalAlignment = ZSTabViewSliderVerticalBottom;
        _tabView.sliderHorizontalAlignment = ZSTabViewSliderHorizontalCenter;
        _tabView.showsHorizontalScrollIndicator = NO;
    }
    return _tabView;
}

- (ZSPageView *)pageView {
    
    if (!_pageView)
    {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _pageView = [[ZSPageView alloc] initWithFlowLayout:flowLayout];
        
        if (@available(iOS 11.0, *)) {
            _pageView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        _pageView.backgroundColor = [UIColor clearColor];
        _pageView.scrollEnabled = YES;
        _pageView.showsHorizontalScrollIndicator = NO;
    }
    return _pageView;
}

- (NSArray *)tabTexts {
    
    return @[@"0", @"1", @"2", @"3", @"4", @"5", @"6"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        self.tabPageViewServe.tabCount = self.tabTexts.count;
        [self.tabPageViewServe zs_setSelectedIndex:5];
    });
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

// ZSPageViewServeDelegate
- (UIView *)zs_pageViewCellForItemAtIndex:(NSInteger)index {
    
    ZSTableViewController *controller = [ZSTableViewController new];
    controller.didScrollViewHandle = self.tabPageViewServe.tabPagePlainDidScrollHandle;
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
    
    return CGSizeMake(30 + index * 10, self.tabPageViewServe.tabViewHeight);
}

@end
