//
//  ZSTabViewServe.h
//  Pods-ZSTabPageView_Example
//
//  Created by Josh on 2020/12/22.
//

#import "ZSTabView.h"
#import "ZSTabCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZSTabViewServeDelegate <NSObject>

/// tabView 点击回调
/// @param index 当前点击的索引
- (void)zs_tabViewDidSelectItemAtIndex:(NSInteger)index;

@end


@protocol ZSTabViewServeDataSource <NSObject>

/// 配置 tabView 的 cell size
/// @param index 当前Cell的索引
- (CGSize)zs_tabViewCellSizeForItemAtIndex:(NSInteger)index;

/// 配置 tabView 的 cell 属性
/// @param cell 当前的Cell
/// @param index 当前Cell的索引
- (void)zs_configTabViewCell:(ZSTabCollectionViewCell *)cell forItemAtIndex:(NSInteger)index;

@end


@interface ZSTabViewServe : NSObject<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/// 初始化方法
/// @param selectIndex 初始状态的默认选中
/// @param tabView 与serve绑定的tabView
/// @param cellClass 复用的cellClass，必须是ZSTabCollectionViewCell的子类
- (instancetype)initWithSelectedIndex:(NSInteger)selectIndex
                          bindTabView:(ZSTabView *)tabView
                    registerTabCellClass:(Class)cellClass;

/// tab count
@property (nonatomic, assign) NSInteger tabCount;

/// tab 之间的间隙
@property (nonatomic, assign) CGFloat minimumSpacing;

/// tab insert
@property (nonatomic, assign) UIEdgeInsets tabViewInset;

/// register cellClass
@property (nonatomic, weak, readonly) Class cellClass;

/// 被绑定的tabView
@property (nonatomic, weak, readonly) ZSTabView *tabView;

/// 当前选中的index
@property (nonatomic, assign, readonly) NSInteger selectIndex;

/// ZSTabViewServeDelegate
@property (nonatomic, weak) id<ZSTabViewServeDelegate> delegate;

/// ZSTabViewServeDataSource
@property (nonatomic, weak) id<ZSTabViewServeDataSource> dataSource;

/// 设置 selectedIndex
/// @param selectedIndex selectedIndex
- (void)zs_setSelectedIndex:(NSInteger)selectedIndex;
- (void)zs_setSelectedIndex:(NSInteger)selectedIndex animation:(BOOL)isAnimation;

@end

NS_ASSUME_NONNULL_END
