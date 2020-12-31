//
//  ZSTabView.h
//  Pods-ZSTabPageView_Example
//
//  Created by Josh on 2020/11/26.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZSTabViewSliderVerticalAlignment) {
    ZSTabViewSliderVerticalCenter = 0,
    ZSTabViewSliderVerticalTop = 1,
    ZSTabViewSliderVerticalBottom = 2,
};

typedef NS_ENUM(NSUInteger, ZSTabViewSliderHorizontalAlignment) {
    ZSTabViewSliderHorizontalCenter = 0,
    ZSTabViewSliderHorizontalLeft = 1,
    ZSTabViewSliderHorizontalRight = 2,
};

typedef NS_ENUM(NSUInteger, ZSTabViewSliderAnimation) {
    ZSTabViewSliderAnimationDefault = 0,
    ZSTabViewSliderAnimationSynchronize = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface ZSTabView : UICollectionView

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout NS_UNAVAILABLE;

/// 初始化方法
/// @param collectionViewFlowLayout collectionViewFlowLayout
- (instancetype)initWithFlowLayout:(UICollectionViewFlowLayout *)collectionViewFlowLayout;

/// 间隔多个Tab时是否保持滑块滑动 default NO
@property (nonatomic, assign, getter=isKeepSlider) BOOL keepSlider;

/// 是否隐藏底部的滑块 default NO
@property (nonatomic, assign, getter=isSliderHidden) BOOL sliderHidden;

/// 滑块的宽度 default 2
@property (nonatomic, assign) CGFloat sliderWidth;

/// 滑块的高度 default 0
@property (nonatomic, assign) CGFloat sliderHeight;

/// slider 垂直方向的对齐方式 default ZSTabViewSliderVerticalBottom
@property (nonatomic, assign) ZSTabViewSliderVerticalAlignment sliderVerticalAlignment;

/// slider 水平方向的对齐方式 default ZSTabViewSliderHorizontalCenter
@property (nonatomic, assign) ZSTabViewSliderHorizontalAlignment sliderHorizontalAlignment;

/// slider 滑动的动画 default ZSTabViewSliderAnimationDefault
@property (nonatomic, assign) ZSTabViewSliderAnimation sliderAnimation;

/// slider 根据Insets来进行调整偏移 default UIEdgeInsetsZero
@property (nonatomic, assign) UIEdgeInsets sliderInset;

/// 当前选择的 tab 索引
@property (nonatomic, assign, readonly) NSUInteger selectedIndex;

/// 滑块
@property (nonatomic, strong, readonly) UIImageView *sliderView;

/// 设置 selectedIndex
/// @param index 当前选中的
/// @param isAnimation 是否开启动画
- (void)zs_setSelectedIndex:(NSUInteger)index
                  animation:(BOOL)isAnimation;

/// 根据index获取Cell
/// @param index 索引
/// @param isHorizontal 是否是横向滚动
- (UICollectionViewCell *)zs_cellForItemAtIndex:(NSUInteger)index
                                     horizontal:(BOOL)isHorizontal;

/// 获取cell的中心位置
/// @param cell cell
/// @param isHorizontal 是否是横向滚动
- (CGPoint)zs_centerContentOffsetWithCell:(UICollectionViewCell *)cell
                               horizontal:(BOOL)isHorizontal;


/// 获取sliderView相对于cell的偏移量
/// @param cell cell
/// @param isHorizontal 是否是横向滚动
- (CGFloat)zs_layoutSliderViewWithCell:(UICollectionViewCell *)cell
                            horizontal:(BOOL)isHorizontal;

/// 设置sliderView的偏移量
/// @param offset 偏移量
/// @param isHorizontal 是否是横向滚动
- (void)zs_setSliderViewOffset:(CGFloat)offset
                    horizontal:(BOOL)isHorizontal;

/// sliderView移动到目标索引
/// @param index 目标索引
/// @param cell 目标索引对应的cell
/// @param isHorizontal 是否是横向滚动
/// @param isAnimation 是否开启动画
/// @param completion 动画完成
- (void)zs_sliderViewMoveToIndex:(NSUInteger)index
                            cell:(UICollectionViewCell *)cell
                      horizontal:(BOOL)isHorizontal
                       animation:(BOOL)isAnimation
                      completion:(nullable void(^)(BOOL finished))completion;

@end

NS_ASSUME_NONNULL_END
