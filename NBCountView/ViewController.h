//
//  ViewController.h
//  NBCountView
//
//  Created by NapoleonBai on 15/5/26.
//  Copyright (c) 2015年 NapoleonBai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBCountView.h"

@interface ViewController : UIViewController<NBCountViewDelegate>
@property (strong, nonatomic) NBCountView *firstView;
@property (strong, nonatomic) NBCountView *secondView;
@property (strong, nonatomic) NBCountView *thirdView;

@end

