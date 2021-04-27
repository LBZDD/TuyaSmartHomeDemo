//
//  TYRegisterViewController.m
//  TuyaSmartHomeDemo
//
//  Created by 林波 on 2021/4/24.
//

#import "TYRegisterViewController.h"

@interface TYRegisterViewController ()
// 区号
@property (nonatomic, strong) UITextField *countryTextField;
// 账号
@property (nonatomic, strong) UITextField *accountTextField;
// 密码
@property (nonatomic, strong) UITextField *passwordTextField;
// 验证码
@property (nonatomic, strong) UITextField *verifyCodeTextField;
// 获取验证码按钮
@property (nonatomic, strong) UIButton *sendVerifyCodeButton;
// 注册按钮
@property (nonatomic, strong) UIButton *registerButton;
@end

@implementation TYRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    self.title = @"注册";
    [self configureView];
}

#pragma mark - action
-(void)actionSendVerifyCode:(id)sender{
    NSString *userName      = self.accountTextField.text;
    NSString *countryCode   = self.countryTextField.text;
    NSString *region = [[TuyaSmartUser sharedInstance] getDefaultRegionWithCountryCode:countryCode];
    [SVProgressHUD showWithStatus:@"已发送"];
    [[TuyaSmartUser sharedInstance] sendVerifyCodeWithUserName:userName region:region countryCode:countryCode type:1 success:^{
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
    } failure:^(NSError *error) {
        NSString *errorStr = [NSString stringWithFormat:@"获取验证码失败:%@",error.localizedDescription];
        [SVProgressHUD showErrorWithStatus:errorStr];
    }];
}

-(void)actionRegister:(id)sender{
    NSString *userName      = self.accountTextField.text;
    NSString *countryCode   = self.countryTextField.text;
    NSString *verifyCode    = self.verifyCodeTextField.text;
    NSString *password      = self.passwordTextField.text;
    NSString *region = [[TuyaSmartUser sharedInstance] getDefaultRegionWithCountryCode:countryCode];
    [SVProgressHUD showWithStatus:@"注册中"];    
    [[TuyaSmartUser sharedInstance] registerWithUserName:userName region:region countryCode:countryCode code:verifyCode password:password success:^{
        [self dismissViewControllerAnimated:YES completion:^{
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
        }];
    } failure:^(NSError *error) {
        NSString *errorStr = [NSString stringWithFormat:@"注册失败:%@",error.localizedDescription];
        [SVProgressHUD showErrorWithStatus:errorStr];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self.view resignFirstResponder];
}

#pragma mark - private method
- (void)configureView{
    [self.view addSubview:self.countryTextField];
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.verifyCodeTextField];
    [self.view addSubview:self.sendVerifyCodeButton];
    [self.view addSubview:self.registerButton];
    
    [self.countryTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(200.0f);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(30.0f);
        make.height.mas_equalTo(30.0f);
    }];
    
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.countryTextField.mas_bottom).offset(20.0f);
        make.width.equalTo(self.countryTextField);
        make.centerX.equalTo(self.countryTextField);
        make.height.equalTo(self.countryTextField);
    }];
    
    [self.verifyCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTextField.mas_bottom).offset(20.0f);
        make.width.equalTo(self.accountTextField);
        make.centerX.equalTo(self.accountTextField);
        make.height.equalTo(self.accountTextField);
    }];
    
    [self.sendVerifyCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verifyCodeTextField.mas_bottom).offset(30.0f);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.verifyCodeTextField);
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendVerifyCodeButton.mas_bottom).offset(20.0f);
        make.width.equalTo(self.sendVerifyCodeButton);
        make.centerX.equalTo(self.sendVerifyCodeButton);
        make.height.equalTo(self.sendVerifyCodeButton);
    }];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(30.0f);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.passwordTextField);
    }];
}

#pragma mark - setter && getter
-(UITextField *)countryTextField{
    if (!_countryTextField) {
        _countryTextField = [[UITextField alloc]initWithFrame:CGRectZero];
        _countryTextField.placeholder = @"输入区号";
        _countryTextField.keyboardType = UIKeyboardTypeNumberPad;
        _countryTextField.font = [UIFont systemFontOfSize:16.0f];
        _countryTextField.layer.borderColor = UIColor.blackColor.CGColor;
        _countryTextField.layer.borderWidth = 1.0f;
        _countryTextField.layer.cornerRadius = 6.0f;
        _countryTextField.layer.masksToBounds = YES;
    }
    return _countryTextField;
}

-(UITextField *)accountTextField{
    if (!_accountTextField) {
        _accountTextField = [[UITextField alloc]initWithFrame:CGRectZero];
        _accountTextField.placeholder = @"输入手机号或邮箱";
        _accountTextField.font = [UIFont systemFontOfSize:16.0f];
        _accountTextField.layer.borderColor = UIColor.blackColor.CGColor;
        _accountTextField.layer.borderWidth = 1.0f;
        _accountTextField.layer.cornerRadius = 6.0f;
        _accountTextField.layer.masksToBounds = YES;
    }
    return _accountTextField;
}

-(UITextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField= [[UITextField alloc]initWithFrame:CGRectZero];
        _passwordTextField.placeholder = @"输入密码";
        _passwordTextField.font = [UIFont systemFontOfSize:16.0f];
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.layer.borderColor = UIColor.blackColor.CGColor;
        _passwordTextField.layer.borderWidth = 1.0f;
        _passwordTextField.layer.cornerRadius = 6.0f;
        _passwordTextField.layer.masksToBounds = YES;
    }
    return _passwordTextField;
}

-(UITextField *)verifyCodeTextField{
    if (!_verifyCodeTextField) {
        _verifyCodeTextField= [[UITextField alloc]initWithFrame:CGRectZero];
        _verifyCodeTextField.placeholder = @"输入验证码";
        _verifyCodeTextField.font = [UIFont systemFontOfSize:16.0f];
        _verifyCodeTextField.secureTextEntry = YES;
        _verifyCodeTextField.layer.borderColor = UIColor.blackColor.CGColor;
        _verifyCodeTextField.layer.borderWidth = 1.0f;
        _verifyCodeTextField.layer.cornerRadius = 6.0f;
        _verifyCodeTextField.layer.masksToBounds = YES;
    }
    return _verifyCodeTextField;
}

-(UIButton *)sendVerifyCodeButton{
    if (!_sendVerifyCodeButton) {
        _sendVerifyCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendVerifyCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        _sendVerifyCodeButton.frame = CGRectZero;
        _sendVerifyCodeButton.layer.cornerRadius = 6.0f;
        _sendVerifyCodeButton.backgroundColor = [UIColor blueColor];
        [_sendVerifyCodeButton addTarget:self action:@selector(actionSendVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendVerifyCodeButton;
}

-(UIButton *)registerButton{
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        _registerButton.frame = CGRectZero;
        _registerButton.layer.cornerRadius = 6.0f;
        _registerButton.backgroundColor = [UIColor blueColor];
        [_registerButton addTarget:self action:@selector(actionRegister:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

@end
