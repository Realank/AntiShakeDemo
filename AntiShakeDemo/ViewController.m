//
//  ViewController.m
//  AntiShakeDemo
//
//  Created by Realank on 2016/11/6.
//  Copyright © 2016年 Realank. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

#define AVG_COUNT 240
#define GAIN_RATE 0.9

@interface ViewController ()
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIView *stableView;
@property (nonatomic, strong) NSMutableArray* xData;
@property (nonatomic, strong) NSMutableArray* yData;
@property (nonatomic, strong) NSMutableArray* zData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _motionManager = [[CMMotionManager alloc] init];
    _xData = [NSMutableArray array];
    
    if (_motionManager.isGyroAvailable) {
        _motionManager.gyroUpdateInterval = 1/120.0;
        __weak typeof(self) weakSelf = self;
        
        [_motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {

            double x = gyroData.rotationRate.y;
            double y = gyroData.rotationRate.x;
            double z = gyroData.rotationRate.z;
            //x
            [_xData addObject:[NSNumber numberWithDouble:x]];
            if (_xData.count > AVG_COUNT) {
                [_xData removeObjectAtIndex:0];
            }
            double avgX = 0;
            if (_xData.count) {
                for (NSNumber* preXNumber in _xData) {
                    avgX += [preXNumber doubleValue];
                }
                avgX /= _xData.count;
            }
            double deltaX = avgX - x;
            
            //y
            [_yData addObject:[NSNumber numberWithDouble:y]];
            if (_yData.count > AVG_COUNT) {
                [_yData removeObjectAtIndex:0];
            }
            double avgY = 0;
            if (_yData.count) {
                for (NSNumber* preYNumber in _yData) {
                    avgY += [preYNumber doubleValue];
                }
                avgY /= _yData.count;
            }
            double deltaY = avgY - y;
            
            //z
            [_zData addObject:[NSNumber numberWithDouble:y]];
            if (_zData.count > AVG_COUNT) {
                [_zData removeObjectAtIndex:0];
            }
            double avgZ = 0;
            if (_zData.count) {
                for (NSNumber* preZNumber in _zData) {
                    avgZ += [preZNumber doubleValue];
                }
                avgZ /= _zData.count;
            }
            double deltaZ = avgZ - z;
            
            
            weakSelf.infoLabel.text = [NSString stringWithFormat:@"delta x:%.3lf, delta y:%.3lf",deltaX, deltaY];

            CGAffineTransform transfrom = CGAffineTransformMakeTranslation(deltaX*GAIN_RATE, deltaY*GAIN_RATE);
            transfrom = CGAffineTransformRotate(transfrom, -deltaZ/80);
            _stableView.layer.affineTransform = transfrom;
            
        }];
    }
    
    
}


@end
