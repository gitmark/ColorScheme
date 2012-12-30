/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  CubicSpline.m
//
//  Created by Mark Elrod on 12/15/12.
//

#import "CubicSpline.h"

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


CGFloat linearVal(CGFloat *colors, CGFloat *locations, CGFloat location, int colorCount, int color)
{
    int lowRow = 0;
    for(int row = 0; row < colorCount; row++)
    {
        if (location <= locations[row])
        {
            break;
        }
        else
        {
            lowRow = row;
        }
    }
    
    CGFloat x1 = locations[lowRow];
    CGFloat y1 = colors[lowRow*4 + color];
    
    if(lowRow < colorCount - 1)
    {
        lowRow++;
    }
    
    CGFloat x2 = locations[lowRow];
    CGFloat y2 = colors[lowRow*4 + color];
    
    CGFloat deltaY = y2 - y1;
    CGFloat deltaX = x2 - x1;
    
    CGFloat slope = 0;
    
    CGFloat val = y1;
    
    if (deltaX > 0)
    {
        slope = deltaY/deltaX;
        
        CGFloat deltaX2 = location - x1;
        val = y1 + slope*deltaX2;
    }
    
    return val;
}

CGFloat splineVal(CGFloat *params, CGFloat *locations, CGFloat location, int colorCount)
{
    int lowRow = 0;
    for(int row = 0; row < colorCount; row++)
    {
        if (location <= locations[row])
        {
            break;
        }
        else
        {
            lowRow = row;
        }
    }
    
    CGFloat start = locations[lowRow];
    
    CGFloat x = location - start;
    CGFloat x2 = x*x;
    CGFloat x3 = x2*x;
    
    CGFloat val =  params[lowRow*4] + params[lowRow*4+1]*x + params[lowRow*4+2]*x2 + params[lowRow*4+3]*x3;
    return val;
}




CGFloat norm(CGFloat *row, int start, int rank)
{
    CGFloat max = 0;
    CGFloat val = 0;
    for (int col = start; col < rank; col++)
    {
        val = fabs(row[col]);
        if (max < val)
        {
            max = val;
        }
    }
    
    if (max == 0)
    {
        return -1;
    }
    
    return fabs(row[start])/max;
}

int findPivit(CGFloat *m, int start, int rank)
{
    int maxRow = start;
    CGFloat maxVal = 0;
    CGFloat val = 0;
    for(int r = start; r < rank; r++)
    {
        val = norm(&m[r*rank], start, rank);
        if (maxVal < val)
        {
            maxVal = val;
            maxRow = r;
        }
    }
    
    return maxRow;
}

void pivit(CGFloat *m, int row1, int row2, int rank, CGFloat *y)
{
    CGFloat val = 0;
    for(int c = 0; c < rank; c++)
    {
        val = m[row1*rank + c];
        m[row1*rank + c] = m[row2*rank + c];
        m[row2*rank + c] = val;
    }
    
    val = y[row1];
    y[row1] = y[row2];
    y[row2 ] = val;
    
}

void eliminateRows(CGFloat *m, int start, int rank, CGFloat *y)
{
    CGFloat val = 0;
    for(int r = start + 1; r < rank; r++)
    {
        val = m[r*rank + start]/m[start*rank + start];
        
        for(int c = start; c < rank; c++)
        {
            m[r*rank + c] -= m[start*rank + c]*val;
        }
        
        y[r] -= y[start]*val;
    }
}

void printMatrix(CGFloat *m, int rank)
{
    for(int r = 0; r < rank; r++)
    {
        NSLog(@"%f, %f, %f, %f", m[r*rank], m[r*rank+1], m[r*rank+2], m[r*rank+3]);
    }
    NSLog(@"---");
}

void printVector(CGFloat *v, int rank)
{
    for(int r = 0; r < rank; r++)
    {
        NSLog(@"%f", v[r]);
    }
    NSLog(@"---");
}

void gaussElimination(CGFloat *m, int rank, CGFloat *y)
{
    int pivitRow = 0;
    for(int r = 0; r < rank - 1; r++)
    {
        pivitRow = findPivit(m,r,rank);
        if (pivitRow != r)
        {
            pivit(m, r, pivitRow, rank,y);
        }
        
        eliminateRows(m, r, rank, y);
    }
}

void backSubstitution(CGFloat *m, int rank, CGFloat *y, CGFloat *x)
{
    CGFloat yVal = 0;
    for(int r = rank -1; r >= 0; r--)
    {
        yVal = y[r];
        for(int j = r+1; j < rank; j++)
        {
            yVal -= m[r*rank+j]*x[j];
        }
        
        x[r] = yVal/m[r*rank+r];
    }
}


