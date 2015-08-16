//
//  TPFingerPresenter.m
//  TweaksPresentation
//
//  Created by Jarosław Pendowski on 16/08/15.
//  Copyright (c) 2015 Jarosław Pendowski. All rights reserved.
//

#import "TPFingerPresenter.h"
#import <objc/runtime.h>
#import "UIWindow+TweaksPresentation.h"
#import "NSMutableArray+Queue.h"
#import <Tweaks/FBTweakInline.h>


const static double kAnimationDuration = 0.15;


@interface TPFingerPresenter ()

@property (nonatomic, strong) NSArray *fingerThemes;
@property (nonatomic, strong) NSNumber *fingerThemeIndex;

@property (nonatomic, strong) NSMutableArray *currentTouches;
@property (nonatomic, strong) NSMutableArray *currentViews;
@property (nonatomic, strong) NSMutableArray *viewsPool;

@property (nonatomic, weak) UIWindow *window;

@end

@implementation TPFingerPresenter

- (instancetype)initWithWindow:(UIWindow *)window
{
    self = [super init];
    if (self) {
        self.window = window;
        
        [self swizzleMethodsForWindow:self.window];
        window.tp_fingerPresenter = self;
        
        self.currentTouches = [NSMutableArray array];
        self.currentViews = [NSMutableArray array];
        self.viewsPool = [NSMutableArray array];
        
        FBTweakBind(self, enabled, @"Tweaks Presentation", @"Presentation", @"Enabled", NO);
        
        FBTweakBind(self, animateTransitions, @"Tweaks Presentation", @"Presentation", @"Animate showing/hiding", YES);
        FBTweakBind(self, fingerRadius, @"Tweaks Presentation", @"Presentation", @"Finger radius", 22);
        FBTweakBind(self, fingerThemeIndex, @"Tweaks Presentation", @"Presentation", @"Finger color theme", @(TPPresentationThemeLight), (@{ @(TPPresentationThemeLight) : @"Light", @(TPPresentationThemeDark) : @"Dark" }));
        FBTweakBind(self, fingerAlpha, @"Tweaks Presentation", @"Presentation", @"Finger opacity", 0.5);
    }
    return self;
}

#pragma mark - Properties

- (void)setEnabled:(BOOL)fingersVisible
{
    _enabled = fingersVisible;
    
    if (!fingersVisible) {
        [self removeTouches:[NSSet setWithArray:self.currentTouches]];
    }
}

- (NSArray *)fingerThemes
{
    return @[ @(TPPresentationThemeLight), @(TPPresentationThemeDark) ];
}

- (void)setFingerThemeIndex:(NSNumber *)fingerThemeIndex
{
    NSNumber *theme = self.fingerThemes[[fingerThemeIndex integerValue]];
    self.fingerTheme = [theme integerValue];
}

- (NSNumber *)fingerThemeIndex
{
    return @([self.fingerThemes indexOfObject:@(self.fingerTheme)]);
}

- (void)setFingerTheme:(TPPresentationTheme)fingerTheme
{
    _fingerTheme = fingerTheme;
    
    switch (fingerTheme) {
        case TPPresentationThemeLight:
            self.fingerColor = [UIColor whiteColor];
            break;
        case TPPresentationThemeDark:
            self.fingerColor = [UIColor blackColor];
            break;
    }
}

#pragma mark - Touches

- (void)swizzled_sendEvent:(UIEvent *)event
{
    [self swizzled_sendEvent:event];
    
    UIWindow *window = (UIWindow *)self; // swizzled pointer
    [window.tp_fingerPresenter handeEvent:event];
}

- (void)handeEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeTouches && self.enabled) {
        NSSet *allTouches = event.allTouches;
        
        [self addTouches:[self filterTouches:allTouches withBlock:^BOOL(UITouch *touch) {
            return touch.phase == UITouchPhaseBegan;
        }]];
        
        [self updateTouches:[self filterTouches:allTouches withBlock:^BOOL(UITouch *touch) {
            return touch.phase == UITouchPhaseMoved;
        }]];
        
        [self removeTouches:[self filterTouches:allTouches withBlock:^BOOL(UITouch *touch) {
            return touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseCancelled;
        }]];
        
    } else if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        
        [self removeTouches:[NSSet setWithArray:self.currentTouches]];
        
    }
}

#pragma mark - Private methods

- (UIView *)dequeuedOrNewTouch
{
    UIView *view = [self.viewsPool q_pop] ?: [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = self.fingerColor;
    view.alpha = self.fingerAlpha;
    view.transform = CGAffineTransformIdentity;
    view.layer.cornerRadius = self.fingerRadius;
    view.userInteractionEnabled = NO;
    
    return view;
}

- (void)addTouches:(NSSet *)touches
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInView:self.window];

        UIView *view = [self dequeuedOrNewTouch];
        view.frame = CGRectMake(location.x - self.fingerRadius, location.y - self.fingerRadius ,self.fingerRadius * 2, self.fingerRadius * 2);
        [self.window addSubview:view];
        
        if (self.animateTransitions) {
            view.transform = CGAffineTransformMakeScale(0.001, 0.001);
            
            [UIView animateWithDuration:kAnimationDuration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.8 options:0 animations:^{
                view.transform = CGAffineTransformIdentity;
            } completion:nil];
        }
        
        [self.currentTouches addObject:touch];
        [self.currentViews addObject:view];
    }
}

- (void)updateTouches:(NSSet *)touches
{
    for (UITouch *touch in touches) {
        NSInteger index = [self.currentTouches indexOfObject:touch];
        if (index == NSNotFound) {
            continue;
        }
        
        CGPoint location = [touch locationInView:self.window];
        
        UIView *view = self.currentViews[index];
        view.frame = CGRectMake(location.x - self.fingerRadius, location.y - self.fingerRadius ,self.fingerRadius * 2, self.fingerRadius * 2);
    }
}

- (void)removeTouches:(NSSet *)touches
{
    for (UITouch *touch in touches) {
        NSInteger index = [self.currentTouches indexOfObject:touch];
        if (index == NSNotFound) {
            continue;
        }
        
        UIView *view = self.currentViews[index];
        if (self.animateTransitions) {
            view.transform = CGAffineTransformIdentity;
            
            [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                view.transform = CGAffineTransformMakeScale(0.001, 0.001);
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
                [self.viewsPool q_push:view];
            }];
        } else {
            [view removeFromSuperview];
            [self.viewsPool q_push:view];
        }
        
        [self.currentTouches removeObjectAtIndex:index];
        [self.currentViews removeObjectAtIndex:index];
    }
}

- (void)swizzleMethodsForWindow:(UIWindow *)window
{
    Method originalMethod = class_getInstanceMethod([window class], @selector(sendEvent:));
    Method swizzledMethod = class_getInstanceMethod([self class], @selector(swizzled_sendEvent:));
    
    BOOL didAddMethod =
    class_addMethod(window.class, @selector(sendEvent:), method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(window.class, @selector(swizzled_sendEvent:), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
}

- (NSSet *)filterTouches:(NSSet *)touches withBlock:(BOOL (^)(UITouch *))block
{
    NSMutableSet *set = [NSMutableSet set];
    
    for (UITouch *touch in touches) {
        if (block(touch)) {
            [set addObject:touch];
        }
    }
    
    return [set copy];
}

@end
