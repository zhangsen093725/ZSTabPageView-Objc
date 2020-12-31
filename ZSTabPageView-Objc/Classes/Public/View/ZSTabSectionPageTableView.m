//
//  ZSTabSectionPageTableView.m
//  ZSTabPageView
//
//  Created by Josh on 2020/12/28.
//

#import "ZSTabSectionPageTableView.h"

@implementation ZSTabSectionPageTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

@end
