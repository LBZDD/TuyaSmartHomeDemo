//
//  LoginViewController.m
//  TuyaSmartHomeDemo
//
//  Created by 林波 on 2021/4/24.
//

#import "TYLoginViewController.h"
#import "TYRegisterViewController.h"
#import "TYDeviceManagerViewController.h"

@interface TYLoginViewController ()
// 登录按钮
@property (nonatomic, strong) UIButton *loginButton;
// 注册按钮
@property (nonatomic, strong) UIButton *registerButton;
// 区号
@property (nonatomic, strong) UITextField *countryTextField;
// 账号
@property (nonatomic, strong) UITextField *accountTextField;
// 密码
@property (nonatomic, strong) UITextField *passwordTextField;

@end

@implementation TYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];    
    [self configureView];
}
#pragma mark - action
- (void)actionLogin:(id)sender{
    [self.view endEditing:YES];
    if ([self isValidateEmail:self.accountTextField.text]) {
        [self loginByEmail];
    } else {
        [self loginByPhoneNumber];
    }
}

- (void)actionRegister:(id)sender{
    [self.view endEditing:YES];
    TYRegisterViewController *registerVC = [[TYRegisterViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:registerVC];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - private method
- (void)configureView{
    [self.view addSubview:self.countryTextField];
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.loginButton];
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
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTextField.mas_bottom).offset(20.0f);
        make.width.equalTo(self.accountTextField);
        make.centerX.equalTo(self.accountTextField);
        make.height.equalTo(self.accountTextField);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(30.0f);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.passwordTextField);
    }];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.loginButton.mas_bottom).offset(20.0f);
        make.size.equalTo(self.loginButton);
    }];
}

- (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPredicate evaluateWithObject:email];
}

- (void)loginByEmail{
    NSString *countryCode   = self.countryTextField.text;
    NSString *email         = self.accountTextField.text;
    NSString *password      = self.passwordTextField.text;
    [SVProgressHUD showWithStatus:@"正在登录中"];
    [[TuyaSmartUser sharedInstance] loginByEmail:countryCode email:email password:password success:^{
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        TYDeviceManagerViewController *deviceVC = [[TYDeviceManagerViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:deviceVC];
        [self presentViewController:navigationController animated:YES completion:nil];
    } failure:^(NSError *error) {
        NSString *errorStr = [NSString stringWithFormat:@"登陆失败:%@",error.localizedDescription];
        [SVProgressHUD showErrorWithStatus:errorStr];
    }];
}

- (void)loginByPhoneNumber{
    NSString *countryCode   = self.countryTextField.text;
    NSString *phoneNumber   = self.accountTextField.text;
    NSString *password      = self.passwordTextField.text;
    [SVProgressHUD showWithStatus:@"正在登录中"];
    [[TuyaSmartUser sharedInstance] loginByPhone:countryCode phoneNumber:phoneNumber password:password success:^{
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        TYDeviceManagerViewController *deviceVC = [[TYDeviceManagerViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:deviceVC];
        [self presentViewController:navigationController animated:YES completion:nil];
    } failure:^(NSError *error) {
        NSString *errorStr = [NSString stringWithFormat:@"登陆失败:%@",error.localizedDescription];
        [SVProgressHUD showErrorWithStatus:errorStr];
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

-(UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
        _loginButton.frame = CGRectZero;
        _loginButton.layer.cornerRadius = 6.0f;
        _loginButton.backgroundColor = [UIColor blueColor];
        [_loginButton addTarget:self action:@selector(actionLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
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
