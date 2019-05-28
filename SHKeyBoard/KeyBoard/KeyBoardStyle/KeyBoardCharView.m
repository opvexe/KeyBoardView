//
//  KeyBoardCharView.m
//  SHKeyBoard
//
//  Created by FaceBook on 2019/5/24.
//  Copyright © 2019年 FaceBook. All rights reserved.
//

#import "KeyBoardCharView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "CYRKeyboardButton.h"

static const int rowFirstCount    =  10;        //第一列10
static const int rowSecCount      =   9;        //第二列,第三列 9个
static const int rowThreeCount    =   7;        //第三列 7 个
static const int column           =   4;        //4行

@interface KeyBoardCharView ()
@property(nonatomic,strong)NSArray *lowerCharSouce; //小写
@property(nonatomic,strong)NSArray *upperCharSouce; //大写
@property(nonatomic,strong)NSArray *totalButSouce;  //总共按钮
@property(nonatomic,strong)UIButton *upperButton;   //小写按钮
@property(nonatomic,strong)UIButton *numberButton;  //数字按钮
@property(nonatomic,strong)UIButton *deleteButton;  //删除按钮
@property(nonatomic,strong)UIButton *spaceButton;   //空格按钮
@property(nonatomic,strong)UIButton *confirmButton; //确认按钮
@property(nonatomic,assign)BOOL isLower; //默认小写
@property(nonatomic,assign)BOOL isChar;  //默认字符
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

- (instancetype)initWithFrame:(CGRect)frame charDateSource:(NSArray *)dataSouce{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _isLower = NO;
        _isChar = NO;
        _lowerCharSouce = dataSouce;
        [self setLayoutCharCollectionButton];
        [self setLayoutCharOthersCollectionButton];
    }
    return self;
}

//MARK:字符按钮布局
-(void)setLayoutCharCollectionButton{
    
    //MARK: 布局第1列 10
    rowSpace            = 8;
    columnSpace         = 8;
    
    charWidth  = (self.frame.size.width - rowSpace*(rowFirstCount + 1))/rowFirstCount;
    charHeight = (self.frame.size.height - columnSpace*(column + 1))/column;
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i <rowFirstCount; i++) {
        CYRKeyboardButton *btn   = [CYRKeyboardButton new];
        btn.frame       = CGRectMake(rowSpace+(rowSpace+charWidth)*i, columnSpace, charWidth, charHeight);
        [self addSubview:btn];
        [arrM addObject:btn];
    }
    
    //MARK: 布局第2列 9
    CGFloat  spaceTwoX   = (self.frame.size.width - charWidth*rowSecCount - (rowSecCount-1)*rowSpace)/2;
    CGFloat  spaceTwoY   = charHeight + 2*columnSpace;
    
    for (int i = 0; i< rowSecCount; i++) {
        CYRKeyboardButton *btn    = [CYRKeyboardButton new];
        btn.frame        = CGRectMake(spaceTwoX +(rowSpace+charWidth)*i, spaceTwoY, charWidth, charHeight);
        [self  addSubview:btn];
        [arrM addObject:btn];
    }
    
    //MARK: 布局第3列 7
    CGFloat  spaceThreeX  = (self.frame.size.width - rowThreeCount*charWidth - (rowThreeCount-1)*rowSpace)/2;
    spaceThreeY  = charHeight*2 + 3*columnSpace;
    for (int i = 0; i<7; i++) {
        CYRKeyboardButton *btn     = [CYRKeyboardButton new];
        btn.frame         = CGRectMake(spaceThreeX+(rowSpace +charWidth)*i, spaceThreeY, charWidth, charHeight);
        [self addSubview:btn];
        [arrM addObject:btn];
    }
    self.totalButSouce = [NSArray arrayWithArray:arrM];
    [self switchKeyBoardUperLetters];
    //小写转换成大写
    NSMutableArray *upperTemp = [NSMutableArray arrayWithCapacity:self.lowerCharSouce.count];
    for (NSString *lower in self.lowerCharSouce) {
        [upperTemp addObject:[lower uppercaseString]];
    }
    _upperCharSouce = [NSArray arrayWithArray:upperTemp];
    
}

