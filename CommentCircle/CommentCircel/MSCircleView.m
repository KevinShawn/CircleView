//
//  MSCircleView.m
//  CommentCircel
//
//  Created by Programmer Four on 15/7/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MSCircleView.h"
#import "UIViewExt.h"

#define Scale  ([UIScreen mainScreen].bounds.size.width / 414.0)
#define MaxWidth 120 * Scale
#define DefaultRadius 55 * Scale
#define DefaultCircleNum 2
#define DefaultRadiusChange 50 * Scale
#define DefaultSpace 15

@interface MSCircleView()
{
    CGPoint center;
}
// the number of Circel
// default is 2
@property (nonatomic) NSInteger circleNum;
@property (nonatomic, strong) NSArray *circleArray;
@property (nonatomic, strong) NSMutableArray *circleCells;
@property (nonatomic, strong) NSMutableArray *seedArray;// 用来随机生成的
@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, weak) id<MSCircleViewDelegate>delegate;
@property (nonatomic, weak) id<MSCircleViewDataSource>datasource;

@end

@implementation MSCircleView

- (instancetype)initWithFrame:(CGRect)frame
                        andDataSource:(id<MSCircleViewDataSource>)dataSource
                             andDelegate:(id<MSCircleViewDelegate>)delegate
{
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        self.datasource = dataSource;
        [self initValue];
        [self configureCircle];
        [self initAvatarInCenter];
        [self configureCells];
    }
    return self;
}

- (NSMutableArray *)seedArray
{
    if (!_seedArray) {
        _seedArray = [[NSMutableArray alloc] init];
    }
    return _seedArray;
}

- (NSMutableArray *)circleCells
{
    if (!_circleCells) {
        _circleCells = [[NSMutableArray alloc] init];
    }
    return _circleCells;
}

/**
 *  初始化一些值
 */
- (void)initValue
{
    _radiusChange = DefaultRadiusChange;
    _circleNum = DefaultCircleNum;
    _smallRadius = DefaultRadius / 2;
    center = self.center;
    _borderColor = [UIColor groupTableViewBackgroundColor];
}

/**
 *  画圆
 */
- (void)configureCircle
{
    if ([self.datasource respondsToSelector:@selector(numberOfCirclesInCircleView:)]) {
        self.circleNum = [self.datasource numberOfCirclesInCircleView:self];
    }
    if ([self.delegate respondsToSelector:@selector(radiusChangeBetweenCircles)]) {
        self.radiusChange = [self.delegate radiusChangeBetweenCircles];
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 1; i <= self.circleNum; i++) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = [self circlePathWithRadius:self.smallRadius + i * self.radiusChange].CGPath;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = self.borderColor.CGColor;
        shapeLayer.lineWidth = 0.5;
        shapeLayer.opacity = 1;
        [self.layer addSublayer:shapeLayer];
        [array addObject:shapeLayer];
    }
    self.circleArray = [array copy];
}

- (UIBezierPath *)circlePathWithRadius:(CGFloat)radius
{
    CGRect rect = CGRectMake(0, 0, 2 * radius, 2 * radius);
    rect = CGRectMoveToCenter(rect, center);
    UIBezierPath *beizerPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    return beizerPath;
}

/**
 *  中间头像
 */
- (void)initAvatarInCenter
{
    if ([self.datasource respondsToSelector:@selector(centerViewForCircleView:)]) {
        self.centerView = [self.datasource centerViewForCircleView:self];
    }
    if (self.centerView == nil) {
        return;
    }
    else {
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.strokeColor = [UIColor whiteColor].CGColor;
        CGFloat x = self.centerView.bounds.size.width / 2;
        CGFloat y = self.centerView.bounds.size.height / 2;
        CGRect rect = CGRectMake(x - self.smallRadius,
                                 y - self.smallRadius,
                                 2 * self.smallRadius,
                                 2 * self.smallRadius);
        UIBezierPath *beizerPath = [UIBezierPath bezierPathWithOvalInRect:rect];
        maskLayer.lineWidth = 1;
        maskLayer.fillColor = [UIColor blackColor].CGColor;
        maskLayer.path = beizerPath.CGPath;
        
        self.centerView.center = center;
        self.centerView.layer.borderWidth = 1;
        self.centerView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.centerView.layer.mask = maskLayer;
        [self addSubview:self.centerView];
        if ([self.datasource respondsToSelector:@selector(circleViewCenterAnimationDuration)]) {
            NSTimeInterval interval = [self.datasource circleViewCenterAnimationDuration];
            [self.centerView.layer addAnimation:[self scaleAnimationWithFinalScale:1.1 withDuration:interval]
                                         forKey:@"Scale"];
        }
    }
}

