//
//  UIView+Constraints.h
//  TimelapseExample
//
//  Created by Miguel Cazares on 5/27/14.
//  Copyright (c) 2014 EagleEye Networks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Constraints)

- (NSArray *)lhs_addConstraints:(NSString *)constraint metrics:(NSDictionary *)metrics views:(NSDictionary *)views;
- (NSArray *)lhs_centerHorizontallyForView:(UIView *)view width:(CGFloat)width;

@end
