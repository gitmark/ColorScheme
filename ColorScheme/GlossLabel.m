/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  GlossLabel.m
//
//  Created by Mark Elrod on 12/27/12.
//

#import "GlossLabel.h"
#import "GlossFactory.h"

@interface GlossLabel ()
{
}
@end

@implementation GlossLabel
@synthesize glossRect;



- (BOOL) isOpaque {
    return NO;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initGlossRect];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initGlossRect];
}

-(bool) rect:(CGRect)r1 equals:(CGRect)r2
{
    if (r1.origin.x != r2.origin.x)
    {
        return false;
    }
    
    if (r1.origin.y != r2.origin.y)
    {
        return false;
    }
    
    if(r1.size.width != r2.size.width)
    {
        return false;
    }
    
    if(r1.size.height != r2.size.height)
    {
        return false;
    }
    
    return true;
}


-(void)initGlossRect
{
    UIColor* bkColor = self.backgroundColor;
    self.backgroundColor = nil;
    
    glossRect = getGlossRect(TextBackgroundType);
    [glossRect addDelegate:self];
    glossRect.rect = [self bounds];
    CGFloat radius = 10;
    glossRect.topLeftRadius = radius;
    glossRect.topRightRadius = radius;
    glossRect.bottomRightRadius = radius;
    glossRect.bottomLeftRadius = radius;
    
    if (bkColor)
    {
        //        self.color = bkColor;
    }
}


- (void)drawRect:(CGRect)rect
{
    CGRect bounds1 = self.bounds;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    if (!glossRect)
    {
        [self initGlossRect];
    }
    
    glossRect.rect = bounds1;
    CGFloat radius = 10;
    glossRect.topLeftRadius = radius;
    glossRect.topRightRadius = radius;
    glossRect.bottomRightRadius = radius;
    glossRect.bottomLeftRadius = radius;
    [glossRect buildRects];
    [glossRect draw:c];
}


-(UIColor *)color
{
    return glossRect.color;
}

-(void)setColor:(UIColor*)color
{
    glossRect.color = color;
}

-(CGFloat)glow
{
    return glossRect.glow;
}

-(void)setGlow:(CGFloat)glow
{
    glossRect.glow = glow;
}

-(CGFloat)gloss
{
    return glossRect.gloss;
}

-(void)setGloss:(CGFloat)gloss
{
    glossRect.gloss = gloss;
}

-(CGFloat)shadow
{
    return glossRect.shadow;
}

-(void)setShadow:(CGFloat)shadow
{
    glossRect.shadow = shadow;
}


-(void)setAllCornersToRadius:(CGFloat)radius
{
    [glossRect setAllCornersToRadius:radius];
}

-(void)glossDidComplete:(GlossRect *)theGlossRect
{
    [self setNeedsDisplay];
}

@end
