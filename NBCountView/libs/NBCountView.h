//
//  NBCountView.h
//  NBCountView
//
//  Created by NapoleonBai on 15/5/22.
//  Copyright (c) 2015年 NapoleonBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NBCountViewDelegate;

@interface NBCountView : UIView<UITextFieldDelegate>

@property(nonatomic,weak,setter=setDelegate:)id<NBCountViewDelegate> delegate;
@property(nonatomic)NSInteger stepNumber;///< 单步增加减少多少,缺省为1
@property(nonatomic)CGFloat buttonFont;///< 按钮标题字体大小
@property(nonatomic)CGFloat textfieldFont;///< 输入文字字体大小
@property(nonatomic,strong)UIColor *borderColor;///< 边框颜色
@property(nonatomic)NSInteger currentNumber;///< 当前值
@property(nonatomic)NSInteger maxNumber;///< 最大值
@property(nonatomic)NSInteger minNumber;///< 最小值,缺省为0
@property(nonatomic,getter=isAllowEdit)BOOL allowEdit;///< 是否允许编辑
@property (nonatomic,strong)UIImage *decreaseImage;///< 减按钮背景图片
@property (nonatomic,strong)UIImage *increaseImage;///< 加按钮背景图片
@property (nonatomic,copy)NSString *decreaseTitle;///< 减按钮标题
@property (nonatomic,copy)NSString *increaseTitle;///< 加按钮标题


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
 */
- (void)countViewOverFlow:(NBCountView *)countView;

//键盘弹出时调用,在启用手动编辑的时候执行
- (void)countViewShowKeyBoard;

@end

