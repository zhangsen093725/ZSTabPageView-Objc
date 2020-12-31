//
//  ZSPageViewServe.h
//  ZSTabPageView
//
//  Created by Josh on 2020/12/22.
//

#import "ZSPageView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZSPageViewServeDelegate <NSObject>

/// Page 需要展示的View
/// @param index 当前Page的索引
- (UIView *)zs_pageViewCellForItemAtIndex:(NSInteger)index;

/// Page 将要消失
/// @param index 将要消失的索引
- (void)zs_pageViewWillDisappearAtIndex:(NSInteger)index;

/// Page 将要显示
/// @param index 将要显示的索引
- (void)zs_pageViewWillAppearAtIndex:(NSInteger)index;

@end


@protocol ZSPageViewScrollDelegate <NSObject>

@optional

/// scrollView 滚动的回调
/// @param scrollView 当前滚动的ScrollView
- (void)zs_pageViewDidScroll:(UIScrollView *)scrollView;

/// scrollView 将要滚动，手指放上
/// @param scrollView 当前滚动的ScrollView
- (void)zs_pageViewWillBeginDecelerating:(UIScrollView *)scrollView;

/// scrollView 滚动结束，手指离开
/// @param scrollView 当前滚动的ScrollView
- (void)zs_pageViewDidEndDecelerating:(UIScrollView *)scrollView;

/// Page 改变index
/// @param scrollView scrollView
/// @param index 改变后的索引
- (void)zs_pageScrollView:(UIScrollView *)scrollView didChangeIndex:(NSInteger)index;

@end


@interface ZSPageViewServe : NSObject<UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/// 初始化方法
/// @param selectIndex 初始状态的默认选中
/// @param pageView 与serve绑定的pageView
- (instancetype)initWithSelectedIndex:(NSInteger)selectIndex
                          bindPageView:(ZSPageView *)pageView;

/// 被绑定的tabView
@property (nonatomic, weak, readonly) ZSPageView *pageView;

/// 当前选中的index
@property (nonatomic, assign, readonly) NSInteger selectIndex;

/// ZSPageViewServeDelegate
@property (nonatomic, weak) id<ZSPageViewServeDelegate> delegate;

/// ZSPageViewScrollDelegate
@property (nonatomic, weak) id<ZSPageViewScrollDelegate> scrollDelegate;

/// page count
@property (nonatomic, assign) NSInteger pageCount;

/// 清理缓存
- (void)zs_clearCache;

/// pageView 的配置
/// @param pageView pageView
- (void)zs_configPageView:(ZSPageView *)pageView;

/// 设置 selectedIndex
/// @param selectedIndex selectedIndex
- (void)zs_setSelectedIndex:(NSInteger)selectedIndex;

@end

NS_ASSUME_NONNULL_END
