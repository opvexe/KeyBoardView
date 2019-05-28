//
//  KeyBoardNumberView.m
//  SHKeyBoard
//
//  Created by FaceBook on 2019/5/24.
//  Copyright © 2019年 FaceBook. All rights reserved.
//

#import "KeyBoardNumberView.h"
#import "UIView+Category.h"
#import <AudioToolbox/AudioToolbox.h>

static const int row    = 4;                //4行
static const int column = 3;                //3列

@interface KeyBoardNumberView ()
@property (nonatomic, strong)NSMutableArray   *randomnNubersArray;
@property (nonatomic, strong)UIButton         *confirmButton;
@property (nonatomic, strong)UIButton         *deleteButton;
@property (nonatomic, strong)UIButton         *returnButton;
@property (nonatomic, strong)UIButton         *dotButton;
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


- (instancetype)initWithFrame:(CGRect)frame randomNumbers:(NSMutableArray *)randomDateSouce{
    self = [super initWithFrame:frame];
    if (self) {
        
        _randomnNubersArray  = randomDateSouce;
        [self setLayoutNumCollectionButton];
        [self setLayoutCharOthersCollectionButton];
    }
    return self;
}

-(void)setLayoutNumCollectionButton{
    
    //计算右侧 确认，删除按钮的宽高
    numberKeyBoardRightHeight           = self.frame.size.height/2;
    numberKeyBoardRightWidth            = self.frame.size.height/2;
    
    //计算数字按钮的 宽高
    numberKeyBoardWidth                 = (self.frame.size.width - numberKeyBoardRightWidth)/column;
    numberKeyBoardHeight                = self.frame.size.height/row;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    for (NSInteger i = 0; i <3; i++) {
        for (NSInteger j = 0; j <3; j++) {          //9宫格布局
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(numberKeyBoardWidth*j, numberKeyBoardHeight*i, numberKeyBoardWidth, numberKeyBoardHeight);
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:25];
            [self addSubview:btn];
            [array addObject:btn];
        }
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(numberKeyBoardWidth, 3*numberKeyBoardHeight, numberKeyBoardWidth, numberKeyBoardHeight);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:25];
    [self addSubview:btn];
    [array addObject:btn];
    
    
    for (int i = 0; i < array.count; i++){
        UIButton *button = [array objectAtIndex:i];
        NSString *title = self.randomnNubersArray[i];
        [button addTopBorderWithColor:[UIColor lightGrayColor] andWidth:.5];
        [button addRightBorderWithColor:[UIColor lightGrayColor] andWidth:.5];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button addTarget:self action:@selector(clickNumbers:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)setLayoutCharOthersCollectionButton{
    
    _deleteButton = ({
        UIButton *iv = [UIButton buttonWithType:UIButtonTypeCustom];
        iv.frame = CGRectMake(column*numberKeyBoardWidth, 0, numberKeyBoardRightWidth, numberKeyBoardRightHeight);
        [iv addTopBorderWithColor:[UIColor lightGrayColor] andWidth:.5];
        [iv setTitle:@"删除" forState:UIControlStateNormal];
        iv.tag = 101;
        [iv setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [iv addTarget:self action:@selector(keyNumbers:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:iv];
        iv;
    });
    
    _confirmButton = ({
        UIButton *iv = [UIButton buttonWithType:UIButtonTypeCustom];
        iv.frame = CGRectMake(column*numberKeyBoardWidth, numberKeyBoardRightHeight, numberKeyBoardRightWidth, numberKeyBoardRightHeight);
        [iv addTopBorderWithColor:[UIColor lightGrayColor] andWidth:.5];
        [iv setTitle:@"确定" forState:UIControlStateNormal];
        iv.tag = 102;
        [iv setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [iv addTarget:self action:@selector(keyNumbers:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:iv];
        iv;
    });
    
    _returnButton = ({
        UIButton *iv = [UIButton buttonWithType:UIButtonTypeCustom];
        iv.frame = CGRectMake((column -1)*numberKeyBoardWidth, (row -1)*numberKeyBoardHeight, numberKeyBoardWidth, numberKeyBoardHeight);
        [iv addTopBorderWithColor:[UIColor lightGrayColor] andWidth:.5];
        [iv addRightBorderWithColor:[UIColor lightGrayColor] andWidth:.5];
        [iv setTitle:@"返回" forState:UIControlStateNormal];
        iv.tag = 103;
        [iv setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [iv addTarget:self action:@selector(keyNumbers:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:iv];
        iv;
    });
    
    _dotButton = ({
        UIButton *iv = [UIButton buttonWithType:UIButtonTypeCustom];
        iv.frame = CGRectMake(0, (row-1)*numberKeyBoardHeight, numberKeyBoardWidth, numberKeyBoardHeight);
        [iv addTarget:self action:@selector(keyNumbers:) forControlEvents:UIControlEventTouchUpInside];
        [iv addTopBorderWithColor:[UIColor lightGrayColor] andWidth:.5];
        [iv addRightBorderWithColor:[UIColor lightGrayColor] andWidth:.5];
        [iv setTitle:@"." forState:UIControlStateNormal];
        iv.tag = 104;
        [iv setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:iv];
        iv;
    });
}

-(void)clickNumbers:(UIButton *)sender{
      AudioServicesPlaySystemSound(1104);
    [self onNumbersAllClick:sender clickKeyboardTag:100];
}

-(void)keyNumbers:(UIButton *)sender{
    AudioServicesPlaySystemSound(1105);
    [self onNumbersAllClick:sender clickKeyboardTag:sender.tag];
}

- (void)onNumbersAllClick:(id)sender clickKeyboardTag:(NSInteger)clickKeyboardTag{
    UIButton *button = (UIButton *)sender;
    NSString *titleStr = button.currentTitle;
    if (self.keyBoardNumbersBlock) {
        self.keyBoardNumbersBlock(clickKeyboardTag,titleStr);
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
