//
//  UserCenterViewController.m
//  TuyaSmartHomeDemo
//
//  Created by 林波 on 2021/4/24.
//

#import "TYUserCenterViewController.h"
#import "TYLoginViewController.h"

@interface TYUserCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
// 退出登录
@property (nonatomic, strong) UIBarButtonItem *rightTitleItem;

@property (nonatomic, strong) UITableView *tableView;
// 数据源
@property (nonatomic, strong) NSArray <TYTableViewSecionModel *>*dataSource;

@end

@implementation TYUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户中心";
    [self configureView];
}

#pragma mark - action
- (void)actionLoginOut:(id)sender{
    [SVProgressHUD showWithStatus:@"退出登录中"];
    [[TuyaSmartUser sharedInstance] loginOut:^{
        [SVProgressHUD showSuccessWithStatus:@"退出成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        TYLoginViewController *viewController = [[TYLoginViewController alloc] init];;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
       navigationController.navigationBarHidden = YES;
        [UIApplication sharedApplication].keyWindow.rootViewController = navigationController;
    } failure:^(NSError *error) {
        NSString *errorStr = [NSString stringWithFormat:@"退出失败:%@",error.localizedDescription];
        [SVProgressHUD showErrorWithStatus:errorStr];
    }];
}

#pragma mark - private method
- (void)configureView{
    self.navigationItem.rightBarButtonItem = self.rightTitleItem;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(CGSizeZero);
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource objectAtIndex:section].items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    TYTableViewItemModel *item = [[[self.dataSource objectAtIndex:indexPath.section] items] objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subTitle;
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.dataSource objectAtIndex:section].sectionTitle;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - setter && getter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIBarButtonItem *)rightTitleItem {
    if (!_rightTitleItem) {
        _rightTitleItem = [[UIBarButtonItem alloc] initWithTitle:@"退出登录" style:UIBarButtonItemStylePlain target:self action:@selector(actionLoginOut:)];
    }
    return _rightTitleItem;
}

-(NSArray<TYTableViewSecionModel *> *)dataSource{
    if (!_dataSource) {
        NSMutableArray <TYTableViewSecionModel *>*array = [NSMutableArray array];
        
        TYTableViewItemModel *userItem = [TYTableViewItemModel itemModelWithTitle:@"用户名" subTitle:[TuyaSmartUser sharedInstance].userName];
        TYTableViewItemModel *phoneNumberItem = [TYTableViewItemModel itemModelWithTitle:@"手机号码" subTitle:[TuyaSmartUser sharedInstance].phoneNumber];
        TYTableViewItemModel *emailItem = [TYTableViewItemModel itemModelWithTitle:@"电子邮箱" subTitle:[TuyaSmartUser sharedInstance].email];
        TYTableViewItemModel *countryItem = [TYTableViewItemModel itemModelWithTitle:@"区号" subTitle:[TuyaSmartUser sharedInstance].countryCode];
        TYTableViewItemModel *timeItem = [TYTableViewItemModel itemModelWithTitle:@"时区" subTitle:[TuyaSmartUser sharedInstance].timezoneId];
        
        TYTableViewSecionModel *familyItem = [TYTableViewSecionModel sectionModelWithTitle:@"" items:@[userItem,phoneNumberItem,emailItem,countryItem,timeItem]];
        [array addObject:familyItem];
                        
        _dataSource = array.copy;
    }
    return _dataSource;
}

@end
