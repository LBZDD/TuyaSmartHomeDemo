//
//  TYFamilyDetailViewController.m
//  TuyaSmartHomeDemo
//
//  Created by 林波 on 2021/4/25.
//

#import "TYFamilyDetailViewController.h"
#import "TYFamilyEditViewController.h"

@interface TYFamilyDetailViewController ()<UITableViewDelegate,UITableViewDataSource,TuyaSmartHomeDelegate>
// 编辑
@property (nonatomic, strong) UIBarButtonItem *rightTitleItem;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *deleteButton;

// 数据源
@property (nonatomic, strong) NSArray <TYTableViewSecionModel *>*dataSource;

@property (nonatomic, strong) TuyaSmartHome *home;

@end

@implementation TYFamilyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.home = [TuyaSmartHome homeWithHomeId:self.homeModel.homeId];
    self.home.delegate = self;
    [self configureView];
    [self configureData];
}

#pragma mark - action
- (void)actionEdit:(id)sender{
    TYFamilyEditViewController *editViewController = [[TYFamilyEditViewController alloc] init];
    editViewController.homeModel = self.homeModel;
    [self.navigationController pushViewController:editViewController animated:YES];
}

- (void)actionDelete:(id)sender{
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"解散家庭圈" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"解散" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.home dismissHomeWithSuccess:^{
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            NSString *errorStr = [NSString stringWithFormat:@"解散失败:%@",error.localizedDescription];
            [SVProgressHUD showErrorWithStatus:errorStr];
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    alertViewController.popoverPresentationController.sourceView = sender;
    [alertViewController addAction:action];
    [alertViewController addAction:cancelAction];
    [self.navigationController presentViewController:alertViewController animated:YES completion:nil];
}
#pragma mark - private method
- (void)configureData{
    
    TYTableViewItemModel *idItem = [TYTableViewItemModel itemModelWithTitle:@"家庭Id" subTitle:[NSString stringWithFormat:@"%lld",self.homeModel.homeId]];
    TYTableViewItemModel *roleItem = [TYTableViewItemModel itemModelWithTitle:@"角色" subTitle:[self roleString]];
    TYTableViewItemModel *nameItem = [TYTableViewItemModel itemModelWithTitle:@"家庭名称" subTitle:self.homeModel.name];
    TYTableViewItemModel *cityItem = [TYTableViewItemModel itemModelWithTitle:@"城市" subTitle:self.homeModel.geoName];
    if (self.homeModel.nickName) {
        TYTableViewItemModel *inviterItem = [TYTableViewItemModel itemModelWithTitle:@"邀请者" subTitle:self.homeModel.nickName];
        TYTableViewSecionModel *sectionModel = [TYTableViewSecionModel sectionModelWithTitle:@"" items:@[idItem,roleItem,nameItem,cityItem,inviterItem]];
        self.dataSource = @[sectionModel];
    } else {
        TYTableViewSecionModel *sectionModel = [TYTableViewSecionModel sectionModelWithTitle:@"" items:@[idItem,roleItem,nameItem,cityItem]];
        self.dataSource = @[sectionModel];
    }
        
    [self.tableView reloadData];
}

- (void)configureView{
    self.navigationItem.rightBarButtonItem = self.rightTitleItem;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(CGSizeZero);
    }];
}

- (NSString *)roleString{
    NSString *roleString = [NSString stringWithFormat:@"%@",@"未知"];
    switch (self.homeModel.role) {
        case TYHomeRoleType_Member:
            roleString = [NSString stringWithFormat:@"成员"];
            break;
        case TYHomeRoleType_Admin:
            roleString = [NSString stringWithFormat:@"管理员"];
            break;
        case TYHomeRoleType_Owner:
            roleString = [NSString stringWithFormat:@"创建者"];
            break;;
        default:
            break;
    }
    return roleString;
}

#pragma mark - TuyaSmartHomeDelegate
- (void)homeDidUpdateInfo:(TuyaSmartHome *)home{    
    @weakify(self)
    [self.home getHomeDetailWithSuccess:^(TuyaSmartHomeModel *homeModel) {
        @strongify(self)
        self.homeModel = homeModel;
        [self configureData];
    } failure:nil];
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
                
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
        [footView addSubview:self.deleteButton];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.centerX.equalTo(footView);
            make.left.equalTo(footView).offset(30.0f);
            make.height.mas_equalTo(40.0f);
        }];
        _tableView.tableFooterView = footView;
    }
    return _tableView;
}

- (UIBarButtonItem *)rightTitleItem {
    if (!_rightTitleItem) {
        _rightTitleItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(actionEdit:)];
    }
    return _rightTitleItem;
}

-(UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        _deleteButton.frame = CGRectZero;
        _deleteButton.layer.cornerRadius = 6.0f;
        _deleteButton.backgroundColor = [UIColor blueColor];
        [_deleteButton addTarget:self action:@selector(actionDelete:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

@end
