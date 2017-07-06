//
//  VerRunView.h
//  VerticalRunView
//
//  Created by admin on 17/6/29.
//  Copyright © 2017年 光大银行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerRunView : UIView

- (instancetype)initWithFrame:(CGRect)frame setBgColor:(UIColor *)bgColor textColor:(UIColor *)textColor textFont:(UIFont *)Font;

@property(nonatomic, assign)                   CGFloat            cornerRadius;
@property(nonatomic, assign)                   NSTimeInterval     scrollDuration;
@property(nonatomic, assign)                   NSTimeInterval     stayDuration;
@property(nonatomic, assign)                   BOOL               hasGradient;
@property(nonatomic, strong)                   NSArray            *messageArray;
@property(nonatomic, copy)                     void(^clickBtnBlock)(NSInteger sender);

-(void)stop;
-(void)strat;
@end
