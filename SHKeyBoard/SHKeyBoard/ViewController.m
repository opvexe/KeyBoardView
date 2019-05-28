//
//  ViewController.m
//  SHKeyBoard
//
//  Created by FaceBook on 2019/5/24.
//  Copyright © 2019年 FaceBook. All rights reserved.
//

#import "ViewController.h"
#import "KeyBoardView.h"

@interface ViewController ()
@property (nonatomic, strong)  UITextField *inputField;
@property (nonatomic, strong)  UITextField *otputField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.inputField];
    KeyBoardView *keyBoardView = [[KeyBoardView  alloc]initWithKeyBoardStyle:KeyBoardLayoutStyleDefault];
    [keyBoardView setInputTextField:self.inputField];
    
    
    [self.view addSubview:self.otputField];
    KeyBoardView *keyBoardViews = [[KeyBoardView  alloc]initWithKeyBoardStyle:KeyBoardLayoutStyleNumbers];
    [keyBoardViews setInputTextField:self.otputField];
}

-(UITextField *)inputField{
    if (!_inputField) {
        _inputField = [[UITextField alloc]initWithFrame:CGRectMake(50, 500, 200, 80)];
        _inputField.backgroundColor = [UIColor redColor];
    }
    return _inputField;
}

-(UITextField *)otputField{
    if (!_otputField) {
        _otputField = [[UITextField alloc]initWithFrame:CGRectMake(50, 100, 200, 80)];
        _otputField.backgroundColor = [UIColor redColor];
    }
    return _otputField;
}
@end
