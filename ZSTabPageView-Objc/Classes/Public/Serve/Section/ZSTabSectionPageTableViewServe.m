//
//  ZSTabSectionPageTableViewServe.m
//  ZSTabPageView
//
//  Created by Josh on 2020/12/28.
//

#import "ZSTabSectionPageTableViewServe.h"

@interface ZSTabSectionPageTableViewServe ()

/// 被绑定的tabPageView
@property (nonatomic, weak) ZSTabSectionPageTableView *tableView;

@end


@implementation ZSTabSectionPageTableViewServe

- (instancetype)initWithSelectedIndex:(NSInteger)selectIndex
                        bindTableView:(ZSTabSectionPageTableView *)tableView
                              tabView:(ZSTabView *)tabView
                         tabCellClass:(Class)tabCellClass
                             pageView:(ZSPageView *)pageView {
    
    if (self = [super init])
    {
        [self zs_setSelectedIndex:selectIndex];
        
        [self zs_bindTabView:tabView registerTabCellClass:tabCellClass];
        [self zs_bindPageView:pageView];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        [self zs_configTableView:tableView];
        self.tableView = tableView;
        
        self.tabViewHeight = 44;
        self.shouldBaseScroll = YES;
        self.sectionFloatEnable = YES;
    }
    return self;
}

- (void)setTabCount:(NSInteger)tabCount {
    
    [super setTabCount:tabCount];
    [self.tableView reloadData];
}

- (void)setTabViewHeight:(CGFloat)tabViewHeight {
    
    [super setTabViewHeight:tabViewHeight];
    [self.tableView reloadData];
}

- (void)zs_configTableView:(ZSTabSectionPageTableView *)tableView {
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

# pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView != self.tableView) return;
    
    if (CGSizeEqualToSize(scrollView.contentSize, CGSizeZero)) { return; }
    
    CGFloat offset = scrollView.contentSize.height - CGRectGetHeight(scrollView.bounds);
    
    if (self.isSectionFloatEnable == NO)
    {
        if ((scrollView.contentOffset.y <= offset) &&
            (scrollView.contentOffset.y >= 0))
        {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        else if (scrollView.contentOffset.y >= offset)
        {
            scrollView.contentInset = UIEdgeInsetsMake(-offset, 0, 0, 0);
        }
    }
    
    if (scrollView.contentOffset.y >= offset)
    {
        scrollView.contentOffset = CGPointMake(0, offset);
        
        if (self.isShouldBaseScroll)
        {
            self.shouldBaseScroll = NO;
            self.shouldPageScroll = YES;
        }
        return;
    }
    
    if (self.isShouldBaseScroll == NO)
    {
        scrollView.contentOffset = CGPointMake(0, offset);
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.exclusiveTouch = YES;
    
    for (UIView *subView in cell.contentView.subviews)
    {
        [subView removeFromSuperview];
    }
    
    UIView *view = self.pageViewServe.pageView;
    
    if (view != nil)
    {
        [cell.contentView addSubview:view];
        view.frame = cell.contentView.bounds;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    return CGRectGetHeight(tableView.frame) - (self.isSectionFloatEnable ? self.tabViewHeight : 0);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.tabViewServe.tabView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return self.tabViewHeight;
}

@end
