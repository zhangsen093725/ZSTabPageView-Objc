//
//  ZSTabSectionPageServe.m
//  ZSTabPageView
//
//  Created by Josh on 2020/12/28.
//

#import "ZSTabSectionPageServe.h"
#import "ZSTabLabelCollectionViewCell.h"

@interface ZSTabSectionPageServe ()

/// tab view item 样式Serve
@property (nonatomic, strong) ZSTabViewServe *tabViewServe;

/// page view item 样式 Serve
@property (nonatomic, strong) ZSPageViewServe *pageViewServe;

/// 当前选中的index
@property (nonatomic, assign) NSInteger selectIndex;

@end


@implementation ZSTabSectionPageServe

- (ZSTabPagePlainDidScrollHandle)tabPagePlainDidScrollHandle {
    
    __weak typeof(self)weak_self = self;
    return ^CGPoint(UIScrollView * _Nonnull scrollView, CGPoint cacheContentOffset) {
        
        if (weak_self.isShouldPageScroll == NO)
        {
            scrollView.contentOffset = cacheContentOffset;
            return cacheContentOffset;
        }
        
        if (scrollView.contentOffset.y <= 0)
        {
            weak_self.shouldBaseScroll = YES;
            weak_self.shouldPageScroll = NO;
            scrollView.contentOffset = CGPointZero;
            return CGPointZero;
        }
        
        return scrollView.contentOffset;
    };
}

- (void)setDataSource:(id<ZSTabSectionPageServeDataSource>)dataSource {
    
    self.tabViewServe.dataSource = dataSource;
    self.pageViewServe.dataSource = dataSource;
}

- (void)setTabCount:(NSInteger)tabCount {
    
    _tabCount = tabCount;
    
    if (tabCount > 0)
    {
        self.selectIndex = self.selectIndex < tabCount ? self.selectIndex : tabCount - 1;
    }
    else
    {
        self.selectIndex = 0;
    }
    
    self.tabViewServe.tabCount = tabCount;
    self.pageViewServe.pageCount = tabCount;
}

- (void)zs_setSelectedIndex:(NSInteger)selectedIndex {
    
    _selectIndex = selectedIndex;
    [self.tabViewServe zs_setSelectedIndex:selectedIndex];
    [self.pageViewServe zs_setSelectedIndex:selectedIndex];
}

- (void)zs_bindTabView:(ZSTabView *)tabView registerTabCellClass:(Class)tabCellClass {
    
    self.tabViewServe = [[ZSTabViewServe alloc] initWithSelectedIndex:self.selectIndex
                                                          bindTabView:tabView
                                                    registerTabCellClass:tabCellClass];
    self.tabViewServe.delegate = self;
}

- (void)zs_bindPageView:(ZSPageView *)pageView{
    
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
    
    if (CGSizeEqualToSize(scrollView.contentSize, CGSizeZero)) { return; }
    
    if (scrollView.contentOffset.x >= 0)
    {
        self.shouldPageScroll = !self.isShouldBaseScroll;
        return;
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
