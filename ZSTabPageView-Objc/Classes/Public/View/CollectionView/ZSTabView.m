//
//  ZSTabView.m
//  Pods-ZSTabPageView_Example
//
//  Created by Josh on 2020/11/26.
//

#import "ZSTabView.h"

@interface ZSTabView ()

/// 当前选择的 tab 索引
@property (nonatomic, assign) NSUInteger selectedIndex;

/// 滑块
@property (nonatomic, strong) UIImageView *sliderView;

@end

@implementation ZSTabView

- (instancetype)initWithFlowLayout:(UICollectionViewFlowLayout *)collectionViewFlowLayout {
    
    if (self = [super initWithFrame:CGRectZero collectionViewLayout:collectionViewFlowLayout])
    {
        self.keepSlider = NO;
        self.sliderHidden = NO;
        self.sliderWidth = (collectionViewFlowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal ? 0 : 2);
        self.sliderHeight = (collectionViewFlowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal ? 2 : 0);
        self.sliderVerticalAlignment = ZSTabViewSliderVerticalBottom;
        self.sliderHorizontalAlignment = ZSTabViewSliderHorizontalCenter;
        self.sliderAnimation = ZSTabViewSliderAnimationDefault;
        self.sliderInset = UIEdgeInsetsZero;
    }
    return self;
}

- (UIImageView *)sliderView {
    
    if (!_sliderView)
    {
        _sliderView = [UIImageView new];
        _sliderView.hidden = self.isSliderHidden;
        _sliderView.backgroundColor = [UIColor systemGrayColor];
    }
    return _sliderView;
}

- (UICollectionViewCell *)zs_cellForItemAtIndex:(NSUInteger)index
                                     horizontal:(BOOL)isHorizontal {
    
    [self reloadData];
    [self layoutIfNeeded];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
    
    UICollectionViewScrollPosition scrollPosition = isHorizontal ? UICollectionViewScrollPositionCenteredHorizontally : UICollectionViewScrollPositionCenteredVertically;
    
    if (cell == nil)
    {
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:NO];
        [self layoutIfNeeded];
        return [self cellForItemAtIndexPath:indexPath];
    }
    
    return cell;
}

- (CGPoint)zs_centerContentOffsetWithCell:(UICollectionViewCell *)cell
                               horizontal:(BOOL)isHorizontal {
    
    CGFloat min = 0;
    CGFloat max = isHorizontal ? (self.contentSize.width - CGRectGetWidth(self.frame)) : self.contentSize.height - CGRectGetHeight(self.frame);
    max = max > 0 ? max : 0;
    
    CGFloat cellCenter = isHorizontal ? cell.center.x : cell.center.y;
    CGFloat centerContentOffset = cellCenter - (isHorizontal ? self.center.x : self.center.y);
    
    CGPoint contentOffset = CGPointZero;
    
    if (self.contentOffset.x >= min)
    {
        if (centerContentOffset > max)
        {
            contentOffset = isHorizontal ? CGPointMake(max, 0) : CGPointMake(0, max);
        }
        else if (centerContentOffset > 0)
        {
            contentOffset = isHorizontal ? CGPointMake(centerContentOffset, 0) : CGPointMake(0, centerContentOffset);
        }
    }
    return contentOffset;
}

- (CGFloat)zs_layoutSliderViewWithCell:(UICollectionViewCell *)cell
                            horizontal:(BOOL)isHorizontal {
    
    CGFloat sliderOffset = 0;
    CGRect sliderFrame = self.sliderView.frame;
    
    sliderFrame.size.width = _sliderWidth > 0 ? _sliderWidth : (CGRectGetWidth(cell.frame) - _sliderInset.left - _sliderInset.right);
    sliderFrame.size.height = _sliderHeight > 0 ? _sliderHeight :  (CGRectGetHeight(cell.frame) - _sliderInset.top - _sliderInset.bottom);
    
    switch (_sliderVerticalAlignment)
    {
        case ZSTabViewSliderVerticalCenter:
        {
            CGFloat calculationResult = CGRectGetMinY(cell.frame) + (CGRectGetHeight(cell.frame) - CGRectGetHeight(sliderFrame)) * 0.5 + self.sliderInset.top - _sliderInset.bottom;
            
            if (isHorizontal)
            {
                sliderFrame.origin.y = calculationResult;
            }
            else
            {
                sliderOffset = calculationResult;
            }
            break;
        }
        case ZSTabViewSliderVerticalTop:
        {
            if (isHorizontal)
            {
                sliderFrame.origin.y = _sliderInset.top;
            }
            else
            {
                sliderOffset = CGRectGetMinY(cell.frame) + _sliderInset.top;
            }
            break;
        }
        case ZSTabViewSliderVerticalBottom:
        {
            if (isHorizontal)
            {
                sliderFrame.origin.y = CGRectGetHeight(self.frame) - CGRectGetHeight(sliderFrame) - _sliderInset.bottom;
            }
            else
            {
                sliderOffset = CGRectGetMaxY(cell.frame) - CGRectGetHeight(sliderFrame) - _sliderInset.bottom;
            }
            break;
        }
        default:
            break;
    }
    
    switch (_sliderHorizontalAlignment)
    {
        case ZSTabViewSliderHorizontalCenter:
        {
            CGFloat calculationResult = CGRectGetMinX(cell.frame) + (CGRectGetWidth(cell.frame) - CGRectGetWidth(sliderFrame)) * 0.5 + _sliderInset.left - _sliderInset.right;
            
            if (isHorizontal)
            {
                sliderOffset = calculationResult;
            }
            else
            {
                sliderFrame.origin.x = calculationResult;
            }
            break;
        }
        case ZSTabViewSliderHorizontalLeft:
        {
            if (isHorizontal)
            {
                sliderOffset = CGRectGetMinX(cell.frame) + _sliderInset.left;
            }
            else
            {
                sliderFrame.origin.x = _sliderInset.left;
            }
            break;
        }
        case ZSTabViewSliderHorizontalRight:
        {
            if (isHorizontal)
            {
                sliderOffset = CGRectGetMaxX(cell.frame) - CGRectGetWidth(sliderFrame) - _sliderInset.right;
            }
            else
            {
                sliderFrame.origin.x = CGRectGetWidth(self.frame) - CGRectGetWidth(sliderFrame) - _sliderInset.right;
            }
            break;
        }
        default:
            break;
    }
    
    self.sliderView.frame = sliderFrame;
    
    return sliderOffset;
}

