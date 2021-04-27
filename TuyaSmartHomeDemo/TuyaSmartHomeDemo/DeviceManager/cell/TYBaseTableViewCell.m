//
//  TYBaseTableViewCell.m
//  TuyaSmartHomeDemo
//
//  Created by 林波 on 2021/4/26.
//

#import "TYBaseTableViewCell.h"

@implementation TYBaseTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureView];
    }
    return self;
}

- (void)configureView{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(5.0f);
        make.height.mas_equalTo(@(20.0f));
        make.left.mas_equalTo(self).offset(20.0f);
        make.width.mas_equalTo(self).multipliedBy(0.5f);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5.0f);
        make.left.width.height.mas_equalTo(self.titleLabel);
    }];
}

- (void)configureModel:(TuyaSmartSchemaModel *)model dps:(NSDictionary *)dps{
    _schemaModel = model;
    self.titleLabel.text = model.name;
    BOOL canOperate = ![model.mode isEqualToString:@"ro"];
    if (canOperate) {
        self.subTitleLabel.text = @"可操作";
    }  else {
        self.subTitleLabel.text = @"禁用操作";
        self.subTitleLabel.textColor = [UIColor redColor];
        [self disEnableControl];
    }
}

- (void)disEnableControl{    
}

#pragma mark - setter && getter
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;;
}

-(UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
    }
    return _subTitleLabel;
}

@end
