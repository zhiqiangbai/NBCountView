//
//  NBCountView.m
//  NBCountView
//
//  Created by NapoleonBai on 15/5/22.
//  Copyright (c) 2015年 NapoleonBai. All rights reserved.
//

#import "NBCountView.h"

@interface NBCountTextField : UITextField

@end

@implementation NBCountTextField

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    // 禁止弹出菜单
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}
@end

@interface NBCountView ()

@property(nonatomic,strong)UIButton *decreaseBtn;
@property(nonatomic,strong)UIButton *increaseBtn;
@property(nonatomic,strong)NBCountTextField *countTextField;
@property(nonatomic,assign)NSInteger changeAgainValue;
@property (nonatomic, strong) NSTimer *timer;///< 加减定时器


@end

@implementation NBCountView

/**
 创建Button公共方法

 @return button
 */
- (UIButton *)creatButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:_buttonFont];
    [button setTitleColor:_borderColor forState:UIControlStateNormal];
    [button setTitleColor:_buttonDisableColor forState:UIControlStateDisabled];

    [button addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    return button;
}

- (UIButton *)decreaseBtn{
    if (!_decreaseBtn) {
        _decreaseBtn = [self creatButton];
        [_decreaseBtn setTitle:_decreaseTitle forState:UIControlStateNormal];
    }
    return _decreaseBtn;
}

- (UIButton *)increaseBtn{
    if (!_increaseBtn) {
        _increaseBtn = [self creatButton];
        [_increaseBtn setTitle:_increaseTitle forState:UIControlStateNormal];

    }
    return _increaseBtn;
}



+ (instancetype)countViewWithFrame:(CGRect)frame{
    return [[NBCountView alloc]initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        if(CGRectIsEmpty(frame))
        {
            //默认设置为110,30
            self.frame = CGRectMake(0, 0, 110, 30);
        };
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder])
    {
        [self initView];
    }
    return self;
}

- (void)initView{
    _stepNumber = 1;
    _minNumber = 0;
    _number = 1;
    _maxNumber = NSIntegerMax;
    _textfieldFont = 15;
    _buttonFont = 17;
    _decreaseTitle = @"－";
    _increaseTitle = @"＋";
    _allowEdit = YES;
    _enableLongPress = NO;
    _borderColor = [UIColor grayColor];
    _textfieldTextColor = [UIColor grayColor];
    _buttonDisableColor = [UIColor lightGrayColor];
    
    _countTextField = [NBCountTextField new];
    _countTextField.delegate = self;
    _countTextField.keyboardType = UIKeyboardTypeNumberPad;
    _countTextField.textAlignment = NSTextAlignmentCenter;
    _countTextField.font = [UIFont systemFontOfSize:_textfieldFont];
    _countTextField.text = [NSString stringWithFormat:@"%ld",_minNumber];
    [_countTextField addTarget:self action:@selector(countChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.decreaseBtn];
    [self addSubview:self.countTextField];
    [self addSubview:self.increaseBtn];

}

- (void)setTextfieldTextColor:(UIColor *)textfieldTextColor{
    _textfieldTextColor = textfieldTextColor;
    _countTextField.textColor = textfieldTextColor;
}

- (void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 1;
    
    self.increaseBtn.layer.borderColor = borderColor.CGColor;
    self.increaseBtn.layer.borderWidth = 1;
    
    self.decreaseBtn.layer.borderWidth = 1;
    self.decreaseBtn.layer.borderColor = borderColor.CGColor;
    
    [self.increaseBtn setTitleColor:borderColor forState:UIControlStateNormal];
    [self.decreaseBtn setTitleColor:borderColor forState:UIControlStateNormal];

}

- (void)setButtonDisableColor:(UIColor *)buttonDisableColor{
    _buttonDisableColor = buttonDisableColor;
    [self.increaseBtn setTitleColor:buttonDisableColor forState:UIControlStateDisabled];
    [self.decreaseBtn setTitleColor:buttonDisableColor forState:UIControlStateDisabled];
}

- (void)setIncreaseTitle:(NSString *)increaseTitle{
    _increaseTitle = increaseTitle;
    [self.increaseBtn setTitle:increaseTitle forState:UIControlStateNormal];
}

- (void)setDecreaseTitle:(NSString *)decreaseTitle{
    _decreaseTitle = decreaseTitle;
    [self.decreaseBtn setTitle:decreaseTitle forState:UIControlStateNormal];
}

- (void)setDecreaseImage:(UIImage *)decreaseImage{
    _decreaseImage = decreaseImage;
    [self.decreaseBtn setBackgroundImage:decreaseImage forState:UIControlStateNormal];
}

- (void)setIncreaseImage:(UIImage *)increaseImage{
    _increaseImage = increaseImage;
    [self.increaseBtn setBackgroundImage:increaseImage forState:UIControlStateNormal];
}


/**
 加运算
 */
- (void)increase{
    [self resignFirstResponder];
    _changeAgainValue = _number;
    _number += _stepNumber;

    [self countValueChangeBefore:_changeAgainValue withAfterValue:_number];
}

/**
 减运算

 */
- (void)decrease{
    [self resignFirstResponder];
    _changeAgainValue = _number;

    _number -=_stepNumber;
    
    
    
    [self countValueChangeBefore:_changeAgainValue withAfterValue:_number];
}

- (void)setNumber:(NSInteger)number{
    if (_minNumber > number) {
        _minNumber = number;
    }
    if (_maxNumber < number) {
        _maxNumber = number;
    }
    _number = number;
    _countTextField.text = [NSString stringWithFormat:@"%ld",_number];
}

- (void)setMaxNumber:(NSInteger)maxNumber{
    if (maxNumber < _number) {
        _number = maxNumber;
    }
    if (maxNumber < _minNumber) {
        _minNumber = maxNumber;
    }
    _maxNumber = maxNumber;
    
    _countTextField.text = [NSString stringWithFormat:@"%ld",_number];
}

- (void)setMinNumber:(NSInteger)minNumber{
    if (minNumber > _maxNumber) {
        _maxNumber = minNumber;
    }
    if (minNumber > _number) {
        _number = minNumber;
    }
    _minNumber = minNumber;
    _countTextField.text = [NSString stringWithFormat:@"%ld",_number];
}

- (void)countValueChangeBefore:(NSInteger)againNumber withAfterValue:(NSInteger)afterNumber{
    if (afterNumber >= _maxNumber || afterNumber <= _minNumber) {
        if (afterNumber >= _maxNumber) {
            _number = _maxNumber;
            self.increaseBtn.enabled = NO;
            [self invalidateTimer];
        }else{
            _number = _minNumber;
            self.decreaseBtn.enabled = NO;
            [self invalidateTimer];
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(countViewOverFlow:isMaxNumber:)]) {
            [_delegate countViewOverFlow:self isMaxNumber:_number >= _maxNumber];
        }
        if (_countViewOverFlowHandler) {
            _countViewOverFlowHandler(_number >= _maxNumber);
        }
    }else{
        _number = afterNumber;
    
        if (!self.decreaseBtn.isEnabled && _number > _minNumber) {
            self.decreaseBtn.enabled = YES;
        }
        if (!self.increaseBtn.isEnabled  && _number < _maxNumber) {
            self.increaseBtn.enabled = YES;
        }

    }
    
    _countTextField.text = [NSString stringWithFormat:@"%ld",_number];
    
    if (_delegate && [_delegate respondsToSelector:@selector(countView:number:)]) {
        [_delegate countView:self number:_number];
    }
    if (_countViewChangeHandler) {
        _countViewChangeHandler(_number);
    }
}

