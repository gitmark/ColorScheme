/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  SmoothGradient.h
//
//  Created by Mark Elrod on 12/15/12.
//

#import <Foundation/Foundation.h>
#import "CubicSpline.h"

#define BUILD_RED   1
#define BUILD_GREEN 2
#define BUILD_BLUE  4
#define BUILD_ALPHA 8

@class SmoothGradient;

@protocol SmoothGradientDelegate <NSObject>
-(void)gradientDidComplete:(SmoothGradient*)theGradient;
@end


@interface SmoothGradient : NSObject <CubicSplineDelegate>
{
    NSMutableArray *colorsArray;
    NSMutableArray *locationsArray;
    CubicSpline *redSpline;
    CubicSpline *greenSpline;
    CubicSpline *blueSpline;
    CubicSpline *alphaSpline;
    
    CGFloat *red;
    CGFloat *green;
    CGFloat *blue;
    CGFloat *alpha;
    CGFloat *locations;
    CGFloat *colors;

    int colorCount;
    bool clamped;
    NSMutableArray *delegates;
}
-(SmoothGradient*) init;
-(void)removeAllColors;
-(void)addColor:(CGFloat*)color location:(CGFloat) loc;
-(void)addUIColor:(UIColor*)color location:(CGFloat) loc;
-(void)addCGColor:(CGColorRef)color location:(CGFloat) loc;

-(void)addColorRed:(CGFloat) red1 green:(CGFloat) green1 blue:(CGFloat) blue1 alpha:(CGFloat) alpha1 location:(CGFloat) loc;

-(void)buildWithSmoothBoundary:(bool)async colors:(int)c ;
-(void)buildWithSharpBoundary:(bool)async colors:(int)c;
-(void)addDelegate: (id) delegate;
-(UIColor*)colorAtIndex:(int)index;
-(int)colorCount;
-(void)setColor:(UIColor*)color1 atIndex:(int)index;

@property (nonatomic, readonly) CGFunctionRef functionObject;
@property (nonatomic, readonly) CGFloat * red;
@property (nonatomic, readonly) CGFloat * green;
@property (nonatomic, readonly) CGFloat * blue;
@property (nonatomic, readonly) CGFloat * alpha;
@property (nonatomic, readonly) CGFloat * locations;
@property (nonatomic, readonly) CGFloat * colors;
@property (nonatomic, readonly) int colorCount;
@property (nonatomic) CGFloat start;
@property (nonatomic) CGFloat end;
@property (nonatomic) bool linear;
@property bool async;


@end
