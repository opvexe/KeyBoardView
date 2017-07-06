//
//  SignView.m
//  RunView
//
//  Created by admin on 17/6/29.
//  Copyright © 2017年 光大银行. All rights reserved.
//

#import "SignView.h"
#import <CoreGraphics/CoreGraphics.h>

@interface SignView ()

@property(nonatomic, assign)                CGFloat lineWidth;
@property(nonatomic, strong)                UIColor *lineColor;
@property(nonatomic, strong)                NSMutableArray *pathArray;

@property(nonatomic, assign)                CGPoint startPoint;
@property(nonatomic, assign)                CGPoint movePoint;

@end
@implementation SignView
{
    CGMutablePathRef _path;
}

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _lineWidth = lineWidth;
        _lineColor = lineColor;
        
        _pathArray = [NSMutableArray array];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (NSArray * attribute in _pathArray) {
        CGPathRef pathRef = (__bridge CGPathRef)(attribute[0]);
        CGContextAddPath(context, pathRef);
        [attribute[1] setStroke];
        CGContextSetLineWidth(context, [attribute[2] floatValue]);
        CGContextDrawPath(context, kCGPathStroke);
    }
    NSLog(@"%ld---%@",_pathArray.count,_pathArray);     //数组里包含了_path ,颜色，宽度
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    _path = CGPathCreateMutable(); //创建路径
    NSArray *attributeArry = @[(__bridge id)(_path),_lineColor,[NSNumber numberWithFloat:_lineWidth]];
    [self.pathArray addObject:attributeArry]; //路径及属性数组数组
    _startPoint = [touch locationInView:self]; //起始点
    CGPathMoveToPoint(_path, NULL,_startPoint.x, _startPoint.y);
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    _movePoint = [touch locationInView:self];
    CGPathAddLineToPoint(_path, NULL, _movePoint.x, _movePoint.y);
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPathRelease(_path);       //释放对象
}

-(void)cleanContext{
    [_pathArray removeAllObjects];
    [self setNeedsDisplay];
}

@end
