//
//  ViewController.m
//  WeChat
//
//  Created by 袁艳祥 on 15/12/2.
//  Copyright © 2015年 袁艳祥. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // 做注销
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app logout];
    
}

@end
