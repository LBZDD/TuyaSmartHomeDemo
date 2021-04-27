//
//  TYDeviceManagerViewController.m
//  TuyaSmartHomeDemo
//
//  Created by 林波 on 2021/4/24.
//

#import "TYDeviceManagerViewController.h"
#import "TYUserCenterViewController.h"

#define ADDVIRTUREDEVICE @"添加虚拟设备"

@interface TYDeviceManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
// 用户中心
@property (nonatomic, strong) UIBarButtonItem *rightTitleItem;

@property (nonatomic, strong) UITableView *tableView;
// 数据源
@property (nonatomic, strong) NSArray <TYTableViewSecionModel *>*dataSource;
// 家庭管理
@property(strong, nonatomic) TuyaSmartHomeManager *homeManager;
// 请求类
@property (nonatomic, strong) TuyaSmartRequest *request;

@end

@implementation TYDeviceManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备信息";
    [self configureView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}

#pragma mark - action
- (void)actionGoUserCenter:(id)sender{
    TYUserCenterViewController *userCenterViewController = [[TYUserCenterViewController alloc] init];
    [self.navigationController pushViewController:userCenterViewController animated:YES];
}

- (void)addVirtureDevice{
//    NSString *homeId = [TYSDKUserDefault tysdk_getUserDefault:CURRENTHOME_ID];
//    if (!homeId) {
//        [SVProgressHUD showErrorWithStatus:@"homeID为空"];
//        return;
//    }
//    [self.request requestWithApiName:@"tuya.m.qrcode.parse" postData:nil getData:@{@"gid":homeId} version:@"4.0" success:^(id result) {
//        NSLog(@">>>>>result:%@",result);
//    } failure:^(NSError *error) {
//        NSString *errorStr = [NSString stringWithFormat:@"添加失败:%@",error.localizedDescription];
//        [SVProgressHUD showErrorWithStatus:errorStr];
//    }];
}

#pragma mark - private method
- (void)configureView{
    self.navigationItem.rightBarButtonItem = self.rightTitleItem;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(CGSizeZero);
    }];
}

- (void)requestData{
    @weakify(self)
    [self.homeManager getHomeListWithSuccess:^(NSArray<TuyaSmartHomeModel *> *homes) {
        @strongify(self)
        NSString *homeId = [TYSDKUserDefault tysdk_getUserDefault:CURRENTHOME_ID];
        if (!homeId && homes.firstObject) {
            homeId = [NSString stringWithFormat:@"%lld",homes.firstObject.homeId];
            [TYSDKUserDefault tysdk_setUserDefault:homeId forKey:CURRENTHOME_ID];
        }
        TuyaSmartHomeModel *homeModel = [TuyaSmartHome homeWithHomeId:homeId.longLongValue].homeModel;
        TYTableViewItemModel *itemModel = [[[self.dataSource objectAtIndex:0] items] objectAtIndex:1];
        itemModel.subTitle = homeModel.name;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSString *errorStr = [NSString stringWithFormat:@"获取家庭列表失败:%@",error.localizedDescription];
        [SVProgressHUD showErrorWithStatus:errorStr];
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
    TYTableViewItemModel *item = [[[self.dataSource objectAtIndex:indexPath.section] items] objectAtIndex:indexPath.row];
    if (item.selectViewController) {
        UIViewController *viewController = [[NSClassFromString(item.selectViewController) alloc] init];
        viewController.title = item.title;
        viewController.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if ([item.title isEqualToString:ADDVIRTUREDEVICE]) {
        [self addVirtureDevice];
    }
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
        _rightTitleItem = [[UIBarButtonItem alloc] initWithTitle:@"用户中心" style:UIBarButtonItemStylePlain target:self action:@selector(actionGoUserCenter:)];
    }
    return _rightTitleItem;
}

-(NSArray<TYTableViewSecionModel *> *)dataSource{
    if (!_dataSource) {
        NSMutableArray <TYTableViewSecionModel *>*array = [NSMutableArray array];
        {
            TYTableViewItemModel *createFamilyItem = [TYTableViewItemModel itemModelWithTitle:@"创建家庭" subTitle:nil];
            createFamilyItem.selectViewController = @"TYCreateFamilyViewController";
            NSString *value = [TYSDKUserDefault tysdk_getUserDefault:CURRENTHOME_ID];
            TuyaSmartHome *home = [TuyaSmartHome homeWithHomeId:value.longLongValue];
            TYTableViewItemModel *currentFamilyItem = [TYTableViewItemModel itemModelWithTitle:@"当前家庭" subTitle:home.homeModel.name];
            currentFamilyItem.selectViewController = @"TYFamilySelectViewController";
            TYTableViewItemModel *familyListItem = [TYTableViewItemModel itemModelWithTitle:@"家庭列表" subTitle:nil];
            familyListItem.selectViewController = @"TYFamilyListViewController";
            TYTableViewSecionModel *familyItem = [TYTableViewSecionModel sectionModelWithTitle:@"家庭管理" items:@[createFamilyItem,currentFamilyItem,familyListItem]];
            [array addObject:familyItem];
        }
        
        {
            TYTableViewItemModel *ezItem = [TYTableViewItemModel itemModelWithTitle:@"EZ模式" subTitle:nil];
            ezItem.selectViewController = @"TYEZModelViewController";
            TYTableViewItemModel *apItem = [TYTableViewItemModel itemModelWithTitle:@"AP模式" subTitle:nil];
            apItem.selectViewController = @"TYAPModelViewController";
            TYTableViewItemModel *doubleItem = [TYTableViewItemModel itemModelWithTitle:@"双模配网" subTitle:nil];
            doubleItem.selectViewController = @"TYBlueWiFiViewController";
            
            TYTableViewSecionModel *styleItem = [TYTableViewSecionModel sectionModelWithTitle:@"配网模式" items:@[ezItem,apItem,doubleItem]];
            [array addObject:styleItem];
        }
        
        {
//            TYTableViewItemModel *virtureDeviceItem = [TYTableViewItemModel itemModelWithTitle:ADDVIRTUREDEVICE subTitle:nil];
            TYTableViewItemModel *deviceListItem = [TYTableViewItemModel itemModelWithTitle:@"设备列表" subTitle:nil];
            deviceListItem.selectViewController = @"TYDeviceListViewController";
            
            TYTableViewSecionModel *deviceItem = [TYTableViewSecionModel sectionModelWithTitle:@"设备管理" items:@[/*virtureDeviceItem,*/deviceListItem]];

            [array addObject:deviceItem];
        }
        
        _dataSource = array.copy;
    }
    return _dataSource;
}

-(TuyaSmartHomeManager *)homeManager{
    if (!_homeManager) {
        _homeManager = [[TuyaSmartHomeManager alloc] init];
    }
    return _homeManager;
}

-(TuyaSmartRequest *)request{
    if (!_request) {
        _request = [[TuyaSmartRequest alloc] init];
    }
    return _request;
}
@end
