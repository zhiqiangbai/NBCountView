//
//  NBCountView.m
//  NBCountView
//
//  Created by NapoleonBai on 15/5/22.
//  Copyright (c) 2015年 NapoleonBai. All rights reserved.
//

#import "NBCountView.h"

@interface NBCountView ()

@property(nonatomic,strong)UIButton *lessBtn;
@property(nonatomic,strong)UIButton *addBtn;
@property(nonatomic,strong)UITextField *countTextField;

@property(nonatomic,assign)NSInteger currentValue;
@property(nonatomic,assign)NSInteger maxValue;
@property(nonatomic,assign)NSInteger minValue;
@property(nonatomic,assign)NSInteger changeAgainValue;

@property(nonatomic,copy)UIColor *borderColor;
@property(nonatomic,copy)UIColor *backgroudColor;

@property(nonatomic,assign)BOOL isEdit;

@end

@implementation NBCountView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self == nil) {
        self = [[NBCountView alloc]initWithFrame:frame];
    }
    if (self) {
        [self initView:frame];
    }
    return self;
}

- (void)initView:(CGRect)frame{
    self.lessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lessBtn.frame = CGRectMake(0, 0, frame.size.width/4, frame.size.height);
    [self.lessBtn setTitle:@"－" forState:UIControlStateNormal];
    self.lessBtn.titleLabel.font = [UIFont systemFontOfSize:30];
    [self.lessBtn addTarget:self action:@selector(lessCount:) forControlEvents:UIControlEventTouchUpInside];
    self.lessBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn.frame = CGRectMake(frame.size.width/4*3, 0, frame.size.width/4, frame.size.height);
    [self.addBtn setTitle:@"＋" forState:UIControlStateNormal];
    self.addBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.addBtn addTarget:self action:@selector(addCount:) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn.titleLabel.font = [UIFont systemFontOfSize:30];
    
    self.countTextField = [[UITextField alloc]initWithFrame:CGRectMake(frame.size.width/4, 0, frame.size.width/2, frame.size.height)];
    self.countTextField.delegate = self;
    self.countTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.countTextField.textAlignment = NSTextAlignmentCenter;
    self.countTextField.font = [UIFont systemFontOfSize:20];
    
    self.stepValue = 1;//默认每步+1
    self.minValue = 0;
    self.maxValue = 100;
    
    [self addSubview:self.lessBtn];
    [self addSubview:self.countTextField];
    [self addSubview:self.addBtn];
}

- (void)addCount:(id)sender{
    [self resignFirstResponder];
    self.changeAgainValue = self.currentValue;
    self.currentValue = self.currentValue+self.stepValue > self.maxValue ? self.maxValue : self.currentValue + self.stepValue;
    [self countValueChangeBefore:self.changeAgainValue withAfterValue:self.changeAgainValue + self.stepValue > self.maxValue ? self.maxValue : self.changeAgainValue + self.stepValue];
    
    self.countTextField.text = [NSString stringWithFormat:@"%lu",self.currentValue ];
}

- (void)lessCount:(id)sender{
    [self resignFirstResponder];
    self.changeAgainValue = self.currentValue;

    self.currentValue = self.currentValue-self.stepValue < self.minValue ? self.minValue : self.currentValue - self.stepValue;
    [self countValueChangeBefore:self.changeAgainValue withAfterValue:(self.changeAgainValue - self.stepValue)<0 ? self.minValue : self.changeAgainValue - self.stepValue];

    self.countTextField.text = [NSString stringWithFormat:@"%lu",self.currentValue ];
}

- (void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    self.addBtn.layer.borderColor = borderColor.CGColor;
    self.addBtn.layer.borderWidth = 1;
    
    self.lessBtn.layer.borderWidth = 1;
    self.lessBtn.layer.borderColor = borderColor.CGColor;
    
    [self.addBtn setTitleColor:borderColor forState:UIControlStateNormal];
    [self.lessBtn setTitleColor:borderColor forState:UIControlStateNormal];
}

- (void)setCurrentValue:(NSInteger)currentValue withMaxValue:(NSInteger) maxValue withMinValue:(NSInteger)minValue{
    self.maxValue = maxValue;
    self.minValue = minValue;
    self.currentValue = currentValue;
    self.countTextField.text = [NSString stringWithFormat:@"%lu",currentValue < self.minValue ? self.minValue : (self.maxValue > currentValue ? currentValue : self.maxValue)];
}

- (void)setCurrentValues:(NSInteger)currentValue{
    [self setCurrentValue:currentValue withMaxValue:self.maxValue withMinValue:self.minValue];
}

- (void)setCountViewEdit:(BOOL)isEdit{
    self.isEdit = isEdit;
    [self.countTextField addTarget:self action:@selector(countChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)countValueChangeBefore:(NSInteger)againValue withAfterValue:(NSInteger)afterValue{
    if (_delegate) {
        if (afterValue > self.maxValue) {
            if ([_delegate respondsToSelector:@selector(countViewValue:moreThanMaxValue:)]) {
                [_delegate countViewValue:afterValue moreThanMaxValue:self.currentValue];
            }
        }else if (afterValue < self.minValue) {
            if ([_delegate respondsToSelector:@selector(countViewValue:lessThanMinValue:)]) {
                [_delegate countViewValue:afterValue lessThanMinValue:self.currentValue];
            }
        }else{
            if ([_delegate respondsToSelector:@selector(countViewValueChangeAgain:after:)]) {
                [_delegate countViewValueChangeAgain:againValue after:afterValue];
            }
        }
    }
}

- (void)countChange:(id)sender{
    UITextField *textfield = (UITextField *)sender;
    NSInteger inputValue = [textfield.text integerValue];
    self.changeAgainValue = self.currentValue;
    if (inputValue > self.maxValue) {
        textfield.text = [NSString stringWithFormat:@"%lu",self.currentValue = self.maxValue];
    }
    else if(inputValue < self.minValue){
        //textfield.text = [NSString stringWithFormat:@"%lu",self.currentValue = self.minValue];
    }
    else{
        self.currentValue = inputValue;
    }
    [self countValueChangeBefore:self.changeAgainValue withAfterValue:inputValue < self.minValue ? self.minValue : inputValue];
}

#pragma UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.isEdit) {
        if (_delegate) {
            if ([_delegate respondsToSelector:@selector(countViewShowKeyBoard)]) {
                [_delegate countViewShowKeyBoard];
            }
        }
    }
    return self.isEdit;
}

- (BOOL)resignFirstResponder{
    NSInteger inputValue = [self.countTextField.text integerValue];
    self.changeAgainValue = self.currentValue;
    if(inputValue < self.minValue){
        self.countTextField.text = [NSString stringWithFormat:@"%lu",self.currentValue = self.minValue];
        [self countValueChangeBefore:self.changeAgainValue withAfterValue:self.currentValue];

    }
    return [self.countTextField resignFirstResponder];
}

- (BOOL)becomeFirstResponder{
    return [self.countTextField becomeFirstResponder];
}

@end
