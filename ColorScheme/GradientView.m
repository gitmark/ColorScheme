/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  GradientView.m
//
//  Created by Mark Elrod on 12/20/12.
//

#import "GradientView.h"
#import "SmoothGradient.h"
#import "GlossFactory.h"

@interface GradientView ()
{
    CGFloat origColor1[4];
    CGFloat origColor2[4];
    bool ready;
    UIColor * color1;
    UIColor * color2;
}
@end


@implementation GradientView
@synthesize async, grid, smoothGradient, gridHeight;

-(void) buildGradient:(bool)a
{
    [smoothGradient setColor:color1 atIndex:0];
    [smoothGradient setColor:color2 atIndex:1];
    [self setOrigState];
    ready = true;
    
}

-(void) initSmoothGradient
{
    grid = false;
    smoothGradient = getGradient(BackgroundType);
    smoothGradient.async = true;
    [smoothGradient addDelegate:self];
    color1 = [smoothGradient colorAtIndex:0];
    color2 = [smoothGradient colorAtIndex:1];
    ready = true;
    memset(origColor1, 0, 4*sizeof(CGFloat));
    memset(origColor2, 0, 4*sizeof(CGFloat));
}

-(bool)stateChanged
{
    const CGFloat * comp1 = CGColorGetComponents(self.color1.CGColor);
    
    for (int i = 0; i < 4; i++)
    {
        if (origColor1[i] != comp1[i])
        {
            return true;
        }
    }
    
    const CGFloat * comp2 = CGColorGetComponents(self.color2.CGColor);
    
    for (int i = 0; i < 4; i++)
    {
        if (origColor2[i] != comp2[i])
        {
            return true;
        }
    }
    
    return false;
}

-(void)setOrigState
{
    const CGFloat * comp1 = CGColorGetComponents(self.color1.CGColor);
    memcpy(origColor1, comp1, 4*sizeof(CGFloat));
    const CGFloat * comp2 = CGColorGetComponents(self.color2.CGColor);
    memcpy(origColor2, comp2, 4*sizeof(CGFloat));
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSaveGState(c);
    
    
    if (!ready || [self stateChanged])
    {
        [self buildGradient:false];
    }
    
    CGRect rect1 = [self bounds];
    CGPoint startPoint = CGPointMake(rect1.origin.x, rect1.origin.y);
    
    CGPoint endPoint = CGPointMake(rect1.origin.x, rect1.origin.y + rect1.size.height);
    
    
    CGShadingRef shading = CGShadingCreateAxial (CGColorSpaceCreateDeviceRGB(),
                                                 startPoint, endPoint,
                                                 smoothGradient.functionObject,
                                                 true, true);
    CGContextDrawShading (c, shading);
    
    CGFloat height = 0;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        height = 130;
    }
    else
    {
        height = 250;
    }
    
    CGFloat topMargin = 5;
    CGFloat leftMargin = 5;
    CGFloat x1 = leftMargin;
    CGFloat x2 = rect1.size.width - leftMargin;
    CGFloat y1 = topMargin;
    CGFloat y2 = topMargin + height;
    if(grid)
    {
        CGContextSetStrokeColorWithColor(c, [[[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:1]  CGColor]);
        CGContextSetLineWidth(c, 1);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, x1, y1);
        
        CGPathAddLineToPoint(path, NULL, x2, y1);
        CGPathAddLineToPoint(path, NULL, x2, y2);
        CGPathAddLineToPoint(path, NULL, x1, y2);
        CGPathAddLineToPoint(path, NULL, x1, y1);
        CGPathAddLineToPoint(path, NULL, x2, y2);
        CGPathMoveToPoint(path, NULL, x2, y1);
        CGPathAddLineToPoint(path, NULL, x1, y2);
        
        CGContextAddPath(c, path);
        CGContextStrokePath(c);
    }
    
    CGContextRestoreGState(c);
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initSmoothGradient];
}

- (BOOL) isOpaque {
    return NO;
}

-(UIColor *)color1
{
    return color1;
}

-(void)setColor1:(UIColor*)color
{
    color1 = color;
    if (self.async)
    {
        if([self stateChanged])
        {
            [self buildGradient:true];
        }
    }
}

-(UIColor *)color2
{
    return color2;
}

-(void)setColor2:(UIColor*)color
{
    color2 = color;
    if (self.async)
    {
        if([self stateChanged])
        {
            [self buildGradient:true];
        }
    }
}

-(void)gradientDidComplete:(SmoothGradient *)theGradient
{
    [self setNeedsDisplay];
}

@end
