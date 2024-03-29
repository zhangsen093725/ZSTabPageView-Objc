//
//  ZSPageViewServe.m
//  ZSTabPageView
//
//  Created by Josh on 2020/12/22.
//

#import "ZSPageViewServe.h"
#import "ZSTabPageViewDisplayLink.h"

static const NSInteger __displayLinkCount = 8;

@interface ZSPageViewServe ()

/// ZSPageVie 是否允许 ScrollToIndex
@property (nonatomic, assign) BOOL pageViewScrollToIndexEnable;

/// displayLink
@property (nonatomic, strong) _ZSTabPageViewDisplayLink *displayLink;

/// displayLink Count
@property (nonatomic, assign) NSInteger displayLinkCount;

/// pageView 的 contentView 缓存
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIView *> *cellContentCacheViewMap;

/// 被绑定的pageView
@property (nonatomic, weak) ZSPageView *pageView;

/// 当前选中的index
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation ZSPageViewServe

- (void)dealloc {
    
    self.pageView = nil;
}

- (instancetype)initWithSelectedIndex:(NSInteger)selectIndex
                         bindPageView:(ZSPageView *)pageView {
 
    if (self = [super init])
    {
        self.pageViewScrollToIndexEnable = YES;
        self.displayLinkCount = __displayLinkCount;
        
        self.selectIndex = selectIndex;
        
        pageView.delegate = self;
        pageView.dataSource = self;
        
        [self zs_configPageView:pageView];
        self.pageView = pageView;
    }
    return self;
}

- (NSMutableDictionary<NSNumber *,UIView *> *)cellContentCacheViewMap {
    
    if (!_cellContentCacheViewMap)
    {
        _cellContentCacheViewMap = [NSMutableDictionary dictionary];
    }
    return _cellContentCacheViewMap;
}

- (void)setPageView:(ZSPageView *)pageView {
    
    [_pageView removeObserver:self forKeyPath:@"frame"];
    _pageView = pageView;
    [pageView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    
    if (_selectIndex == selectIndex) { return; }
    
    [self.delegate zs_pageViewWillAppearAtIndex:selectIndex];
    [self.delegate zs_pageViewWillDisappearAtIndex:_selectIndex];
    _selectIndex = selectIndex;
}

- (void)setPageCount:(NSInteger)pageCount {
    
    _pageCount = pageCount;
    
    if (pageCount <= 0)
    {
        self.selectIndex = 0;
    }
    
    [self zs_clearCache];
    [self.pageView reloadData];
    [self zs_setSelectedIndex:self.selectIndex];
}

- (void)setPageViewInset:(UIEdgeInsets)pageViewInset {
    
    _pageViewInset = pageViewInset;
    [self.pageView reloadData];
}

- (void)zs_configPageView:(ZSPageView *)pageView {
    
    [pageView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
}

- (void)zs_clearCache {
    
    [self.cellContentCacheViewMap removeAllObjects];
}

- (void)zs_setSelectedIndex:(NSInteger)selectedIndex {
    
    [self zs_setSelectedIndex:selectedIndex animation:NO];
}

- (void)zs_setSelectedIndex:(NSInteger)selectedIndex animation:(BOOL)isAnimation {
    
    if (self.pageCount <= 0) { return; }
    
    NSInteger index = selectedIndex > 0 ? selectedIndex : 0;
    index = index < self.pageCount ? index : self.pageCount - 1;
    
    self.selectIndex = index;
    
    if (self.pageViewScrollToIndexEnable == NO) { return; }
    
    [self.pageView zs_setSelectedIndex:index animation:isAnimation];
    [self.pageView layoutIfNeeded];
    
    [self stopDisplayLink];
    self.displayLinkCount = __displayLinkCount;
    [self startDisplayLink];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    if (object == self.pageView)
    {
        CGRect new = [change[NSKeyValueChangeNewKey] CGRectValue];
        CGRect old = [change[NSKeyValueChangeOldKey] CGRectValue];
        
        if (CGRectEqualToRect(new, old)) { return; }
        
        [self zs_setSelectedIndex:_selectIndex];
    }
}

# pragma mark - DisplayLink
- (void)startDisplayLink {
    
    if (self.displayLink != nil) { return; }

    __weak typeof(self)weak_self = self;
    self.displayLink = [[_ZSTabPageViewDisplayLink alloc] init:60 block:^(CADisplayLink * _Nonnull displayLink) {
        
        [weak_self runDisplayLink];
    }];
}

- (void)runDisplayLink {
    
    self.displayLinkCount -= 1;
    
    if (self.displayLinkCount <= 0)
    {
        [self zs_showCellContentCacheView];
        [self stopDisplayLink];
    }
}

- (void)stopDisplayLink {
    
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)zs_showCellContentCacheView {
    
    UICollectionViewCell *cell = [self.pageView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_selectIndex inSection:0]];
    
    if (cell == nil) { return; }
    
    UIView *view = self.cellContentCacheViewMap[@(_selectIndex)];
    
    if (view == nil)
    {
        view = [self.dataSource zs_pageViewCellForItemAtIndex:_selectIndex];
        [_cellContentCacheViewMap setObject:view forKey:@(_selectIndex)];
    }
    
    [self zs_cellContentView:cell.contentView layoutCaCheViewForIndex:_selectIndex];
}


- (void)zs_cellContentView:(UIView *)contentView layoutCaCheViewForIndex:(NSInteger)index {
    
    UIView *view = self.cellContentCacheViewMap[@(index)];
    
    [contentView addSubview:view];
    
    if ([self.dataSource respondsToSelector:@selector(zs_pageViewCellFrameForItemAtIndex:superView:)])
    {
        view.frame = [self.dataSource zs_pageViewCellFrameForItemAtIndex:index superView:contentView];
    }
    else
    {
        view.frame = contentView.bounds;
    }
    
    view.hidden = NO;
}

# pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)])
    {
        [self.delegate scrollViewDidScroll:scrollView];
    }
    
    if (self.pageViewScrollToIndexEnable == YES) { return; }
    
    NSInteger page = 0;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.pageView.collectionViewLayout;
    
    if (flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        page = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame) + 0.5;
    }
    else
    {
        page = scrollView.contentOffset.y / CGRectGetHeight(scrollView.frame) + 0.5;
    }
    
    if (self.selectIndex == page) { return; }
    
    if ([self.delegate respondsToSelector:@selector(zs_pageScrollView:didChangeIndex:)])
    {
        [self.delegate zs_pageScrollView:scrollView didChangeIndex:page];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    [self stopDisplayLink];
    self.displayLinkCount = __displayLinkCount;
    self.pageViewScrollToIndexEnable = NO;
    
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
    {
        [self.delegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self startDisplayLink];
    self.pageViewScrollToIndexEnable = YES;
    
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
    {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
 
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
    {
        [self.delegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
    {
        [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}


# pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.pageCount;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    
    cell.exclusiveTouch = YES;
    cell.contentView.frame = cell.bounds;
    
    for (UIView *subView in cell.contentView.subviews)
    {
        subView.hidden = YES;
        [subView removeFromSuperview];
    }
    
    [self zs_cellContentView:cell.contentView layoutCaCheViewForIndex:indexPath.item];
    
    return cell;
}


# pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = CGRectGetWidth(collectionView.bounds) - _pageViewInset.left - _pageViewInset.right;
    CGFloat height = CGRectGetHeight(collectionView.bounds) - _pageViewInset.top - _pageViewInset.bottom;
    
    return (width > 0 && height > 0) ? CGSizeMake(width, height) : CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return self.pageViewInset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}


@end
