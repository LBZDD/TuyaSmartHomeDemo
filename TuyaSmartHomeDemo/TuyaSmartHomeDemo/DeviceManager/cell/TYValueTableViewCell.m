//
//  TYValueTableViewCell.m
//  TuyaSmartHomeDemo
//
//  Created by 林波 on 2021/4/26.
//

#import "TYValueTableViewCell.h"

@interface TYValueTableViewCell ()

@property (nonatomic, strong) UIStepper *stepper;

@property (nonatomic, strong) UILabel *valueLabel;

@end

@implementation TYValueTableViewCell

-(void)configureView{
    [super configureView];
    [self.contentView addSubview:self.stepper];
    [self.contentView addSubview:self.valueLabel];
    
    [self.stepper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(30.0f));
        make.right.mas_equalTo(self).offset(-20.0f);
        make.width.mas_equalTo(@(100.0f));
        make.centerY.mas_equalTo(self);
    }];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.stepper.mas_left).offset(-10.0f);
        make.centerY.equalTo(self);
        make.height.equalTo(self.stepper);
        make.width.equalTo(@50.0f);
    }];
}

-(void)configureModel:(TuyaSmartSchemaModel *)model dps:(NSDictionary *)dps{
    [super configureModel:model dps:dps];
    NSLog(@">>>>>>>%@  class:%@",[dps objectForKey:model.dpId],[[dps objectForKey:model.dpId] class]);
    self.valueLabel.text = [[dps objectForKey:model.dpId] stringValue];
    self.stepper.value = [[dps objectForKey:model.dpId] integerValue];
    self.stepper.minimumValue = model.property.min;
    self.stepper.maximumValue = model.property.max;
    self.stepper.stepValue = model.property.step;
}

- (void)disEnableControl{
    self.stepper.enabled = NO;
}

#pragma mark - action
- (void)actionStepper:(UIStepper *)sender{
    self.valueLabel.text = [NSString stringWithFormat:@"%d",(int)sender.value];
    if ([self.delegate respondsToSelector:@selector(tyCell:actionType:schemaModel:value:)]) {
        [self.delegate tyCell:self actionType:TYCellActionTypeValue schemaModel:self.schemaModel value:@(sender.value)];
    }
}

#pragma mark - setter && getter
-(UIStepper *)stepper{
    if (!_stepper) {
        _stepper = [[UIStepper alloc] init];
        [_stepper addTarget:self action:@selector(actionStepper:) forControlEvents:UIControlEventValueChanged];
    }
    return _stepper;
}

-(UILabel *)valueLabel{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _valueLabel;
}
@end
