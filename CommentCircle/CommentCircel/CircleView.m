//
//  CircelView.m
//  CommentCircel
//
//  Created by Programmer Four on 15/7/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CircleView.h"
#import "UIViewExt.h"
#import "CircleCell.h"

#define Scale  ([UIScreen mainScreen].bounds.size.width / 414.0)
#define MaxWidth 120 * Scale
#define DefaultRadius 53 * Scale
#define DefaultCircleNum 3
#define DefaultRadiusChange 50 * Scale

#define DefaultSpace 15

@interface CircleView ()<CircleCellDelegate>
{
    CGPoint center;
}

// the number of Circel
// default is 2
@property (nonatomic) NSInteger circleNum;
@property (nonatomic) CGFloat   smallRadius;
@property (nonatomic) CGFloat   radiusChange;
@property (nonatomic, strong) NSArray *circleArray;
@property (nonatomic, strong) NSArray *labels;

@property (nonatomic, strong) NSMutableArray *seedArray;// 用来随机生成的

@end

@implementation CircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initValue];
        [self configureCircle];
        [self initAvatarInCenter];
        [self createFourLabel];
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
 *  中间头像
 */
- (void)initAvatarInCenter
{
    self.avatarImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DefaultRadius, DefaultRadius)];
    self.avatarImg.center = center;
    self.avatarImg.backgroundColor = [UIColor clearColor];
    self.avatarImg.layer.cornerRadius = DefaultRadius / 2;
    self.avatarImg.layer.masksToBounds = YES;
    self.avatarImg.layer.borderWidth = 1.3;
    self.avatarImg.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:self.avatarImg];
    [self.avatarImg.layer addAnimation:[self scaleAnimationWithFinalScale:1.1] forKey:@"Scale"];
}

/**
 *  浮动动画
 *
 *  @param scale 最后的比例
 *
 *  @return 动画
 */
- (CAAnimation*)scaleAnimationWithFinalScale:(float)scale
{
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnim.duration = 0.7;
    scaleAnim.repeatCount = HUGE_VALF;
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1.0)];
    scaleAnim.removedOnCompletion = NO;
    scaleAnim.autoreverses = YES;
    scaleAnim.fillMode = kCAFillModeForwards;
    return scaleAnim;
}

- (void)configureCircle
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 1; i <= self.circleNum; i++) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = [self circlePathWithRadius:self.smallRadius].CGPath;
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


- (void)createFourLabel
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        CircleCell *cell = [[CircleCell alloc] initWithFrame:CGRectMake(0,
                                                                        0,
                                                                        DefaultSpace,
                                                                        DefaultSpace)];
        cell.alpha = 0;
        cell.delegate = self;
        CGFloat fontSize;
        if (SCREEN_WIDTH > 320) {
            fontSize = 17;
        }
        else {
            fontSize = 15;
        }
        cell.label.font = [UIFont systemFontOfSize:fontSize];
        cell.layer.cornerRadius = 17;
        cell.layer.masksToBounds = YES;
        [self addSubview:cell];
        [array addObject:cell];
    }
    self.labels = [array copy];
}

