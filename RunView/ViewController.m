//
//  ViewController.m
//  RunView
//
//  Created by admin on 17/6/29.
//  Copyright © 2017年 光大银行. All rights reserved.
//

#import "ViewController.h"
#import "VerRunView.h"
#import "SignView.h"

#import "GDBankKeyboardView.h"
@interface ViewController ()

@property (nonatomic, strong) VerRunView *runView;

@property (nonatomic, strong)  UITextField *inputField;
@end

@implementation ViewController

-(void)viewWillDisappear:(BOOL)animated{
    [self.runView stop];        //关闭定时器
}

-(UITextField *)inputField{
    if (!_inputField) {
        _inputField = [[UITextField alloc]initWithFrame:CGRectMake(50, 500, 200, 80)];
        _inputField.backgroundColor = [UIColor redColor];
    }
    return _inputField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    VerRunView *runView = [[VerRunView alloc]initWithFrame:CGRectMake(50, 64, [UIScreen mainScreen].bounds.size.width-100, 40) setBgColor:[UIColor whiteColor] textColor:[UIColor purpleColor] textFont:[UIFont systemFontOfSize:15.0]];
    runView.messageArray = @[@"i just like  do it!",@"you can do it ",@"no things  to do "];
    runView.clickBtnBlock = ^(NSInteger sender){
        NSLog(@"%ld",sender);
    };
    [runView strat];
    [self.view addSubview:runView];
    self.runView = runView;
    
    
    /*手写签名 */
    SignView *signView  = [[SignView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 400) lineWidth:5.0f lineColor:[UIColor blackColor]];
    signView.backgroundColor  = [UIColor whiteColor];
    [self.view addSubview:signView];
    
    /*自定义键盘 */
    
    [self.view addSubview:self.inputField];
    GDBankKeyboardView *keyBoardView = [[GDBankKeyboardView  alloc]initWithKeyBoard];
    keyBoardView.KeyBoardLayoutStyle = KeyBoardLayoutStyleDefault;
    [keyBoardView setInputTextField:self.inputField];
}

//关闭键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