/**
 *  浮动动画
 *
 *  @param scale 最后的比例
 *
 *  @return 动画
 */
- (CAAnimation*)scaleAnimationWithFinalScale:(float)scale
                                withDuration:(NSTimeInterval)interval
{
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnim.duration = interval;
    scaleAnim.repeatCount = HUGE_VALF;
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1.0)];
    scaleAnim.removedOnCompletion = NO;
    scaleAnim.autoreverses = YES;
    scaleAnim.fillMode = kCAFillModeForwards;
    return scaleAnim;
}

- (void)configureCells
{
    for (int section = 0; section < self.circleNum; section++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSInteger rowCount = [self.datasource circleView:self
                               numberOfItemInCircle:section];
        for (int row = 0; row < rowCount; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            UIView *view = [self.datasource circleView:self
                                 viewForRowAtIndexPath:indexPath];
            CGFloat angle = [self.datasource circleView:self
                             itemAngleForRowAtIndexPath:indexPath];
            [self setCellPositionWithCell:view
                            withIndexPath:indexPath
                             withRotation:angle];
            [self addSubview:view];
            [array addObject:view];
        }
        [self.circleCells addObject:array];
    }
}

// 设置view的位置
- (void)setCellPositionWithCell:(UIView *)cell
                  withIndexPath:(NSIndexPath *)indexPath
                   withRotation:(CGFloat)angle
{
    CGFloat outterRadius = self.smallRadius + (indexPath.section + 1) * self.radiusChange;
    cell.center = CGPointMake(outterRadius * cos(angle) + center.x,center.y - outterRadius * sin(angle));
}

- (void)showCircle
{
    for (int i = 0; i < self.circleArray.count; i++) {
        CAShapeLayer *shapeLayer = self.circleArray[i];
        CABasicAnimation *animation = [self circleAnimationWithFinalRadius:self.radiusChange * (i + 1) + self.smallRadius];
        animation.fromValue = (__bridge id)([self circlePathWithRadius:self.smallRadius].CGPath);
        animation.duration = 0.55;
        [shapeLayer addAnimation:animation forKey:@"CirclePath"];
    }
    for (int section = 0; section < self.circleCells.count; section++) {
        NSArray *rowArray = self.circleCells[section];
        for (int row = 0; row < rowArray.count; row++) {
            UIView *view = rowArray[row];
            view.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
            [UIView animateWithDuration:0.85 animations:^{
                view.layer.transform = CATransform3DMakeScale(1, 1, 1);
                view.alpha = 1;
            }];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            [self setCellPositionWithCell:view withIndexPath:indexPath withRotation:[self.datasource circleView:self itemAngleForRowAtIndexPath:indexPath]];
        }
    }
}

- (CABasicAnimation *)circleAnimationWithFinalRadius:(CGFloat)radius
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.toValue = (__bridge id)([self circlePathWithRadius:radius].CGPath);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

- (void)hideCircel
{
    for (int i = 0; i < self.circleArray.count; i++) {
        CAShapeLayer *shapeLayer = self.circleArray[i];
        CABasicAnimation *animation = [self circleAnimationWithFinalRadius: self.smallRadius];
        animation.duration = 0.55;
        animation.fromValue = (__bridge id)([self circlePathWithRadius:self.radiusChange * (i + 1) + self.smallRadius].CGPath);
        [shapeLayer addAnimation:animation forKey:@"CirclePath"];
    }
    for (int section = 0; section < self.circleCells.count; section++) {
        NSArray *rowArray = self.circleCells[section];
        for (int row = 0; row < rowArray.count; row++) {
            UIView *view = rowArray[row];
            view.alpha = 0;
        }
    }

}


@end
