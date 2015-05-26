//
//  NBCountView.h
//  GQF_flowers
//
//  Created by NapoleonBai on 15/5/22.
//  Copyright (c) 2015年 NapoleonBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NBCountViewDelegate;

@interface NBCountView : UIView<UITextFieldDelegate>

@property(nonatomic,weak,setter=setDelegate:)id<NBCountViewDelegate> delegate;

- (void)setCurrentValue:(NSInteger)currentValue withMaxValue:(NSInteger) maxValue withMinValue:(NSInteger)minValue;

- (void)setBorderColor:(UIColor *)borderColor;

- (void)setCountViewEdit:(BOOL)isEdit;

@end

@protocol NBCountViewDelegate <NSObject>

- (void)countViewValue:(NSInteger) value moreThanMaxValue:(NSInteger) maxValue;

- (void)countViewValue:(NSInteger) value lessThanMinValue:(NSInteger) minValue;

- (void)countViewValueChangeAgain:(NSInteger) againValue after:(NSInteger)currentValue;

@end

