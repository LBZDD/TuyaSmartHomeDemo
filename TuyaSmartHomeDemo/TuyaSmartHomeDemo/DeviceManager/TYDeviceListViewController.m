//
//  TYDeviceListViewController.m
//  TuyaSmartHomeDemo
//
//  Created by 林波 on 2021/4/26.
//

#import "TYDeviceListViewController.h"
#import "TYDeviceControlViewController.h"

@interface TYDeviceListViewController ()<UITableViewDelegate,UITableViewDataSource,TuyaSmartHomeDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (strong, nonatomic) TuyaSmartHome *home;

@end

@implementation TYDeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    [self configureData];
}

#pragma mark - private method
- (void)configureView{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(CGSizeZero);
    }];
}

- (void)configureData{
    NSString *homeId = [TYSDKUserDefault tysdk_getUserDefault:CURRENTHOME_ID];
    self.home = [TuyaSmartHome homeWithHomeId:homeId.longLongValue];
    self.home.delegate = self;
    @weakify(self)
    [self.home getHomeDetailWithSuccess:^(TuyaSmartHomeModel *homeModel) {
        @strongify(self)
        [self.tableView reloadData];
    } failure:nil];
}

#pragma mark - TuyaSmartHomeDelegate
- (void)homeDidUpdateInfo:(TuyaSmartHome *)home {
    [self.tableView reloadData];
}

-(void)home:(TuyaSmartHome *)home didAddDeivice:(TuyaSmartDeviceModel *)device {
    [self.tableView reloadData];
}

-(void)home:(TuyaSmartHome *)home didRemoveDeivice:(NSString *)devId {
    [self.tableView reloadData];
}

-(void)home:(TuyaSmartHome *)home deviceInfoUpdate:(TuyaSmartDeviceModel *)device {
    [self.tableView reloadData];
}

-(void)home:(TuyaSmartHome *)home device:(TuyaSmartDeviceModel *)device dpsUpdate:(NSDictionary *)dps {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.home.deviceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    TuyaSmartDeviceModel *deviceModel = self.home.deviceList[indexPath.row];
    cell.textLabel.text = deviceModel.name;
    cell.detailTextLabel.text = deviceModel.isOnline?@"在线":@"离线";
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
    TuyaSmartDeviceModel *deviceModel = self.home.deviceList[indexPath.row];
    TuyaSmartDevice *device = [TuyaSmartDevice deviceWithDeviceId:deviceModel.devId];
    
    TYDeviceControlViewController *deviceControlViewController = [[TYDeviceControlViewController alloc] init];
    deviceControlViewController.device = device;
    [self.navigationController pushViewController:deviceControlViewController animated:YES];
            
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
@end
