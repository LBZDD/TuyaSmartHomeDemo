//
//  TYEZModelViewController.m
//  TuyaSmartHomeDemo
//
//  Created by 林波 on 2021/4/25.
//

#import "TYEZModelViewController.h"

@interface TYEZModelViewController ()<TuyaSmartActivatorDelegate>

// 区号
@property (nonatomic, strong) UITextField *ssidTextField;
// 账号
@property (nonatomic, strong) UITextField *passwordTextField;
// 开始配网
@property (nonatomic, strong) UIButton *startBindButton;
// 停止配网
@property (nonatomic, strong) UIButton *stopBindButton;

@end

@implementation TYEZModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurData];
    [self configureView];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopConfigureWIFi];
}

#pragma mark - action
- (void)actionStartBind:(id)sender{
    NSString *homeId = [TYSDKUserDefault tysdk_getUserDefault:CURRENTHOME_ID];
    [SVProgressHUD showWithStatus:@"开始配网中"];
    [[TuyaSmartActivator sharedInstance] getTokenWithHomeId:homeId.longLongValue success:^(NSString *result) {
        if (result && result.length > 0) {
            NSLog(@"token获取成功");
            [self startConfigureWiFiWithToken:result];
        } else {
            [SVProgressHUD showErrorWithStatus:@"token异常"];
        }
    } failure:^(NSError *error) {
        NSString *errorStr = [NSString stringWithFormat:@"获取token失败:%@",error.localizedDescription];
        [SVProgressHUD showErrorWithStatus:errorStr];
    }];
}

- (void)actionStopBind:(id)sender{
    [self stopConfigureWIFi];
}

#pragma mark - private method
- (void)configurData{
    self.ssidTextField.text = @"Tuya-Test";
    self.passwordTextField.text = @"Tuya.140616";
}

- (void)configureView{
    [self.view addSubview:self.ssidTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.startBindButton];
    [self.view addSubview:self.stopBindButton];
    
    [self.ssidTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(200.0f);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(30.0f);
        make.height.mas_equalTo(30.0f);
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ssidTextField.mas_bottom).offset(20.0f);
        make.width.equalTo(self.ssidTextField);
        make.centerX.equalTo(self.ssidTextField);
        make.height.equalTo(self.ssidTextField);
    }];
    
    [self.startBindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(30.0f);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.passwordTextField);
    }];
    
    [self.stopBindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.startBindButton.mas_bottom).offset(20.0f);
        make.size.equalTo(self.startBindButton);
    }];
    
}

- (void)startConfigureWiFiWithToken:(NSString *)token{
    [TuyaSmartActivator sharedInstance].delegate = self;
    [[TuyaSmartActivator sharedInstance] startConfigWiFi:TYActivatorModeEZ ssid:self.ssidTextField.text password:self.passwordTextField.text token:token timeout:100];
}

- (void)stopConfigureWIFi{
    [SVProgressHUD dismiss];
    [TuyaSmartActivator sharedInstance].delegate = nil;
    [[TuyaSmartActivator sharedInstance] stopConfigWiFi];
}

#pragma mark - TuyaSmartActivatorDelegate
- (void)activator:(TuyaSmartActivator *)activator didReceiveDevice:(TuyaSmartDeviceModel *)deviceModel error:(NSError *)error{
    if (deviceModel && !error) {
        NSString *deviceName = deviceModel.name?:@"unknown device";
        NSString *status = [NSString stringWithFormat:@"配网成功:%@",deviceName];
        [SVProgressHUD showSuccessWithStatus:status];
    } else {
        NSString *errorStr = [NSString stringWithFormat:@"配网失败:%@",error.localizedDescription];
        [SVProgressHUD showErrorWithStatus:errorStr];
    }
}

#pragma mark - setter && getter
-(UITextField *)ssidTextField{
    if (!_ssidTextField) {
        _ssidTextField = [[UITextField alloc]initWithFrame:CGRectZero];
        _ssidTextField.placeholder = @"输入WiFi名称";
        _ssidTextField.keyboardType = UIKeyboardTypeNumberPad;
        _ssidTextField.font = [UIFont systemFontOfSize:16.0f];
        _ssidTextField.layer.borderColor = UIColor.blackColor.CGColor;
        _ssidTextField.layer.borderWidth = 1.0f;
        _ssidTextField.layer.cornerRadius = 6.0f;
        _ssidTextField.layer.masksToBounds = YES;
    }
    return _ssidTextField;
}

-(UITextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc]initWithFrame:CGRectZero];
        _passwordTextField.placeholder = @"输入WiFi密码";
        _passwordTextField.font = [UIFont systemFontOfSize:16.0f];
        _passwordTextField.layer.borderColor = UIColor.blackColor.CGColor;
        _passwordTextField.layer.borderWidth = 1.0f;
        _passwordTextField.layer.cornerRadius = 6.0f;
        _passwordTextField.layer.masksToBounds = YES;
    }
    return _passwordTextField;
}

-(UIButton *)startBindButton{
    if (!_startBindButton) {
        _startBindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBindButton setTitle:@"开始配网" forState:UIControlStateNormal];
        _startBindButton.frame = CGRectZero;
        _startBindButton.layer.cornerRadius = 6.0f;
        _startBindButton.backgroundColor = [UIColor blueColor];
        [_startBindButton addTarget:self action:@selector(actionStartBind:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBindButton;
}

-(UIButton *)stopBindButton{
    if (!_stopBindButton) {
        _stopBindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopBindButton setTitle:@"停止配网" forState:UIControlStateNormal];
        _stopBindButton.frame = CGRectZero;
        _stopBindButton.layer.cornerRadius = 6.0f;
        _stopBindButton.backgroundColor = [UIColor blueColor];
        [_stopBindButton addTarget:self action:@selector(actionStopBind:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopBindButton;
}

@end
