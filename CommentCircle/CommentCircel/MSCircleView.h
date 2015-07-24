//
//  MSCircleView.h
//  CommentCircel
//
//  Created by Programmer Four on 15/7/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSCircleView;

@protocol MSCircleViewDelegate <NSObject>

@optional
/**
 *  圆之间的半径差
 *
 *  @return 默认50
 */
- (CGFloat)radiusChangeBetweenCircles;

/**
 *  点击选中
 *
 *  @param circleView 当前的circleView
 *  @param indexPath  indexPath
 */
- (void)circleView:(MSCircleView *)circleView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol MSCircleViewDataSource <NSObject>

@required

/**
 *  cell所在的位置
 *
 *  @param circleView 当前的circleView
 *  @param indexPath  所处的位置
 *
 *  @return cell所在的角度
 */
- (CGFloat)circleView:(MSCircleView *)circleView itemAngleForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  圈上有多少个cell
 *
 *  @param circleView 当前的circleView
 *  @param circle     第几个circle
 *
 *  @return cell个数
 */
- (NSInteger)circleView:(MSCircleView *)circleView numberOfItemInCircle:(NSInteger)circle;

/**
 *  cell的设计
 *
 *  @param circleView 当前的circleView
 *  @param indexPath  indexPath
 *
 *  @return view
 */
- (UIView *)circleView:(MSCircleView *)circleView viewForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
/**
 *  中间的view
 *  @return 中间的view
 */
- (UIView *)centerViewForCircleView:(MSCircleView *)circleView;
/**
 *  画多少个圈
 *  @return 圈数 默认1圈
 */
- (NSInteger)numberOfCirclesInCircleView:(MSCircleView *)circleView;
/**
 *  中间的view的动画时间
 *
 *  @return 默认0 如果传0 没有动画
 */
- (NSTimeInterval)circleViewCenterAnimationDuration;
@end

@interface MSCircleView : UIView
- (instancetype)initWithFrame:(CGRect)frame
                        andDataSource:(id<MSCircleViewDataSource>)dataSource
                             andDelegate:(id<MSCircleViewDelegate>)delegate;

// Default is 23
@property (nonatomic) CGFloat   smallRadius;
// Defalut is 50
@property (nonatomic) CGFloat   radiusChange;
// Default is  [UIColor groupTableViewBackgroundColor]
@property (nonatomic, strong) UIColor *borderColor;

- (void)showCircle;
- (void)hideCircel;

- (void)reloadCircleView;

@end