- (void)zs_setSliderViewOffset:(CGFloat)offset horizontal:(BOOL)isHorizontal {
    
    CGRect sliderFrame = self.sliderView.frame;
    
    if (isHorizontal)
    {
        sliderFrame.origin.x = offset;
    }
    else
    {
        sliderFrame.origin.y = offset;
    }
    
    self.sliderView.frame = sliderFrame;
}

- (void)zs_sliderViewMoveToIndex:(NSUInteger)index
                            cell:(UICollectionViewCell *)cell
                      horizontal:(BOOL)isHorizontal
                       animation:(BOOL)isAnimation
                      completion:(void(^)(BOOL finished))completion {
    
    CGFloat sliderOffset = [self zs_layoutSliderViewWithCell:cell horizontal:isHorizontal];
    
    if (self.sliderView.superview == nil)
    {
        [self insertSubview:_sliderView atIndex:0];
    }
    
    if (isAnimation == NO)
    {
        completion ? completion(YES) : nil;
        [self zs_setSliderViewOffset:sliderOffset horizontal:isHorizontal];
        self.userInteractionEnabled = true;
        return;
    }
    
    int _index_ = (int)index;
    int _selectedIndex_ = (int)self.selectedIndex;
    
    if (!self.isKeepSlider && abs(_index_ - _selectedIndex_) > 1)
    {
        _selectedIndex = index;
        self.sliderView.alpha = 0;
        completion ? completion(YES) : nil;
        [self zs_setSliderViewOffset:sliderOffset horizontal:isHorizontal];
        [self.sliderView layoutIfNeeded];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.sliderView.alpha = 1;
            
        } completion:^(BOOL finished) {
            
            self.userInteractionEnabled = true;
        }];
        
        return;
    }
    
    _selectedIndex = index;
    [self.sliderView layoutIfNeeded];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self zs_setSliderViewOffset:sliderOffset horizontal:isHorizontal];
        
    } completion:^(BOOL finished) {
        
        self.userInteractionEnabled = true;
        completion ? completion(finished) : nil;
    }];
}

- (void)zs_setSelectedIndex:(NSUInteger)index animation:(BOOL)isAnimation {
    
    if (CGRectEqualToRect(self.frame, CGRectZero)) { return; }
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    BOOL isHorizontal = flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal;
    
    UICollectionViewCell *cell = [self zs_cellForItemAtIndex:index horizontal:isHorizontal];
    
    if (cell == nil) { return; }
    
    self.userInteractionEnabled = NO;
    
    CGPoint contentOffset = [self zs_centerContentOffsetWithCell:cell horizontal:isHorizontal];
    
    switch (_sliderAnimation)
    {
        case ZSTabViewSliderAnimationDefault:
        {
            [self zs_sliderViewMoveToIndex:index cell:cell horizontal:isHorizontal animation:isAnimation completion:^(BOOL finished) {
                
                [self setContentOffset:contentOffset animated:isAnimation];
                
            }];
            break;
        }
        case ZSTabViewSliderAnimationSynchronize:
        {
            [self setContentOffset:contentOffset animated:isAnimation];
            [self zs_sliderViewMoveToIndex:index cell:cell horizontal:isHorizontal animation:isAnimation completion:nil];
        }
        default:
            break;
    }
    
    [self reloadData];
}


@end
