//
//  ViewController.m
//  手势解锁
//
//  Created by apple on 2016/10/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "ZPLockView.h"

@interface ViewController () <ZPLockViewDelegate>

@property (weak, nonatomic) IBOutlet ZPLockView *lockView;

@end

@implementation ViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.lockView.delegate = self;
}

#pragma mark ————— ZPLockViewDelegate —————
-(void)lockView:(ZPLockView *)lockView didFinishPath:(NSString *)path
{
    NSLog(@"%@", path);
}

@end