void copyComponentToY(CGFloat *y, CGFloat *colors, int component, int n)
{
    
    for(int i = 0; i < n; i++)
    {
        y[i] = colors[i*4 + component];
    }
}



void buildMatrixH(CGFloat *h, CGFloat *x, int rank)
{
    for(int i = 0; i < rank - 1; i++)
    {
        h[i] = x[i+1] - x[i];
    }
    
}

void buildMatrixR(CGFloat *r, CGFloat *y, CGFloat *h, int rank, bool clamped)
{
    if (rank < 1)
    {
        return;
    }
    
    for(int row = 0; row < rank; row++)
    {
        CGFloat left = (y[row+1] - y[row])/h[row];
        CGFloat right = (y[row] - y[row-1])/h[row-1];
        
        if(row == 0)
        {
            if (clamped)
            {
                right = 0;
            }
            else
            {
                left = 0;
                right = 0;
            }
        }
        else if (row == rank - 1)
        {
            if (clamped)
            {
                left = 0;
            }
            else
            {
                left = 0;
                right = 0;
            }
        }
        
        r[row] = (left - right) * 6.0f;
    }
    
}

void buildMatrixA(CGFloat *A, CGFloat *x, CGFloat *y, CGFloat *h, int rank, bool clamped)
{
    if (rank < 1)
    {
        return;
    }
    
    if ( clamped)
    {
        A[0] = 2.0f*h[0];
        A[1] = h[0];
        for(int col = 2; col < rank;col++)
        {
            A[col] = 0;
        }
        int row = rank - 1;
        for(int col = 0; col < rank - 2; col++)
        {
            A[row*rank + col] = 0;
        }
        
        A[row*rank + rank - 2] = h[rank-2];
        A[row*rank + rank - 1] = 2.0f*h[rank-2];
    }
    else
    {
        A[0] = 1;
        for(int col = 1; col < rank; col++)
        {
            A[col] = 0;
        }
        
        int row = rank - 1;
        for(int col = 0; col < rank -1; col++)
        {
            A[row*rank + col] = 0;
        }
        
        A[row*rank + rank - 1] = 1;
    }
    
    for(int row = 1; row < rank - 1; row++)
    {
        for (int col = 0; col < row - 1; col++)
        {
            A[row*rank + col] = 0;
        }
        
        A[row*rank + row - 1] = h[row - 1];
        A[row*rank + row] = 2.0f * (h[row - 1] + h[row]);
        A[row*rank + row + 1] = h[row];
        
        for (int col = row + 2; col < rank; col++)
        {
            A[row*rank + col] = 0;
        }
    }
}

void buildMatrixB(CGFloat *b, CGFloat *m, CGFloat *y, CGFloat *h, CGFloat *r, int colCount, int n)
{
    for(int row = 0; row < n -1; row++)
    {
        // a
        b[row*colCount] = y[row];
        
        // b
        b[row*colCount + 1] = (y[row+1] - y[row])/h[row] - h[row]*m[row]/2.0f - h[row]*(m[row+1] - m[row])/6.0f;
        
        // c
        b[row*colCount + 2] = m[row]/2;
        
        // d
        b[row*colCount + 3] = (m[row+1] - m[row])/(6.0f*h[row]);
    }
}


@implementation CubicSpline
@synthesize start, end, linear, delegate, queueCount;


-(CubicSpline*) init
{
    resultCount = 0;
    queueValid = false;
    queueCount = 0;
    lock = [[NSRecursiveLock alloc] init];
    
    locationsArray = 0;
    
    y1 = 0;
    loc1 = 0;
    colorCount1 = 0;
    
    y = 0;
    h = 0;
    m = 0;
    result = 0;
    A = 0;
    r = 0;
    locations = 0;
    
    colorCount = 0;
    clamped = false;
    
    start = 0;
    end = 1;
    return self;
}

-(void)copyStagingBuffers
{
    memcpy(y, y1, colorCount1*sizeof(CGFloat));
    memcpy(locations, loc1, colorCount1*sizeof(CGFloat));
}

-(void) allocResultBuffer
{
    if (resultCount < 1)
    {
        resultCount = 0;
        return;
    }
    
    result   = malloc(resultCount*sizeof(CGFloat)*4);
}

