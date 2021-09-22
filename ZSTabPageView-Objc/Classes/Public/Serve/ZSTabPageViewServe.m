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
                    registerTabCellClass:(Class)cellClass{
    
    if (self = [super init])
    {
        self.selectIndex = selectIndex;
        
        [self zs_configPageViewServe:tabPageView.pageView];
        [self zs_configTabViewServe:tabPageView.tabView tabCellClass:cellClass];
        self.tabPageView = tabPageView;
    }
    return self;
}

- (void)setDataSource:(id<ZSTabPageViewServeDataSource>)dataSource {
    
    self.pageViewServe.dataSource = dataSource;
    self.tabViewServe.dataSource = dataSource;
}

- (void)setTabCount:(NSInteger)tabCount {
    
    _tabCount = tabCount;
    
    self.tabViewServe.tabCount = tabCount;
    self.pageViewServe.pageCount = tabCount;
    
    if (tabCount > 0)
    {
        self.selectIndex = self.selectIndex < tabCount ? self.selectIndex : tabCount - 1;
    }
    else
    {
        self.selectIndex = 0;
    }
}

- (void)zs_setSelectedIndex:(NSInteger)selectedIndex {
    
    [self zs_setSelectedIndex:selectedIndex tabAnimation:YES pageAnimation:NO];
}

- (void)zs_setSelectedIndex:(NSInteger)selectedIndex tabAnimation:(BOOL)isTabAnimation pageAnimation:(BOOL)isPageAnimation {
    
    _selectIndex = selectedIndex;
    [self.tabViewServe zs_setSelectedIndex:selectedIndex animation:isTabAnimation];
    [self.pageViewServe zs_setSelectedIndex:selectedIndex animation:isPageAnimation];
}

- (void)zs_configTabViewServe:(ZSTabView *)tabView
                 tabCellClass:(Class)tabCellClass {
    
    self.tabViewServe = [[ZSTabViewServe alloc] initWithSelectedIndex:self.selectIndex
                                                          bindTabView:tabView
                                                    registerTabCellClass:tabCellClass];
    self.tabViewServe.delegate = self;
}

- (void)zs_configPageViewServe:(ZSPageView *)pageView {
    
    self.pageViewServe = [[ZSPageViewServe alloc] initWithSelectedIndex:self.selectIndex
                                                           bindPageView:pageView];
    self.pageViewServe.delegate = self;
}

# pragma mark - ZSPageViewScrollDelegate
- (void)zs_pageScrollView:(UIScrollView *)scrollView didChangeIndex:(NSInteger)index {
    
    if (index < self.tabCount)
    {
        [self zs_setSelectedIndex:index];
    }
    
    if ([self.delegate respondsToSelector:@selector(zs_pageScrollView:didChangeIndex:)])
    {
        [self.delegate zs_pageScrollView:scrollView didChangeIndex:index];
    }
}

- (void)zs_pageViewWillDisappearAtIndex:(NSInteger)index {
    
    if ([self.delegate respondsToSelector:@selector(zs_pageViewWillDisappearAtIndex:)])
    {
        [self.delegate zs_pageViewWillDisappearAtIndex:index];
    }
}

- (void)zs_pageViewWillAppearAtIndex:(NSInteger)index {
 
    if ([self.delegate respondsToSelector:@selector(zs_pageViewWillAppearAtIndex:)])
    {
        [self.delegate zs_pageViewWillAppearAtIndex:index];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {

    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
    {
        [self.delegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
    {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
 
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
    {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
    {
        [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

# pragma mark - ZSTabViewServeDelegate
- (void)zs_tabViewDidSelectItemAtIndex:(NSInteger)index {
    
    [self zs_setSelectedIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(zs_tabViewDidSelectItemAtIndex:)])
    {
        [self.delegate zs_tabViewDidSelectItemAtIndex:index];
    }
}

@end
