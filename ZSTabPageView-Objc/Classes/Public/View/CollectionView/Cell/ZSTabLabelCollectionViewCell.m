//
//  ZSTabLabelCollectionViewCell.m
//  ZSTabPageView
//
//  Created by Josh on 2020/12/22.
//

#import "ZSTabLabelCollectionViewCell.h"

@implementation ZSTabLabelCollectionViewCell

- (UILabel *)lbTitle {
    
    if (!_lbTitle)
    {
        _lbTitle = [UILabel new];
        _lbTitle.textAlignment = NSTextAlignmentCenter;

        _lbTitle.textColor = [UIColor blackColor];
        _lbTitle.font = [UIFont systemFontOfSize:16];
        
        _lbTitle.text = @"标题";
        
        [self.contentView addSubview:_lbTitle];
    }
    return _lbTitle;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.lbTitle.frame = self.contentView.bounds;
}

@end
