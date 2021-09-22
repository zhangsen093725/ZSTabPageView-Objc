//
//  ZSTabPageViewServe.h
//  ZSTabPageView
//
//  Created by Josh on 2020/12/23.
//

#import "ZSTabPageView.h"
#import "ZSTabViewServe.h"
#import "ZSPageViewServe.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZSTabPageViewServeDelegate <ZSTabViewServeDelegate, ZSPageViewServeDelegate>

@end


@protocol ZSTabPageViewServeDataSource <ZSTabViewServeDataSource, ZSPageViewServeDataSource>


@end


@interface ZSTabPageViewServe : NSObject<ZSTabViewServeDelegate, ZSPageViewServeDelegate, ZSPageViewServeDataSource>

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/// 初始化方法
/// @param selectIndex 初始状态的默认选中
/// @param tabPageView 与serve绑定的tabPageView
- (instancetype)initWithSelectedIndex:(NSInteger)selectIndex
                      bindTabPageView:(ZSTabPageView *)tabPageView
                    registerTabCellClass:(Class)cellClass;

/// tab view item 样式Serve
@property (nonatomic, strong, readonly) ZSTabViewServe *tabViewServe;

/// page view item 样式 Serve
@property (nonatomic, strong, readonly) ZSPageViewServe *pageViewServe;

/// 被绑定的tabPageView
@property (nonatomic, weak, readonly) ZSTabPageView *tabPageView;

/// 当前选中的index
@property (nonatomic, assign, readonly) NSInteger selectIndex;

/// ZSPageViewServeDelegate
@property (nonatomic, weak) id<ZSTabPageViewServeDelegate> delegate;

/// ZSTabViewServeDataSource
@property (nonatomic, weak) id<ZSTabPageViewServeDataSource> dataSource;

/// tab count
@property (nonatomic, assign) NSInteger tabCount;

/// 设置 selectedIndex
/// @param selectedIndex selectedIndex
- (void)zs_setSelectedIndex:(NSInteger)selectedIndex;
- (void)zs_setSelectedIndex:(NSInteger)selectedIndex tabAnimation:(BOOL)isTabAnimation pageAnimation:(BOOL)isPageAnimation;

/// 配置TabViewServe
/// @param tabView tabView
/// @param tabCellClass 复用的cellClass，必须是ZSTabCollectionViewCell的子类
- (void)zs_configTabViewServe:(ZSTabView *)tabView
                 tabCellClass:(Class)tabCellClass;

/// 配置PageViewServe
/// @param pageView pageView
- (void)zs_configPageViewServe:(ZSPageView *)pageView;

@end

NS_ASSUME_NONNULL_END
