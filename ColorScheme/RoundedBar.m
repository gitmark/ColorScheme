/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  RoundedBar.m
//
//  Created by Mark Elrod on 12/16/12.

#import <UIKit/UIKit.h>
#import <CoreGraphics/CGPath.h>
#import "RoundedBar.h"

SmoothGradient *defaultSmoothGradient = nil;
SmoothGradient *defaultSmoothGradientWithBoundary = nil;

SmoothGradient* getDefaultSmoothGradient()
{
    if (defaultSmoothGradient != nil)
        return defaultSmoothGradient;
    
    defaultSmoothGradient = [[SmoothGradient alloc] init];
    [defaultSmoothGradient addColorRed:0.0 green:10.0/255.0 blue:100.0/255.0 alpha:1 location:0.0];
    [defaultSmoothGradient addColorRed:0.0 green:16.0/255.0 blue:216.0/255.0 alpha:1 location:0.5];
    [defaultSmoothGradient addColorRed:0.0 green:10.0/255.0 blue:100.0/255.0 alpha:1 location:1.0];
    [defaultSmoothGradient buildWithSmoothBoundary:false colors:BUILD_RED|BUILD_GREEN|BUILD_BLUE|BUILD_ALPHA];
    
    return defaultSmoothGradient;
}

SmoothGradient* getDefaultSmoothGradientWithBoundary()
{
    if (defaultSmoothGradientWithBoundary != nil)
        return defaultSmoothGradientWithBoundary;
    
    defaultSmoothGradientWithBoundary = [[SmoothGradient alloc] init];
    [defaultSmoothGradientWithBoundary addColorRed:0.0 green:10.0/255.0 blue:60.0/255.0 alpha:1 location:0.0];
    [defaultSmoothGradientWithBoundary addColorRed:0.0 green:16.0/255.0 blue:216.0/255.0 alpha:1 location:0.5];
    [defaultSmoothGradientWithBoundary addColorRed:0.0 green:10.0/255.0 blue:60.0/255.0 alpha:1 location:1.0];
    [defaultSmoothGradientWithBoundary buildWithSharpBoundary:false  colors:BUILD_RED|BUILD_GREEN|BUILD_BLUE|BUILD_ALPHA];
    
    return defaultSmoothGradientWithBoundary;
}


void drawArcShading(CGContextRef c, SmoothGradient *grad, CGFloat x, CGFloat y, CGFloat width, CGFloat height, int side, bool clip);
void drawRectShading(CGContextRef c, SmoothGradient *grad, CGFloat x, CGFloat y, CGFloat width, CGFloat height, int orientation, bool clip);

