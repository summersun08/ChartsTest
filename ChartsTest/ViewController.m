//
//  ViewController.m
//  ChartsTest
//
//  Created by 孙宛宛 on 2018/12/6.
//  Copyright © 2018年 wanwan. All rights reserved.
//

#import "ViewController.h"
#import "LineChartVC.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTable;

@property (nonatomic, strong) NSArray *titleArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Charts";
    
    self.titleArr = @[@"折线图",@"K线图",@"柱状图",@"饼状图"];
    
    [self.view addSubview:self.mainTable];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.textColor = [UIColor blueColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    cell.textLabel.text = self.titleArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        LineChartVC *vc = [[LineChartVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - getter

- (UITableView *)mainTable
{
    if (!_mainTable)
    {
        _mainTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.backgroundColor = [UIColor clearColor];
        _mainTable.showsVerticalScrollIndicator = NO;
    }
    return _mainTable;
}


@end
