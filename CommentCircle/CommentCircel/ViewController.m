//
//  ViewController.m
//  CommentCircel
//
//  Created by Programmer Four on 15/7/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import "CircleView.h"
#import "CircleCell.h"
#import "MSCircleView.h"

@interface ViewController ()<MSCircleViewDataSource, MSCircleViewDelegate>
@property (nonatomic, strong) CircleView *circleView;
@property (nonatomic, strong) NSArray *angles;

@property (nonatomic, strong) MSCircleView *msCircleView;

@end

@implementation ViewController

- (NSArray *)angles
{
    return  @[@[@(M_PI_2 / 3 * 4), @(M_PI_2 / 3 * 10)],
                        @[@(M_PI_4 / 3 ), @(M_PI_4 / 3 * 5), @(M_PI_2 / 3 * 7 )]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    CircleView *view = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
//    view.comments = @[@"文化氛围柔i", @"wlqihdoqiw", @"wiefoih", @"文化温柔i", @"文化氛围柔i"];
//    view.avatarImg.image = [UIImage imageNamed:@"1.jpg"];
//    view.center = CGPointMake(self.view.center.x, 200);
//    view.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:view];
//    self.circleView = view;
    MSCircleView *msCircle = [[MSCircleView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 200)
                                                                               andDataSource:self
                                                                                    andDelegate:self];
    self.msCircleView = msCircle;
    [self.view addSubview:msCircle];
}

- (CGFloat)circleView:(MSCircleView *)circleView itemAngleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.angles[indexPath.section][indexPath.row] floatValue];
}

- (NSInteger)circleView:(MSCircleView *)circleView numberOfItemInCircle:(NSInteger)circle
{
    return [self.angles[circle] count];
}


- (UIView *)circleView:(MSCircleView *)circleView viewForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    view.backgroundColor = [UIColor blueColor];
    view.layer.cornerRadius = view.frame.size.width / 2;
    view.layer.masksToBounds = YES;
    return view;
}

- (UIView *)centerViewForCircleView:(MSCircleView *)circleView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = [UIColor yellowColor];
    return view;
}

- (IBAction)show:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
//         [self.circleView showCircle];
        [self.msCircleView hideCircel];
    }
    else {
//        [self.circleView hideCircel];
        [self.msCircleView showCircle];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
