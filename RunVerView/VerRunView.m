//
//  VerRunView.m
//  VerticalRunView
//
//  Created by admin on 17/6/29.
//  Copyright © 2017年 光大银行. All rights reserved.
//

#import "VerRunView.h"

@interface VerRunView ()

@property(nonatomic, strong)               UILabel          *label1;
@property(nonatomic, strong)               UILabel          *label2;

@property(nonatomic, assign)               CGFloat          h;
@property(nonatomic, assign)               CGFloat          w;
@property(nonatomic, assign)               NSInteger        messageIndex;

@property(nonatomic, strong)               UIButton         *bgBtn1;
@property(nonatomic, strong)               UIButton         *bgBtn2;

@property(nonatomic, strong)               NSTimer          *timer;
@end
@implementation VerRunView

- (instancetype)initWithFrame:(CGRect)frame setBgColor:(UIColor *)bgColor textColor:(UIColor *)textColor textFont:(UIFont *)Font
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _h = frame.size.height;
        _w = frame.size.width;
        
        self.layer.cornerRadius = self.cornerRadius;
        self.layer.masksToBounds = YES;
        
        _scrollDuration = 1.0f;
        _stayDuration   = 2.0f;
        _cornerRadius   = 2;
        
        _label1         = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, frame.size.width, _h)];
        _label2         = [[UILabel alloc]initWithFrame:CGRectMake(10, _h, frame.size.width, _h)];
        [self initWithLabel:_label1 bgColor:bgColor textColor:textColor font:Font];
        [self initWithLabel:_label2 bgColor:bgColor textColor:textColor font:Font];
        
        [self addSubview:self.label1];
        [self addSubview:self.label2];
        
        _bgBtn1         = [[UIButton alloc]initWithFrame:self.label1.frame];
        _bgBtn1.tag     = 0;
        [_bgBtn1 addTarget:self action:@selector(bgButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _bgBtn2         = [[UIButton alloc]initWithFrame:self.label2.frame];
        _bgBtn2.tag     =1;
        [_bgBtn2 addTarget:self action:@selector(bgButtonClick:)
          forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.bgBtn1];
        [self addSubview:self.bgBtn2];

    }
    return self;
}

-(void)strat{
    if (self.messageArray.count < 2) {
        return;
    }
    self.timer = [NSTimer timerWithTimeInterval:_stayDuration target:self selector:@selector(scrollAnimate) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)stop{
    [self.timer invalidate];
}

-(void)scrollAnimate{
    CGRect rect1 = self.label1.frame;
    CGRect rect2 = self.label2.frame;
    rect1.origin.y -= _h;
    rect2.origin.y -= _h;
    [UIView animateWithDuration:_scrollDuration animations:^{
        self.label1.frame = rect1;
        self.label2.frame = rect2;
        self.bgBtn1.frame = rect1;
        self.bgBtn2.frame = rect2;
    } completion:^(BOOL finished) {
        [self checkButtonFrameChange:self.bgBtn1];
        [self checkButtonFrameChange:self.bgBtn2];
        [self checkLabelFrameChange:self.label1];
        [self checkLabelFrameChange:self.label2];
    }];
}

- (void)checkLabelFrameChange:(UILabel *)label{
    if (label.frame.origin.y < -10) {
        CGRect rect = label.frame;
        rect.origin.y = _h;
        label.frame = rect;
        label.text = self.messageArray[self.messageIndex];
        if (self.messageIndex == self.messageArray.count - 1) {
            self.messageIndex = 0;
        }else{
            self.messageIndex += 1;
        }
    }
}

- (void)checkButtonFrameChange:(UIButton *)button{
    if (button.frame.origin.y < -10) {
        CGRect rect = button.frame;
        rect.origin.y = _h;
        button.frame = rect;
        button.tag = self.messageIndex;
    }
}

-(void)setMessageArray:(NSArray *)messageArray{
    _messageArray = messageArray;
    if (self.messageArray.count > 2) {
        self.label1.text = self.messageArray[0];
        self.label2.text = self.messageArray[1];
        self.messageIndex = 2;
    }else if (self.messageArray.count == 1){
        self.label1.text = self.messageArray[0];
    }else if (self.messageArray.count == 2){
        self.label1.text = self.messageArray[0];
        self.label2.text = self.messageArray[1];
        self.messageIndex = 0;
    }
}

-(void)bgButtonClick:(UIButton *)sender{
    if (self.clickBtnBlock) {
        self.clickBtnBlock(sender.tag);
    }
}

-(void)initWithLabel:(UILabel *)label bgColor:(UIColor *)bgcolor textColor:(UIColor *)textColor font:(UIFont *)font{
    
    label.numberOfLines = 0 ;
    label.backgroundColor = bgcolor;
    label.textColor = textColor;
    label.font = font;
}
@end
