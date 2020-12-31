//
//  ZSTabSectionPageServe.h
//  ZSTabPageView
//
//  Created by Josh on 2020/12/28.
//

#import "ZSTabView.h"
#import "ZSPageView.h"
#import "ZSTabViewServe.h"
#import "ZSPageViewServe.h"

NS_ASSUME_NONNULL_BEGIN

typedef CGPoint (^ZSTabPagePlainDidScrollHandle) (UIScrollView *scrollView, CGPoint cacheContentOffset);

@interface ZSTabSectionPageServe : NSObject<ZSTabViewServeDelegate, ZSPageViewScrollDelegate>

+ (instancetype)new NS_UNAVAILABLE;

/// tab view item 样式Serve
@property (nonatomic, strong, readonly) ZSTabViewServe *tabViewServe;

/// page view item 样式 Serve
@property (nonatomic, strong, readonly) ZSPageViewServe *pageViewServe;

/// 当前选中的index
@property (nonatomic, assign, readonly) NSInteger selectIndex;

/// ZSPageViewServeDelegate
@property (nonatomic, weak) id<ZSPageViewServeDelegate> delegate;

/// ZSTabViewServeDataSource
@property (nonatomic, weak) id<ZSTabViewServeDataSource> dataSource;

/// tab count
@property (nonatomic, assign) NSInteger tabCount;


/// tabView 的高度, default 44
@property (nonatomic, assign) CGFloat tabViewHeight;

/// section 是否开启悬浮, default YES
@property (nonatomic, assign, getter=isSectionFloatEnable) BOOL sectionFloatEnable;

/// base view 是否可以滚动, default YES
@property (nonatomic, assign, getter=isShouldBaseScroll) BOOL shouldBaseScroll;

/// tab page 是否可以滚动, default NO
@property (nonatomic, assign, getter=isShouldPageScroll) BOOL shouldPageScroll;

/// pageView 的 cell 中如果是 UIScrollView，需要添加 UIScrollView DidScroll 代理的回调
@property (nonatomic, copy, readonly) ZSTabPagePlainDidScrollHandle tabPagePlainDidScrollHandle;

/// 配置 TabViewServe 绑定 tabView
/// @param tabView tabView
/// @param tabCellClass tabCellClass 复用的cellClass，必须是ZSTabCollectionViewCell的子类
- (void)zs_bindTabView:(ZSTabView *)tabView tabCellClass:(Class)tabCellClass;

/// 配置PageViewServe 绑定 pageView
/// @param pageView pageView
- (void)zs_bindPageView:(ZSPageView *)pageView;

/// 设置 selectedIndex
/// @param selectedIndex selectedIndex
- (void)zs_setSelectedIndex:(NSInteger)selectedIndex;

@end

NS_ASSUME_NONNULL_END
