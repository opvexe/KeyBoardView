//
//  KeyBoardNumberView.h
//  SHKeyBoard
//
//  Created by FaceBook on 2019/5/24.
//  Copyright © 2019年 FaceBook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyBoardNumberView : UIView
/*
 * 初始化
 */
- (instancetype)initWithFrame:(CGRect)frame randomNumbers:(NSMutableArray *)randomDateSouce;
/*
 * 键盘回调
 */
@property (nonatomic, copy) void(^keyBoardNumbersBlock)(NSInteger key,NSString *title);

@end

NS_ASSUME_NONNULL_END
