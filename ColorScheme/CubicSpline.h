/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  CubicSpline.h
//
//  Created by Mark Elrod on 12/15/12.
//

#import <Foundation/Foundation.h>
@class CubicSpline;

@protocol CubicSplineDelegate <NSObject>
-(void)splineDidComplete:(CubicSpline*)theSpline;
@end


@interface CubicSpline : NSObject
{
    dispatch_queue_t serialQueue;
    NSMutableArray *locationsArray;
    
    CGFloat *y;
    CGFloat *h;
    CGFloat *m;
    CGFloat *result;
    CGFloat *A;
    CGFloat *r;
    CGFloat *locations;
    
    CGFloat *y1;
    CGFloat *loc1;
    int colorCount1;
    
    int colorCount;
    bool clamped;
    NSRecursiveLock *lock;
    bool queueValid;
    int queueCount;
    int resultCount;
}

-(CubicSpline*) init;


-(int)build:(bool)clampedSpline colors:(CGFloat*)colors location:(CGFloat*)loc count:(int)count async:(bool)async;

@property (nonatomic, assign) id <CubicSplineDelegate> delegate;

@property (nonatomic, readonly) CGFloat * result;
@property (nonatomic, readonly) CGFloat * locations;
@property (nonatomic, readonly) int colorCount;
@property (nonatomic) CGFloat start;
@property (nonatomic) CGFloat end;
@property (nonatomic) bool linear;
@property (nonatomic,readonly) int queueCount;
@property (nonatomic, readonly) int resultCount;

-(void)lock;
-(void)unlock;

@end
