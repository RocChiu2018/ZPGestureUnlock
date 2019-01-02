//
//  ZPLockView.m
//  手势解锁
//
//  Created by apple on 2016/10/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZPLockView.h"
#import "ZPCircleView.h"

@interface ZPLockView()

@property (nonatomic, strong) NSMutableArray *selectedButtonsMutableArray;  //存放选中按钮的数组
@property (nonatomic, assign) CGPoint currentMovePoint;  //没摸到按钮的时候手指所在的点

@end

@implementation ZPLockView

#pragma mark ————— 懒加载 —————
- (NSMutableArray *)selectedButtonsMutableArray
{
    if (_selectedButtonsMutableArray == nil)
    {
        _selectedButtonsMutableArray = [NSMutableArray array];
    }
    
    return _selectedButtonsMutableArray;
}

/**
 用xib文件创建自定义控件的时候，系统首先会调用"initWithCoder:"方法，但是在此方法中不能使用连线的属性（子控件），因此在此方法中不能做任何事情。然后会调用这个方法，在此方法中可以使用连线的属性（子控件）了，一般在此方法中做一些子控件的初始化工作，但不设置子控件的尺寸。
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    for (int index = 0; index < 9; index++)
    {
        //创建按钮（代码创建按钮，必然会调用ZPCircleView类里面的initWithFrame方法进行创建）
        ZPCircleView *button = [ZPCircleView buttonWithType:UIButtonTypeCustom];
        
        button.tag = index;
        
        //添加按钮
        [self addSubview:button];
    }
}

/**
 用xib文件创建自定义控件的时候，当系统调用完"initWithCoder:"和"awakeFromNib"方法以后，就会调用这个方法，在此方法中设置此自定义控件内的子控件的尺寸；
 此方法在消息循环结束的时候调用。
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int index = 0; index < self.subviews.count; index++)
    {
        //取出按钮
        ZPCircleView *button = [self.subviews objectAtIndex:index];
        
        //设置button的frame
        CGFloat buttonWidth = 74;
        CGFloat buttonHeight = 74;
        
        int totalColumn = 3;
        int column = index % totalColumn;
        int row = index / totalColumn;
        
        CGFloat marginX = (self.frame.size.width - totalColumn * buttonWidth) / (totalColumn + 1);
        CGFloat marginY = marginX;
        
        CGFloat buttonX = marginX + column * (buttonWidth + marginX);
        CGFloat buttonY = row * (buttonHeight + marginY);
        button.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
    }
}

#pragma mark ————— 手指点击屏幕 —————
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //把按钮之外的最后一个位置点清空（设为0）
    self.currentMovePoint = CGPointZero;
    
    //获得对应的触摸点的位置
    CGPoint point = [self pointWithTouches:touches];
    
    //获得触摸的按钮
    ZPCircleView *button = [self buttonWithPoint:point];
    
    //设置按钮是否被选中（按钮存在并且按钮没有添加到过数组中）
    if (button && [self.selectedButtonsMutableArray containsObject:button] == NO)
    {
        button.selected = YES;
        [self.selectedButtonsMutableArray addObject:button];
    }
    
    //重绘
    [self setNeedsLayout];
}

#pragma mark ————— 手指在屏幕上拖动 —————
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [self pointWithTouches:touches];
    
    ZPCircleView *button = [self buttonWithPoint:point];
    
    if (button && [self.selectedButtonsMutableArray containsObject:button] == NO)  //摸到了按钮
    {
        button.selected = YES;
        [self.selectedButtonsMutableArray addObject:button];
    }else  //没有摸到按钮
    {
        self.currentMovePoint = point;
    }
    
    [self setNeedsDisplay];
}

#pragma mark ————— 手指离开屏幕 —————
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(lockView:didFinishPath:)])
    {
        NSMutableString *string = [NSMutableString string];
        for (ZPCircleView *button in self.selectedButtonsMutableArray)
        {
            [string appendFormat:@"%ld", (long)button.tag];
        }
        
        [self.delegate lockView:self didFinishPath:string];
    }
    
    //把所有选中的按钮都设为普通状态
    for (ZPCircleView *button in self.selectedButtonsMutableArray)
    {
        [button setSelected:NO];
    }
    
    //清空数组
    [self.selectedButtonsMutableArray removeAllObjects];
    
    [self setNeedsDisplay];
}

#pragma mark ————— 根据touches集合获得对应点的触摸的位置 —————
-(CGPoint)pointWithTouches:(NSSet<UITouch *> *)touches
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:touch.view];
    
    return point;
}

#pragma mark ————— 根据触摸点位置获得对应的按钮 —————
-(ZPCircleView *)buttonWithPoint:(CGPoint)point
{
    for (ZPCircleView *button in self.subviews)
    {
        CGFloat wh = 24;
        CGFloat frameX = button.center.x - wh * 0.5;
        CGFloat frameY = button.center.y - wh * 0.5;
        if (CGRectContainsPoint(CGRectMake(frameX, frameY, wh, wh), point))  //判断point这个点是否在button.frame这个矩形框的范围内
        {
            return button;
        }
    }
    
    return nil;
}

#pragma mark ————— 重绘 —————
-(void)drawRect:(CGRect)rect
{
    //判断数组里面的元素为零的时候就不运行下面的代码了，直接返回，节省运行成本
    if (self.selectedButtonsMutableArray.count == 0)
    {
        return;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //遍历数组中所有的按钮
    for (int index = 0; index < self.selectedButtonsMutableArray.count; index++)
    {
        ZPCircleView *button = [self.selectedButtonsMutableArray objectAtIndex:index];
        
        if (index == 0)
        {
            [path moveToPoint:button.center];
        }else
        {
            [path addLineToPoint:button.center];
        }
    }
    
    //for循环中线已经连接到了最后一个选中的按钮，所以path可以从最后一个选中的按钮连接按钮范围之外的最后一个位置点了。
    if (CGPointEqualToPoint(self.currentMovePoint, CGPointZero) == NO)
    {
        [path addLineToPoint:self.currentMovePoint];
    }
    
    //绘图
    path.lineWidth = 8;
    path.lineJoinStyle = kCGLineJoinBevel;
    [[UIColor colorWithRed:32/255.0 green:210/255.0 blue:254/255.0 alpha:0.5] set];
    [path stroke];
}

@end
