//
//  KeyBoardNumberView.m
//  RunView
//
//  Created by admin on 17/6/30.
//  Copyright © 2017年 光大银行. All rights reserved.
//

#import "KeyBoardNumberView.h"

static const int row    = 4;                //4行
static const int column = 3;                //3列

@interface KeyBoardNumberView ()

@property (nonatomic, strong)           NSMutableArray   *randomnNubersArray;

@property (nonatomic, strong)           UIButton         *confirmButton;
@property (nonatomic, strong)           UIButton         *deleteButton;
@property (nonatomic, strong)           UIButton         *returnButton;

@property (nonatomic, assign)           KeyBoardNumbersStyle numbersStyle;
@end

@implementation KeyBoardNumberView
{
    /* 每个数字按钮的宽 ，高*/
    CGFloat             numberKeyBoardWidth;
    CGFloat             numberKeyBoardHeight;
    /* 右侧确认数字的宽  ，高*/
    CGFloat             numberKeyBoardRightWidth;
    CGFloat             numberKeyBoardRightHeight;
}

- (instancetype)initWithFrame:(CGRect)frame randomNumbers:(NSMutableArray *)randomDateSouce KeyBoardStyles:(KeyBoardNumbersStyle)numberStyle
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _numbersStyle        = numberStyle;
        _randomnNubersArray  = randomDateSouce;
    
        [self setLayoutNumCollectionButton];
        [self setLayoutDeleteButton];
        [self setLayoutConfirmButton];
        [self setLayoutRetrunButton];
        
        switch (_numbersStyle) {
            case KeyBoardNumbersStyleDefault:
            {
                [self setLayoutSwitchButtontitle:@"ABC"];
            }
                break;
            case KeyBoardNumbersStyleDot:
            {
                [self setLayoutSwitchButtontitle:@"."];
            }
                break;
            default:
                break;
        }
    }
    return self;
}

#pragma mark  布局数字button
-(void)setLayoutNumCollectionButton{
    
    //计算右侧 确认，删除按钮的宽高
    numberKeyBoardRightHeight           = self.frame.size.height/2;
    numberKeyBoardRightWidth            = self.frame.size.height/2;
    
    //计算数字按钮的 宽高
    numberKeyBoardWidth                 = (self.frame.size.width - numberKeyBoardRightWidth)/column;
    numberKeyBoardHeight                = self.frame.size.height/row;
    
    //创建一个空数组 装buuton
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    for (NSInteger i = 0; i <3; i++) {
        
        for (NSInteger j = 0; j <3; j++) {          //9宫格布局
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(numberKeyBoardWidth*j, numberKeyBoardHeight*i, numberKeyBoardWidth, numberKeyBoardHeight);
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
            [self addSubview:btn];
            [array addObject:btn];
        }
    }
    //布局第4列 中间那个数字
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(numberKeyBoardWidth, 3*numberKeyBoardHeight, numberKeyBoardWidth, numberKeyBoardHeight);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [self addSubview:btn];
    [array addObject:btn];
    
#warning 判断数组是否为空
    for (int i = 0; i < array.count; i++){
        UIButton *button = [array objectAtIndex:i];
        NSNumber *number = self.randomnNubersArray[i];
        NSString *title = number.stringValue;
        [button setTitle:title forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor]];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button addTarget:self action:@selector(clickNumbers:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark 布局切换按钮
-(void)setLayoutSwitchButtontitle:(NSString *)switchTitle{
    self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchButton.frame = CGRectMake(0, (row-1)*numberKeyBoardHeight, numberKeyBoardWidth, numberKeyBoardHeight);
    [self setUpButton:self.switchButton setBackgroundImage:@"" hightedsetBackgroundImage:@"" setTitle:switchTitle];
    self.switchButton.tag = 1000;
    [self.switchButton addTarget:self action:@selector(keyNumbers:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.switchButton];
}

#pragma mark 布局删除按钮
-(void)setLayoutDeleteButton{
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteButton.frame = CGRectMake(column*numberKeyBoardWidth, 0, numberKeyBoardRightWidth, numberKeyBoardRightHeight);
    [self setUpButton:_deleteButton setBackgroundImage:@"" hightedsetBackgroundImage:@"" setTitle:@"删除"];
    _deleteButton.tag = 1001;
    [_deleteButton addTarget:self action:@selector(keyNumbers:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteButton];
}

#pragma mark 布局确定按钮
-(void)setLayoutConfirmButton{
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.frame = CGRectMake(column*numberKeyBoardWidth, numberKeyBoardRightHeight, numberKeyBoardRightWidth, numberKeyBoardRightHeight);
    [self setUpButton:_confirmButton setBackgroundImage:@"" hightedsetBackgroundImage:@"" setTitle:@"确定"];
    _confirmButton.tag = 1002;
    [_confirmButton addTarget:self action:@selector(keyNumbers:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.confirmButton];
}

#pragma mark 布局键盘回收按钮
-(void)setLayoutRetrunButton{
    _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _returnButton.frame = CGRectMake((column -1)*numberKeyBoardWidth, (row -1)*numberKeyBoardHeight, numberKeyBoardWidth, numberKeyBoardHeight);
    [self setUpButton:_returnButton setBackgroundImage:@"" hightedsetBackgroundImage:@"" setTitle:@"返回"];
    _returnButton.tag = 1003;
    [_returnButton addTarget:self action:@selector(keyNumbers:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.returnButton];
}

-(void)clickNumbers:(UIButton *)sender{
    [self onNumbersAllClick:sender clickKeyboardTag:1004];
}

-(void)keyNumbers:(UIButton *)sender{
    [self onNumbersAllClick:sender clickKeyboardTag:sender.tag];
}

- (void)onNumbersAllClick:(id)sender clickKeyboardTag:(NSInteger)clickKeyboardTag{
    UIButton *button = (UIButton *)sender;
    NSString *titleStr = button.currentTitle;
    if (self.keyBoardNumbersBlock) {
        self.keyBoardNumbersBlock(clickKeyboardTag,titleStr);
    }
}

-(void)setUpButton:(UIButton *)button setBackgroundImage:(NSString *)normalSetBackgroundImage hightedsetBackgroundImage:(NSString *)hightSetBackgroundImage setTitle:(NSString *)title{
    [button setBackgroundImage:[UIImage imageNamed:normalSetBackgroundImage] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:hightSetBackgroundImage] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
}

@end
