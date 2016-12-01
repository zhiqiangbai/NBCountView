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
    [_firstView setBorderColor:[UIColor greenColor]];
    _firstView.allowEdit = YES;
    [_firstView setDelegate:self];
    _firstView.maxNumber = 10;
    _firstView.enableLongPress = YES;
    [self.view addSubview:_firstView];
    
    
    _secondView = [[NBCountView alloc]initWithFrame:CGRectMake(85, 100, 150, 40)];
    [_secondView setBorderColor:[UIColor redColor]];
    _secondView.allowEdit = YES;
    _secondView.maxNumber = 30;
    _secondView.countViewChangeHandler = ^(NSInteger number){
        NSLog(@"===>>>> %ld",number);
    };
    _secondView.countViewOverFlowHandler = ^(){
        NSLog(@"溢出===>>>>");
    };
    _secondView.layer.cornerRadius = 1;
    [_secondView setStepNumber:3];
    [self.view addSubview:_secondView];
    
    
    _thirdView = [[NBCountView alloc]initWithFrame:CGRectMake(85, 150, 150, 40)];
    [_thirdView setBorderColor:[UIColor redColor]];
    _thirdView.allowEdit = YES;
    [_thirdView setDelegate:self];
    // 采用tintColor设置title字体颜色
    _thirdView.tintColor = [UIColor yellowColor];
    _thirdView.textfieldTextColor = [UIColor greenColor];
    [_thirdView setStepNumber:5];
    [self.view addSubview:_thirdView];
}


- (void)countView:(NBCountView *)countView number:(NSInteger)value{
    NSLog(@"===>>> number == %ld",value);
}

- (void)countViewOverFlow:(NBCountView *)countView{
    NSLog(@"溢出了....");
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
