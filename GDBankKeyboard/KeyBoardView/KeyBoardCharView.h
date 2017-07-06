//
//  KeyBoardCharView.h
//  RunView
//
//  Created by admin on 17/6/30.
//  Copyright © 2017年 光大银行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyBoardCharView : UIView

@property (nonatomic, copy) void(^clickCharsKeyBoardBlock)(NSInteger key,NSString *title);

- (instancetype)initWithFrame:(CGRect)frame charDateSource:(NSArray *)dataSouce;
-(void)switchKeyBoardChars;


@end
