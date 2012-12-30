/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  GlossView.m
//
//  Created by Mark Elrod on 12/17/12.
//

#import "GlossView.h"
#import "GlossFactory.h"

@implementation GlossView
@synthesize glossRect, topMargin, bottomMargin, leftMargin, rightMargin, type;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initGlossRect];
    }
    return self;
}

-(void)initGlossRect
{
    glossRect = getGlossRect(type);
    [glossRect addDelegate:self];
    [glossRect setAllCornersToRadius:10];
    position = 0;
    topMargin = 0;
    bottomMargin = 0;
    leftMargin = 0;
    rightMargin = 0;
    
}

-(GlossView*)initWithType:(int)type1
{
    type = type1;
    self = [super init];
    return self;
}

- (BOOL) isOpaque {
    return NO;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();

    CGFloat radius = 10;
    
    // todo use enum
    
    switch(self.position)
    {
        case 1: // top
            glossRect.topLeftRadius = radius;
            glossRect.topRightRadius = radius;
            glossRect.bottomRightRadius = 0;
            glossRect.bottomLeftRadius = 0;
            break;
            
        case 2: // middle
            glossRect.topLeftRadius = 0;
            glossRect.topRightRadius = 0;
            glossRect.bottomRightRadius = 0;
            glossRect.bottomLeftRadius = 0;
            break;
            
        case 3: // bottom
            glossRect.topLeftRadius = 0;
            glossRect.topRightRadius = 0;
            glossRect.bottomRightRadius = radius;
            glossRect.bottomLeftRadius = radius;
            break;
            
        default:
        case 0: //single
            glossRect.topLeftRadius = radius;
            glossRect.topRightRadius = radius;
            glossRect.bottomRightRadius = radius;
            glossRect.bottomLeftRadius = radius;
            break;
            
    }
    
    CGRect marginBounds = CGRectMake(self.bounds.origin.x + leftMargin, self.bounds.origin.y + topMargin, self.bounds.size.width - leftMargin - rightMargin, self.bounds.size.height - topMargin - bottomMargin);
    
    glossRect.rect = marginBounds;
    [glossRect buildRects];
    [glossRect draw:c];
}

- (void)setPosition:(int)pos {
    if (position != pos) {
        position = pos;
        [self setNeedsDisplay];
    }
}

-(int)position
{
    return position;
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

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initGlossRect];
}

-(void)glossDidComplete:(GlossRect *)theGlossRect
{
    [self setNeedsDisplay];
}

@end
