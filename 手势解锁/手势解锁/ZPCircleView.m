//
//  ZPCircleView.m
//  手势解锁
//
//  Created by apple on 2016/10/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZPCircleView.h"

@implementation ZPCircleView

/**
 用代码的方式创建自定义控件类的时候，系统会首先调用这个方法，一般在此方法中会创建此自定义控件内的子控件（不设置尺寸）并做一些初始化的工作。
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        /**
         取消按钮的交互能力：
         在不做任何处理的情况下，不点击按钮的时候，按钮呈现的是正常状态(Normal)，点击按钮的时候，按钮呈现的是高亮状态(Highlighted)，点击按钮之后，按钮呈现的选中状态(Selected)。
         */
        self.userInteractionEnabled = NO;
        
        //设置正常状态下按钮的背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        
        //设置选中时的按钮的背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
    }
    
    return self;
}

@end
