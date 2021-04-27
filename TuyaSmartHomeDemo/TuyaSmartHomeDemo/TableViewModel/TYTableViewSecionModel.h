//
//  TYTableViewSecionModel.h
//  TuyaSmartHomeDemo
//
//  Created by 林波 on 2021/4/24.
//

#import <Foundation/Foundation.h>
@class TYTableViewItemModel;

@interface TYTableViewSecionModel : NSObject

@property (nonatomic, copy) NSString *sectionTitle;

@property (nonatomic, strong) NSArray <TYTableViewItemModel *>*items;

+ (instancetype)sectionModelWithTitle:(NSString *)title items:(NSArray <TYTableViewItemModel *>*)items;

@end

@interface TYTableViewItemModel : NSObject

@property (nonatomic, strong) id object;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic, copy) NSString *selectViewController;

+ (instancetype)itemModelWithTitle:(NSString *)title subTitle:(NSString *)subTitle;

@end

