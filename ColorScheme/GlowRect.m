/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  GlowRect.m
//
//  Created by Mark Elrod on 12/17/12.
//

#import "GlowRect.h"
#import "RoundedRect.h"

@implementation GlowRect
@synthesize rect, glowPosition, ready, origGlow, async, orientation;

-(bool)stateChanged
{
    if (origGlow != glow)
    {
        return true;
    }
    const CGFloat * comp = CGColorGetComponents(color.CGColor);
    
    for (int i = 0; i < 4; i++)
    {
        if (origColorComponents[i] != comp[i])
        {
            return true;
        }
    }
    return false;
}

-(GlowRect*)init
{
    orientation = ORIENT_AUTO;
    async = false;
    memset(origColorComponents, 0, 4*sizeof(CGFloat));
    glowPosition = 0.5;
    origGlow = 0.12345;
    glow = 0.5;
    self.color = [[UIColor alloc] initWithRed:1 green:75.0f/255 blue:150.0f/255 alpha:1];
    glowGradient = [[SmoothGradient alloc] init];
    glowBar = [[RoundedBar alloc] initWithRect:CGRectMake(0,
                                                          0,
                                                          100,
                                                          100)
                                      gradient:glowGradient];
    self.roundedBar = glowBar;
    
    ready = false;
    self.border = true;
    return self;
}

-(void)setOrigState
{
    origGlow = glow;
    const CGFloat * comp = CGColorGetComponents(color.CGColor);
    memcpy(origColorComponents, comp, 4*sizeof(CGFloat));
}

-(CGFloat) clampRadius
{
    CGFloat maxRadiusFound = 0;
    CGFloat maxRadius = 0;
    
    if (rect.size.width < rect.size.height)
    {
        maxRadius = rect.size.width/2;
    }
    else
    {
        maxRadius = rect.size.height/2;
    }
    
    
    if(self.topLeftRadius > 0)
    {
        if (self.topLeftRadius > maxRadius)
        {
            self.topLeftRadius = maxRadius;
        }
    }
    
    if(self.topRightRadius > 0)
    {
        if (self.topRightRadius > maxRadius)
        {
            self.topRightRadius = maxRadius;
        }
    }
    
    if(self.bottomRightRadius > 0)
    {
        if (self.bottomRightRadius > maxRadius)
        {
            self.bottomRightRadius = maxRadius;
        }
    }
    
    if(self.bottomLeftRadius > 0)
    {
        if (self.bottomLeftRadius > maxRadius)
        {
            self.bottomLeftRadius = maxRadius;
        }
    }
    
    if (maxRadiusFound < self.topLeftRadius)
    {
        maxRadiusFound = self.topLeftRadius;
    }
    
    if (maxRadiusFound < self.topRightRadius)
    {
        maxRadiusFound = self.topRightRadius;
    }
    
    if (maxRadiusFound < self.bottomRightRadius)
    {
        maxRadiusFound = self.bottomRightRadius;
    }
    
    if (maxRadiusFound < self.bottomLeftRadius)
    {
        maxRadiusFound = self.bottomLeftRadius;
    }
    
    return maxRadiusFound;
}

-(void)buildRects
{
    
    CGFloat glowBarHeight;
    CGFloat glowBarWidth;
    CGFloat leftMargin;
    CGFloat rightMargin;
    CGFloat topMargin;
    
    int orient = orientation;
    
    if(orient == ORIENT_AUTO)
    {
        if(self.rect.size.width >= self.rect.size.height)
        {
            orient = ORIENT_HORIZONTAL;
        }
        else
        {
            orient = ORIENT_VERTICAL;
        }
    }
    
    if (orient == ORIENT_HORIZONTAL)
    {
        leftMargin = -(int)(0.03*self.rect.size.width);
        rightMargin = -(int)(0.03*self.rect.size.width);
        topMargin = (self.rect.size.height/2.0f) *(glowPosition - 0.5f)*2.0f;
        glowBarHeight = self.rect.size.height;
        glowBarWidth = self.rect.size.width - leftMargin - rightMargin;
    }
    else
    {
        leftMargin = (self.rect.size.width/2.0f) *(glowPosition - 0.5f)*2.0f;
        rightMargin = 0;
        topMargin = -(int)(0.03*self.rect.size.height);
        glowBarHeight = self.rect.size.height - 2*topMargin;
        glowBarWidth = self.rect.size.width;
    }
    
    
    glowBar.rect = CGRectMake(self.rect.origin.x + leftMargin,
                              self.rect.origin.y + topMargin,
                              glowBarWidth,
                              glowBarHeight);
    
    
    
    self.fillScale = 1;
    self.xFillOffset = 0;
}



