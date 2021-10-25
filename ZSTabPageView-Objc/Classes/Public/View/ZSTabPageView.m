//
//  ZSTabPageView.m
//  Pods-ZSTabPageView_Example
//
//  Created by Josh on 2020/12/23.
//

#import "ZSTabPageView.h"

@interface ZSTabPageView ()

/// 滚动方向，default UICollectionViewScrollDirectionHorizontal
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

/// tabView
@property (nonatomic, strong) ZSTabView *tabView;

/// pageView
@property (nonatomic, strong) ZSPageView *pageView;

/// spaceView
@property (nonatomic, strong) UIImageView *spaceView;

@end

@implementation ZSTabPageView

- (instancetype)initWithScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    
    if (self = [super init])
    {
        self.scrollDirection = scrollDirection;
        self.tabViewHeight = 44;
        self.spaceViewHeight = 0.5;
    }
    return self;
}

- (ZSTabView *)tabView {
    
    if (!_tabView)
    {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.scrollDirection = self.scrollDirection;
        
        _tabView = [[ZSTabView alloc] initWithFlowLayout:flowLayout];
        
        if (@available(iOS 11.0, *)) {
            _tabView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        _tabView.backgroundColor = [UIColor clearColor];
        
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
        {
            _tabView.sliderVerticalAlignment = ZSTabViewSliderVerticalBottom;
            _tabView.sliderHorizontalAlignment = ZSTabViewSliderHorizontalCenter;
            _tabView.showsHorizontalScrollIndicator = NO;
        }
        else
        {
            _tabView.sliderVerticalAlignment = ZSTabViewSliderVerticalCenter;
            _tabView.sliderHorizontalAlignment = ZSTabViewSliderHorizontalLeft;
            _tabView.showsHorizontalScrollIndicator = NO;
        }
        
        [self insertSubview:_tabView atIndex:0];
    }
    return _tabView;
}

- (UIImageView *)spaceView {
    
    if (!_spaceView)
    {
        _spaceView = [UIImageView new];
        _spaceView.backgroundColor = [[UIColor systemGrayColor] colorWithAlphaComponent:0.5];
        [self addSubview:_spaceView];
    }
    return _spaceView;
}

- (ZSPageView *)pageView {
    
    if (!_pageView)
    {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.scrollDirection = self.scrollDirection;
        
        _pageView = [[ZSPageView alloc] initWithFlowLayout:flowLayout];
        
        if (@available(iOS 11.0, *)) {
            _pageView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        _pageView.backgroundColor = [UIColor clearColor];
        
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
        {
            _pageView.scrollEnabled = YES;
            _pageView.showsHorizontalScrollIndicator = NO;
        }
        else
        {
            _pageView.scrollEnabled = NO;
            _pageView.showsVerticalScrollIndicator = NO;
        }
        
        [self insertSubview:_pageView atIndex:0];
    }
    return _pageView;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        self.tabView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.tabViewHeight);
        self.spaceView.frame = CGRectMake(self.spaceViewInsets.left, CGRectGetMaxY(self.tabView.frame) + self.spaceViewInsets.top - self.spaceViewInsets.bottom, CGRectGetWidth(self.bounds) - self.spaceViewInsets.left - self.spaceViewInsets.right, self.spaceViewHeight);
        
        CGFloat pageViewY = self.spaceViewHeight > 1 ? CGRectGetMaxY(self.spaceView.frame) : CGRectGetMaxY(self.tabView.frame);
        self.pageView.frame = CGRectMake(0, pageViewY, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - pageViewY);
    }
    else
    {
        self.tabView.frame = CGRectMake(0, 0, self.tabViewHeight, CGRectGetHeight(self.bounds));
        self.spaceView.frame = CGRectMake(CGRectGetMaxX(self.tabView.frame) + self.spaceViewInsets.left - self.spaceViewInsets.right, self.spaceViewInsets.top, self.spaceViewHeight, CGRectGetHeight(self.bounds) - self.spaceViewInsets.top - self.spaceViewInsets.bottom);
        
        CGFloat pageViewX = self.spaceViewHeight > 1 ? CGRectGetMaxY(self.spaceView.frame) : CGRectGetMaxY(self.tabView.frame);
        self.pageView.frame = CGRectMake(pageViewX, 0, CGRectGetWidth(self.bounds) - pageViewX, CGRectGetHeight(self.bounds));
    }
}


- (void)setTabViewHeight:(CGFloat)tabViewHeight {
    
    _tabViewHeight = tabViewHeight;
    [self layoutSubviews];
}

- (void)setSpaceViewHeight:(CGFloat)spaceViewHeight {
    
    _spaceViewHeight = spaceViewHeight;
    [self layoutSubviews];
}

- (void)setSpaceViewInsets:(UIEdgeInsets)spaceViewInsets {
    
    _spaceViewInsets = spaceViewInsets;
    [self layoutSubviews];
}



@end
