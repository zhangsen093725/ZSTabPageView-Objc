//
//  ZSTabViewServe.m
//  Pods-ZSTabPageView_Example
//
//  Created by Josh on 2020/12/22.
//

#import "ZSTabViewServe.h"

@interface ZSTabViewServe ()

/// 被绑定的tabView
@property (nonatomic, weak) ZSTabView *tabView;

/// 当前选中的index
@property (nonatomic, assign) NSInteger selectIndex;

/// register cellClass
@property (nonatomic, weak) Class cellClass;

@end

@implementation ZSTabViewServe

- (instancetype)initWithSelectedIndex:(NSInteger)selectIndex
                          bindTabView:(ZSTabView *)tabView
                    registerTabCellClass:(Class)cellClass {
    
    if (self = [super init])
    {
        self.selectIndex = selectIndex;
        tabView.delegate = self;
        tabView.dataSource = self;
        [tabView registerClass:cellClass forCellWithReuseIdentifier:[cellClass zs_identifier]];
        self.tabView = tabView;
        self.cellClass = cellClass;
    }
    return self;
}

- (void)setTabCount:(NSInteger)tabCount {
    
    _tabCount = tabCount;
    [self.tabView reloadData];
    if (tabCount > 0)
    {
        self.selectIndex = self.selectIndex < tabCount ? self.selectIndex : tabCount - 1;
        [self.tabView ty_setSelectedIndex:self.selectIndex animation:NO];
    }
    else
    {
        self.selectIndex = 0;
    }
}

- (void)setMinimumSpacing:(CGFloat)minimumSpacing {
    
    _minimumSpacing = minimumSpacing;
    [self.tabView reloadData];
}

- (void)setTabViewInset:(UIEdgeInsets)tabViewInset {
    
    _tabViewInset = tabViewInset;
    [self.tabView reloadData];
}

- (void)setTabView:(ZSTabView *)tabView {
    
    [_tabView removeObserver:self forKeyPath:@"frame"];
    _tabView = tabView;
    [tabView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)zs_setSelectedIndex:(NSInteger)selectedIndex {
    
    if (self.tabCount <= 0) { return; }
    
    NSInteger index = selectedIndex > 0 ? selectedIndex : 0;
    index = index < self.tabCount ? index : self.tabCount - 1;
    
    self.selectIndex = index;
    
    [self.tabView zs_setSelectedIndex:index animation:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    if (object == self.tabView)
    {
        CGRect new = [change[NSKeyValueChangeNewKey] CGRectValue];
        CGRect old = [change[NSKeyValueChangeOldKey] CGRectValue];
        
        if (CGRectEqualToRect(new, old)) { return; }
        
        [self zs_setSelectedIndex:_selectIndex];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.tabCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZSTabCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[_cellClass zs_identifier] forIndexPath:indexPath];
    
    [self.dataSource zs_configTabViewCell:cell forItemAtIndex:indexPath.item];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.dataSource zs_tabViewCellSizeForItemAtIndex:indexPath.item];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return _tabViewInset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return _minimumSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return _minimumSpacing;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate zs_tabViewDidSelectItemAtIndex:indexPath.item];
}

@end
