//
//  ZSTabPageViewDisplayLink.m
//  ZSTabPageView
//
//  Created by Josh on 2020/7/24.
//

#import "ZSTabPageViewDisplayLink.h"

@interface _ZSTabPageViewDisplayLink ()

@property (nonatomic, copy) void(^userInfo)(CADisplayLink *displayLink);
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation _ZSTabPageViewDisplayLink

- (instancetype)init:(NSInteger)fps block:(void(^)(CADisplayLink *displayLink))block {
    
    if (self = [super init])
    {
        self.userInfo = block;
    }
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(runDisplayLink)];
    
    if (@available(iOS 10.0, *)) {
        _displayLink.preferredFramesPerSecond = fps;
    } else {
        _displayLink.frameInterval = fps;
    }
    [_displayLink addToRunLoop:NSRunLoop.currentRunLoop forMode:NSDefaultRunLoopMode];
    
    return self;
}

- (void)runDisplayLink {
    
    _userInfo ? _userInfo(_displayLink) : nil;
}

- (void)invalidate {
    
    [_displayLink removeFromRunLoop:NSRunLoop.currentRunLoop forMode:NSDefaultRunLoopMode];
    [_displayLink invalidate];
    _displayLink = nil;
    _userInfo = nil;
}

@end
