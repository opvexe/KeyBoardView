//
//  KeyBoardCharView.h
//  SHKeyBoard
//
//  Created by FaceBook on 2019/5/24.
//  Copyright © 2019年 FaceBook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyBoardCharView : UIView
/*
 * 初始化
 */
- (instancetype)initWithFrame:(CGRect)frame charDateSource:(NSArray *)dataSouce;
/*
 * 键盘回调
 */
@property (nonatomic, copy) void(^clickCharsKeyBoardBlock)(NSInteger key,NSString *title);
/*
 * 大小写转换
 */
-(void)switchKeyBoardUperLetters;

@end

NS_ASSUME_NONNULL_END
