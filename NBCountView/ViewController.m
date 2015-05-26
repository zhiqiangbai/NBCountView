//
//  ViewController.m
//  NBCountView
//
//  Created by NapoleonBai on 15/5/26.
//  Copyright (c) 2015年 NapoleonBai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _firstView = [[NBCountView alloc]initWithFrame:CGRectMake(85, 50, 150, 40)];
    [_firstView setCurrentValue:1 withMaxValue:100 withMinValue:1];
    [_firstView setBorderColor:[UIColor greenColor]];
    [self.view addSubview:_firstView];
    
    _secondView = [[NBCountView alloc]initWithFrame:CGRectMake(85, 100, 150, 40)];
    [_secondView setCurrentValue:1 withMaxValue:100 withMinValue:1];
    [_secondView setBorderColor:[UIColor redColor]];
    [_secondView setStepValue:3];
    [self.view addSubview:_secondView];
    
    
    _thirdView = [[NBCountView alloc]initWithFrame:CGRectMake(85, 150, 150, 40)];
    [_thirdView setCurrentValue:1 withMaxValue:1000 withMinValue:1];
    [_thirdView setBorderColor:[UIColor redColor]];
    [_thirdView setCountViewEdit:YES];
    [_thirdView setDelegate:self];
    [_thirdView setStepValue:5];
    [self.view addSubview:_thirdView];
}

- (void)countViewValue:(NSInteger) value moreThanMaxValue:(NSInteger) maxValue{
    NSLog(@"---currentValue->>>>%lu--maxValue->>>%lu",value,maxValue);
}

//获取当前值和最小值
- (void)countViewValue:(NSInteger) value lessThanMinValue:(NSInteger) minValue{
    NSLog(@"-currentValue--->>>>%lu- minValue-->>>%lu",value,minValue);

}

- (void)countViewValueChangeAgain:(NSInteger) againValue after:(NSInteger)currentValue{
    NSLog(@"-currentValue--->>>>%lu--->>currentValue===>%lu",againValue,currentValue);
}

- (void)countViewShowKeyBoard{
    NSLog(@"show keyboard");
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_thirdView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
