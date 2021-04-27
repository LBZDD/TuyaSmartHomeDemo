//
//  TYBaseTableViewCell.h
//  TuyaSmartHomeDemo
//
//  Created by 林波 on 2021/4/26.
//

#import <UIKit/UIKit.h>

@class TYBaseTableViewCell;

typedef NS_ENUM(NSInteger,TYCellActionType) {
    TYCellActionTypeSwitch,
    TYCellActionTypeEnum,
    TYCellActionTypeValue,
    TYCellActionTypeString,
};

@protocol TYCellActionDelegate<NSObject>
@optional

- (void)tyCell:(TYBaseTableViewCell *_Nonnull)cell actionType:(TYCellActionType)actionType schemaModel:(TuyaSmartSchemaModel *_Nonnull)schemaModel value:(id _Nullable)value;


@end

NS_ASSUME_NONNULL_BEGIN

@interface TYBaseTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, weak, nullable) id<TYCellActionDelegate> delegate;

@property (nonatomic, strong, readonly) TuyaSmartSchemaModel *schemaModel;

- (void)configureView;

- (void)configureModel:(TuyaSmartSchemaModel *)model dps:(NSDictionary *)dps;

- (void)disEnableControl;

@end

NS_ASSUME_NONNULL_END
