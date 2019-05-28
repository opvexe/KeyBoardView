//
//  KeyBoardView.h
//  SHKeyBoard
//
//  Created by FaceBook on 2019/5/24.
//  Copyright © 2019年 FaceBook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KeyBoardLayoutStyle){
    KeyBoardLayoutStyleDefault  =  1,           //默认字母
    KeyBoardLayoutStyleNumbers,                 //数字
    KeyBoardLayoutStyleSymbol,                  //符号
};

@interface KeyBoardView : UIView
/*
 * 是否打开数字键盘随机数字
 */
@property(nonatomic,assign)BOOL isOpen;
/*
 * 工厂模式初始化键盘
 */
-(instancetype)initWithKeyBoardStyle:(KeyBoardLayoutStyle)KeyBoardLayoutStyle;
/*
 * 关联inputTextField
 */
- (void)setInputTextField:(UITextField *)inputTextField;
@end

NS_ASSUME_NONNULL_END
