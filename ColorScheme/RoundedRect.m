/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  RoundedRect.m
//
//  Created by Mark Elrod on 12/16/12.
//

#import "RoundedRect.h"
#import <CoreGraphics/CGPath.h>

@implementation RoundedRect
@synthesize topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius, rect, roundedBar, xFillOffset, yFillOffset, fillScale, border;


-(RoundedRect*)init
{
    yFillOffset = 5;
    xFillOffset = 0;
    fillScale = 1.0;
    rect = CGRectMake(0,0,0,0);
    roundedBar = nil;
    border = false;
    return self;
}

-(void)draw:(CGContextRef)c
{
    CGContextSaveGState(c);
    CGFloat x1 = CGRectGetMinX(self.rect);
    CGFloat x2 = CGRectGetMidX(self.rect);
    CGFloat x3 = CGRectGetMaxX(self.rect);
    CGFloat y1 = CGRectGetMinY(self.rect);
    CGFloat y2 = CGRectGetMidY(self.rect);
    CGFloat y3 = CGRectGetMaxY(self.rect);
    
    if (border)
    {
        CGContextSetStrokeColorWithColor(c, [[[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.1]  CGColor]);
    CGContextSetLineWidth(c, 1);
    }
    
    CGContextSetAllowsAntialiasing(c, true);
    CGContextSetShouldAntialias(c, true);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, x2, y1);
    if(self.topRightRadius > 0)
    {
        CGPathAddArcToPoint(path, NULL, x3, y1, x3, y2, topRightRadius);
    }
    else
    {
        CGPathAddLineToPoint(path, NULL, x3, y1);
        CGPathAddLineToPoint(path, NULL, x3, y2);
    }
    
    if(self.bottomRightRadius > 0)
    {
        CGPathAddArcToPoint(path, NULL, x3, y3, x2, y3, bottomRightRadius);
        
    }
    else
    {
    CGPathAddLineToPoint(path, NULL, x3, y3);
    CGPathAddLineToPoint(path, NULL, x2, y3);
    }
    
    if(self.bottomLeftRadius > 0)
    {
        CGPathAddArcToPoint(path, NULL, x1, y3, x1, y2, bottomLeftRadius);
        
    }
    else
    {
        CGPathAddLineToPoint(path, NULL, x1, y3);
        CGPathAddLineToPoint(path, NULL, x1, y2);
    }
    

    if(topLeftRadius > 0)
    {
        CGPathAddArcToPoint(path, NULL, x1, y1, x2, y1, topLeftRadius);
        
    }
    else
    {
        CGPathAddLineToPoint(path, NULL, x1, y1);
        CGPathAddLineToPoint(path, NULL, x2, y1);
    }
    
    CGPathCloseSubpath(path);
    
    CGContextAddPath(c, path);
    CGContextClip(c);

    roundedBar.boundary = false;
    
    roundedBar.clip = false;
    [roundedBar draw:c];
    
    if(border)
    {
        CGContextAddPath(c, path);
        CGContextStrokePath(c);
    }

    CGPathRelease(path);
    
    CGContextRestoreGState(c);
    
}

-(void)setAllCornersToRadius:(CGFloat)radius
{
    topLeftRadius = radius;
    topRightRadius = radius;
    bottomRightRadius = radius;
    bottomLeftRadius = radius;
}

@end
