//
//  UIWindow+TweaksPresentation.h
//  TweaksPresentation
//
//  Created by Jarosław Pendowski on 16/08/15.
//  Copyright (c) 2015 Jarosław Pendowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPFingerPresenter.h"

@interface UIWindow (TweaksPresentation)

@property (nonatomic, weak) TPFingerPresenter *tp_fingerPresenter;

@end
