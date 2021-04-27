//
//  TYEnumTableViewCell.m
//  TuyaSmartHomeDemo
//
//  Created by 林波 on 2021/4/26.
//

#import "TYEnumTableViewCell.h"

@interface TYEnumTableViewCell ()

@property (nonatomic, strong) UIButton *enumButton;

@end

@implementation TYEnumTableViewCell

-(void)configureView{
    [super configureView];
    [self.contentView addSubview:self.enumButton];
    [self.enumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20.0f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100.0f, 30.0f));
    }];
}

-(void)configureModel:(TuyaSmartSchemaModel *)model dps:(NSDictionary *)dps{
    [super configureModel:model dps:dps];
    
    [self.enumButton setTitle:[dps objectForKey:model.dpId] forState:UIControlStateNormal];
}

- (void)disEnableControl{
    self.enumButton.enabled = NO;
}

#pragma mark - action
- (void)actionEnum:(id)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"可选择其中一项操作" preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSString *range in self.schemaModel.property.range) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:range style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.enumButton setTitle:range forState:UIControlStateNormal];
            if ([self.delegate respondsToSelector:@selector(tyCell:actionType:schemaModel:value:)]) {
                [self.delegate tyCell:self actionType:TYCellActionTypeEnum schemaModel:self.schemaModel value:range];
            }
        }];
        if ([range isEqualToString:self.enumButton.currentTitle]) {
            action.enabled = NO;
        }
        [alert addAction:action];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    UIViewController *viewController = [[UIApplication sharedApplication] delegate].window.rootViewController;
    [viewController presentViewController:alert animated:YES completion:nil];
    

}

#pragma mark - setter && getter
-(UIButton *)enumButton{
    if (!_enumButton) {
        _enumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _enumButton.frame = CGRectZero;
        _enumButton.backgroundColor = [UIColor cyanColor];
        _enumButton.layer.cornerRadius = 6.0f;
        _enumButton.layer.borderWidth = 1.0f;
        _enumButton.layer.borderColor = [UIColor orangeColor].CGColor;
        [_enumButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _enumButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_enumButton addTarget:self action:@selector(actionEnum:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _enumButton;
}

@end
