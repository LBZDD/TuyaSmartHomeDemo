//
//  TYTableViewSecionModel.m
//  TuyaSmartHomeDemo
//
//  Created by 林波 on 2021/4/24.
//

#import "TYTableViewSecionModel.h"

@implementation TYTableViewSecionModel

+ (instancetype)sectionModelWithTitle:(NSString *)title items:(NSArray <TYTableViewItemModel *>*)items{
    TYTableViewSecionModel *sectionModel = [[TYTableViewSecionModel alloc] init];
    sectionModel.sectionTitle = title;
    sectionModel.items = items;
    return sectionModel;
}

@end

@implementation TYTableViewItemModel

+ (instancetype)itemModelWithTitle:(NSString *)title subTitle:(NSString *)subTitle{
    TYTableViewItemModel *itemModel = [[TYTableViewItemModel alloc] init];
    itemModel.title = title;
    itemModel.subTitle = subTitle;
    return itemModel;
}

@end
