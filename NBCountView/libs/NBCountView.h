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
@property(nonatomic,assign)NSInteger stepValue;

//设置当前值,最大值,以及最小值
- (void)setCurrentValue:(NSInteger)currentValue withMaxValue:(NSInteger) maxValue withMinValue:(NSInteger)minValue;

//设置当前值
- (void)setCurrentValues:(NSInteger)currentValue;

//设置边框颜色
- (void)setBorderColor:(UIColor *)borderColor;

//设置是否允许编辑
- (void)setCountViewEdit:(BOOL)isEdit;

@end

@protocol NBCountViewDelegate <NSObject>

//获取当前值和最大值,在输入数字或者添加数字超过最大值时调用
- (void)countViewValue:(NSInteger) value moreThanMaxValue:(NSInteger) maxValue;

//获取当前值和最小值,在输入数字或者添加数字低于最小值时调用
- (void)countViewValue:(NSInteger) value lessThanMinValue:(NSInteger) minValue;

//获取改变之前的值和当前值,在数字改变的时候调用
- (void)countViewValueChangeAgain:(NSInteger) againValue after:(NSInteger)currentValue;

//键盘弹出时调用,在启用手动编辑的时候执行
- (void)countViewShowKeyBoard;

@end

