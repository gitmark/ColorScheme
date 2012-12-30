/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  SmoothGradient.m
//
//  Created by Mark Elrod on 12/15/12.
//

#import "SmoothGradient.h"
#import "CubicSpline.h"

// todo, put headers in one place

void copyComponentToY(CGFloat *y, CGFloat *colors, int component, int n);
void buildMatrixH(CGFloat *h, CGFloat *x, int rank);
void buildMatrixR(CGFloat *r, CGFloat *y, CGFloat *h, int rank, bool clamped);
void buildMatrixA(CGFloat *A, CGFloat *x, CGFloat *y, CGFloat *h, int rank, bool clamped);
void buildMatrixB(CGFloat *b, CGFloat *m, CGFloat *y, CGFloat *h, CGFloat *r, int colCount, int n);

CGFloat norm(CGFloat *row, int start, int rank);
int findPivit(CGFloat *m, int start, int rank);
void pivit(CGFloat *m, int row1, int row2, int rank, CGFloat *y);
void eliminateRows(CGFloat *m, int start, int rank, CGFloat *y);
void printMatrix(CGFloat *m, int rank);
void printVector(CGFloat *v, int rank);
void gaussElimination(CGFloat *m, int rank, CGFloat *y);
void backSubstitution(CGFloat *m, int rank, CGFloat *y, CGFloat *x);


CGFloat splineVal(CGFloat *params, CGFloat *locations, CGFloat location, int colorCount);
static void calcSplineShadingValues (void *info, const CGFloat *in, CGFloat *out);
static void calcLinearShadingValues (void *info, const CGFloat *in, CGFloat *out);
CGFloat linearVal(CGFloat *colors, CGFloat *locations, CGFloat location, int colorCount, int color);

static void calcSplineShadingValues (void *info,
                                     const CGFloat *in,
                                     CGFloat *out)
{
    CGFloat loc1 = *in;
    SmoothGradient *grad = (__bridge SmoothGradient*)info;
    
    CGFloat start = grad.start;
    CGFloat end = grad.end;
    CGFloat scale = end - start;
    
    CGFloat loc = start + scale*loc1;
    
    CGFloat r = splineVal(grad.red, grad.locations, loc, grad.colorCount);
    CGFloat g = splineVal(grad.green, grad.locations, loc, grad.colorCount);
    CGFloat b = splineVal(grad.blue, grad.locations, loc, grad.colorCount);
    CGFloat a = splineVal(grad.alpha, grad.locations, loc, grad.colorCount);
    out[0] = r;
    out[1] = g;
    out[2] = b;
    out[3] = a;
    
    
}

static void calcLinearShadingValues (void *info,
                                     const CGFloat *in,
                                     CGFloat *out)
{
    CGFloat loc1 = *in;
    SmoothGradient *grad = (__bridge SmoothGradient*)info;
    
    CGFloat start = grad.start;
    CGFloat end = grad.end;
    CGFloat scale = end - start;
    
    CGFloat loc = start + scale*loc1;
    
    CGFloat r = linearVal(grad.colors, grad.locations, loc, grad.colorCount, 0);
    CGFloat g = linearVal(grad.colors, grad.locations, loc, grad.colorCount, 1);
    CGFloat b = linearVal(grad.colors, grad.locations, loc, grad.colorCount, 2);
    CGFloat a = linearVal(grad.colors, grad.locations, loc, grad.colorCount, 3);
    out[0] = r;
    out[1] = g;
    out[2] = b;
    out[3] = a;
    
    
}


@implementation SmoothGradient
@synthesize start, end, linear, async;

-(void)addColorRed:(CGFloat) red1 green:(CGFloat) green1 blue:(CGFloat) blue1 alpha:(CGFloat) alpha1 location:(CGFloat) loc
{
    [self addUIColor:[UIColor colorWithRed:red1 green:green1 blue:blue1 alpha:alpha1] location:loc];
}

-(void)addUIColor:(UIColor*)color location:(CGFloat) loc
{
    if (!colorsArray) {
        colorsArray = [[NSMutableArray alloc] init];
    }
    
    [colorsArray insertObject:color atIndex:colorsArray.count];
    
    if (!locationsArray) {
        locationsArray = [[NSMutableArray alloc] init];
    }
    
    [locationsArray insertObject:[NSNumber numberWithFloat:loc] atIndex:locationsArray.count];
}

