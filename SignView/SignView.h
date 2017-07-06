//
//  SignView.h
//  RunView
//
//  Created by admin on 17/6/29.
//  Copyright © 2017年 光大银行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignView : UIView

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor;

-(void)cleanContext;                //清除上下文

@end
