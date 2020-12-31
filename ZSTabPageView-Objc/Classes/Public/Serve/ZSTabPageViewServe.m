//
//  ZSTabPageViewServe.m
//  ZSTabPageView
//
//  Created by Josh on 2020/12/23.
//

#import "ZSTabPageViewServe.h"

@interface ZSTabPageViewServe ()

/// tab view item 样式Serve
@property (nonatomic, strong) ZSTabViewServe *tabViewServe;

/// page view item 样式 Serve
@property (nonatomic, strong) ZSPageViewServe *pageViewServe;

/// 被绑定的tabPageView
@property (nonatomic, weak) ZSTabPageView *tabPageView;

/// 当前选中的index
@property (nonatomic, assign) NSInteger selectIndex;

@end


@implementation ZSTabPageViewServe

- (instancetype)initWithSelectedIndex:(NSInteger)selectIndex
                      bindTabPageView:(ZSTabPageView *)tabPageView
                    registerCellClass:(Class)cellClass{
    
    if (self = [super init])
    {
        self.selectIndex = selectIndex;
        
        [self zs_configPageViewServe:tabPageView.pageView];
        [self zs_configTabViewServe:tabPageView.tabView tabCellClass:cellClass];
        self.tabPageView = tabPageView;
    }
    return self;
}

- (void)setDelegate:(id<ZSPageViewServeDelegate>)delegate {
    
    self.pageViewServe.delegate = delegate;
}

- (void)setDataSource:(id<ZSTabViewServeDataSource>)dataSource {
    
    self.tabViewServe.dataSource = dataSource;
}

- (void)setTabCount:(NSInteger)tabCount {
    
    _tabCount = tabCount;
    self.selectIndex = self.selectIndex < tabCount ? self.selectIndex : tabCount - 1;
    self.tabViewServe.tabCount = tabCount;
    self.pageViewServe.pageCount = tabCount;
}

- (void)zs_setSelectedIndex:(NSInteger)selectedIndex {
    
    _selectIndex = selectedIndex;
    [self.tabViewServe zs_setSelectedIndex:selectedIndex];
    [self.pageViewServe zs_setSelectedIndex:selectedIndex];
}

- (void)zs_configTabViewServe:(ZSTabView *)tabView
                 tabCellClass:(Class)tabCellClass {
    
    self.tabViewServe = [[ZSTabViewServe alloc] initWithSelectedIndex:self.selectIndex
                                                          bindTabView:tabView
                                                    registerCellClass:tabCellClass];
    self.tabViewServe.delegate = self;
}

- (void)zs_configPageViewServe:(ZSPageView *)pageView {
    
    self.pageViewServe = [[ZSPageViewServe alloc] initWithSelectedIndex:self.selectIndex
                                                           bindPageView:pageView];
    self.pageViewServe.scrollDelegate = self;
}

# pragma mark - ZSPageViewScrollDelegate
- (void)zs_pageScrollView:(UIScrollView *)scrollView didChangeIndex:(NSInteger)index {
    
    if (index < self.tabCount)
    {
        [self zs_setSelectedIndex:index];
    }
}

# pragma mark - ZSTabViewServeDelegate
- (void)zs_tabViewDidSelectItemAtIndex:(NSInteger)index {
    
    [self zs_setSelectedIndex:index];
}

@end
