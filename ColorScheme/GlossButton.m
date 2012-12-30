/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  GlossButton.m
//
//  Created by Mark Elrod on 12/18/12.
//

#import "GlossButton.h"
#import "GlossRect.h"
#import "GlossFactory.h"

@interface GlossButton ()
{
    GlossRect * highlightedGlossRect;
    CGRect initBounds;
    CGRect initFrame;
}
@end

@implementation GlossButton
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

-(void)postInit
{
    CGRect bounds1 = self.bounds;
    CGRect frame1 = self.frame;
    bool changed = false;
    
    
    if (![self rect:bounds1 equals:initBounds])
    {
        [self setBounds: initBounds];
        changed = true;
    }
    
    if (![self rect:frame1 equals:initFrame])
    {
        [self setFrame: initFrame];
        changed = true;
    }
    
    if (changed)
    {
        [self setNeedsDisplay];
        return;
    }
}

-(void)initGlossRect
{
    UIColor* bkColor = self.backgroundColor;
    self.backgroundColor = nil;
    
    initBounds = self.bounds;
    initFrame = self.frame;
    
    CGFloat radius = 10;
    
    // todo, get highlight from factory
    highlightedGlossRect = [[GlossRect alloc] init];
    [highlightedGlossRect addDelegate:self];
    highlightedGlossRect.color = [[UIColor alloc]initWithRed:1 green:0.3 blue:0.1 alpha:1];
    highlightedGlossRect.topLeftRadius = radius;
    highlightedGlossRect.topRightRadius = radius;
    highlightedGlossRect.bottomRightRadius = radius;
    highlightedGlossRect.bottomLeftRadius = radius;
    highlightedGlossRect.glow = 0.7;
    highlightedGlossRect.gloss = 0.7;
    
    glossRect = getGlossRect(ButtonType);
    
    [glossRect addDelegate:self];
    glossRect.rect = [self bounds];
    glossRect.topLeftRadius = radius;
    glossRect.topRightRadius = radius;
    glossRect.bottomRightRadius = radius;
    glossRect.bottomLeftRadius = radius;
    [glossRect buildRects];
    
    self.color = glossRect.color;
    
    if (bkColor)
    {
        //       self.color = bkColor;
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
    
    CGFloat radius = 10;
    glossRect.topLeftRadius = radius;
    glossRect.topRightRadius = radius;
    glossRect.bottomRightRadius = radius;
    glossRect.bottomLeftRadius = radius;
    
    if([self state] == UIControlStateHighlighted)
    {
        highlightedGlossRect.rect = bounds1;
        [highlightedGlossRect draw:c];
    }
    else
    {
        glossRect.rect = bounds1;
        [glossRect buildRects];
        [glossRect draw:c];
    }
}

+ (id)buttonWithType:(UIButtonType)buttonType {
    return [super buttonWithType:buttonType];
}

-(UIColor *)color
{
    return glossRect.color;
}

-(void)setColor:(UIColor*)color
{
    glossRect.color = color;
    highlightedGlossRect.color = color;
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
    highlightedGlossRect.gloss = gloss;
}

-(CGFloat)shadow
{
    return glossRect.shadow;
}

-(void)setShadow:(CGFloat)shadow
{
    glossRect.shadow = shadow;
    highlightedGlossRect.shadow = shadow;
}

-(void) setHighlighted:(BOOL)highlighted
{;
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

-(void)setAllCornersToRadius:(CGFloat)radius
{
    [glossRect setAllCornersToRadius:radius];
    [highlightedGlossRect setAllCornersToRadius:radius];
}

-(void)glossDidComplete:(GlossRect *)theGlossRect
{
    [self setNeedsDisplay];
}

-(bool)async
{
    return glossRect.async;
}

-(void)setAsync:(bool)a
{
    glossRect.async = a;
}

@end