-(void)addCGColor:(CGColorRef)color location:(CGFloat) loc
{
    [self addUIColor:[UIColor colorWithCGColor:color] location:loc];
    
}

-(void)addColor:(CGFloat*)color location:(CGFloat) loc
{
    [self addColorRed:color[0] green:color[1] blue:color[2] alpha:color[3] location:loc];
    
}

-(SmoothGradient*) init
{
    async = false;
    delegates = [[NSMutableArray alloc] init];
    colorsArray = 0;
    locationsArray = 0;
    
    red = 0;
    green = 0;
    blue = 0;
    alpha = 0;
    locations = 0;
    colors = 0;
    
    colorCount = 0;
    clamped = false;
    
    start = 0;
    end = 1;
    redSpline = [[CubicSpline alloc] init];
    redSpline.delegate = self;
    
    greenSpline = [[CubicSpline alloc] init];
    greenSpline.delegate = self;
    
    blueSpline = [[CubicSpline alloc] init];
    blueSpline.delegate = self;
    
    alphaSpline = [[CubicSpline alloc] init];
    alphaSpline.delegate = self;
    return self;
}

-(void) allocBuffers
{
    clamped = true;
    colorCount = colorsArray.count;
    if (colorCount < 1)
    {
        colorCount = 0;
        return;
    }
    
    colors      = malloc(colorCount*sizeof(CGFloat)*4); // red, green, blue, alpha
    locations   = malloc(colorCount*sizeof(CGFloat));
    red         = malloc(colorCount*sizeof(CGFloat)*4);
    green       = malloc(colorCount*sizeof(CGFloat)*4);
    blue        = malloc(colorCount*sizeof(CGFloat)*4);
    alpha       = malloc(colorCount*sizeof(CGFloat)*4);
    
}

-(void)copyBuffers
{
    for(int i = 0; i < colorCount; i++)
    {
        UIColor *color = [colorsArray objectAtIndex:i];
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        colors[i*4] = components[0];
        colors[i*4+1] = components[1];
        colors[i*4+2] = components[2];
        colors[i*4+3] = components[3];
        locations[i] = [[locationsArray objectAtIndex:i] floatValue];
    }
    
}

-(void)buildWithSmoothBoundary:(bool) async1 colors:(int)c
{
    [self build:true async:async1 colors:c];
}

-(void)buildWithSharpBoundary:(bool) async1 colors:(int)c
{
    [self build:false async:async1 colors:c];
}

-(void)build:(bool)clampedSpline async:(bool)async1 colors:(int)c
{
    if (!colors)
    {
        [self allocBuffers];
    }
    
    [self copyBuffers];
    clamped = clampedSpline;
    
    CGFloat * y = malloc(colorCount*sizeof(CGFloat));
    
    if (c & BUILD_RED)
    {
        copyComponentToY(y,colors,0,colorCount);
        [redSpline build:clamped colors:y location:locations count:colorCount async:async1];
        
        if (!async1)
        {
            memcpy(red, redSpline.result, colorCount*sizeof(CGFloat)*4);
        }
    }
    
    if (c & BUILD_GREEN)
    {
        copyComponentToY(y,colors,1,colorCount);
        
        [greenSpline build:clamped colors:y location:locations count:colorCount async:async1];
        
        if (!async1)
        {
            memcpy(green, greenSpline.result, colorCount*sizeof(CGFloat)*4);
        }
    }
    
    if (c & BUILD_BLUE)
    {
        copyComponentToY(y,colors,2,colorCount);
        [blueSpline build:clamped colors:y location:locations count:colorCount async:async1];
        
        if (!async1)
        {
            memcpy(blue, blueSpline.result, colorCount*sizeof(CGFloat)*4);
        }
    }
    
    if (c & BUILD_ALPHA)
    {
        copyComponentToY(y,colors,3,colorCount);
        [alphaSpline build:clamped colors:y location:locations count:colorCount async:async1];
        
        if (!async1)
        {
            memcpy(alpha, alphaSpline.result, colorCount*sizeof(CGFloat)*4);
        }
    }
    
    free(y);
}


