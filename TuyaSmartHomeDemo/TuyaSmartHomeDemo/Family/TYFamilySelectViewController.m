//
//  TYFamilySelectViewController.m
//  TuyaSmartHomeDemo
//
//  Created by 林波 on 2021/4/25.
//

#import "TYFamilySelectViewController.h"

@interface TYFamilySelectViewController ()<UITableViewDelegate,UITableViewDataSource,TuyaSmartHomeManagerDelegate,TuyaSmartHomeDelegate>

@property (nonatomic, strong) UITableView *tableView;

// 数据源
@property (nonatomic, strong) NSArray <TYTableViewSecionModel *>*dataSource;
// 家庭管理
@property(strong, nonatomic) TuyaSmartHomeManager *homeManager;

@end

@implementation TYFamilySelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
    [self requestData];
}

#pragma mark - private method
- (void)configureView{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(CGSizeZero);
    }];
}

- (void)requestData{
    @weakify(self)
    [self.homeManager getHomeListWithSuccess:^(NSArray<TuyaSmartHomeModel *> *homes) {
        @strongify(self)
        [self configureDataWithHomes:homes];
    } failure:^(NSError *error) {
        NSString *errorStr = [NSString stringWithFormat:@"获取家庭列表失败:%@",error.localizedDescription];
        [SVProgressHUD showErrorWithStatus:errorStr];
    }];
}

- (void)configureDataWithHomes:(NSArray <TuyaSmartHomeModel *>*)homes{
    NSMutableArray <TYTableViewItemModel *>*items = [NSMutableArray array];
    [homes enumerateObjectsUsingBlock:^(TuyaSmartHomeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TYTableViewItemModel *itemModel = [TYTableViewItemModel itemModelWithTitle:obj.name subTitle:nil];
        itemModel.selectViewController = @"TYFamilyDetailViewController";
        itemModel.object = obj;
        [items addObject:itemModel];
    }];
    
    TYTableViewSecionModel *sectionModel = [TYTableViewSecionModel sectionModelWithTitle:@"" items:items.copy];
    self.dataSource = @[sectionModel];
    [self.tableView reloadData];
}

#pragma mark - TuyaSmartHomeManagerDelegate
- (void)homeManager:(TuyaSmartHomeManager *)manager didRemoveHome:(long long)homeId{
    [self requestData];
}

#pragma mark - TuyaSmartHomeDelegate
- (void)homeDidUpdateInfo:(TuyaSmartHome *)home{
    [self requestData];
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
    
    TYTableViewItemModel *item = [[[self.dataSource objectAtIndex:indexPath.section] items] objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subTitle;
    TuyaSmartHomeModel *homeModel = item.object;
    NSString *homeId = [TYSDKUserDefault tysdk_getUserDefault:CURRENTHOME_ID];
    if (homeModel.homeId == homeId.longLongValue) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        return;
    }
    for (UITableViewCell *objCell in tableView.visibleCells) {
        objCell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    TYTableViewItemModel *item = [[[self.dataSource objectAtIndex:indexPath.section] items] objectAtIndex:indexPath.row];
    TuyaSmartHomeModel *homeModel = item.object;
    NSString *homeId = [NSString stringWithFormat:@"%lld",homeModel.homeId];
    [TYSDKUserDefault tysdk_setUserDefault:homeId forKey:CURRENTHOME_ID];
    [self.navigationController popViewControllerAnimated:YES];
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

-(TuyaSmartHomeManager *)homeManager{
    if (!_homeManager) {
        _homeManager = [[TuyaSmartHomeManager alloc] init];
        _homeManager.delegate = self;
    }
    return _homeManager;
}

@end
