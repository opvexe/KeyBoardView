//
//  GDBankKeyboardView.m
//  RunView
//
//  Created by admin on 17/6/30.
//  Copyright © 2017年 光大银行. All rights reserved.
//

#import "GDBankKeyboardView.h"

#import "KeyBoardCharView.h"
#import "KeyBoardNumberView.h"
#import "KeyBoardSymbolView.h"

#define plusInch ([UIScreen mainScreen].bounds.size.height > 700)
#define kKeyboardPadding 43                     //自定义键盘上43的视图
#define kKeyboardHeight 253
#define kKeyboardHeightOfKeys kKeyboardHeight - kKeyboardPadding  //按钮布局高度
#define kKeyboardHeightPlus 270 //设置plus尺寸的高度
#define kKeyboardHeightOfKeyPlus kKeyboardHeightPlus - kKeyboardPadding

@interface GDBankKeyboardView ()

@property (nonatomic, strong)                       NSArray   *lettersDataSource;           //小写
@property (nonatomic, strong)                       NSArray   *symbolsDataSource;           //符号

@property (nonatomic, strong)                       UIView    *keyBoardInputView;

@property (nonatomic, strong)                       KeyBoardSymbolView          *symbolsView;       //符号视图
@property (nonatomic, strong)                       KeyBoardNumberView          *numbersView;       //数字视图
@property (nonatomic, strong)                       KeyBoardCharView            *charsView;         //字符视图

@property (nonatomic, strong)                       UITextField                 *inputTextField;    //关联输入框

@end
@implementation GDBankKeyboardView
{
    CGFloat             keyboardHeight;                 //键盘的高度
    CGFloat             keyboardHeightOfKeys;           //宫格对应的高度
}

#pragma mark - 懒加载对应的键盘数组格式

- (NSArray *)lettersDataSource
{
    if (!_lettersDataSource) {
        _lettersDataSource = @[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m"];
    }
    return _lettersDataSource;
}

- (NSArray *)symbolsDataSource
{
    if (!_symbolsDataSource) {
        _symbolsDataSource = @[@"[",@"]",@"{",@"}",@"#",@"%",@"^",@"*",@"+",@"=",@"_",@"$",@"(",@")",@"-",@"\\",@"|",@"~",@"<",@">",@"/",@".",@"?",@",",@"!",@"\"",@";",@"@"];
        
    }
    return _symbolsDataSource;
}

#pragma mark  工厂模式加载控件
-(instancetype)initWithKeyBoard{
    
    [self setKeyBoardHeight];       //设置键盘高度
    self = [super initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, keyboardHeight)];
    if (self){
        [self setKeyBoardLayoutView];
        
    }
    return self;
}

#pragma mark  设置键盘的高度
-(void)setKeyBoardHeight{       //设置两种键盘高度
    if (plusInch){
        keyboardHeight = kKeyboardHeightPlus;
        keyboardHeightOfKeys = kKeyboardHeightOfKeyPlus;
    }else{
        keyboardHeight = kKeyboardHeight;
        keyboardHeightOfKeys = kKeyboardHeightOfKeys;
    }
}

#pragma mark 设置区域
-(void)setKeyBoardLayoutView{
    _keyBoardInputView = [[UIView alloc]initWithFrame:CGRectMake(0, kKeyboardPadding, self.frame.size.width, keyboardHeightOfKeys)];
    _keyBoardInputView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.keyBoardInputView];
}

#pragma mark 重写Set方法
-(void)setKeyBoardLayoutStyle:(KeyBoardLayoutStyle)KeyBoardLayoutStyle{
    
    _KeyBoardLayoutStyle            = KeyBoardLayoutStyle;
    
    [self initWithKeyBoradCharsView];
    [self initWithKeyBoardNumbersView];
    [self initWithKeyBoardSymbolsView];
    
    CGRect rectFrame                = CGRectMake(0, 0, self.frame.size.width, CGRectGetHeight(self.keyBoardInputView.frame));
    self.charsView.frame            = rectFrame;
    self.numbersView.frame          = rectFrame;
    self.symbolsView.frame          = rectFrame;
    
    [self.keyBoardInputView addSubview:self.charsView];
    [self.keyBoardInputView addSubview:self.numbersView];
    [self.keyBoardInputView addSubview:self.symbolsView];
    
    switch (KeyBoardLayoutStyle) {
        case KeyBoardLayoutStyleNumbers:               //数字键盘
        {
            [self switchKeyBoardNumbersView];
        }
            break;
        case KeyBoardLayoutStyleLetters:               //大写键盘
        {
            [self switchKeyBoardCharsView];
        }
            break;
        case KeyBoardLayoutStyleUperLetters:          //小写键盘
        {
            [self switchKeyBoardCharsView];
        }
            break;
        case KeyBoardLayoutStyleSymbol:            //符号键盘
        {
            [self switchKeyBoardCharsView];
        }
            break;
        default:{                       //默认键盘
            KeyBoardLayoutStyle = KeyBoardLayoutStyleDefault;
            [self switchKeyBoardCharsView];
        }
            
            break;
    }
}

