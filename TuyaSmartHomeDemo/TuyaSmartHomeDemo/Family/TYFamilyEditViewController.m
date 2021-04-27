//
//  TYFamilyEditViewController.m
//  TuyaSmartHomeDemo
//
//  Created by 林波 on 2021/4/25.
//

#import "TYFamilyEditViewController.h"

@interface TYFamilyEditViewController ()

// 家庭名称
@property (nonatomic, strong) UITextField *familyNameTextField;
// 城市名称
@property (nonatomic, strong) UITextField *cityNameTextField;
// 修改按钮
@property (nonatomic, strong) UIButton *finishButton;
// 家庭管理
@property(strong, nonatomic) TuyaSmartHomeManager *homeManager;

@end

@implementation TYFamilyEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"编辑";
    [self configureView];
}

#pragma mark - action
- (void)actionEditFinish:(id)sender{
    [self.view endEditing:YES];
    NSString *currentName = self.familyNameTextField.text;
    NSString *currentCity = self.cityNameTextField.text;
    TuyaSmartHome *home = [TuyaSmartHome homeWithHomeId:self.homeModel.homeId];
    [home updateHomeInfoWithName:currentName geoName:currentCity latitude:0 longitude:0 success:^{
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        NSString *errorStr = [NSString stringWithFormat:@"修改失败:%@",error.localizedDescription];
        [SVProgressHUD showErrorWithStatus:errorStr];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - private method
- (void)configureView{
    self.familyNameTextField.text = self.homeModel.name;
    self.cityNameTextField.text = self.homeModel.geoName;
    [self.view addSubview:self.familyNameTextField];
    [self.view addSubview:self.cityNameTextField];
    [self.view addSubview:self.finishButton];
    
    [self.familyNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(30.0f);
        make.height.mas_equalTo(30.0f);
    }];
    
    [self.cityNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.familyNameTextField.mas_bottom).offset(20.0f);
        make.width.equalTo(self.familyNameTextField);
        make.centerX.equalTo(self.familyNameTextField);
        make.height.equalTo(self.familyNameTextField);
    }];
    
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cityNameTextField.mas_bottom).offset(20.0f);
        make.width.equalTo(self.cityNameTextField);
        make.centerX.equalTo(self.cityNameTextField);
    }];
}

#pragma mark - setter && getter
-(UITextField *)familyNameTextField{
    if (!_familyNameTextField) {
        _familyNameTextField = [[UITextField alloc]initWithFrame:CGRectZero];
        _familyNameTextField.placeholder = @"输入家庭名称";
        _familyNameTextField.font = [UIFont systemFontOfSize:16.0f];
        _familyNameTextField.layer.borderColor = UIColor.blackColor.CGColor;
        _familyNameTextField.layer.borderWidth = 1.0f;
        _familyNameTextField.layer.cornerRadius = 6.0f;
        _familyNameTextField.layer.masksToBounds = YES;
    }
    return _familyNameTextField;
}


-(UITextField *)cityNameTextField{
    if (!_cityNameTextField) {
        _cityNameTextField = [[UITextField alloc]initWithFrame:CGRectZero];
        _cityNameTextField.placeholder = @"输入城市";
        _cityNameTextField.font = [UIFont systemFontOfSize:16.0f];
        _cityNameTextField.layer.borderColor = UIColor.blackColor.CGColor;
        _cityNameTextField.layer.borderWidth = 1.0f;
        _cityNameTextField.layer.cornerRadius = 6.0f;
        _cityNameTextField.layer.masksToBounds = YES;
    }
    return _cityNameTextField;
}

-(UIButton *)finishButton{
    if (!_finishButton) {
        _finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        _finishButton.frame = CGRectZero;
        _finishButton.layer.cornerRadius = 6.0f;
        _finishButton.backgroundColor = [UIColor blueColor];
        [_finishButton addTarget:self action:@selector(actionEditFinish:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishButton;
}

-(TuyaSmartHomeManager *)homeManager{
    if (!_homeManager) {
        _homeManager = [[TuyaSmartHomeManager alloc] init];
    }
    return _homeManager;
}
@end
