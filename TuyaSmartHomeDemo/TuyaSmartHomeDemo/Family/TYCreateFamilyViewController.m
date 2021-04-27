//
//  TYCreateFamilyViewController.m
//  TuyaSmartHomeDemo
//
//  Created by 林波 on 2021/4/24.
//

#import "TYCreateFamilyViewController.h"

@interface TYCreateFamilyViewController ()

// 家庭名称
@property (nonatomic, strong) UITextField *familyNameTextField;
// 城市名称
@property (nonatomic, strong) UITextField *cityNameTextField;
// 创建按钮
@property (nonatomic, strong) UIButton *createButton;
// 家庭管理
@property(strong, nonatomic) TuyaSmartHomeManager *homeManager;

@end

@implementation TYCreateFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    [self configureView];
}

#pragma mark - action
- (void)actionCreateFamily:(id)sender{
    [self.view endEditing:YES];
    NSString *homeName = self.familyNameTextField.text;
    NSString *geoName = self.cityNameTextField.text;
    [SVProgressHUD showWithStatus:@"创建房间中"];
    @weakify(self)
    [self.homeManager addHomeWithName:homeName geoName:geoName rooms:@[] latitude:0.0f longitude:0.0f success:^(long long result) {
        @strongify(self)
        [SVProgressHUD showSuccessWithStatus:@"创建成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        NSString *errorStr = [NSString stringWithFormat:@"创建失败:%@",error.localizedDescription];
        [SVProgressHUD showErrorWithStatus:errorStr];
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - private method
- (void)configureView{
    [self.view addSubview:self.familyNameTextField];
    [self.view addSubview:self.cityNameTextField];
    [self.view addSubview:self.createButton];
    
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
    
    [self.createButton mas_makeConstraints:^(MASConstraintMaker *make) {
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

-(UIButton *)createButton{
    if (!_createButton) {
        _createButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_createButton setTitle:@"开始创建" forState:UIControlStateNormal];
        _createButton.frame = CGRectZero;
        _createButton.layer.cornerRadius = 6.0f;
        _createButton.backgroundColor = [UIColor blueColor];
        [_createButton addTarget:self action:@selector(actionCreateFamily:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createButton;
}

-(TuyaSmartHomeManager *)homeManager{
    if (!_homeManager) {
        _homeManager = [[TuyaSmartHomeManager alloc] init];
    }
    return _homeManager;
}
@end
