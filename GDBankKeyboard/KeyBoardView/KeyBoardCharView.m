//
//  KeyBoardCharView.m
//  RunView
//
//  Created by admin on 17/6/30.
//  Copyright © 2017年 光大银行. All rights reserved.
//

#import "KeyBoardCharView.h"

static const int rowFirstCount    =  10;        //第一列10
static const int rowSecCount      =   9;        //第二列,第三列 9个
static const int column           =   4;        //4行
static const int rowThreeCount    =   7;        //第三列 7 个

@interface KeyBoardCharView ()

@property (nonatomic, strong)                               NSArray         *lowerCharSouce; //小写
@property (nonatomic, strong)                               NSArray         *upperCharSouce; //大写
@property (nonatomic, strong)                               NSArray         *totalButSouce;

@property (nonatomic, strong)                               UIButton        *upperButton;
@property (nonatomic, strong)                               UIButton        *numberButton;
@property (nonatomic, strong)                               UIButton        *deleteButton;
@property (nonatomic, strong)                               UIButton        *symbolsButton;
@property (nonatomic, strong)                               UIButton        *spaceButton;
@property (nonatomic, strong)                               UIButton        *confirmButton;

@property (nonatomic, assign)                               BOOL            isLower;   //小写默认
@end
@implementation KeyBoardCharView
{
    CGFloat     rowSpace;                           //行间隙
    CGFloat     columnSpace;                        //列间隙
    
    CGFloat     charWidth;                          //key 宽度
    CGFloat     charHeight;                         //key 高度
    
    CGFloat     spaceThreeY;                        //第三列的Y
    
    CGFloat     letterW;                            //大写宽度
}
- (instancetype)initWithFrame:(CGRect)frame charDateSource:(NSArray *)dataSouce
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _isLower        = NO;
        _lowerCharSouce = dataSouce;
        
        [self setLayoutCharCollectionButton];
        [self setLayoutLettersCollectionButton];
        [self setLayoutNumbersCollectionButton];
        [self setLayoutSymbolsCollectionButton];
        [self setLayoutSymbolsCollectionButton];
        [self setLayoutConFirmCollectionButton];
        [self setLayoutDeleteCollectionButton];
        [self setLayoutSpaceCollectionButton];
    }
    return self;
}

#pragma mark  布局字母按钮
-(void)setLayoutCharCollectionButton{
    
#pragma mark  布局第一列   10
    rowSpace            = 2;
    columnSpace         = 7;
    
    charWidth  = (self.frame.size.width - rowSpace*(rowFirstCount + 1))/rowFirstCount;
    charHeight = (self.frame.size.height - columnSpace*(column + 1))/column;
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i <rowFirstCount; i++) {
        
        UIButton *btn   = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame       = CGRectMake(rowSpace+(rowSpace+charWidth)*i, columnSpace, charWidth, charHeight);
        [self addSubview:btn];
        [arrM addObject:btn];
    }
#pragma mark  布局第二列 9
    CGFloat  spaceTwoX   = (self.frame.size.width - charWidth*rowSecCount - (rowSecCount-1)*rowSpace)/2;
    CGFloat  spaceTwoY   = charHeight + 2*columnSpace;
    
    for (int i = 0; i< rowSecCount; i++) {
        UIButton *btn    = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame        = CGRectMake(spaceTwoX +(rowSpace+charWidth)*i, spaceTwoY, charWidth, charHeight);
        [self  addSubview:btn];
        [arrM addObject:btn];
    }
    
#pragma mark 布局第三列  7
    CGFloat  spaceThreeX  = (self.frame.size.width - rowThreeCount*charWidth - (rowThreeCount-1)*rowSpace)/2;
    spaceThreeY  = charHeight*2 + 3*columnSpace;
    
    for (int i = 0; i<7; i++) {
        UIButton *btn     = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame         = CGRectMake(spaceThreeX+(rowSpace +charWidth)*i, spaceThreeY, charWidth, charHeight);
        [self addSubview:btn];
        [arrM addObject:btn];
    }
    self.totalButSouce = [NSArray arrayWithArray:arrM];
    [self switchKeyBoardChars];
    //小写转换成大写
    NSMutableArray *upperTemp = [NSMutableArray arrayWithCapacity:self.lowerCharSouce.count];
    for (NSString *lower in self.lowerCharSouce) {
        [upperTemp addObject:[lower uppercaseString]];
    }
    _upperCharSouce = [NSArray arrayWithArray:upperTemp];
    
}