//MARK:切换大小写
-(void)switchKeyBoardUperLetters{
    _isLower = !_isLower;
    if (_isLower) {         //如果是小写
        _isLower  = YES;
        for (int i = 0 ; i<self.totalButSouce.count; i++) {
            CYRKeyboardButton *button = [self.totalButSouce objectAtIndex:i];
            button.font = [UIFont systemFontOfSize:22];
            button.keyTextColor = [UIColor blackColor];
            button.keyHighlightedColor = [UIColor blackColor];
            button.keyShadowColor = [UIColor lightGrayColor];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.style = CYRKeyboardButtonStylePhone;
            button.input = self.lowerCharSouce[i];
            [button addTarget:self action:@selector(clickChars:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else{                 //若果是大写
        _isLower = NO;
        for (int i = 0 ; i<self.totalButSouce.count; i++) {
            CYRKeyboardButton *button = [self.totalButSouce objectAtIndex:i];
            button.font = [UIFont systemFontOfSize:22];
            button.keyTextColor = [UIColor blackColor];
            button.keyHighlightedColor = [UIColor blackColor];
            button.keyShadowColor = [UIColor lightGrayColor];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.style = CYRKeyboardButtonStylePhone;
            button.input = self.upperCharSouce[i];
            [button addTarget:self action:@selector(clickChars:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

//MARK:其他按钮
-(void)setLayoutCharOthersCollectionButton{
    
    letterW  =  ((self.frame.size.width - rowThreeCount*charWidth - (rowThreeCount-1)*rowSpace)/2 -2*rowSpace);
    
    _upperButton = ({  //大小写
        UIButton *iv = [UIButton buttonWithType:UIButtonTypeCustom];
        iv.frame = CGRectMake(rowSpace, spaceThreeY, letterW, charHeight);
        iv.clipsToBounds = YES;
        iv.layer.cornerRadius = 4.0f;
        iv.tag   = 100;
        [iv addTarget:self action:@selector(keyChars:) forControlEvents:UIControlEventTouchUpInside];
        [iv setImage:[UIImage imageNamed:@"shift.png"] forState:UIControlStateNormal];
        [iv setImage:[UIImage imageNamed:@"oneShift.png"] forState:UIControlStateSelected];
        [self addSubview:iv];
        iv;
    });
    
    _deleteButton = ({ //删除
        UIButton *iv = [UIButton buttonWithType:UIButtonTypeCustom];
        iv.frame = CGRectMake(self.frame.size.width-letterW-rowSpace, spaceThreeY, letterW, charHeight);
        iv.tag = 101;
        iv.clipsToBounds = YES;
        iv.layer.cornerRadius = 4.0f;
        [iv addTarget:self action:@selector(keyChars:) forControlEvents:UIControlEventTouchUpInside];
        [iv setImage:[UIImage imageNamed:@"deleteL.png"] forState:UIControlStateNormal];
        [self addSubview:iv];
        iv;
    });
    
    _numberButton = ({ //字符转换
        UIButton  *iv = [UIButton buttonWithType:UIButtonTypeCustom];
        iv.frame  = CGRectMake(rowSpace, spaceThreeY + columnSpace +charHeight, letterW*2, charHeight);
        iv.tag  =   102;
        iv.clipsToBounds = YES;
        iv.layer.cornerRadius = 4.0f;
        iv.backgroundColor = [UIColor lightGrayColor];
        [iv addTarget:self action:@selector(keyChars:) forControlEvents:UIControlEventTouchUpInside];
        [iv setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [iv setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        iv.titleLabel.font = [UIFont systemFontOfSize:20];
        [iv setTitle:@"123" forState:UIControlStateNormal];
        [iv setTitle:@"ABC" forState:UIControlStateSelected];
        [self addSubview:iv];
        iv;
    });
    
    _confirmButton = ({
        UIButton  *iv = [UIButton buttonWithType:UIButtonTypeCustom];
        iv.frame    = CGRectMake(self.frame.size.width - rowSpace - 2*letterW, columnSpace + spaceThreeY+charHeight, letterW*2, charHeight);
        [iv setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [iv setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        iv.backgroundColor = [UIColor purpleColor];
        iv.clipsToBounds = YES;
        iv.layer.cornerRadius = 4.0f;
        iv.titleLabel.font = [UIFont systemFontOfSize:20];
        [iv setTitle:@"确定" forState:UIControlStateNormal];
        [iv setTitle:@"确定" forState:UIControlStateHighlighted];
        [iv addTarget:self action:@selector(keyChars:) forControlEvents:UIControlEventTouchUpInside];
        iv.tag        =   103;
        [self addSubview:iv];
        iv;
    });
    
    _spaceButton = ({
        UIButton *iv            = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat  spaceWidth     = self.frame.size.width - 4*letterW - 4*rowSpace;
        iv.frame      = CGRectMake(rowSpace*2 + letterW*2, columnSpace+spaceThreeY +charHeight, spaceWidth, charHeight);
        [iv setImage:[UIImage imageNamed:@"logoBank.png"] forState:UIControlStateNormal];
        [iv setImage:[UIImage imageNamed:@"logoBank.png"] forState:UIControlStateSelected];
        [iv addTarget:self action:@selector(keyChars:) forControlEvents:UIControlEventTouchUpInside];
        iv.tag        =   104;
        iv.clipsToBounds = YES;
        iv.layer.cornerRadius = 4.0f;
        [self addSubview:iv];
        iv;
    });
}



-(void)clickChars:(CYRKeyboardButton *)sender{
    AudioServicesPlaySystemSound(1104);
    [self onCharsAllClick:sender clickKeyboardTag:105];
}

-(void)keyChars:(UIButton *)sender{
    AudioServicesPlaySystemSound(1105);
    sender.selected = !sender.selected;
    [self onCharsAllClick:sender clickKeyboardTag:sender.tag];
}

- (void)onCharsAllClick:(id)sender clickKeyboardTag:(NSInteger)clickKeyboardTag{
    UIButton *button = (UIButton *)sender;
    NSString *titleStr = button.currentTitle;
    if (self.clickCharsKeyBoardBlock) {
        self.clickCharsKeyBoardBlock(clickKeyboardTag,titleStr);
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
