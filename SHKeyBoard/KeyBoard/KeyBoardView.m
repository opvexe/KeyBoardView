//
//  KeyBoardView.m
//  SHKeyBoard
//
//  Created by FaceBook on 2019/5/24.
//  Copyright © 2019年 FaceBook. All rights reserved.
//

#import "KeyBoardView.h"
#import "KeyBoardCharView.h"
#import "KeyBoardNumberView.h"
#import "KeyBoardBarView.h"

#define plusInch ([UIScreen mainScreen].bounds.size.height > 700)
#define kKeyboardPadding 51                     //自定义键盘上43的视图 + 8
#define kKeyboardHeight 253
#define kKeyboardHeightOfKeys kKeyboardHeight - kKeyboardPadding  //按钮布局高度
#define kKeyboardHeightPlus 270 //设置plus尺寸的高度
#define kKeyboardHeightOfKeyPlus kKeyboardHeightPlus - kKeyboardPadding

@interface KeyBoardView (){
    CGFloat  keyboardHeight;                 //键盘的高度
    CGFloat  keyboardHeightOfKeys;           //宫格对应的高度
}
@property(nonatomic,strong)NSArray *lettersDataSource;  //小写
@property(nonatomic,strong)NSArray *symbolsDataSource;  //符号
@property(nonatomic,strong)NSArray *numbersDataSource;  //数字
@property(nonatomic,strong)UIView      *keyBoardInputView;
@property(nonatomic,strong)KeyBoardBarView  *keyToolBarView;
@property(nonatomic,strong)UITextField *inputTextField;  //关联输入框
@property(nonatomic,strong)KeyBoardCharView *charsView;  //字符视图
@property(nonatomic,strong)KeyBoardNumberView *numbersView; //数字视图
@end

@implementation KeyBoardView

-(instancetype)initWithKeyBoardStyle:(KeyBoardLayoutStyle)KeyBoardLayoutStyle{
    [self setKeyBoardHeight];       //设置键盘高度
    self = [super initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, keyboardHeight)];
    if (self){
        [self setKeyBoardBarLayoutView];
        [self setKeyBoardLayoutView];
        [self initWithKeyBoardType:KeyBoardLayoutStyle];
    }
    return self;
}

-(void)setKeyBoardHeight{       //设置两种键盘高度
    if (plusInch){
        keyboardHeight = kKeyboardHeightPlus;
        keyboardHeightOfKeys = kKeyboardHeightOfKeyPlus;
    }else{
        keyboardHeight = kKeyboardHeight;
        keyboardHeightOfKeys = kKeyboardHeightOfKeys;
    }
}

-(void)setKeyBoardBarLayoutView{
    //    _keyToolBarView = [[KeyBoardBarView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, kKeyboardPadding) toolBars:self.numbersDataSource];
    //    _keyToolBarView.backgroundColor = [UIColor clearColor];
    //    [self addSubview:self.keyToolBarView];
}

-(void)setKeyBoardLayoutView{
    _keyBoardInputView = [[UIView alloc]initWithFrame:CGRectMake(0, kKeyboardPadding, self.frame.size.width, keyboardHeightOfKeys)];
    _keyBoardInputView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.keyBoardInputView];
}

-(void)initWithKeyBoardType:(KeyBoardLayoutStyle)type{
    
    [self initWithKeyBoradCharsView];
    [self initWithKeyBoardNumbersView];
    
    CGRect rectFrame                = CGRectMake(0, 0, self.frame.size.width, CGRectGetHeight(self.keyBoardInputView.frame));
    self.charsView.frame            = rectFrame;
    self.numbersView.frame          = rectFrame;
    
    [self.keyBoardInputView addSubview:self.charsView];
    [self.keyBoardInputView addSubview:self.numbersView];
    
    switch (type) {
        case KeyBoardLayoutStyleDefault:{  //默认键盘
            [self switchKeyBoardCharsView];
            break;
        }
        case KeyBoardLayoutStyleNumbers:{  //数字键盘
            [self switchKeyBoardNumbersView];
            break;
        }
        case KeyBoardLayoutStyleSymbol:{  //符号键盘
//            [self switchKeyBoardSymbolsView];
            
            break;
        }
            
        default:
            break;
    }
}

