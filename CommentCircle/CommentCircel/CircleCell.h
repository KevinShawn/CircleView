//
//  CircleCell.h
//  CommentCircel
//
//  Created by Programmer Four on 15/7/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CircleCellDelegate <NSObject>

@optional
- (void)circleCellDidSelectComment:(NSString *)comment;

@end

@interface CircleCell : UIView
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, weak) id<CircleCellDelegate> delegate;

@end
