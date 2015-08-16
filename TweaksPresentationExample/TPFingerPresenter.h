//
//  TPFingerPresenter.h
//  TweaksPresentation
//
//  Created by Jarosław Pendowski on 16/08/15.
//  Copyright (c) 2015 Jarosław Pendowski. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, TPPresentationTheme) {
    TPPresentationThemeLight,
    TPPresentationThemeDark
};

@interface TPFingerPresenter : NSObject

@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL animateTransitions;
@property (nonatomic) CGFloat fingerRadius;
@property (nonatomic) TPPresentationTheme fingerTheme;
@property (nonatomic, strong) UIColor *fingerColor;
@property (nonatomic) CGFloat fingerAlpha;

@property (nonatomic, weak, readonly) UIWindow *window;

- (instancetype)initWithWindow:(UIWindow *)window NS_DESIGNATED_INITIALIZER;

@end
