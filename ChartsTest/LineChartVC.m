//
//  LineChartVC.m
//  TestPods
//
//  Created by 孙宛宛 on 2018/12/6.
//  Copyright © 2018年 孙宛宛. All rights reserved.
//

#import "LineChartVC.h"
#import "ChartsTest-Bridging-Header.h"
#import "ChartsTest-Swift.h"
#import "Masonry.h"

#define UIColorFromHEXA(hex,a) [UIColor colorWithRed:((hex & 0xFF0000) >> 16) / 255.0f green:((hex & 0xFF00) >> 8) / 255.0f blue:(hex & 0xFF) / 255.0f alpha:a]
#define BtnBgColor    UIColorFromHEXA(0x00bcac,1.0)

#define kSpaceToLeftOrRight 15

#define iPhoneX ([UIScreen instanceMethodForSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(1125,2436),[[UIScreen mainScreen] currentMode].size):NO)
#define  kNavigationHeight (iPhoneX ? 88.0f : 64.f)

@interface LineChartVC ()<ChartViewDelegate>

@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UILabel *descLab;
@property (nonatomic, strong) LineChartView *lineChartView;

@end

@implementation LineChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"折线图";
    
    [self setUI];
    
    [self setLineChartWithXData:@[@"9:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00"] yData:@[@"47",@"49",@"46",@"51",@"45",@"43"]];
}

#pragma mark - privateMethod

- (void)setLineChartWithXData:(NSArray *)xData yData:(NSArray *)yData
{
    if (xData.count > 0)
    {
        //对应Y轴上面需要显示的数据
        NSMutableArray *yVals = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < yData.count; i++)
        {
            ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:[xData[i] doubleValue] y:[yData[i] doubleValue]];
            [yVals addObject:entry];
            
            if (i == yData.count - 1)
            {
                self.contentLab.text = [NSString stringWithFormat:@"%g℃",entry.y];
            }
        }
        
        // 设置折线的样式
        LineChartDataSet *set1 = [[LineChartDataSet alloc]initWithValues:yVals label:nil];
        set1.lineWidth = 1.0f;       // 折线宽度
        [set1 setColor:BtnBgColor];  // 折线颜色
        set1.drawValuesEnabled = NO; // 是否在拐点处显示数据
        
        // 折线拐点样式
        set1.drawCirclesEnabled = YES;      // 是否绘制拐点
        set1.drawFilledEnabled = NO;        // 是否填充颜色
        [set1 setCircleColor:BtnBgColor];   // 拐点 圆的颜色
        set1.circleRadius = 5.0f;
        set1.highlightColor = [UIColor clearColor];
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.0f]]; // 文字字体
        [data setValueTextColor:[UIColor blackColor]];                               // 文字颜色
        
        _lineChartView.data = data;
        
        [_lineChartView highlightValue: [[ChartHighlight alloc] initWithX:[xData[xData.count - 1] doubleValue] y:[yData[yData.count - 1] doubleValue] dataSetIndex:0 dataIndex:0]];
    }
}

- (void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight
{
    NSLog(@"---chartValueSelected---value: %g", entry.x);
    
    self.contentLab.text = [NSString stringWithFormat:@"%g℃",entry.y];
}

#pragma mark - setUI

- (void)setUI
{
    [self.view addSubview:self.contentLab];
    [self.view addSubview:self.descLab];
    [self.view addSubview:self.lineChartView];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(kNavigationHeight + kSpaceToLeftOrRight);
        make.left.mas_offset(25);
        make.height.mas_offset(30);
    }];
    
    [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLab.mas_bottom).mas_offset(8);
        make.left.mas_equalTo(self.contentLab.mas_left);
        make.height.mas_offset(16);
    }];
    
    [self.lineChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kSpaceToLeftOrRight);
        make.right.mas_offset(-kSpaceToLeftOrRight);
        make.top.mas_equalTo(self.descLab.mas_bottom).mas_offset(10);
        make.height.mas_offset(240);
    }];
}

