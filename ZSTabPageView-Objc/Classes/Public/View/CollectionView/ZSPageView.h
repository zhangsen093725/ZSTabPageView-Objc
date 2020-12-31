//
//  ZSPageView.h
//  ZSTabPageView
//
//  Created by Josh on 2020/11/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZSPageView : UICollectionView

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout NS_UNAVAILABLE;

/// 初始化方法
/// @param collectionViewFlowLayout collectionViewFlowLayout
- (instancetype)initWithFlowLayout:(UICollectionViewFlowLayout *)collectionViewFlowLayout;

/// 设置 selectedIndex
/// @param index 当前选中的
/// @param isAnimation 是否开启动画
- (void)zs_setSelectedIndex:(NSUInteger)index
                  animation:(BOOL)isAnimation;

@end

NS_ASSUME_NONNULL_END
