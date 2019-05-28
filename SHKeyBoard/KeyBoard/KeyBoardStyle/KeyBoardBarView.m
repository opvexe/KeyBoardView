//
//  KeyBoardBarView.m
//  SHKeyBoard
//
//  Created by FaceBook on 2019/5/24.
//  Copyright © 2019年 FaceBook. All rights reserved.
//

#import "KeyBoardBarView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "CYRKeyboardButton.h"
static const int rowFirstCount    =  10;        //第一列10
static const int column           =   1;        //4行

@interface KeyBoardBarView ()
@property(nonatomic,strong)NSArray *barsSouce; //小写
@end
@implementation KeyBoardBarView
{
    CGFloat     rowSpace;                           //行间隙
    CGFloat     columnSpace;                        //列间隙
    CGFloat     charWidth;                          //key 宽度
    CGFloat     charHeight;                         //key 高度
}

- (instancetype)initWithFrame:(CGRect)frame toolBars:(NSArray *)barDateSouce{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _barsSouce = barDateSouce;
        [self setLayoutBarCollectionButton];
    }
    return self;
}

-(void)setLayoutBarCollectionButton{
    
    //MARK: 布局第1列 10
    rowSpace            = 8;
    columnSpace         = 8;
    
    charWidth  = (self.frame.size.width - rowSpace*(rowFirstCount + 1))/rowFirstCount;
//    charHeight = (self.frame.size.height - columnSpace*(column + 1))/column;
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i <rowFirstCount; i++) {
        CYRKeyboardButton *btn   = [CYRKeyboardButton new];
        btn.frame       = CGRectMake(rowSpace+(rowSpace+charWidth)*i, columnSpace, charWidth, self.frame.size.height - columnSpace);
        [self addSubview:btn];
        [arrM addObject:btn];
    }
    
    for (int i = 0 ; i<self.barsSouce.count; i++) {
        CYRKeyboardButton *button = [arrM objectAtIndex:i];
        button.font = [UIFont systemFontOfSize:22];
        button.keyTextColor = [UIColor blackColor];
        button.keyHighlightedColor = [UIColor blackColor];
        button.keyShadowColor = [UIColor lightGrayColor];
        button.input = self.barsSouce[i];
        [button addTarget:self action:@selector(clickChars:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)clickChars:(UIButton *)sender{
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
