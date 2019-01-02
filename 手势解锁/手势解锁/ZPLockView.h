//
//  ZPLockView.h
//  手势解锁
//
//  Created by apple on 2016/10/28.
//  Copyright © 2016年 apple. All rights reserved.
//

//自定义View类。

#import <UIKit/UIKit.h>

@class ZPLockView;

@protocol ZPLockViewDelegate <NSObject>

@optional

- (void)lockView:(ZPLockView *)lockView didFinishPath:(NSString *)path;

@end

@interface ZPLockView : UIView

@property (nonatomic, weak) id <ZPLockViewDelegate> delegate;

@end
