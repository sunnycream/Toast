//
//  ViewController.m
//  Toast
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ViewController ()

// Atomic, because it may be canceled from main thread, flag is read on a background thread
@property (atomic, assign) BOOL canceled;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    /*
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:hud];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.backgroundColor = [UIColor lightGrayColor];
//    hud.alpha = 0.5;

    hud.bezelView.layer.cornerRadius = 30;
    hud.label.text = @"Loading";
    hud.label.textColor = [UIColor redColor];
    hud.label.font = [UIFont systemFontOfSize:14];
 
    hud.detailsLabel.text = @"please wait...";
    hud.detailsLabel.textColor = [UIColor blackColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:10];
    
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor redColor];
    
//    [hud setOffset:CGPointMake(100, 100)];//+ 右下； - 左上
//    hud.margin = 10;//各个元素距离矩形边框的距离
//    hud.minSize = CGSizeMake(100, 10);//背景框的最小size？？？
//    hud.square = YES;//是否宽高相等
//    hud.minShowTime = 3;
    
//    hud.animationType = MBProgressHUDAnimationZoomOut;
    
    hud.removeFromSuperViewOnHide = NO;
    hud.progress = 0.3;
     */
}

- (IBAction)startAction:(id)sender {
//    [self onlyView];
//    [self onlyText:@"🍊🍊🍊🍊🍊🍊"];
//    [self withText:@"Loading..." andDetailText:@"Please wait..."];
//    [self bothViewAndButtonText:@"Cancel"];
//    [self viewWithText:@"Loading..." ButtonText:@"Cancel"];
//    [self bothViewAndText:@"Loading..."];
//    [self customViewWithText:@"Done"];
    [self barViewWithText:@"Loading..."];
}

- (void)onlyView {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;//默认菊花
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background
        sleep(3);
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)onlyText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = text;
    hud.mode = MBProgressHUDModeText;
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);//偏移量
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.2f];
    
    [hud hideAnimated:YES afterDelay:3.f];
}

- (void)withText:(NSString *)text andDetailText:(NSString *)detailText {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = text;
    hud.label.textColor = [UIColor blackColor];
    hud.label.font = [UIFont systemFontOfSize:14];
    
    hud.detailsLabel.text = detailText;
    hud.detailsLabel.textColor = [UIColor grayColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:10];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(3);
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
//            hud.completionBlock = ^{
//                NSLog(@"加载完成。。。");
//            };
        });
    });
}

- (void)bothViewAndButtonText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    [hud.button setTitle:text forState:UIControlStateNormal];
    [hud.button addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self workWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)viewWithText:(NSString *)text ButtonText:(NSString *)buttonText {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;//圆环
    hud.label.text = text;
    
    NSProgress *progressObject = [NSProgress progressWithTotalUnitCount:100];
    hud.progressObject = progressObject;
    
    [hud.button setTitle:buttonText forState:UIControlStateNormal];
    [hud.button addTarget:progressObject action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self workWithProgressObject:progressObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)bothViewAndText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;//圆环1
//    hud.mode = MBProgressHUDModeAnnularDeterminate;//圆环2
    hud.label.text = text;
    hud.contentColor = [UIColor redColor];//所有元素改变颜色
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self workWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)customViewWithText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    
    UIImage *image = [[UIImage imageNamed:@"trophy"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    UIImage *image = [UIImage imageNamed:@"trophy"];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    
    hud.square = YES;
    hud.label.text = text;
    
    [hud hideAnimated:YES afterDelay:3.f];
}

- (void)barViewWithText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    hud.label.text = text;
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self workWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)cancelAction {
    self.canceled = YES;
}

- (void)workWithProgress {
    self.canceled = NO;
    
    float progress = 0.0f;
    while (progress < 1.0f) {
        if (self.canceled) {
            break;
        }
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD HUDForView:self.view].progress = progress;
        });
        usleep(50000);//usleep 把进程挂起一段时间，单位是微秒（百万分之一秒）（同sleep）
    }
}

- (void)workWithProgressObject:(NSProgress *)progressObject {
    while (progressObject.fractionCompleted < 1.0f) {
        if (progressObject.isCancelled) {
            break;
        }
        [progressObject becomeCurrentWithPendingUnitCount:1];
        [progressObject resignCurrent];
        usleep(50000);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