#pragma mark  初始化默认键盘
-(void)initWithKeyBoradCharsView{
    
    self.charsView = [[KeyBoardCharView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, keyboardHeightOfKeys)  charDateSource:self.lettersDataSource];
    self.charsView.backgroundColor = [UIColor blackColor];
    __weak typeof(self) weakSelf   = self ;
    
    self.charsView.clickCharsKeyBoardBlock = ^(NSInteger key,NSString *title){
        switch (key-2000) {
            case 0:
            {
                [weakSelf.charsView switchKeyBoardChars];           //转换大小写
            }
                break;
            case 1:
            {
                [weakSelf keyBoardDeleteFun];                      //点击删除
            }
                break;
            case 2:
            {
                [weakSelf switchKeyBoardNumbersView];                           //数字转换
            }
                break;
            case 3:
            {
                [weakSelf switchKeyBoardSymbolsView];                         //符号转换
            }
                break;
            case 4:
            {
                [weakSelf keyBoardConfirmFun];
            }
                break;
            case 5:
            {
                NSLog(@"%@==",title);              //空格
            }
                break;
            case 6:
            {
                [weakSelf keyBoardInputFun:title];
            }
                break;
                
            default:
                break;
        }
        
    };
    
}

#pragma mark  初始化数字键盘
-(void)initWithKeyBoardNumbersView{
    
    NSMutableArray *arrM = [self randomNumbers];
    
    self.numbersView = [[KeyBoardNumberView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, keyboardHeightOfKeys) randomNumbers:arrM KeyBoardStyles:KeyBoardNumbersStyleDefault];
    self.numbersView.backgroundColor        = [UIColor blackColor];
    __weak typeof(self) weakSelf            = self;
    self.numbersView.keyBoardNumbersBlock   = ^(NSInteger key,NSString *title){
        switch (key-1000) {
            case 0:
            {
#warning 设置不同类型数字键盘的操作 ---- dot 类型 输入 小数.   默认类型   ---切换 字符
//                    [weakSelf keyBoardInputFun:title];
                [weakSelf switchKeyBoardCharsView];
            }
                break;
            case 1:
            {
                [weakSelf keyBoardDeleteFun];                                   //删除
            }
                break;
            case 2:
            {
                [weakSelf keyBoardConfirmFun];                                  //确定
            }
                break;
            case 3:
            {
                [weakSelf keyBoardConfirmFun];                               //关闭键盘
            }
                break;
            case 4:
            {
                [weakSelf keyBoardInputFun:title];                          //输入
            }
                break;
                
            default:
                break;
        }
    };
}

#pragma mark 初始化符号键盘
-(void)initWithKeyBoardSymbolsView{
    
#warning 符号键盘  ------------ 1，点击大写切换大写  2，点击数字切换数字   3，点击符号切换符号 4，点击空格  5，点击删除  ，6 ，点击确定
    self.symbolsView = [[KeyBoardSymbolView alloc]init];
    
}

#pragma mark 切换 默认键盘
-(void)switchKeyBoardCharsView{
    [self.numbersView setHidden:YES];
    [self.symbolsView setHidden:YES];
    [self.charsView setHidden:NO];
}

#pragma mark 切换数字键盘
-(void)switchKeyBoardNumbersView{
    [self.charsView setHidden:YES];
    [self.symbolsView setHidden:YES];
    [self.numbersView setHidden:NO];
}

#pragma mark  切换符号
-(void)switchKeyBoardSymbolsView{
    [self.charsView setHidden:YES];
    [self.numbersView setHidden:YES];
    [self.symbolsView setHidden:NO];
}


#pragma mark  关联inputTextField
- (void)setInputTextField:(UITextField *)inputTextField{
    if (_inputTextField != inputTextField)
    {
        _inputTextField = inputTextField;
        _inputTextField.inputView = self;
    }
}

#pragma mark 数字键盘产生随机数
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
        for (int i = 0; i< 10; i++) {
            NSNumber *number = [[NSNumber alloc]initWithInt:i];
            [arrM addObject:number];
        }
    }
    return arrM;
}

#pragma mark 点击了删除
-(void)keyBoardDeleteFun{
    
    if (self.inputTextField.text.length > 0) {
        self.inputTextField.text = [self.inputTextField.text substringToIndex:self.inputTextField.text.length - 1];
    }
}

#pragma mark 点击确定
-(void)keyBoardConfirmFun{
    
    [self.inputTextField resignFirstResponder];
}

#pragma mark  点击了输入
-(void)keyBoardInputFun:(NSString *)input{
    
    self.inputTextField.text = [self.inputTextField.text stringByAppendingString:input];
    NSLog(@"内容==%@",self.inputTextField.text);
}


@end
