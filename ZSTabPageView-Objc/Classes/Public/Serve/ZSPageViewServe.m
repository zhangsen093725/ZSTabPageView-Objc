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

/// TYPageVie 是否允许 ScrollToIndex
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
    [self zs_clearCache];
    [self.pageView reloadData];
    [self zs_setSelectedIndex:self.selectIndex];
}

- (void)zs_configPageView:(ZSPageView *)pageView {
    
    [pageView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
}

- (void)zs_clearCache {
    
    [self.cellContentCacheViewMap removeAllObjects];
}

- (void)zs_setSelectedIndex:(NSInteger)selectedIndex {
    
    if (self.pageCount <= 0) { return; }
    
    NSInteger index = selectedIndex > 0 ? selectedIndex : 0;
    index = index < self.pageCount ? index : self.pageCount - 1;
    
    self.selectIndex = index;
    
    if (self.pageViewScrollToIndexEnable == NO) { return; }
    
    [self.pageView zs_setSelectedIndex:index animation:NO];
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
        [self ty_showCellContentCacheView];
        [self stopDisplayLink];
    }
}

- (void)stopDisplayLink {
    
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)ty_showCellContentCacheView {
    
    UICollectionViewCell *cell = [self.pageView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectIndex inSection:0]];
    
    if (cell == nil) { return; }
    
    UIView *view = self.cellContentCacheViewMap[@(_selectIndex)];
    
    if (view == nil)
    {
        view = [self.delegate zs_pageViewCellForItemAtIndex:_selectIndex];
        [_cellContentCacheViewMap setObject:view forKey:@(_selectIndex)];
        [cell.contentView addSubview:view];
    }
    
    view.frame = cell.contentView.bounds;
}

# pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([self.scrollDelegate respondsToSelector:@selector(zs_pageViewDidScroll:)])
    {
        [self.scrollDelegate zs_pageViewDidScroll:scrollView];
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
    
    if ([self.scrollDelegate respondsToSelector:@selector(zs_pageScrollView:didChangeIndex:)])
    {
        [self.scrollDelegate zs_pageScrollView:scrollView didChangeIndex:page];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    [self stopDisplayLink];
    self.displayLinkCount = __displayLinkCount;
    self.pageViewScrollToIndexEnable = NO;
    
    if ([self.scrollDelegate respondsToSelector:@selector(zs_pageViewWillBeginDecelerating:)])
    {
        [self.scrollDelegate zs_pageViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self startDisplayLink];
    self.pageViewScrollToIndexEnable = YES;
    
    if ([self.scrollDelegate respondsToSelector:@selector(zs_pageViewDidEndDecelerating:)])
    {
        [self.scrollDelegate zs_pageViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
 
    if ([self.scrollDelegate respondsToSelector:@selector(zs_pageViewWillBeginDragging:)])
    {
        [self.scrollDelegate zs_pageViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if ([self.scrollDelegate respondsToSelector:@selector(zs_pageViewDidEndDragging:willDecelerate:)])
    {
        [self.scrollDelegate zs_pageViewDidEndDragging:scrollView willDecelerate:decelerate];
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
    
    UIView *view = self.cellContentCacheViewMap[@(indexPath.item)];
    
    if (view != nil)
    {
        [cell.contentView addSubview:view];
        view.hidden = NO;
        view.frame = cell.contentView.bounds;
    }
    
    return cell;
}


# pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return collectionView.bounds.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}


@end
