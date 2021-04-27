//
//  TYSwitchTableViewCel.m
//  TuyaSmartHomeDemo
//
//  Created by 林波 on 2021/4/26.
//

#import "TYSwitchTableViewCell.h"

@interface TYSwitchTableViewCell ()

@property (nonatomic, strong) UISwitch *switchButton;

@end

@implementation TYSwitchTableViewCell

-(void)configureView{
    [super configureView];
    [self.contentView addSubview:self.switchButton];
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-20.0f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50.0f, 30.0f));
    }];
}

- (void)configureModel:(TuyaSmartSchemaModel *)model dps:(NSDictionary *)dps{
    [super configureModel:model dps:dps];
    BOOL isOn = [[dps objectForKey:model.dpId] boolValue];
    [self.switchButton setOn:isOn];
}

-(void)disEnableControl{
    self.switchButton.enabled = NO;
}

#pragma mark - action
- (void)actionSwith:(UISwitch *)sender{
    if ([self.delegate respondsToSelector:@selector(tyCell:actionType:schemaModel:value:)]) {
        [self.delegate tyCell:self actionType:TYCellActionTypeSwitch schemaModel:self.schemaModel value:[NSNumber numberWithBool:sender.on]];
    }
}

#pragma mark - setter && getter
-(UISwitch *)switchButton{
    if (!_switchButton) {
        _switchButton = [[UISwitch alloc] init];
        [_switchButton addTarget:self action:@selector(actionSwith:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchButton;
}

@end
