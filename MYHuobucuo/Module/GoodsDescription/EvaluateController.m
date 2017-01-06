//
//  EvaluateController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/17.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "EvaluateController.h"
#import "EvaluateTabHeader.h"
#import "EvaluateTabCell.h"
#import <Masonry.h>
#import "NetworkRequest.h"
#import "HDRefresh.h"

#define kPageSize 10

@interface EvaluateController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *evaListView;     // 评论列表

@property (nonatomic, strong) NSArray<EvaluateModel *> *dataList;

@property (nonatomic, assign) EvaluateType currType;

@property (nonatomic, assign) NSUInteger currPage;

@end

@implementation EvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.dataList) {
        
        self.goodsId = @"264";
        
        [self requestData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMoreEvaluate
{
    self.currPage++;
    
    [self requestDataWithType:self.currType page:self.currPage isRefresh:NO];
}

- (void)refreshData
{
    self.currPage = 1;
    
    self.dataList = nil;
    
    self.evaListView.mj_footer.state = MJRefreshStateIdle;
    
    [self requestDataWithType:self.currType page:self.currPage isRefresh:YES];
}

- (void)requestDataWithType:(EvaluateType)type page:(NSUInteger)page isRefresh:(BOOL)isRefresh
{
    __weak typeof(self) weakSelf = self;
    
    [NetworkManager getGoodsEvaluateWithGoodsId:self.goodsId page:self.currPage pageSize:kPageSize evaluateType:self.currType finishBlock:^(id jsonData, NSError *error) {
        
        [weakSelf.evaListView.mj_header endRefreshing];
        [weakSelf.evaListView.mj_footer endRefreshing];
        
        if (error) {
            DLog(@"%@",error.localizedDescription);
        }
        else {
            NSDictionary *jsonDict = (NSDictionary *)jsonData;
            
            NSDictionary *statusDict = jsonDict[@"status"];
            
            if (![statusDict[@"code"] isEqualToString:kStatusSuccessCode]) {
                
                [MYProgressHUD showAlertWithMessage:statusDict[@"msg"]];
            }
            else {
                
                NSDictionary *jsonDict = (NSDictionary *)jsonData;
                
                NSDictionary *statusDict = jsonDict[@"status"];
                
                if (![statusDict[@"code"] isEqualToString:kStatusSuccessCode]) {
                    
                    [MYProgressHUD showAlertWithMessage:statusDict[@"msg"]];
                }
                else {
                    
                    NSDictionary *evaDict = jsonDict[@"data"];
                    
                    NSArray *evaArray = evaDict[@"lists"];
                    
                    if (evaArray.count < kPageSize) {
                        
                        weakSelf.evaListView.mj_footer.state = MJRefreshStateNoMoreData;
                    }
                    
                    if (evaArray.count > 0) {
                        
                        NSMutableArray *mEvaArray;
                        
                        if (weakSelf.currPage > 1) {
                            
                            mEvaArray = [NSMutableArray arrayWithArray:weakSelf.dataList];
                        }
                        else {
                            
                            mEvaArray = [NSMutableArray arrayWithCapacity:evaArray.count];
                        }
                        
                        for (NSDictionary *dict in evaArray) {
                            
                            EvaluateModel *evaModel = [[EvaluateModel alloc] init];
                            
                            [evaModel setValueWithDict:dict];
                            
                            [mEvaArray addObject:evaModel];
                        }
                        
                        weakSelf.dataList = [mEvaArray copy];
                        
                        [weakSelf.evaListView reloadData];
                    }
                }
            }
        }
    }];
}

- (void)requestData
{
    self.currType = EvaluateType_All;
    
    [self refreshData];
}

- (void)initUI
{
    // header
    EvaluateTabHeader *header = [[EvaluateTabHeader alloc] init];

    __weak typeof(self) weakSelf = self;

    header.buttonBlock = ^(EvaluateType tag) {

        weakSelf.currType = tag;

        [weakSelf refreshData];
    };
    
    [self.view addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(1);
        make.height.mas_equalTo(fScreen(110));
    }];
    
    // tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    
    tableView.mj_header = [RefreshHeader headerWithTitle:@"下拉刷新评论" freshingTitle:@"玩命加载中..." freshBlock:^{
        
        [weakSelf refreshData];
    }];
    
    tableView.mj_footer = [RefreshFooter footerWithTitle:@"上拉加载更多评论" uploadingTitle:@"玩命加载中..." noMoreTitle:@"木有更多啦~" uploadBlock:^{
        
        [weakSelf loadMoreEvaluate];
    }];
    
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(header.mas_bottom).offset(1);
        make.bottom.equalTo(self.view.mas_bottom).offset(-fScreen(112));
    }];
    
    self.evaListView = tableView;
}

#pragma mark - tableView dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvaluateTabCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (!cell) {
        cell = [[EvaluateTabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    
    EvaluateModel *model = (EvaluateModel *)[self.dataList objectAtIndex:indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvaluateModel *model = (EvaluateModel *)[self.dataList objectAtIndex:indexPath.row];
    return model.rowHeight;
}

@end
