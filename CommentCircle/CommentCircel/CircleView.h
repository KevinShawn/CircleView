//
//  CircelView.h
//  CommentCircel
//
//  Created by Programmer Four on 15/7/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CircelViewDelegate <NSObject>

@optional
- (void)circleViewDidSelectComment:(NSString *)commment;

@end

@interface CircleView : UIView

@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIImageView *avatarImg;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, weak) id<CircelViewDelegate> delegate;
- (void)showCircle;
- (void)hideCircel;

@end
