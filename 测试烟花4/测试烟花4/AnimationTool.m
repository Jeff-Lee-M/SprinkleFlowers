//
//  AnimationTool.m
//  测试烟花4
//
//  Created by 518MW on 2019/12/3.
//  Copyright © 2019 518MW. All rights reserved.
//

#import "AnimationTool.h"
#import "WinnerView.h"

//图片
static NSString *const kImageName1 = @"yezi";
static NSString *const kImageName2 = @"yellow_flower";
static NSString *const kImageName3 = @"siyecao";
static NSString *const kImageName4 = @"red_flower";

//中奖视图的位置
static const CGFloat kWinnerX = 50.0;
static const CGFloat kWinnerHeight = 50.0;
#define kWinnerY view.bounds.size.height / 4
#define kWinnerWidth (view.bounds.size.width - kWinnerX *2)

//动画时间
static const CGFloat kWinnerAnimationDuration = 0.4;
//static const CGFloat kWinnerStayTime = 4.0;

//刚开始每个burst发射出花花的个数
static const CGFloat kBirthRate = 35.0;


@interface AnimationTool ()

@property (nonatomic, strong) CAEmitterLayer *emitterLayer;
///中奖者视图
@property (nonatomic, strong) WinnerView *winnerView;
///正在执行动画
@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation AnimationTool

- (void)showWithView:(UIView *)view {
    if (self.isAnimating) return;
    self.isAnimating = YES;
    
    [self showWinnerView:view];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kWinnerAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        #pragma mark 创建粒子layer  开始粒子效果
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.emitterLayer = [strongSelf createEmitterLayerFrom:view];
        [strongSelf startAnimate:strongSelf.emitterLayer];
    });
}

- (void)showWinnerView:(UIView *)view {
    if (!_winnerView) {
        _winnerView = [WinnerView new];
        [view addSubview:_winnerView];
        _winnerView.frame = CGRectMake(view.bounds.size.width + kWinnerWidth, kWinnerY,  kWinnerWidth, kWinnerHeight);
        _winnerView.layer.cornerRadius = kWinnerHeight / 2.0;
        _winnerView.clipsToBounds = YES;
    }
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kWinnerAnimationDuration animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.winnerView.frame = CGRectMake(kWinnerX, kWinnerY, kWinnerWidth, kWinnerHeight);
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:kWinnerAnimationDuration animations:^{
                strongSelf.winnerView.frame = CGRectMake(-kWinnerWidth, kWinnerY, kWinnerWidth, kWinnerHeight);
            } completion:^(BOOL finished) {
                [strongSelf.winnerView removeFromSuperview];
                strongSelf.winnerView = nil;
                self.isAnimating = NO;
            }];
        });
    }];
}

- (CAEmitterLayer *)createEmitterLayerFrom:(UIView *)view {
    //粒子  yellow_flower  siyecao  red_flower
    CAEmitterCell *subCell1 = [self createSubcell:[UIImage imageNamed:kImageName1]];
    subCell1.name = kImageName1;
    CAEmitterCell *subCell2 = [self createSubcell:[UIImage imageNamed:kImageName2]];
    subCell2.name = kImageName2;
    CAEmitterCell *subCell3 = [self createSubcell:[UIImage imageNamed:kImageName3]];
    subCell3.name = kImageName3;
    CAEmitterCell *subCell4 = [self createSubcell:[UIImage imageNamed:kImageName4]];
    subCell4.name = kImageName4;
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    
#pragma mark 发射点位置 及 发射区域
//    emitterLayer.emitterPosition = view.center;
//    emitterLayer.emitterSize = view.bounds.size;
    emitterLayer.emitterPosition = CGPointMake(kWinnerX + kWinnerWidth / 2.0, kWinnerY + kWinnerHeight / 2.0);
    emitterLayer.emitterSize = CGSizeMake(view.bounds.size.width, kWinnerHeight);
    emitterLayer.emitterMode = kCAEmitterLayerOutline;
    emitterLayer.emitterShape = kCAEmitterLayerRectangle;
    emitterLayer.renderMode = kCAEmitterLayerOldestFirst;
    
    emitterLayer.emitterCells = @[subCell1,subCell2,subCell3,subCell4];
    [view.layer addSublayer:emitterLayer];
    return emitterLayer;
}

- (CAEmitterCell *)createSubcell:(UIImage *)image {
    CAEmitterCell * cell = [CAEmitterCell emitterCell];
    //粒子的名字
    cell.name = @"flower";
    //是个CGImageRef的对象,既粒子要展现的图片
    cell.contents = (__bridge id _Nullable)image.CGImage;
    // 缩放比例
    cell.scale = 0.6;
    //缩放比例范围
    cell.scaleRange = 0.6;
    //表示effectCell的生命周期，既在屏幕上的显示时间要多长
    cell.lifetime = 10;
    //速度
    cell.velocity = 200;
    //速度范围
    cell.velocityRange = 200;
    //粒子y方向的加速度分量
    cell.yAcceleration = 9.8;
    //粒子x方向的加速度分量(控制粒子往左还是往右飘)
    cell.xAcceleration = 0;
    //周围发射角度
    cell.emissionRange = M_PI;
    //缩放比例速度
    cell.scaleSpeed = -0.05;
    //子旋转角度
    cell.spin = 2 * M_PI;
    //子旋转角度范围
    cell.spinRange = 2 * M_PI;
    
    return cell;
}

- (void)startAnimate:(CAEmitterLayer *)emitterLayer {
    CABasicAnimation *burst1 = [self createBurstImageName:kImageName1 birthRate:kBirthRate];
    CABasicAnimation *burst2 = [self createBurstImageName:kImageName2 birthRate:kBirthRate];
    CABasicAnimation *burst3 = [self createBurstImageName:kImageName3 birthRate:kBirthRate];
    CABasicAnimation *burst4 = [self createBurstImageName:kImageName4 birthRate:kBirthRate];

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[burst1,burst2,burst3,burst4];
    [emitterLayer addAnimation:group forKey:@"flowersBurst"];
}

- (CABasicAnimation *)createBurstImageName:(NSString *)iamgeName birthRate:(float)birthRate {
    NSString *animatePath = [NSString stringWithFormat:@"emitterCells.%@.birthRate",iamgeName];
    CABasicAnimation *burst = [CABasicAnimation animationWithKeyPath:animatePath];
    burst.fromValue = [NSNumber numberWithFloat:birthRate];
    burst.toValue = [NSNumber numberWithFloat:0.0];
    burst.duration = 0.5;
    burst.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    return burst;
}

- (void)dealloc {
    [self.emitterLayer removeFromSuperlayer];
    self.emitterLayer = nil;
}

@end
