//
//  ZSTabSectionPageTableViewServe.h
//  ZSTabPageView
//
//  Created by Josh on 2020/12/28.
//

#import "ZSTabSectionPageServe.h"
#import "ZSTabSectionPageTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZSTabSectionPageTableViewServe : ZSTabSectionPageServe<UITableViewDelegate, UITableViewDataSource>

- (instancetype)init NS_UNAVAILABLE;

/// 初始化方法
/// @param selectIndex 初始状态的默认选中
/// @param tableView 与serve绑定的tableView
/// @param tabView tabView
/// @param tabCellClass tabCellClass 复用的cellClass，必须是ZSTabCollectionViewCell的子类
/// @param pageView pageView
- (instancetype)initWithSelectedIndex:(NSInteger)selectIndex
                        bindTableView:(ZSTabSectionPageTableView *)tableView
                              tabView:(ZSTabView *)tabView
                         tabCellClass:(Class)tabCellClass
                             pageView:(ZSPageView *)pageView;

/// 被绑定的 tableView
@property (nonatomic, weak, readonly) ZSTabSectionPageTableView *tableView;

/// 配置被绑定的 tableView
/// @param tableView tableView
- (void)zs_configTableView:(ZSTabSectionPageTableView *)tableView;

@end

NS_ASSUME_NONNULL_END
