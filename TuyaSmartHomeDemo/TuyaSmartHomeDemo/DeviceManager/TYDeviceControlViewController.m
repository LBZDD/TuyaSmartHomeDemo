//
//  TYDeviceControlViewController.m
//  TuyaSmartHomeDemo
//
//  Created by 林波 on 2021/4/26.
//

#import "TYDeviceControlViewController.h"
#import "TYSwitchTableViewCell.h"
#import "TYEnumTableViewCell.h"
#import "TYValueTableViewCell.h"
#import "TYStringTableViewCell.h"

@interface TYDeviceControlViewController ()<UITableViewDelegate,UITableViewDataSource,TuyaSmartDeviceDelegate,TYCellActionDelegate>
// 移除
@property (nonatomic, strong) UIBarButtonItem *rightTitleItem;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TYDeviceControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.device.deviceModel.name;
    [self configureView];
    [self configureData];
}


#pragma mark - action
- (void)actionRemoveDevice:(id)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认删除该设备吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //确认处理
        [SVProgressHUD showWithStatus:@"删除中"];
        @weakify(self)
        [self.device remove:^{
            @strongify(self)
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"删除失败"];
        }];
    }];
    UIAlertAction *cancaleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:confirmAction];
    [alert addAction:cancaleAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - private method
- (void)configureView{
    self.navigationItem.rightBarButtonItem = self.rightTitleItem;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(CGSizeZero);
    }];
}

- (void)configureData{
    self.device.delegate = self;
}

#pragma mark - TYCellActionDelegate
-(void)tyCell:(TYBaseTableViewCell *)cell actionType:(TYCellActionType)actionType schemaModel:(TuyaSmartSchemaModel *)schemaModel value:(id)value{
    NSLog(@">>>>>>>>params:%@",value);
    [self publishMessage:@{schemaModel.dpId:value}];
}

- (void)publishMessage:(NSDictionary *)message{
    NSLog(@">>>>>>>>message:%@",message);
    [SVProgressHUD showWithStatus:@"发送指令中"];
    [self.device publishDps:message success:^{
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
    } failure:^(NSError *error) {
        NSString *errorStr = [NSString stringWithFormat:@"发送失败:%@",error.localizedDescription];
        [SVProgressHUD showErrorWithStatus:errorStr];
    }];
}

#pragma mark - TuyaSmartDeviceDelegate


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.device.deviceModel.schemaArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TuyaSmartSchemaModel *schemaModel = self.device.deviceModel.schemaArray[indexPath.row];
    NSDictionary *dps = self.device.deviceModel.dps;
    NSString *type = [schemaModel.type isEqualToString:@"obj"] ? schemaModel.property.type : schemaModel.type;
    
    Class cellClass = [TYBaseTableViewCell class];
    if ([type isEqualToString:@"bool"]) {
        cellClass = [TYSwitchTableViewCell class];
    } else if ([type isEqualToString:@"enum"]){
        cellClass = [TYEnumTableViewCell class];
    } else if ([type isEqualToString:@"value"]){
        cellClass = [TYValueTableViewCell class];
    } else if ([type isEqualToString:@"string"]){
        cellClass = [TYStringTableViewCell class];
    }
    
    TYBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([cellClass class])];
    if (!cell) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.delegate = self;
    }
    [cell configureModel:schemaModel dps:dps];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
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
        _rightTitleItem = [[UIBarButtonItem alloc] initWithTitle:@"移除" style:UIBarButtonItemStylePlain target:self action:@selector(actionRemoveDevice:)];
    }
    return _rightTitleItem;
}
@end
