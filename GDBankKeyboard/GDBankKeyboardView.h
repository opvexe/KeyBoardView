//
//  GDBankKeyboardView.h
//  RunView
//
//  Created by admin on 17/6/30.
//  Copyright © 2017年 光大银行. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KeyBoardLayoutStyle){
    
    KeyBoardLayoutStyleDefault  =  1,           //默认字母
    KeyBoardLayoutStyleNumbers,                 //数字
    KeyBoardLayoutStyleLetters,                 //大写字母
    KeyBoardLayoutStyleUperLetters,             //小些字母
    KeyBoardLayoutStyleSymbol                   //符号
};


@interface GDBankKeyboardView : UIView

/*
 * 键盘类型
 */
@property (nonatomic, assign)          KeyBoardLayoutStyle  KeyBoardLayoutStyle;

/*
 * 是否打开数字键盘随机数字
 */
@property (nonatomic, assign)          BOOL                 isOpen;

/*
 * 是否隐藏ABC
 */
@property (nonatomic, assign)          BOOL                 isHide;

/*
 * 工厂模式初始化键盘
 */
-(instancetype)initWithKeyBoard;

/*
 * 关联inputTextField
 */
- (void)setInputTextField:(UITextField *)inputTextField;


@end
