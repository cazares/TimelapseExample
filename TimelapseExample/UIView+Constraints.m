//
//  UIView+Constraints.m
//  TimelapseExample
//
//  Created by Miguel Cazares on 5/27/14.
//  Copyright (c) 2014 EagleEye Networks. All rights reserved.
//

#import "UIView+Constraints.h"

@implementation UIView (Constraints)

- (NSArray *)lhs_addConstraints:(NSString *)constraint metrics:(NSDictionary *)metrics views:(NSDictionary *)views {
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:constraint options:0 metrics:metrics views:views];
    [self addConstraints:constraints];
    return constraints;
}

- (NSArray *)lhs_centerHorizontallyForView:(UIView *)view width:(CGFloat)width {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self addConstraint:constraint];
    NSMutableArray *constraints = [@[constraint] mutableCopy];
    if (width > 0) {
        [constraints addObjectsFromArray:[self lhs_addConstraints:@"H:|-(>=1)-[view(width)]-(>=1)-|"
                                                          metrics:@{@"width": @(width)} views:@{@"view": view}]];
    }
    return constraints;
}

@end
