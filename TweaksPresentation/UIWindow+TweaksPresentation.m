//
//  UIWindow+TweaksPresentation.m
//  TweaksPresentation
//
//  Created by Jarosław Pendowski on 16/08/15.
//  Copyright (c) 2015 Jarosław Pendowski. All rights reserved.
//

#import "UIWindow+TweaksPresentation.h"
#import <objc/runtime.h>

static char kFingerPresenterObjectKey;

@implementation UIWindow (TweaksPresentation)

- (TPFingerPresenter *)tp_fingerPresenter
{
    return objc_getAssociatedObject(self, &kFingerPresenterObjectKey);
}

- (void)setTp_fingerPresenter:(TPFingerPresenter *)tp_fingerPresenter
{
    objc_setAssociatedObject(self, &kFingerPresenterObjectKey, tp_fingerPresenter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