#pragma mark - getter

- (UILabel *)contentLab
{
    if (!_contentLab)
    {
        _contentLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLab.backgroundColor = [UIColor clearColor];
        _contentLab.textAlignment = NSTextAlignmentLeft;
        _contentLab.textColor = UIColorFromHEXA(0x3c4355,1.0);
        _contentLab.font = [UIFont systemFontOfSize:24];
    }
    return _contentLab;
}

- (UILabel *)descLab
{
    if(!_descLab)
    {
        _descLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLab.backgroundColor = [UIColor clearColor];
        _descLab.textAlignment = NSTextAlignmentLeft;
        _descLab.textColor = UIColorFromHEXA(0xa7b0c2,1.0);
        _descLab.font = [UIFont systemFontOfSize:13];
        _descLab.text = @"当前温度";
    }
    return _descLab;
}

- (LineChartView *)lineChartView
{
    if (!_lineChartView)
    {
        _lineChartView = [[LineChartView alloc] init];
        _lineChartView.backgroundColor =  [UIColor whiteColor];
        _lineChartView.chartDescription.enabled = YES;
        _lineChartView.delegate = self;
        
        _lineChartView.scaleYEnabled = YES;         // 取消Y轴缩放
        _lineChartView.scaleXEnabled = NO;          // 取消X轴缩放
        _lineChartView.doubleTapToZoomEnabled = NO; // 取消双击缩放
        _lineChartView.dragEnabled = NO;            // 关闭拖拽图标
        _lineChartView.legend.enabled = NO;         // 关闭图例显示
        [_lineChartView setExtraOffsetsWithLeft:13 top:20 right:40 bottom:0];
        
        // 绘制
        _lineChartView.rightAxis.enabled = NO;          // 绘制右边轴
        _lineChartView.leftAxis.enabled = NO;           // 绘制左边轴
        
        // Y轴设置
        ChartYAxis *leftAxis = _lineChartView.leftAxis;
        [leftAxis setXOffset:15.0f];
        
        leftAxis.forceLabelsEnabled = YES;  // 强制绘制指定数量的label
        leftAxis.labelCount = 8;
        
        leftAxis.gridColor = [UIColor clearColor]; // 网格线颜色
        leftAxis.gridAntialiasEnabled = YES;       // 开启抗锯齿
        leftAxis.inverted = NO;                    // 是否将Y轴进行上下翻转
        
        // X轴设置
        ChartXAxis *xAxis = _lineChartView.xAxis;
        xAxis.labelPosition = XAxisLabelPositionBottom; // 设置x轴数据在底部
        xAxis.axisLineColor = [UIColor clearColor];     // X轴颜色
        xAxis.granularityEnabled = YES;                 // 设置重复的值不显示
        xAxis.gridColor = [UIColor clearColor];
        
        xAxis.labelTextColor =  UIColorFromHEXA(0xa7b0c2,1.0);    // 文字颜色
        NSNumberFormatter *xAxisFormatter = [[NSNumberFormatter alloc] init];
        xAxisFormatter.positiveSuffix = @":00";
        xAxisFormatter.positivePrefix = @"|";
        xAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:xAxisFormatter];
        
        // 能够显示的数据数量
        _lineChartView.maxVisibleCount = 999;
        
        // 展现动画
        [_lineChartView animateWithYAxisDuration:0.75f];
        
        // 设置选中时气泡
        XYMarkerView *marker = [[XYMarkerView alloc] initWithColor:UIColorFromHEXA(0x00bcac,1.0) font:[UIFont systemFontOfSize:12.0]  textColor:UIColor.whiteColor insets:UIEdgeInsetsMake(3, 3, 16.0, 3) xAxisValueFormatter:_lineChartView.xAxis.valueFormatter];
        marker.chartView = _lineChartView;
        marker.minimumSize = CGSizeMake(30.0f, 15.0f);
        _lineChartView.marker = marker;
    }
    return _lineChartView;
}


@end