#pragma mark  切换键盘
-(void)switchKeyBoardChars{
    
    _isLower = !_isLower;
    if (_isLower) {         //如果是小写
        _isLower  = YES;
        for (int i = 0 ; i<self.totalButSouce.count; i++) {
            UIButton *button = [self.totalButSouce objectAtIndex:i];
            [button setTitle:self.lowerCharSouce[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:20.0f];
            button.backgroundColor = [UIColor redColor];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button addTarget:self action:@selector(clickChars:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else{                 //若果是大写
        _isLower = NO;
        for (int i = 0 ; i<self.totalButSouce.count; i++) {
            UIButton *button = [self.totalButSouce objectAtIndex:i];
            [button setTitle:self.upperCharSouce[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:20.0f];
            button.backgroundColor = [UIColor redColor];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button addTarget:self action:@selector(clickChars:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

#pragma mark    大小写字符转换
-(void)setLayoutLettersCollectionButton{
    
    letterW                =  ((self.frame.size.width - rowThreeCount*charWidth - (rowThreeCount-1)*rowSpace)/2 -2*rowSpace);
    _upperButton            = [UIButton buttonWithType:UIButtonTypeCustom];
    _upperButton.frame      = CGRectMake(rowSpace, spaceThreeY, letterW, charHeight);
    [self setUpButton:_upperButton setBackgroundImage:@"" hightedsetBackgroundImage:@"" setTitle:@"大写"];
    [_upperButton addTarget:self action:@selector(keyChars:) forControlEvents:UIControlEventTouchUpInside];
    _upperButton.tag        =   2000;
    [self addSubview:self.upperButton];
}

#pragma mark 删除控件
-(void)setLayoutDeleteCollectionButton{
    
    _deleteButton           = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteButton.frame     = CGRectMake(self.frame.size.width-letterW-rowSpace, spaceThreeY, letterW, charHeight);
    [self setUpButton:_deleteButton setBackgroundImage:@"" hightedsetBackgroundImage:@"" setTitle:@"删除"];
    [_deleteButton addTarget:self action:@selector(keyChars:) forControlEvents:UIControlEventTouchUpInside];
    _deleteButton.tag        =   2001;
    [self addSubview:self.deleteButton];
}

#pragma mark    数字转换
-(void)setLayoutNumbersCollectionButton{
    
    _numberButton           = [UIButton buttonWithType:UIButtonTypeCustom];
    _numberButton.frame     = CGRectMake(rowSpace, spaceThreeY + columnSpace +charHeight, letterW, charHeight);
    [self setUpButton:_numberButton setBackgroundImage:@"" hightedsetBackgroundImage:@"" setTitle:@"123"];
    [_numberButton addTarget:self action:@selector(keyChars:) forControlEvents:UIControlEventTouchUpInside];
    _numberButton.tag        =   2002;
    [self addSubview:self.numberButton];
}

#pragma mark   符号转换
-(void)setLayoutSymbolsCollectionButton{
    
    _symbolsButton          = [UIButton buttonWithType:UIButtonTypeCustom];
    _symbolsButton.frame    = CGRectMake(rowSpace*2 + letterW, columnSpace + spaceThreeY +charHeight, letterW, charHeight);
    [self setUpButton:_symbolsButton setBackgroundImage:@"" hightedsetBackgroundImage:@"" setTitle:@"符号"];
    [_symbolsButton addTarget:self action:@selector(keyChars:) forControlEvents:UIControlEventTouchUpInside];
    _symbolsButton.tag        =   2003;
    [self addSubview:self.symbolsButton];
}


#pragma mark  确定控件
-(void)setLayoutConFirmCollectionButton{
    
    _confirmButton          = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.frame    = CGRectMake(self.frame.size.width - rowSpace - 2*letterW, columnSpace + spaceThreeY+charHeight, letterW*2, charHeight);
    [self setUpButton:_confirmButton setBackgroundImage:@"" hightedsetBackgroundImage:@"" setTitle:@"确定"];
    [_confirmButton addTarget:self action:@selector(keyChars:) forControlEvents:UIControlEventTouchUpInside];
    _confirmButton.tag        =   2004;
    [self addSubview:self.confirmButton];
}

#pragma mark  空格操作
-(void)setLayoutSpaceCollectionButton{
    
    _spaceButton            = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat  spaceWidth     = self.frame.size.width - 4*letterW - 5*rowSpace;
    _spaceButton.frame      = CGRectMake(rowSpace*3+2*letterW, columnSpace+spaceThreeY +charHeight, spaceWidth, charHeight);
    [self setUpButton:_spaceButton setBackgroundImage:@"" hightedsetBackgroundImage:@"" setTitle:@"空格键"];
    _spaceButton.backgroundColor = [UIColor yellowColor];
    [_spaceButton addTarget:self action:@selector(keyChars:) forControlEvents:UIControlEventTouchUpInside];
    _spaceButton.tag        =   2005;
    [self addSubview:self.spaceButton];
}

#pragma mark  点击事件
-(void)clickChars:(UIButton *)sender{
    [self onCharsAllClick:sender clickKeyboardTag:2006];
}

-(void)keyChars:(UIButton *)sender{
    [self onCharsAllClick:sender clickKeyboardTag:sender.tag];
}

- (void)onCharsAllClick:(id)sender clickKeyboardTag:(NSInteger)clickKeyboardTag{
    UIButton *button = (UIButton *)sender;
    NSString *titleStr = button.currentTitle;
    if (self.clickCharsKeyBoardBlock) {
        self.clickCharsKeyBoardBlock(clickKeyboardTag,titleStr);
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
