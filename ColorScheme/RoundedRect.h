/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  RoundedRect.h
//
//  Created by Mark Elrod on 12/16/12.
//

#import <Foundation/Foundation.h>
#import "RoundedBar.h"

enum ViewPosition
{
    TopView = 1,
    MiddleView,
    BottomView,
    SingleView
};

@interface RoundedRect : NSObject
{
}

-(RoundedRect*)init;
-(void)draw:(CGContextRef)c;
-(void)setAllCornersToRadius:(CGFloat)radius;

@property (nonatomic) CGFloat topLeftRadius;
@property (nonatomic) CGFloat topRightRadius;
@property (nonatomic) CGFloat bottomLeftRadius;
@property (nonatomic) CGFloat bottomRightRadius;
@property (nonatomic) CGRect rect;
@property (nonatomic,strong) RoundedBar* roundedBar;
@property (nonatomic) CGFloat xFillOffset;
@property (nonatomic) CGFloat yFillOffset;
@property (nonatomic) CGFloat fillScale;
@property (nonatomic) bool border;
@end
