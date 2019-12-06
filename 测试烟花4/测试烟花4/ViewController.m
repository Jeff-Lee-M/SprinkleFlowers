//
//  ViewController.m
//  测试烟花4
//
//  Created by 518MW on 2019/12/3.
//  Copyright © 2019 518MW. All rights reserved.
//

#import "ViewController.h"
#import "AnimationTool.h"

@interface ViewController ()
@property(nonatomic,strong)AnimationTool *animateTool;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.animateTool showWithView:self.view];
}

- (AnimationTool *)animateTool {
    if (!_animateTool) {
        _animateTool = [AnimationTool new];
    }
    return _animateTool;
}

@end