-(CGFunctionRef) functionObject
{
    static const CGFloat input_value_range [2] = { 0, 1 };
    static const CGFloat output_value_ranges [8] = { 0, 1, 0, 1, 0, 1, 0, 1 };
    static const CGFunctionCallbacks splineCallbacks = { 0,
        &calcSplineShadingValues,
        NULL };
    
    static const CGFunctionCallbacks linearCallbacks = { 0,
        &calcLinearShadingValues,
        NULL };
    
    const CGFunctionCallbacks *callbacks = nil;
    
    if (linear)
    {
        callbacks = &linearCallbacks;
    }
    else
    {
        callbacks = &splineCallbacks;
    }
    
    return CGFunctionCreate ((__bridge void *) self,
                             1,
                             input_value_range,
                             4,
                             output_value_ranges,
                             callbacks);
}

-(CGFloat*) red
{
    return red;
}

-(CGFloat*) green
{
    return green;
}

-(CGFloat*) blue
{
    return blue;
}

-(CGFloat*) alpha
{
    return alpha;
}

-(CGFloat*) locations
{
    return locations;
}

-(CGFloat*) colors
{
    if (!colors)
    {
        [self allocBuffers ];
        [self copyBuffers];
    }
    
    return colors;
}

-(int) colorCount
{
    return colorCount;
}


-(void) freeBuffersIfAllocated
{
    clamped = true;
    colorCount = 0;
    free(red);         red         = 0;
    free(green);       green       = 0;
    free(blue);        blue        = 0;
    free(alpha);       alpha       = 0;
    free(locations);   locations   = 0;
    free(colors);      colors      = 0;
}

-(void)dealloc {
    [self freeBuffersIfAllocated];
}

-(void)splineDidComplete:(CubicSpline*)theSpline
{
    if (theSpline == redSpline)
    {
        [redSpline lock];
        if(redSpline.resultCount == colorCount)
        {
            memcpy(red, redSpline.result, colorCount*sizeof(CGFloat)*4);
        }
        [redSpline unlock];
    }
    else if (theSpline == greenSpline)
    {
        [greenSpline lock];
        if(greenSpline.resultCount == colorCount)
        {
            memcpy(green, greenSpline.result, colorCount*sizeof(CGFloat)*4);
        }
        [greenSpline unlock];
    }
    else if (theSpline == blueSpline)
    {
        [blueSpline lock];
        if(blueSpline.resultCount == colorCount)
        {
            memcpy(blue, blueSpline.result, colorCount*sizeof(CGFloat)*4);
        }
        [blueSpline unlock];
    }
    else if (theSpline == alphaSpline)
    {
        [alphaSpline lock];
        if(alphaSpline.resultCount == colorCount)
        {
            memcpy(alpha, alphaSpline.result, colorCount*sizeof(CGFloat)*4);
        }
        [alphaSpline unlock];
    }
    
    if (!redSpline.queueCount && !greenSpline.queueCount && !blueSpline.queueCount &&!alphaSpline.queueCount)
    {
        for(id delegate in delegates)
        {
            [delegate gradientDidComplete:self];
        }
    }
}

-(void)removeAllColors
{
    [colorsArray removeAllObjects];
    [locationsArray removeAllObjects];
}

-(void)addDelegate:(id)delegate
{
    [delegates insertObject:delegate atIndex:delegates.count];
}

-(UIColor*)colorAtIndex:(int)index
{
    return [colorsArray objectAtIndex:index];
}

-(void)setColor:(UIColor*)color1 atIndex:(int)index
{
    UIColor *color2 = [colorsArray objectAtIndex:index];
    const CGFloat *comp2 = CGColorGetComponents(color2.CGColor);
    const CGFloat *comp1 = CGColorGetComponents(color1.CGColor);
    bool diff = false;
    for(int i = 0; i < 4; i++)
    {
        if (comp1[i] != comp2[i])
        {
            diff = true;
            break;
        }
    }
    
    if(!diff)
    {
        return;
    }
    
    [colorsArray setObject:color1 atIndexedSubscript:index];
    [self build:false async:async colors:BUILD_RED|BUILD_GREEN|BUILD_BLUE|BUILD_ALPHA];
    
}



@end