- (void)setCellPositionWithCell:(CircleCell *)cell
                      withIndex:(NSInteger)i
                   withRotation:(CGFloat)rotationAngle
{
    CGFloat angle;
    if (i == 0) {
        cell.backgroundColor = UIColorFromRGB(0xff5b61);
        angle = M_PI_4 / 3 + rotationAngle;
        CGFloat outterRadius = self.smallRadius + 2 * self.radiusChange;
        cell.center = CGPointMake(outterRadius * cos(angle) + center.x,center.y - outterRadius * sin(angle));
        CGFloat offset = SCREEN_WIDTH - (cell.center.x + cell.size.width / 2);
        if (offset < 0) {
            cell.center = CGPointMake(outterRadius * cos(angle) + center.x + offset,
                                      center.y - outterRadius * sin(angle));
        }
    }
    else if (i == 1) {
        cell.backgroundColor = UIColorFromRGB(0xa871f1);
        angle = M_PI_4 / 3 * 5 + rotationAngle;
        CGFloat outterRadius = self.smallRadius + 2 * self.radiusChange;
        cell.center = CGPointMake(outterRadius * cos(angle) + center.x,center.y - outterRadius * sin(angle));
        CGFloat offset = cell.center.y - cell.size.width / 2;
        if (offset < 0) {
            angle = M_PI_4;
            cell.center = CGPointMake(outterRadius * cos(angle) + center.x,center.y - outterRadius * sin(angle));
        }
    }
    else if (i == 2) {
        cell.backgroundColor = UIColorFromRGB(0xffcf00);
        angle = M_PI_2 / 3 * 4 + rotationAngle;
        CGFloat outterRadius = self.smallRadius + self.radiusChange;
        cell.center = CGPointMake(outterRadius * cos(angle) + center.x,center.y - outterRadius * sin(angle));
    }
    else if (i == 3) {
        cell.backgroundColor = UIColorFromRGB(0x388dea);
        angle = M_PI_2 / 3 * 7 + rotationAngle;
        CGFloat outterRadius = self.smallRadius + 2 * self.radiusChange;
        cell.center = CGPointMake(outterRadius * cos(angle) + center.x,center.y - outterRadius * sin(angle));
        CGFloat offset = cell.center.x - cell.size.width / 2;
        if (offset < 0) {
            cell.center = CGPointMake(outterRadius * cos(angle) + center.x - offset,
                                      center.y - outterRadius * sin(angle));
        }
    }
    else {
        cell.backgroundColor = UIColorFromRGB(0x88e53f);
        angle = M_PI_2 / 3 * 10 + rotationAngle;
        CGFloat outterRadius = self.smallRadius + self.radiusChange;
        cell.center = CGPointMake(outterRadius * cos(angle) + center.x,center.y - outterRadius * sin(angle));
    }
}

- (void)setCellPositionWithCell:(CircleCell *)cell withIndex:(NSInteger)i
{
    [self setCellPositionWithCell:cell withIndex:i withRotation:0];
}

#pragma mark 显示和隐藏 逻辑

- (void)showCircle
{
    for (int i = 0; i < self.circleArray.count; i++) {
        CAShapeLayer *shapeLayer = self.circleArray[i];
        CABasicAnimation *animation = [self circleAnimationWithFinalRadius:self.radiusChange * (i + 1) + self.smallRadius];
        animation.duration = 0.75;
        [shapeLayer addAnimation:animation forKey:@"CirclePath"];
    }
    CGFloat angle = [self getRandomAngle];
    if (self.comments.count > 0) {
        self.seedArray = [self.comments mutableCopy];
        for (int i = 0; i < self.labels.count; i++) {
            CircleCell *cell = self.labels[i];
            NSString *content = [self setLabelValue];
            cell.label.text = content;
            cell.size = [self getCellSizeWithCell:cell];
            cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
            [UIView animateWithDuration:0.85 animations:^{
                cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
                cell.alpha = 1;
            }];
            [self setCellPositionWithCell:cell withIndex:i withRotation:angle];
        }
    }
}

- (CGSize)getCellSizeWithCell:(CircleCell *)cell
{
    cell.label.width = MaxWidth;
    [cell.label sizeToFit];
    CGSize labelSize = cell.label.size;
    return CGSizeMake(labelSize.width + DefaultSpace,
                      labelSize.height + DefaultSpace);
}

- (NSString *)setLabelValue
{
    if (self.seedArray.count == 0) {
        self.seedArray = [self.comments mutableCopy];
    }
    int x = arc4random() % self.seedArray.count;
    NSString *seed = self.seedArray[x];
    [self.seedArray removeObjectAtIndex:x];
    return seed;
}

- (CGFloat)getRandomAngle
{
    int x = arc4random() % 8;
    return x * M_PI_4 * 0.5;
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
        animation.fromValue = (__bridge id)([self circlePathWithRadius:self.radiusChange * (i + 1) + self.smallRadius].CGPath);
        [shapeLayer addAnimation:animation forKey:@"CirclePath"];
    }
    for (UILabel *label in self.labels) {
        label.alpha = 0;
    }
}

#pragma mark CircleCellDelegate

- (void)circleCellDidSelectComment:(NSString *)comment
{
    if ([self.delegate respondsToSelector:@selector(circleViewDidSelectComment:)]) {
        [self.delegate circleViewDidSelectComment:comment];
    }
}

@end
