/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  GlossNavigationBar.m
//
//  Created by Mark Elrod on 12/20/12.
//

#import "GlossNavigationBar.h"
#import "GlossRect.h"
#import "GlossFactory.h"

@implementation GlossNavigationBar

@synthesize glossRect;

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
    glossRect = getGlossRect(NavBarType);
    [glossRect addDelegate:self];
    [glossRect setAllCornersToRadius:10];
}

- (BOOL) isOpaque {
    return NO;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef c = UIGraphicsGetCurrentContext();
    
     CGContextSetFillColorWithColor (c, [[UIColor blackColor] CGColor ]);
     
     CGRect r2 = [self bounds];
     CGContextAddRect(c, r2);
     CGContextClosePath(c);
     CGContextFillPath(c);
    
    glossRect.rect = [self bounds];
    [glossRect setAllCornersToRadius: 0];
    [glossRect buildRects];
    [glossRect draw:c];
    CGFloat imageWidth = 170;
    CGFloat imageHeight = 30;
    UIImage *image = [UIImage imageNamed:@"ColorSchemeLogo.png"];
    [image drawInRect:CGRectMake(self.bounds.size.width/2 - imageWidth/2, self.bounds.size.height/2 - imageHeight/2, imageWidth, imageHeight)];
 
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
