//
//  ImageChanger.h
//  MapLocator
//
//  Created by lojsk on 29/07/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface ImageChanger : NSObject

+ (UIImage*) replaceColor:(UIColor*)color inImage:(UIImage*)image withTolerance:(float)tolerance;
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha andImage:(UIImage*)img;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
