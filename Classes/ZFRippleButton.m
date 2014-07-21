//
//  ZFRippleButton.swift
//  ZFRippleButtonDemo
//
//  Created by Amornchai Kanokpullwad on 6/26/14.
//  Copyright (c) 2014 zoonref. All rights reserved.
//

#import "ZFRippleButton.h"

@interface ZFRippleButton ()
{
    BOOL _shadowRippleEnableSet;
    BOOL _ripplePercentSet;
}

@property (nonatomic, strong, readonly) UIView *rippleView;
@property (nonatomic, strong, readonly) UIView *rippleBackgroundView;
@property (nonatomic) CGFloat tempShadowRadius;
@property (nonatomic) CGFloat tempShadowOpacity;

@end

@implementation ZFRippleButton
@synthesize rippleColor = _rippleColor;
@synthesize rippleBackgroundColor = _rippleBackgroundColor;
@synthesize rippleBackgroundView = _rippleBackgroundView;
@synthesize rippleView = _rippleView;
@synthesize ripplePercent = _ripplePercent;
@synthesize rippleOverBounds = _rippleOverBounds;


- (void)setRippleOverBounds:(BOOL)rippleOverBounds {
    if (rippleOverBounds) {
        self.rippleBackgroundView.layer.mask = nil;
    } else {
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius].CGPath;
        self.rippleBackgroundView.layer.mask = maskLayer;
    }
    _rippleOverBounds = rippleOverBounds;
}

- (UIView *)rippleView {
    if (!_rippleView) {
        _rippleView = [[UIView alloc] init];
    }
    return _rippleView;
}

- (UIView *)rippleBackgroundView {
    if (!_rippleBackgroundView) {
        _rippleBackgroundView = [[UIView alloc] init];
    }
    return _rippleBackgroundView;
}

- (UIColor *)rippleBackgroundColor {
    if (!_rippleBackgroundColor) {
        _rippleBackgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    }
    return _rippleBackgroundColor;
}

- (UIColor *)rippleColor {
    if (!_rippleColor) {
        _rippleColor = [UIColor colorWithWhite:0.9 alpha: 1];
    }
    return _rippleColor;
}

- (void)setRippleColor:(UIColor *)rippleColor {
    if (_rippleColor == rippleColor) {
        return;
    }
    
    self.rippleView.backgroundColor = rippleColor;
    _rippleColor = rippleColor;
}

- (void)setRippleBackgroundColor:(UIColor *)rippleBackgroundColor {
    if (_rippleBackgroundColor == rippleBackgroundColor) {
        return;
    }
    
    self.rippleBackgroundView.backgroundColor = rippleBackgroundColor;
    _rippleBackgroundColor = rippleBackgroundColor;
}

- (void) setRipplePercent:(float)ripplePercent {
    _ripplePercent = ripplePercent;
    [self setupRippleView];
}

- (void) setup {
    
    [self setupRippleView];
    
    self.rippleBackgroundView.backgroundColor = self.rippleBackgroundColor;
    self.rippleBackgroundView.frame = self.bounds;
    self.rippleBackgroundView.alpha = 0;
    
    self.rippleOverBounds = NO;
    
    [self.layer addSublayer:self.rippleBackgroundView.layer];
    [self.rippleBackgroundView.layer addSublayer:self.rippleView.layer];
    
    self.layer.shadowRadius = 0;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowColor = [UIColor colorWithWhite: 0.0 alpha:0.5].CGColor;
}

- (void) setupRippleView {
    CGFloat size = CGRectGetWidth(self.bounds) * self.ripplePercent;
    CGFloat x = (CGRectGetWidth(self.bounds)/2) - (size/2);
    CGFloat y = (CGRectGetHeight(self.bounds)/2) - (size/2);
    CGFloat corner = size/2;
        
    self.rippleView.backgroundColor = self.rippleColor;
    self.rippleView.frame = CGRectMake(x, y, size, size);
    self.rippleView.layer.cornerRadius = corner;
}

- (BOOL)shadowRippleEnable {
    if (!_shadowRippleEnableSet) {
        _shadowRippleEnable = YES;
        _shadowRippleEnableSet = YES;
    }
    return _shadowRippleEnable;
}

- (float)ripplePercent {
    if (!_ripplePercentSet) {
        _ripplePercentSet = YES;
        _ripplePercent = 0.9;
    }
    return _ripplePercent;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (self.trackTouchLocation) {
        self.rippleView.center = [touch locationInView:self];
    }
    
    [UIView animateWithDuration:0.1
                     animations: ^{
        self.rippleBackgroundView.alpha = 1;
    }
                     completion: nil];
    
    self.rippleView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.7
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations: ^{
        self.rippleView.transform = CGAffineTransformIdentity;
    } completion: nil];
    
    if (self.shadowRippleEnable) {
        self.tempShadowRadius = self.layer.shadowRadius;
        self.tempShadowOpacity = self.layer.shadowOpacity;
        
        CABasicAnimation *shadowAnim = [[CABasicAnimation alloc] init];
        shadowAnim.keyPath = @"shadowRadius";
        shadowAnim.toValue = @(self.shadowRippleRadius);
        
        CABasicAnimation *opacityAnim = [[CABasicAnimation alloc] init];
        opacityAnim.keyPath = @"shadowOpacity";
        opacityAnim.toValue = @1;
        
        CAAnimationGroup *groupAnim = [[CAAnimationGroup alloc] init];
        groupAnim.duration = 0.7;
        groupAnim.fillMode = kCAFillModeForwards;
        groupAnim.removedOnCompletion = NO;
        groupAnim.animations = @[shadowAnim, opacityAnim];
        
        [self.layer addAnimation:groupAnim forKey:@"shadow"];
    }
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    
    [UIView animateWithDuration:0.1
                     animations: ^{
        self.rippleBackgroundView.alpha = 1;
    } completion: ^(BOOL finished){
        [UIView animateWithDuration:0.6 animations: ^{
            self.rippleBackgroundView.alpha = 0;
        } completion:^(BOOL finished){}];
    }];
    
    [UIView animateWithDuration:0.7 delay:0 options: UIViewAnimationOptionCurveEaseOut |UIViewAnimationOptionBeginFromCurrentState animations: ^{
        self.rippleView.transform = CGAffineTransformIdentity;
        
        CABasicAnimation * shadowAnim =  [[CABasicAnimation alloc] init];
        shadowAnim.keyPath = @"shadowRadius";
        shadowAnim.toValue = @(self.tempShadowRadius);
        
        CABasicAnimation * opacityAnim = [[CABasicAnimation alloc] init];
        opacityAnim.keyPath = @"shadowOpacity";
        opacityAnim.toValue = @(self.tempShadowOpacity);
        
        CAAnimationGroup * groupAnim = [[CAAnimationGroup alloc] init];
        groupAnim.duration = 0.7;
        groupAnim.fillMode = kCAFillModeForwards;
        groupAnim.removedOnCompletion = NO;
        groupAnim.animations = @[shadowAnim, opacityAnim];
        
        [self.layer addAnimation:groupAnim forKey:@"shadowBack"];
    } completion: nil];
}

@end