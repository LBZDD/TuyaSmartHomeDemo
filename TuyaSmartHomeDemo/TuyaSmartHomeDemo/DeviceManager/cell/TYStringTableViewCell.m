//
//  TYStringTableViewCell.m
//  TuyaSmartHomeDemo
//
//  Created by 林波 on 2021/4/26.
//

#import "TYStringTableViewCell.h"

@interface TYStringTableViewCell ()

@property (nonatomic, strong) UITextField *stringTextField;

@property (nonatomic, strong) UIButton *confirmButton;
@end

@implementation TYStringTableViewCell

-(void)configureView{
    [super configureView];
    [self.contentView addSubview:self.stringTextField];
    [self.contentView addSubview:self.confirmButton];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10.0f);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50.0f, 40.0f));
    }];
    
    [self.stringTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.mas_equalTo(self).multipliedBy(0.5f);
        make.height.equalTo(@40.0f);
        make.right.equalTo(self.confirmButton.mas_left).offset(-5.0f);
    }];
}

-(void)configureModel:(TuyaSmartSchemaModel *)model dps:(NSDictionary *)dps{
    [super configureModel:model dps:dps];
    self.stringTextField.text = [dps objectForKey:model.dpId];
}


-(void)disEnableControl{
    self.stringTextField.enabled = NO;
}


#pragma mark - action
- (void)actionUpdate:(UIButton *)sender{
    if (self.stringTextField.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"输入不可为空"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(tyCell:actionType:schemaModel:value:)]) {
        [self.delegate tyCell:self actionType:TYCellActionTypeString schemaModel:self.schemaModel value:self.stringTextField.text];
    }
}

#pragma mark - setter && getter
-(UITextField *)stringTextField{
    if (!_stringTextField) {
        _stringTextField = [[UITextField alloc] init];
        _stringTextField.placeholder = @"请输入值";
        _stringTextField.font = [UIFont systemFontOfSize:16.0f];
        _stringTextField.layer.borderColor = UIColor.blackColor.CGColor;
        _stringTextField.layer.borderWidth = 1.0f;
        _stringTextField.layer.cornerRadius = 6.0f;
        _stringTextField.layer.masksToBounds = YES;
        _stringTextField.textAlignment = NSTextAlignmentCenter;
    }
    return _stringTextField;
}

-(UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        _confirmButton.layer.cornerRadius = 6.0f;
        [_confirmButton setBackgroundColor:[UIColor blueColor]];
        [_confirmButton addTarget:self action:@selector(actionUpdate:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
