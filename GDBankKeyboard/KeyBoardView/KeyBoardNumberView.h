//
//  KeyBoardNumberView.h
//  RunView
//
//  Created by admin on 17/6/30.
//  Copyright © 2017年 光大银行. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KeyBoardNumbersStyle){
    
    KeyBoardNumbersStyleDefault  =  1,           //默认字母 --不含小数点
    KeyBoardNumbersStyleDot,                     //小数点
};
@interface KeyBoardNumberView : UIView

@property (nonatomic, strong)           UIButton         *switchButton;

@property (nonatomic, copy) void(^keyBoardNumbersBlock)(NSInteger key,NSString *title);

- (instancetype)initWithFrame:(CGRect)frame randomNumbers:(NSArray *)randomDateSouce KeyBoardStyles:(KeyBoardNumbersStyle)numberStyle;

@end