void drawRectShading(CGContextRef c, SmoothGradient *grad, CGFloat x, CGFloat y, CGFloat width, CGFloat height, int orientation, bool clip)
{
    CGContextSaveGState(c);
    //    CGContextSetAllowsAntialiasing(c, false);
    //    CGContextSetShouldAntialias(c, false);
    
    CGFloat extra = 1000;
    if(clip)
    {
        extra = 0;
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect rect;
    if (orientation == 0)
    {
        rect = CGRectMake(x,y-extra,width,height+extra*2);
    }
    else
    {
        rect = CGRectMake(x-extra,y,width+extra*2,height);
        
    }
    CGPathAddRect (path, NULL, rect);
    
    CGPathCloseSubpath(path);
	CGContextAddPath(c, path);
    CGContextClip(c);
    
    CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
    CGPoint     startPoint,
    endPoint;
    CGFunctionRef myFunctionObject;
    CGShadingRef myShading;
    
    if(orientation == 0) // horizontal
    {
        startPoint = CGPointMake(x,y);
        endPoint = CGPointMake(x,y+height);
    }
    else
    {
        startPoint = CGPointMake(x,y);
        endPoint = CGPointMake(x+width,y);
    }
    
    myColorspace = CGColorSpaceCreateDeviceRGB();
    myFunctionObject = grad.functionObject;
    
    myShading = CGShadingCreateAxial (myColorspace,
                                      startPoint, endPoint,
                                      grad.functionObject,
                                      true, true);
    
    CGContextDrawShading (c, myShading);
    
    CGContextRestoreGState(c);
}



void drawArcShading(CGContextRef c, SmoothGradient *grad, CGFloat x, CGFloat y, CGFloat width, CGFloat height, int side, bool clip)
{
	CGContextSaveGState(c);
    
    CGFloat extra = 1000;
    if(clip)
        extra = 0;
    
    CGFloat xRadius;
    CGFloat yRadius;
    
    if(side == 0 || side == 1)
    {
        xRadius = width;
        yRadius = height/2;
    }
    else
    {
        xRadius = width/2;
        yRadius = height;
    }
    
    switch(side)
    {
        case 1:
            break;
        default:
            break;
    }
    
    CGFloat xRadiusScale = xRadius/yRadius;
    CGAffineTransform transform;
    
    CGRect clipRect;
    switch(side)
    {
        case 0:
            transform = CGAffineTransformMakeTranslation(x+xRadius, y+yRadius);
            clipRect = CGRectMake(x -extra,y-extra,xRadius+extra,height+2*extra);
            break;
            
        case 1:
            transform = CGAffineTransformMakeTranslation(x, y+yRadius);
            clipRect = CGRectMake(x ,y-extra,xRadius+extra,height+2*extra);
            break;
            
        case 2:
            transform = CGAffineTransformMakeTranslation(x+xRadius, y+yRadius);
            clipRect = CGRectMake(x-extra ,y-extra,xRadius*2+extra*2,yRadius+extra);
            break;
            
        case 3:
            transform = CGAffineTransformMakeTranslation(x+xRadius, y);
            clipRect = CGRectMake(x-extra,y,xRadius+extra*2,height+extra);
            break;
            
        default:
            break;
    }
    
    transform = CGAffineTransformScale(transform, xRadiusScale, 1);
    CGMutablePathRef path;
    path = CGPathCreateMutable();
    CGPathAddRect (path, nil, clipRect);
    CGPathCloseSubpath(path);
    
    CGContextAddPath(c, path);
    CGContextClip(c);
    
    
    if(clip)
    {
        CGMutablePathRef path2 = CGPathCreateMutable();
        if(side == 0)
        {
            clipRect = CGRectMake(x + yRadius-xRadius,y,xRadius*2,height);
        }
        else if(side == 1)
        {
            clipRect = CGRectMake(x-xRadius,y,xRadius*2,height);
        }
        else if(side == 2)
        {
            clipRect = CGRectMake(x,y,xRadius*2,yRadius*2);
        }
        
        CGPathAddEllipseInRect(path2, nil, clipRect);
        CGPathCloseSubpath(path2);
        CGContextAddPath(c, path2);
        CGContextClip(c);
    }

    CGContextConcatCTM (c, transform);
    
    CGShadingRef myShading = CGShadingCreateRadial(CGColorSpaceCreateDeviceRGB(), CGPointMake(0,0),
                                                   0, CGPointMake(0,0), yRadius,
                                                   grad.functionObject,
                                                   true, true);
    
    CGContextDrawShading (c, myShading);
	CGContextRestoreGState(c);
}




@implementation RoundedBar
@synthesize smoothGradient, radius, rect, clip, boundary;


-(RoundedBar*)initWithRect:(CGRect)r
{
    clip = true;
    boundary = true;
    rect = r;
    radius = rect.size.height/2;
    smoothGradient = 0;
    return self;
}


-(RoundedBar*)initWithRect:(CGRect)r gradient:(SmoothGradient*)grad
{
    clip = true;
    boundary = true;
    rect = r;
    radius = rect.size.height/8;
    smoothGradient = grad;
    
    return self;
}

-(void)draw:(CGContextRef) c
{
    //   clip = true;
    if (smoothGradient == nil)
    {
        if (boundary)
        {
            smoothGradient = getDefaultSmoothGradientWithBoundary();
        }
        else
        {
            smoothGradient = getDefaultSmoothGradient();
        }
    }
    
    smoothGradient.start = 0.5;
    smoothGradient.end = 1.0;
    smoothGradient.linear = false;
    
    if(rect.size.width > rect.size.height)
    {
        radius = rect.size.height/2;
        drawArcShading(c, smoothGradient, round(rect.origin.x), rect.origin.y, round(radius), rect.size.height, 0, clip);
        drawArcShading(c, smoothGradient, round(rect.origin.x) + round(rect.size.width) - round(radius), rect.origin.y, round(radius), rect.size.height, 1, clip);
        smoothGradient.start = 0.0;
        smoothGradient.end = 1.0;
        drawRectShading(c,smoothGradient, round(rect.origin.x) + round(radius), rect.origin.y, round(rect.size.width) - round(radius)*2.0f, rect.size.height, 0, clip);
        //      NSLog(@"rect x = %f", rect.origin.x + radius);
    }
    else
    {
        radius = rect.size.width/2;
        drawArcShading(c, smoothGradient, rect.origin.x, round(rect.origin.y), rect.size.width, round(radius), 2, clip);
        drawArcShading(c, smoothGradient, rect.origin.x, round(rect.origin.y) + round(rect.size.height) - round(radius), rect.size.width, round(radius), 3, clip);
        smoothGradient.start = 0.0;
        smoothGradient.end = 1.0;
        drawRectShading(c,smoothGradient, rect.origin.x, round(rect.origin.y) + round(radius), rect.size.width, round(rect.size.height) - round(radius)*2.0f, 1, clip);
        
    }
    
}

@end