- (void)countChange:(id)sender{
    UITextField *textfield = (UITextField *)sender;
    NSInteger inputValue = [textfield.text integerValue];
    _changeAgainValue = _number;
   
    [self countValueChangeBefore:_changeAgainValue withAfterValue:inputValue];
}


#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width =  self.frame.size.width;
    CGFloat height = self.frame.size.height;
    _countTextField.frame = CGRectMake(height, 0, width - 2*height, height);
    self.increaseBtn.frame = CGRectMake(width - height, 0, height, height);
    self.decreaseBtn.frame = CGRectMake(0, 0, height, height);
}


#pragma UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_allowEdit) {
        if (_delegate) {
            if ([_delegate respondsToSelector:@selector(countViewShowKeyBoard)]) {
                [_delegate countViewShowKeyBoard];
            }
        }
    }
    return _allowEdit;
}

- (BOOL)resignFirstResponder{
    NSInteger inputValue = [_countTextField.text integerValue];
    _changeAgainValue = _number;
    if(inputValue < _minNumber){
        _countTextField.text = [NSString stringWithFormat:@"%ld",_number = _minNumber];
        [self countValueChangeBefore:_changeAgainValue withAfterValue:_number];

    }
    return [_countTextField resignFirstResponder];
}

- (BOOL)becomeFirstResponder{
    return [_countTextField becomeFirstResponder];
}

#pragma mark - 加减按钮点击响应

/**
 长按实现连续加减,单次点击,加减一次

 @param sender 操作按钮
 */
- (void)touchDown:(UIButton *)sender
{
    [self resignFirstResponder];

    if (sender == self.increaseBtn)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(increase) userInfo:nil repeats:self.isEnableLongPress];
    }
    else
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(decrease) userInfo:nil repeats:self.isEnableLongPress];
    }
    if (_timer) {
        [_timer fire];
    }
}

/**
 手指移开按钮或松开时执行

 @param sender 操作按钮
 */
- (void)touchUp:(UIButton *)sender
{
    [self invalidateTimer];
}


/**
 停止定时器
 */
- (void)invalidateTimer
{
    if (_timer && _timer.isValid)
    {
        [_timer invalidate];
        _timer = nil;
    }
}


@end
