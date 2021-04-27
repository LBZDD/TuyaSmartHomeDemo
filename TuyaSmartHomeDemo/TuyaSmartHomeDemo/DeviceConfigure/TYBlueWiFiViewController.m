//
//  TYBlueWiFiViewController.m
//  TuyaSmartHomeDemo
//
//  Created by 林波 on 2021/4/25.
//

#import "TYBlueWiFiViewController.h"

@interface TYBlueWiFiViewController ()<UITableViewDataSource,UITableViewDelegate,TuyaSmartBLEManagerDelegate,TuyaSmartBLEWifiActivatorDelegate>

// 搜索
@property (nonatomic, strong) UIBarButtonItem *rightTitleItem;

@property (nonatomic, strong) UITableView *tableView;

// 数据源
@property (nonatomic, strong) NSMutableArray <TYBLEAdvModel *>*dataSource;

@property (nonatomic, assign) BOOL searching;
@end

@implementation TYBlueWiFiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self stopListening];
    [TuyaSmartBLEWifiActivator sharedInstance].bleWifiDelegate = nil;
}

#pragma mark - action
- (void)actionSearch:(id)sender{
    if (!self.searching) {
        [self.rightTitleItem setTitle:@"停止搜索"];
        [self startListening];
    } else {
        [self.rightTitleItem setTitle:@"开始搜索"];
        [self stopListening];
    }
    self.searching = !self.searching;
}

#pragma mark - private method
- (void)configureView{
    self.navigationItem.rightBarButtonItem = self.rightTitleItem;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(CGSizeZero);
    }];
}

- (void)startListening{
    [TuyaSmartBLEManager sharedInstance].delegate = self;
    [[TuyaSmartBLEManager sharedInstance] startListening:YES];
}

- (void)stopListening{
    [TuyaSmartBLEManager sharedInstance].delegate= nil;
    [[TuyaSmartBLEManager sharedInstance] stopListening:YES];
}

#pragma mark - TuyaSmartBLEManagerDelegate
- (void)didDiscoveryDeviceWithDeviceInfo:(TYBLEAdvModel *)deviceInfo{
    NSLog(@"扫描到了设备：%@",deviceInfo.productId);
    if(![self.dataSource containsObject:deviceInfo]){
        [self.dataSource addObject:deviceInfo];
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    TYBLEAdvModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.mac;
    cell.detailTextLabel.text = model.productId;
    return cell;
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
    TYBLEAdvModel *model = self.dataSource[indexPath.row];
    NSString  *ssid = @"Tuya-Test";
    NSString  *password = @"Tuya.140616";
    NSString *homeId = [TYSDKUserDefault tysdk_getUserDefault:CURRENTHOME_ID];
    [SVProgressHUD showWithStatus:@"配网中"];
    [TuyaSmartBLEWifiActivator sharedInstance].bleWifiDelegate = self;
    [[TuyaSmartBLEWifiActivator sharedInstance] startConfigBLEWifiDeviceWithUUID:model.uuid homeId:homeId.longLongValue productId:model.productId ssid:ssid password:password timeout:100 success:^{
        [SVProgressHUD showWithStatus:@"配网成功开始连接"];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"配网失败"];
    }];
}

#pragma mark - TuyaSmartBLEWifiActivatorDelegate
- (void)bleWifiActivator:(TuyaSmartBLEWifiActivator *)activator didReceiveBLEWifiConfigDevice:(TuyaSmartDeviceModel *)deviceModel error:(NSError *)error{
    NSLog(@">>>>>>error:%@",error);
    if (!error && deviceModel) {
        [SVProgressHUD showSuccessWithStatus:@"连接成功"];
    } else{
        NSString *errorStr = [NSString stringWithFormat:@"连接失败:%@",error.localizedDescription];
        [SVProgressHUD showErrorWithStatus:errorStr];
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
        _rightTitleItem = [[UIBarButtonItem alloc] initWithTitle:@"开始搜索" style:UIBarButtonItemStylePlain target:self action:@selector(actionSearch:)];
    }
    return _rightTitleItem;
}


-(NSMutableArray<TYBLEAdvModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
