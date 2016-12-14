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

@interface EvaluateController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *evaListView;     // 评论列表
@property (nonatomic, strong) NSArray *dataList;

@end

@implementation EvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];

    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData
{
    NSInteger count = 21;
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:count];
    for (NSInteger index = 0; index < count; index++) {
        EvaluateModel *model = [[EvaluateModel alloc] init];
        model.userName = @"厦门吴彦祖";
        model.starNumber = index%5 + 1;
        model.contentText = @"今天去医院体检要查大便, 我看小护士挺漂亮, 于是就想到逗她一下。跑门口买了一个烤红署, 捏成泥放在了大便盒里,护士说太多了, 喊处理一下, 我说, 不用麻烦了, 说完用手拿着就吃, 小护士连口罩都来不及摘, 当场吐了三个。这时旁边的人拍了拍我的肩膀：兄弟你拿错了, 这盒才是你的!------";
        model.time = @"2016-06-12 07:15";
        if (index != 3) {
            if (index%3 == 0) {
                model.photoArray = @[@"http://img4.duitang.com/uploads/item/201502/28/20150228131257_LGRFB.thumb.224_0.jpeg", @"http://www.qqtu8.net/f/20151218194626_1.jpg"];
            }
            else if (index%5 == 0) {
                model.photoArray = @[];
            }
            else {
                model.photoArray = @[@"http://img4.duitang.com/uploads/item/201307/30/20130730215610_8Tnmr.jpeg", @"http://img4.duitang.com/uploads/item/201502/28/20150228131257_LGRFB.thumb.224_0.jpeg", @"http://www.qqtu8.net/f/20151218194626_1.jpg"];
            }
            
        }
        [tmpArray addObject:model];
    }
    self.dataList = [tmpArray copy];
}

- (void)initUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(1);
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return fScreen(110);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    EvaluateTabHeader *header = [[EvaluateTabHeader alloc] init];
    return header;
}

@end
