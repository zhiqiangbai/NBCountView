//
//  NBCountView.h
//  NBCountView
//
//  Created by NapoleonBai on 15/5/22.
//  Copyright (c) 2015年 NapoleonBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NBCountViewDelegate;
@class NBCountView;

typedef void(^countViewNumberBlock)(NSInteger number);
typedef void(^countViewOverFlowBlock)(BOOL isMax);

/**
 数字增加控制视图,主要实现对数量手动操作,在购物等操作时需要,
 主要特性:
 1.(回调:block 和delegate 支持)值改变回调,以及溢出单独回调(设置最大,最小值),键盘编辑时弹出键盘回调等
 2.允许设置最大,最小,单步值;
 3.允许设置增减按钮文字,背景图片等
 4.允许设置是否可编辑,是否支持长按快速增减功能
 5.文字大小设置等
 6.其他等
 */
@interface NBCountView : UIView<UITextFieldDelegate>
@property(nonatomic,copy)countViewNumberBlock countViewChangeHandler;///< 值改变时回调
@property(nonatomic,copy)countViewOverFlowBlock countViewOverFlowHandler;///< 溢出时回调
@property(nonatomic,weak)id<NBCountViewDelegate> delegate;
@property(nonatomic)NSInteger stepNumber;///< 单步增加减少多少,缺省为1
@property(nonatomic)CGFloat buttonFont;///< 按钮标题字体大小
@property(nonatomic)CGFloat textfieldFont;///< 输入文字字体大小
@property(nonatomic,strong)UIColor *textfieldTextColor;///< 输入文字颜色
@property(nonatomic,strong)UIColor *buttonDisableColor;///< 不可用状态颜色
@property(nonatomic,strong)UIColor *borderColor;///< 线条颜色
@property(nonatomic,getter=curretnNumber)NSInteger number;///< 当前值
@property(nonatomic)NSInteger maxNumber;///< 最大值
@property(nonatomic)NSInteger minNumber;///< 最小值,缺省为0
@property(nonatomic,getter=isAllowEdit)BOOL allowEdit;///< 是否允许编辑
@property(nonatomic,strong)UIImage *decreaseImage;///< 减按钮背景图片
@property(nonatomic,strong)UIImage *increaseImage;///< 加按钮背景图片
@property(nonatomic,copy)NSString *decreaseTitle;///< 减按钮标题
@property(nonatomic,copy)NSString *increaseTitle;///< 加按钮标题
@property(nonatomic,getter=isEnableLongPress)BOOL enableLongPress;///< 启动长按增加


/**
 初始化

 @param frame 位置大小
 @return 实例对象
 */
+ (instancetype)countViewWithFrame:(CGRect)frame;

@end

@protocol NBCountViewDelegate <NSObject>
@optional
/**
 当值发生改变时调用

 @param countView 当前操作实例对象
 @param value 当前显示值
 */
- (void)countView:(NBCountView *)countView number:(NSInteger)value;

/**
 值超过范围时调用

 @param countView 当前操作实例对象
 @param isMoreThan 是否达到最大值 , YES则是,NO则是低于最小值
 */
- (void)countViewOverFlow:(NBCountView *)countView isMaxNumber:(BOOL)isMoreThan;


/**
 键盘弹出时调用,在启用手动编辑的时候执行
 */
- (void)countViewShowKeyBoard;

@end

