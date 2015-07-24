//
//  CircleCell.m
//  CommentCircel
//
//  Created by Programmer Four on 15/7/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CircleCell.h"

@implementation CircleCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CircleCell" owner:self options:nil];
        self = [nibs firstObject];
        self.frame = frame;
    }
    return self;
}
- (IBAction)selectComment:(UITapGestureRecognizer *)sender {
    UILabel *label = (UILabel *)sender.view;
    if ([self.delegate respondsToSelector:@selector(circleCellDidSelectComment:)]) {
        [self.delegate circleCellDidSelectComment:label.text];
    }
}

@end
