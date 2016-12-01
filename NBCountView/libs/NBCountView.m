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
    button.titleLabel.font = [UIFont boldSystemFontOfSize:self.buttonFont];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    return button;
}

- (UIButton *)decreaseBtn{
    if (!_decreaseBtn) {
        _decreaseBtn = [self creatButton];
    }
    return _decreaseBtn;
}

- (UIButton *)increaseBtn{
    if (!_increaseBtn) {
        _increaseBtn = [self creatButton];
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
    self.stepNumber = 1;
    self.minNumber = 0;
    self.maxNumber = NSIntegerMax;
    self.textfieldFont = 15;
    self.buttonFont = 17;
    self.decreaseTitle = @"－";
    self.increaseTitle = @"＋";
    self.allowEdit = YES;
    self.enableLongPress = NO;
    
    self.countTextField = [NBCountTextField new];
    self.countTextField.delegate = self;
    self.countTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.countTextField.textAlignment = NSTextAlignmentCenter;
    self.countTextField.font = [UIFont systemFontOfSize:_textfieldFont];
    self.countTextField.text = [NSString stringWithFormat:@"%ld",_minNumber];
    [self.countTextField addTarget:self action:@selector(countChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.decreaseBtn];
    [self addSubview:self.countTextField];
    [self addSubview:self.increaseBtn];

}

- (void)setTextfieldTextColor:(UIColor *)textfieldTextColor{
    _textfieldTextColor = textfieldTextColor;
    self.countTextField.textColor = textfieldTextColor;
}

- (void)setTintColor:(UIColor *)tintColor{
    [super setTintColor:tintColor];
    [self.increaseBtn setTitleColor:tintColor forState:UIControlStateNormal];
    [self.decreaseBtn setTitleColor:tintColor forState:UIControlStateNormal];
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
    self.changeAgainValue = _number;
    _number = _number+self.stepNumber > self.maxNumber ? self.maxNumber : _number + self.stepNumber;
    
    // 如果当前值是最小值,则停止进行运算
    if (_number+self.stepNumber > self.maxNumber) {
        [self invalidateTimer];
    }
    
    [self countValueChangeBefore:self.changeAgainValue withAfterValue:_number];
}

/**
 减运算

 */
- (void)decrease{
    [self resignFirstResponder];
    self.changeAgainValue = _number;

    _number = _number-self.stepNumber < self.minNumber ? self.minNumber : _number - self.stepNumber;
    
    // 如果当前值是最小值,则停止进行运算
    if (_number-self.stepNumber < self.minNumber) {
        [self invalidateTimer];
    }
    
    [self countValueChangeBefore:self.changeAgainValue withAfterValue:_number];
}

- (void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 1;
    
    self.increaseBtn.layer.borderColor = borderColor.CGColor;
    self.increaseBtn.layer.borderWidth = 1;
    
    self.decreaseBtn.layer.borderWidth = 1;
    self.decreaseBtn.layer.borderColor = borderColor.CGColor;
    
    [self.increaseBtn setTitleColor:borderColor forState:UIControlStateNormal];
    [self.decreaseBtn setTitleColor:borderColor forState:UIControlStateNormal];
}

- (void)setNumber:(NSInteger)number{
    
    [self countValueChangeBefore:_number withAfterValue:number];

//    if (number< self.minNumber || number > self.maxNumber) {
//        return;
//    }
//    _number = number;
//    self.countTextField.text = [NSString stringWithFormat:@"%ld",_number];
}

- (void)countValueChangeBefore:(NSInteger)againNumber withAfterValue:(NSInteger)afterNumber{
    if (afterNumber > self.maxNumber || afterNumber < self.minNumber) {
        if (_delegate && [_delegate respondsToSelector:@selector(countViewOverFlow:)]) {
            [_delegate countViewOverFlow:self];
        }
        if (self.countViewOverFlowHandler) {
            self.countViewOverFlowHandler();
        }
        _number = againNumber;
    }else{
        _number = afterNumber;
    }
    self.countTextField.text = [NSString stringWithFormat:@"%ld",_number];
    
    if (_delegate && [_delegate respondsToSelector:@selector(countView:number:)]) {
        [_delegate countView:self number:_number];
    }
    if (self.countViewChangeHandler) {
        self.countViewChangeHandler(_number);
    }
}

- (void)countChange:(id)sender{
    UITextField *textfield = (UITextField *)sender;
    NSInteger inputValue = [textfield.text integerValue];
    self.changeAgainValue = _number;
   
    [self countValueChangeBefore:self.changeAgainValue withAfterValue:inputValue];
}


#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width =  self.frame.size.width;
    CGFloat height = self.frame.size.height;
    _countTextField.frame = CGRectMake(height, 0, width - 2*height, height);
    _increaseBtn.frame = CGRectMake(width - height, 0, height, height);
    _decreaseBtn.frame = CGRectMake(0, 0, height, height);
}


#pragma UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.allowEdit) {
        if (_delegate) {
            if ([_delegate respondsToSelector:@selector(countViewShowKeyBoard)]) {
                [_delegate countViewShowKeyBoard];
            }
        }
    }
    return self.allowEdit;
}

- (BOOL)resignFirstResponder{
    NSInteger inputValue = [self.countTextField.text integerValue];
    self.changeAgainValue = _number;
    if(inputValue < self.minNumber){
        self.countTextField.text = [NSString stringWithFormat:@"%ld",_number = self.minNumber];
        [self countValueChangeBefore:self.changeAgainValue withAfterValue:_number];

    }
    return [self.countTextField resignFirstResponder];
}

- (BOOL)becomeFirstResponder{
    return [self.countTextField becomeFirstResponder];
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
        if (_number <= self.maxNumber - self.stepNumber) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(increase) userInfo:nil repeats:self.isEnableLongPress];
        }
    }
    else
    {
        if (_number>=self.minNumber+self.stepNumber) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(decrease) userInfo:nil repeats:self.isEnableLongPress];
        }
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
    if (_timer.isValid)
    {
        [_timer invalidate];
        _timer = nil;
    }
}


@end
