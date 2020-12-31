//
//  ZSTabPageView.h
//  Pods-ZSTabPageView_Example
//
//  Created by Josh on 2020/12/23.
//

#import "ZSTabView.h"
#import "ZSPageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZSTabPageView : UIView

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

/// 初始化方法
/// @param scrollDirection 滚动方向
- (instancetype)initWithScrollDirection:(UICollectionViewScrollDirection)scrollDirection;

/// 当 scrollDirection = horizontal 时， tabViewHeight 表示 tabView 的高度，default = 44
/// 当 scrollDirection = vertical 时， tabViewHeight 表示 tabView 的宽度，default = 44
@property (nonatomic, assign) CGFloat tabViewHeight;

/// 当 scrollDirection = horizontal 时， spaceViewHeight 表示 spaceView 的高度，default = 0.5
/// 当 scrollDirection = vertical 时， spaceViewHeight 表示 spaceView 的宽度，default = 0.5
@property (nonatomic, assign) CGFloat spaceViewHeight;

/// spaceView 的 Insets，default UIEdgeInsetsZero
@property (nonatomic, assign) UIEdgeInsets spaceViewInsets;

/// 滚动方向，default UICollectionViewScrollDirectionHorizontal
@property (nonatomic, assign, readonly) UICollectionViewScrollDirection scrollDirection;

/// tabView
@property (nonatomic, strong, readonly) ZSTabView *tabView;

/// pageView
@property (nonatomic, strong, readonly) ZSPageView *pageView;

/// spaceView
@property (nonatomic, strong, readonly) UIImageView *spaceView;

@end

NS_ASSUME_NONNULL_END
