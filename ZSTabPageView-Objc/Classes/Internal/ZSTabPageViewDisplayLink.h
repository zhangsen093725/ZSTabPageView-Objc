//
//  ZSTabPageViewDisplayLink.h
//  ZSTabPageView
//
//  Created by Josh on 2020/7/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface _ZSTabPageViewDisplayLink : NSObject

- (instancetype)init:(NSInteger)fps block:(void(^)(CADisplayLink *displayLink))block;

- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