-(void)initWithKeyBoradCharsView{
    
    self.charsView = [[KeyBoardCharView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, keyboardHeightOfKeys)  charDateSource:self.lettersDataSource];
    self.charsView.backgroundColor = [UIColor clearColor];
    __weak __typeof(self)wself = self;
    self.charsView.clickCharsKeyBoardBlock = ^(NSInteger key, NSString * _Nonnull title) {
        __strong __typeof (wself) sself = wself;
        switch (key -100) {
            case 0:{
                [sself.charsView switchKeyBoardUperLetters];
                break;
            }
            case 1:{
                [sself keyBoardDeleteFun];
                break;
            }
            case 2:{
                NSLog(@"切换符号");
                break;
            }
            case 3:{
                [sself keyBoardConfirmFun];
                break;
            }
            case 4:{
                [sself keyBoardInputFun:@" "];
                break;
            }
            case 5:{
                  [sself keyBoardInputFun:title];
                break;
            }
            default:
                break;
        }
    };
}

-(void)initWithKeyBoardNumbersView{
    NSMutableArray *arrM = [self randomNumbers];
    self.numbersView = [[KeyBoardNumberView alloc]initWithFrame:CGRectMake(0, kKeyboardPadding, self.frame.size.width, keyboardHeightOfKeys) randomNumbers:arrM];
    self.numbersView.backgroundColor        = [UIColor clearColor];
    __weak __typeof(self)wself = self;
    self.numbersView.keyBoardNumbersBlock = ^(NSInteger key, NSString * _Nonnull title) {
        __strong __typeof (wself) sself = wself;
        switch (key-100) {
            case 0:{
                [sself keyBoardInputFun:title];
                break;
            }
            case 1:{
                [sself keyBoardDeleteFun];
                break;
            }
            case 2:{
                [sself keyBoardConfirmFun];
                break;
            }
            case 3:{
                [sself keyBoardConfirmFun];
                break;
            }
            case 4:{
                [sself keyBoardInputFun:title];
                break;
            }
            default:
                break;
        }
    };
}


-(void)keyBoardConfirmFun{
    [self.inputTextField resignFirstResponder];
}

-(void)keyBoardInputFun:(NSString *)input{
    self.inputTextField.text = [self.inputTextField.text stringByAppendingString:input];
}

-(void)keyBoardDeleteFun{
    if (self.inputTextField.text.length > 0) {
        self.inputTextField.text = [self.inputTextField.text substringToIndex:self.inputTextField.text.length - 1];
    }
}

#pragma mark 切换视图
-(void)switchKeyBoardCharsView{
    [self.numbersView setHidden:YES];
    [self.charsView setHidden:NO];
}

-(void)switchKeyBoardNumbersView{
    [self.charsView setHidden:YES];
    [self.numbersView setHidden:NO];
}


#pragma mark 懒加载
- (void)setInputTextField:(UITextField *)inputTextField{
    if (_inputTextField != inputTextField){
        _inputTextField = inputTextField;
        _inputTextField.inputView = self;
    }
}

-(NSArray *)lettersDataSource{
    if (!_lettersDataSource) {
        _lettersDataSource = @[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m"];
    }
    return _lettersDataSource;
}

-(NSArray *)symbolsDataSource{
    if (!_symbolsDataSource) {
        _symbolsDataSource = @[@"[",@"]",@"{",@"}",@"#",@"%",@"^",@"*",@"+",@"=",@"-",@"/",@":",@";",@"(",@")",@"$",@"&",@"@",@"|",@".",@",",@"?",@"!",@"_",@"\"",@"<",@">"];
    }
    return _symbolsDataSource;
}

-(NSArray *)numbersDataSource{
    if (!_numbersDataSource) {
        _numbersDataSource = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    }
    return _numbersDataSource;
}

-(NSMutableArray *)randomNumbers{
    NSMutableArray *arrM = [NSMutableArray array];
    [arrM removeAllObjects];
    if (_isOpen) {              //打开数字键盘产生随机数字
        for (int i = 0 ; i < 10; i++) {
            int j = arc4random_uniform(10);
            NSNumber *number = [[NSNumber alloc] initWithInt:j];
            if ([arrM containsObject:number]) {
                i--;
                continue;
            }
            [arrM addObject:number];
        }
    }else{                  //不打开随机数字
        [arrM addObjectsFromArray:self.numbersDataSource];
    }
    return arrM;
}


@end
