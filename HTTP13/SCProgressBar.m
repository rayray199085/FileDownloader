//
//  SCProgressBar.m
//  HTTP13
//
//  Created by Stephen Cao on 13/3/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

#import "SCProgressBar.h"

@implementation SCProgressBar
- (void)setProcess:(float)process{
    _process = process;
    [self setTitle:[NSString stringWithFormat:@"%0.2f %%",_process * 100] forState:UIControlStateNormal];
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2, height/2) radius:MIN(width, height)/2 startAngle:- M_PI_2 endAngle:M_PI * 2 * self.process - M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(width/2, height/2)];
    [[UIColor redColor]setFill];
    [path fill];
}
@end
