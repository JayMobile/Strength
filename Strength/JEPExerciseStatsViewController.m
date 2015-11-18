//
//  JEPExerciseStatsViewController.m
//  Strength
//
//  Created by Julius Parishy on 11/16/15.
//  Copyright © 2015 Julius Parishy. All rights reserved.
//

#import "JEPExerciseStatsViewController.h"

@import Charts;

#import "JEPExercisesViewController.h"

NSString *const JEPExerciseStatsViewControllerStoryboardIdentifier = @"JEPExerciseStatsViewController";

@interface JEPExerciseStatsViewController ()

@property (nonatomic, weak) IBOutlet BarChartView *chartView;

@end

@implementation JEPExerciseStatsViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.entry.name;
    
    [self configureChart];
}

- (void)configureChart
{
    self.chartView.descriptionText = @"";
    
    ChartXAxis *xAxis = self.chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:12.0f];
    xAxis.drawGridLinesEnabled = NO;
    xAxis.spaceBetweenLabels = 2.0;
    
    ChartYAxis *leftAxis = self.chartView.leftAxis;
    leftAxis.labelFont = [UIFont systemFontOfSize:12.0f];
    leftAxis.labelCount = 8;
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.spaceTop = 0.15;
    
    [self initializeData];
}

- (void)initializeData
{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    NSMutableArray *yVals = [[NSMutableArray alloc] init];

    NSInteger i = 0;
    for(JEPExerciseSet *set in self.entry.allSets)
    {
        
        [xVals addObject:@""];
        [yVals addObject:[[BarChartDataEntry alloc] initWithValue:set.weightValue xIndex:i]];
        
        ++i;
    }
    
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithYVals:yVals label:NSLocalizedString(@"Weight", nil)];
    set1.barSpace = 0.35;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
    
    self.chartView.data = data;
}

@end
