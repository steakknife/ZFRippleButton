//
//  ZFRippleButton.h
//  ZFRippleButtonDemo
//
//  Created by Amornchai Kanokpullwad on 6/26/14.
//  Copyright (c) 2014 zoonref. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ZFRippleButton : UIButton

@property (nonatomic)          float ripplePercent;
@property (nonatomic)          BOOL rippleOverBounds;
@property (nonatomic, strong)  UIColor *rippleColor;
@property (nonatomic, strong)  UIColor *rippleBackgroundColor;
@property (nonatomic)          float shadowRippleRadius;
@property (nonatomic)          BOOL shadowRippleEnable;
@property (nonatomic)          BOOL trackTouchLocation;

@end

