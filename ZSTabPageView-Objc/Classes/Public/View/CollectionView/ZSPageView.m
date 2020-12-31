//
//  ZSPageView.m
//  ZSTabPageView
//
//  Created by Josh on 2020/11/30.
//

#import "ZSPageView.h"

@implementation ZSPageView

- (instancetype)initWithFlowLayout:(UICollectionViewFlowLayout *)collectionViewFlowLayout {
    
    if (self = [super initWithFrame:CGRectZero collectionViewLayout:collectionViewFlowLayout])
    {
        self.pagingEnabled = YES;
    }
    return self;
}

- (void)setPagingEnabled:(BOOL)pagingEnabled {
    
    [super setPagingEnabled:YES];
}

- (void)zs_setSelectedIndex:(NSUInteger)index animation:(BOOL)isAnimation {
    
    [self reloadData];
    
    UICollectionViewFlowLayout *flowLayou = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    if (flowLayou.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:isAnimation];
    }
    else
    {
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:isAnimation];
    }
}

@end