-(void)buildGradients:(bool)async1
{
    const CGFloat *comp = CGColorGetComponents(self.color.CGColor);
    int changedColors = 0;
    
    if (glow != origGlow)
    {
        changedColors = BUILD_RED|BUILD_GREEN|BUILD_BLUE|BUILD_ALPHA;
    }
    
    changedColors |= (comp[0] != origColorComponents[0])?BUILD_RED:0;
    changedColors |= (comp[1] != origColorComponents[1])?BUILD_GREEN:0;
    changedColors |= (comp[2] != origColorComponents[2])?BUILD_BLUE:0;
    changedColors |= (comp[3] != origColorComponents[3])?BUILD_ALPHA:0;
    
    CGFloat r1 = comp[0];
    CGFloat g1 = comp[1];
    CGFloat b1 = comp[2];
    CGFloat a1 = comp[3];
    
    // calc deltas
    CGFloat rd1 = 1 - r1;
    CGFloat gd1 = 1 - g1;
    CGFloat bd1 = 1 - b1;
    CGFloat ad1 = 1 - a1;
    
    // calc hilite color
    CGFloat r2 = (1 - rd1*rd1*rd1)*glow + r1*(1.0-glow);
    CGFloat g2 = (1 - gd1*gd1*gd1)*glow + g1*(1.0-glow);
    CGFloat b2 = (1 - bd1*bd1*bd1)*glow + b1*(1.0-glow);
    CGFloat a2 = (1 - ad1*ad1*ad1)*glow + a1*(1.0-glow);
    
    [glowGradient removeAllColors];
    [glowGradient addColorRed:r1 green:g1 blue:b1 alpha:a1 location:0.0];
    [glowGradient addColorRed:r2 green:g2 blue:b2 alpha:a2 location:0.5];
    [glowGradient addColorRed:r1 green:g1 blue:b1 alpha:a1 location:1.0];
    
    [glowGradient buildWithSmoothBoundary:async1 colors:changedColors];
    
    CGFloat glowBarHeight;
    CGFloat glowBarWidth;
    CGFloat leftMargin;
    CGFloat rightMargin;
    CGFloat topMargin;
    
    int orient = orientation;
    
    if(orient == ORIENT_AUTO)
    {
        if(self.rect.size.width >= self.rect.size.height)
        {
            orient = ORIENT_HORIZONTAL;
        }
        else
        {
            orient = ORIENT_VERTICAL;
        }
    }
    
    if (orient == ORIENT_HORIZONTAL)
    {
        leftMargin = -(int)(0.03*self.rect.size.width);
        rightMargin = -(int)(0.03*self.rect.size.width);
        topMargin = (self.rect.size.height/2.0f) *(glowPosition - 0.5f)*2.0f;
        glowBarHeight = self.rect.size.height;
        glowBarWidth = self.rect.size.width - leftMargin - rightMargin;
    }
    else
    {
        leftMargin = (self.rect.size.width/2.0f) *(glowPosition - 0.5f)*2.0f;
        rightMargin = 0;
        topMargin = -(int)(0.03*self.rect.size.height);
        glowBarHeight = self.rect.size.height - 2*topMargin;
        glowBarWidth = self.rect.size.width;
    }
    
    
    glowBar.rect = CGRectMake(self.rect.origin.x + leftMargin,
                              self.rect.origin.y + topMargin,
                              glowBarWidth,
                              glowBarHeight);
    
    self.fillScale = 1;
    self.xFillOffset = 0;
    
    [self setOrigState];
    ready = true;
}

-(void)draw:(CGContextRef)c
{
    if(!ready || [self stateChanged])
    {
        [self buildGradients:false];
    }
    
    [super draw:c];
}

-(CGFloat *)origColorComponents
{
    return origColorComponents;
}

-(void)setColor:(UIColor*)c
{
    color = c;
}

-(UIColor*)color
{
    return color;
}

-(void)setGlow:(CGFloat)g
{
    glow = g;
    if (self.async)
    {
        if([self stateChanged])
        {
            [self buildGradients:true];
        }
    }
    
}

-(CGFloat)glow
{
    return glow;
}
@end
