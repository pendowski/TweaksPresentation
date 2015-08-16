//
//  TPPresentationTweakShakeWindow.m
//  TweaksPresentation
//
//  Created by Jarosław Pendowski on 15/08/15.
//  Copyright (c) 2015 Jarosław Pendowski. All rights reserved.
//

#import "TPPresentationTweakShakeWindow.h"
#import "TPFingerPresenter.h"

@interface TPPresentationTweakShakeWindow ()

@property (nonatomic, strong) TPFingerPresenter *fingerPresenter;

@end

@implementation TPPresentationTweakShakeWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.fingerPresenter = [[TPFingerPresenter alloc] initWithWindow:self];
    }
    return self;
}

@end
