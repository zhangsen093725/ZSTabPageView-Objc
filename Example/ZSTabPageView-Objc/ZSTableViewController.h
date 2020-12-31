//
//  ZSTableViewController.h
//  ZSTabPageView_Example
//
//  Created by Josh on 2020/12/28.
//  Copyright © 2020 zhangsen093725. All rights reserved.
//

#import "ZSTabPage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZSTableViewController : UITableViewController

@property (nonatomic, copy) ZSTabPagePlainDidScrollHandle didScrollViewHandle;

@end

NS_ASSUME_NONNULL_END