-(void) allocStagingBuffers
{
    if (colorCount1 < 1)
    {
        colorCount1 = 0;
        return;
    }
    
    loc1   = malloc(colorCount1*sizeof(CGFloat));
    y1     = malloc(colorCount1*sizeof(CGFloat));
}

-(void) allocWorkingBuffers
{
    clamped = true;
    if (colorCount < 1)
    {
        colorCount = 0;
        return;
    }
    
    locations   = malloc(colorCount*sizeof(CGFloat));
    y           = malloc(colorCount*sizeof(CGFloat));
    h           = malloc(colorCount*sizeof(CGFloat));
    r           = malloc(colorCount*sizeof(CGFloat));
    m           = malloc(colorCount*sizeof(CGFloat));
    A           = malloc(colorCount*colorCount*sizeof(CGFloat)*4);
}

-(void)_build:(bool)clampedSpline colors:(CGFloat*)colors location:(CGFloat*)loc count:(int)count
{
    clamped = clampedSpline;
    int rowCount = colorCount;
    int colCount = 4;
    buildMatrixH(h, locations, rowCount);
    buildMatrixA(A, locations, y, h, rowCount, clamped);
    buildMatrixR(r, y, h, rowCount,clamped);
    gaussElimination(A,rowCount,r);
    backSubstitution(A,rowCount,r,m);
    [lock lock];
    if(!result)
    {
        resultCount =  colorCount;
        [self allocResultBuffer];
    }
    else if(resultCount != colorCount)
    {
        [self freeResultBufferIfAllocated];
        resultCount = colorCount;
        [self allocResultBuffer];
    }
    buildMatrixB(result, m, y, h, r, colCount, colorCount);
    [lock unlock];
}


-(int)build:(bool)clampedSpline colors:(CGFloat*)colors location:(CGFloat*)loc count:(int)count async:(bool)async
{
    [lock lock];
    if (!y1)
    {
        colorCount1 = count;
        [self allocStagingBuffers];
    }
    else if (count != colorCount1)
    {
        [self freeStagingBuffersIfAllocated];
        colorCount1 = count;
        [self allocStagingBuffers];
    }
    
    memcpy(y1, colors,colorCount1*sizeof(CGFloat));
    memcpy(loc1, loc,colorCount1*sizeof(CGFloat));
    
    if(queueCount < 1)
    {
        if (async == false)
        {
            if(colorCount1 != colorCount)
            {
                [self freeWorkingBuffersIfAllocated];
                colorCount = colorCount1;
                [self allocWorkingBuffers];
            }
            
            [self copyStagingBuffers];
            
            [self _build:clampedSpline colors:colors location:loc count:count];
            [lock unlock];
            return 1;
        }
        else
        {
            queueCount++;
            if(!queueValid)
            {
                serialQueue = dispatch_queue_create("spline", DISPATCH_QUEUE_SERIAL);
                queueValid = true;
            }
            
            dispatch_async(serialQueue, ^{
                [lock lock];
                if(colorCount1 != colorCount)
                {
                    [self freeWorkingBuffersIfAllocated];
                    colorCount = colorCount1;
                    [self allocWorkingBuffers];
                }
                [self copyStagingBuffers];
                queueCount--;
                [lock unlock];
                [self _build:clampedSpline colors:colors location:loc count:count];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (delegate){
                        [delegate splineDidComplete:self];
                    }
                });
            });
            [lock unlock];
            return 2;
        }
    }
    
    [lock unlock];
    return 0;
}



-(CGFloat*) result
{
    return result;
}


-(CGFloat*) locations
{
    return locations;
}


-(int) colorCount
{
    return colorCount;
}


-(void) freeWorkingBuffersIfAllocated
{
    clamped = true;
    colorCount = 0;
    free(y);           y           = 0;
    free(h);           h           = 0;
    free(m);           m           = 0;
    free(A);           A           = 0;
    free(r);           r           = 0;
    free(locations);   locations   = 0;
}

-(void) freeStagingBuffersIfAllocated
{
    colorCount1 = 0;
    free(y1);          y1          = 0;
    free(loc1);        loc1        = 0;
}

-(void) freeResultBufferIfAllocated
{
    resultCount = 0;
    free(result);          result          = 0;
}

-(void)dealloc {
    [self freeStagingBuffersIfAllocated];
    [self freeWorkingBuffersIfAllocated];
}

-(void)lock
{
    [lock lock];
}

-(void)unlock
{
    [lock unlock];
}

-(int)queueCount
{
    return queueCount;
}

-(int)resultCount
{
    return resultCount;
}

@end
