/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  GlossRect.m
//
//  Created by Mark Elrod on 12/17/12.
//

#import "GlossRect.h"
#import "RoundedRect.h"

@interface GlossRect ()
{
    CGFloat origShadow;
    CGFloat origGloss;
    CGFloat gloss;
    CGFloat shadow;
    SmoothGradient *    glossGradient;
    RoundedBar *        glossBar;
    RoundedRect *       glossRect;
    
    SmoothGradient *    shadowGradient;
    RoundedBar *        shadowBar;
    RoundedRect *       shadowRect;
}

@end

@implementation GlossRect
@synthesize async;

-(bool)stateChanged
{
    if ([super stateChanged])
    {
        return true;
    }
    
    if (origShadow != shadow)
    {
        return true;
    }
    
    if (self.origGlow != self.glow)
    {
        return true;
    }
    
    if (origGloss != gloss)
    {
        return true;
    }
    
    
    return false;
}

-(GlossRect*)init
{
    self = [super init];
    delegates = [[NSMutableArray alloc] init];
    
    self.glowPosition = 0.7;
    origShadow = 0.12345;
    origGloss  = 0.12345;
    gloss = 1;
    shadow = 1;
    glossGradient   = 0;
    glossBar        = 0;
    glossRect       = 0;
    [self.roundedBar.smoothGradient addDelegate: self];
    
    glossGradient = [[SmoothGradient alloc] init];
    [glossGradient addDelegate:self];
    glossRect = [[RoundedRect alloc] init];
    glossBar = [[RoundedBar alloc] initWithRect:CGRectMake(0,
                                                           0,
                                                           10,
                                                           10)
                                       gradient:glossGradient];
    glossRect.roundedBar = glossBar;
    
    
    shadowGradient = [[SmoothGradient alloc] init];
    [shadowGradient addDelegate:self];
    
    return self;
}

-(void)setOrigState
{
    [super setOrigState];
    origShadow = shadow;
    origGloss = gloss;
}

-(CGFloat) clampRadius
{
    CGFloat maxRadiusFound = 0;
    CGFloat maxRadius = 0;
    
    if (self.rect.size.width < self.rect.size.height)
    {
        maxRadius = self.rect.size.width/2;
    }
    else
    {
        maxRadius = self.rect.size.height/2;
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
    
    CGFloat radius = [self clampRadius];
    
    self.fillScale = 1;
    self.xFillOffset = 0;
    
    
    CGFloat glossRectHeight;
    CGFloat glossRectWidth;
    CGFloat glossRectTopMargin;
    CGFloat glossRectLeftMargin;
    
    CGFloat glossBarHeight;
    CGFloat glossBarWidth;
    CGFloat glossBarTopMargin;
    CGFloat glossBarLeftMargin;
    
    int orient = self.orientation;
    
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
    
    if(orient == ORIENT_HORIZONTAL)
    {
        glossRectTopMargin  = 0.04*self.rect.size.height;;
        glossRectLeftMargin = radius*radius/self.rect.size.height + glossRectTopMargin*(1-2.0f*radius/self.rect.size.height);
        glossRectHeight     = self.rect.size.height/2.0f;
        glossRectWidth      = self.rect.size.width - 2.0f*glossRectLeftMargin; // - glossRightMargin;
        glossBarLeftMargin  = -self.rect.size.width;
        glossBarHeight      = self.rect.size.height*2;
        glossBarWidth       = self.rect.size.width - 2.0f*glossBarLeftMargin ;
        glossBarTopMargin   = - glossBarHeight/2 + glossRectHeight + glossRectTopMargin;
    }
    else
    {
        glossRectLeftMargin = 0.04*self.rect.size.width;
        glossRectTopMargin  = radius*radius/self.rect.size.width + glossRectLeftMargin*(1-2.0f*radius/self.rect.size.width);
        glossRectHeight     = self.rect.size.height - glossRectTopMargin*2.0f;
        glossRectWidth      = self.rect.size.width / 2.0f;
        glossBarTopMargin   = -self.rect.size.height;
        glossBarHeight      = self.rect.size.height - glossBarTopMargin*2;
        glossBarWidth       = self.rect.size.width*2;
        glossBarLeftMargin  = -glossBarWidth/2 + glossRectWidth + glossRectLeftMargin;
    }
    
    glossBar.rect = CGRectMake(self.rect.origin.x + glossBarLeftMargin,
                               self.rect.origin.y + glossBarTopMargin,
                               glossBarWidth,
                               glossBarHeight);
    
    
    
    glossRect.rect = CGRectMake(self.rect.origin.x + glossRectLeftMargin,
                                self.rect.origin.y + glossRectTopMargin,
                                glossRectWidth,
                                glossRectHeight);
    
    
    
    
    CGFloat div = 1;
    if (orient == ORIENT_HORIZONTAL)
    {
        div = self.rect.size.height;
    }
    else
    {
        div = self.rect.size.width;
    }
    
    
    shadowBar.radius = radius;
    glossRect.fillScale = 1;
    glossRect.xFillOffset = 0;
    glossRect.yFillOffset = 0;
    glossRect.topLeftRadius = self.topLeftRadius/(1.0 + 2.0f*(self.topLeftRadius/div));
    glossRect.topRightRadius = self.topRightRadius/(1.0 + 2.0f*(self.topRightRadius/div));
    glossRect.bottomRightRadius = self.bottomRightRadius/(1.0 + 2.0f*(self.bottomRightRadius/div));
    glossRect.bottomLeftRadius = self.bottomLeftRadius/(1.0 + 2.0f*(self.bottomLeftRadius/div));
    
    if (shadow != origShadow)
    {
        [shadowGradient removeAllColors];
        [shadowGradient addColorRed:0 green:0 blue:0 alpha:self.shadow location:0.0];
        [shadowGradient addColorRed:0 green:0 blue:0 alpha:0*self.shadow location:0.5];
        [shadowGradient addColorRed:0 green:0 blue:0 alpha:self.shadow location:1.0];
        [shadowGradient buildWithSmoothBoundary:async  colors:BUILD_RED|BUILD_GREEN|BUILD_BLUE|BUILD_ALPHA];
        origShadow = shadow;
    }
    
    CGFloat shadowRectHeight;
    CGFloat shadowRectWidth;
    CGFloat shadowRectTopMargin;
    CGFloat shadowRectLeftMargin;
    
    CGFloat shadowBarHeight;
    CGFloat shadowBarWidth;
    CGFloat shadowBarTopMargin;
    CGFloat shadowBarLeftMargin;
    
    if(orient == ORIENT_HORIZONTAL)
    {
        shadowRectHeight     = self.rect.size.height;
        shadowRectTopMargin  = self.rect.size.height - shadowRectHeight;
        shadowRectLeftMargin = 0;
        shadowRectWidth      = self.rect.size.width - 2.0f*shadowRectLeftMargin; // - shadowRightMargin;
        shadowBarLeftMargin  = -self.rect.size.width;
        shadowBarHeight      = self.rect.size.height*2.5;
        shadowBarWidth       = self.rect.size.width - 2.0f*shadowBarLeftMargin ;
        shadowBarTopMargin   = - shadowBarHeight/2 + shadowRectTopMargin;
    }
    else
    {
        shadowRectWidth      = self.rect.size.width;// done
        shadowRectLeftMargin = self.rect.size.width - shadowRectWidth; //done
        shadowRectTopMargin  = 0; //done
        shadowRectHeight     = self.rect.size.height - shadowRectTopMargin*2.0f; //done
        shadowBarTopMargin   = -self.rect.size.height; //done ???
        shadowBarHeight      = self.rect.size.height - shadowBarTopMargin*2; //done
        shadowBarWidth       = self.rect.size.width*2.5;
        shadowBarLeftMargin  = -shadowBarWidth/2 + shadowRectLeftMargin;
    }
    
    shadowBar.rect = CGRectMake(self.rect.origin.x + shadowBarLeftMargin,
                                self.rect.origin.y + shadowBarTopMargin,
                                shadowBarWidth,
                                shadowBarHeight);
    
    
    shadowRect.rect = CGRectMake(self.rect.origin.x + shadowRectLeftMargin,
                                 self.rect.origin.y + shadowRectTopMargin,
                                 shadowRectWidth,
                                 shadowRectHeight);
    
    
    shadowBar.radius = radius;
    shadowRect.fillScale = 1;
    shadowRect.xFillOffset = 0;
    shadowRect.yFillOffset = 0;
    shadowRect.topLeftRadius = self.topLeftRadius;
    shadowRect.topRightRadius = self.topRightRadius;
    shadowRect.bottomRightRadius = self.bottomRightRadius;
    shadowRect.bottomLeftRadius = self.bottomLeftRadius;
    [super buildRects];
}



-(void)buildGradients:(bool)async1
{
    
    CGFloat radius = [self clampRadius];
    
    self.fillScale = 1;
    self.xFillOffset = 0;
    
    if (gloss != origGloss)
    {
        [glossGradient removeAllColors];
        [glossGradient addColorRed:1.0 green:1.0 blue:1.0 alpha:0.8*gloss location:0.0];
        [glossGradient addColorRed:1.0 green:1.0 blue:1.0 alpha:0.18*gloss location:0.5];
        [glossGradient addColorRed:1.0 green:1.0 blue:1.0 alpha:0.8*gloss location:1.0];
        
        [glossGradient buildWithSmoothBoundary:async1  colors:BUILD_RED|BUILD_GREEN|BUILD_BLUE|BUILD_ALPHA];
        origGloss = gloss;
    }
    
    CGFloat glossRectHeight;
    CGFloat glossRectWidth;
    CGFloat glossRectTopMargin;
    CGFloat glossRectLeftMargin;
    
    CGFloat glossBarHeight;
    CGFloat glossBarWidth;
    CGFloat glossBarTopMargin;
    CGFloat glossBarLeftMargin;
    
    int orient = self.orientation;
    
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
    
    if(orient == ORIENT_HORIZONTAL)
    {
        glossRectTopMargin  = 0.04*self.rect.size.height;;
        glossRectLeftMargin = radius*radius/self.rect.size.height + glossRectTopMargin*(1-2.0f*radius/self.rect.size.height);
        glossRectHeight     = self.rect.size.height/2.0f;
        glossRectWidth      = self.rect.size.width - 2.0f*glossRectLeftMargin; // - glossRightMargin;
        glossBarLeftMargin  = -self.rect.size.width;
        glossBarHeight      = self.rect.size.height*2;
        glossBarWidth       = self.rect.size.width - 2.0f*glossBarLeftMargin ;
        glossBarTopMargin   = - glossBarHeight/2 + glossRectHeight + glossRectTopMargin;
    }
    else
    {
        glossRectLeftMargin = 0.04*self.rect.size.width;
        glossRectTopMargin  = radius*radius/self.rect.size.width + glossRectLeftMargin*(1-2.0f*radius/self.rect.size.width);
        glossRectHeight     = self.rect.size.height - glossRectTopMargin*2.0f;
        glossRectWidth      = self.rect.size.width / 2.0f;
        glossBarTopMargin   = -self.rect.size.height;
        glossBarHeight      = self.rect.size.height - glossBarTopMargin*2;
        glossBarWidth       = self.rect.size.width*2;
        glossBarLeftMargin  = -glossBarWidth/2 + glossRectWidth + glossRectLeftMargin;
    }
    
    glossBar.rect = CGRectMake(self.rect.origin.x + glossBarLeftMargin,
                               self.rect.origin.y + glossBarTopMargin,
                               glossBarWidth,
                               glossBarHeight);
    
    
    
    glossRect.rect = CGRectMake(self.rect.origin.x + glossRectLeftMargin,
                                self.rect.origin.y + glossRectTopMargin,
                                glossRectWidth,
                                glossRectHeight);
    
    
    
    
    CGFloat div = 1;
    if (self.rect.size.width >= self.rect.size.height)
    {
        div = self.rect.size.height;
    }
    else
    {
        div = self.rect.size.width;
    }
    
    
    shadowBar.radius = radius;
    glossRect.fillScale = 1;
    glossRect.xFillOffset = 0;
    glossRect.yFillOffset = 0;
    glossRect.topLeftRadius = self.topLeftRadius/(1.0 + 2.0f*(self.topLeftRadius/div));
    glossRect.topRightRadius = self.topRightRadius/(1.0 + 2.0f*(self.topRightRadius/div));
    glossRect.bottomRightRadius = self.bottomRightRadius/(1.0 + 2.0f*(self.bottomRightRadius/div));
    glossRect.bottomLeftRadius = self.bottomLeftRadius/(1.0 + 2.0f*(self.bottomLeftRadius/div));
    
    if (shadow != origShadow)
    {
        [shadowGradient removeAllColors];
        [shadowGradient addColorRed:0 green:0 blue:0 alpha:self.shadow location:0.0];
        [shadowGradient addColorRed:0 green:0 blue:0 alpha:0*self.shadow location:0.5];
        [shadowGradient addColorRed:0 green:0 blue:0 alpha:self.shadow location:1.0];
        [shadowGradient buildWithSmoothBoundary:async  colors:BUILD_RED|BUILD_GREEN|BUILD_BLUE|BUILD_ALPHA];
        origShadow = shadow;
    }
    
    CGFloat shadowRectHeight;
    CGFloat shadowRectWidth;
    CGFloat shadowRectTopMargin;
    CGFloat shadowRectLeftMargin;
    
    CGFloat shadowBarHeight;
    CGFloat shadowBarWidth;
    CGFloat shadowBarTopMargin;
    CGFloat shadowBarLeftMargin;
    
    if(orient == ORIENT_HORIZONTAL)
    {
        shadowRectHeight     = self.rect.size.height;
        shadowRectTopMargin  = self.rect.size.height - shadowRectHeight;
        shadowRectLeftMargin = 0;
        shadowRectWidth      = self.rect.size.width - 2.0f*shadowRectLeftMargin; // - shadowRightMargin;
        shadowBarLeftMargin  = -self.rect.size.width;
        shadowBarHeight      = self.rect.size.height*2.5;
        shadowBarWidth       = self.rect.size.width - 2.0f*shadowBarLeftMargin ;
        shadowBarTopMargin   = - shadowBarHeight/2 + shadowRectTopMargin;
    }
    else
    {
        shadowRectWidth      = self.rect.size.width;// done
        shadowRectLeftMargin = self.rect.size.width - shadowRectWidth; //done
        shadowRectTopMargin  = 0; //done
        shadowRectHeight     = self.rect.size.height - shadowRectTopMargin*2.0f; //done
        shadowBarTopMargin   = -self.rect.size.height; //done ???
        shadowBarHeight      = self.rect.size.height - shadowBarTopMargin*2; //done
        shadowBarWidth       = self.rect.size.width*2.5;
        shadowBarLeftMargin  = -shadowBarWidth/2 + shadowRectLeftMargin;
    }
    
    shadowBar = [[RoundedBar alloc] initWithRect:CGRectMake(self.rect.origin.x + shadowBarLeftMargin,
                                                            self.rect.origin.y + shadowBarTopMargin,
                                                            shadowBarWidth,
                                                            shadowBarHeight)
                                        gradient:shadowGradient];
    shadowRect = [[RoundedRect alloc] init];
    
    shadowRect.rect = CGRectMake(self.rect.origin.x + shadowRectLeftMargin,
                                 self.rect.origin.y + shadowRectTopMargin,
                                 shadowRectWidth,
                                 shadowRectHeight);
    
    shadowRect.roundedBar = shadowBar;
    
    shadowBar.radius = radius;
    shadowRect.fillScale = 1;
    shadowRect.xFillOffset = 0;
    shadowRect.yFillOffset = 0;
    shadowRect.topLeftRadius = self.topLeftRadius;
    shadowRect.topRightRadius = self.topRightRadius;
    shadowRect.bottomRightRadius = self.bottomRightRadius;
    shadowRect.bottomLeftRadius = self.bottomLeftRadius;
    
    
    [super buildGradients:async1];
}

-(void)draw:(CGContextRef)c
{
    if(!self.ready || [self stateChanged])
    {
        [self buildGradients:false];
    }
    
    [super draw:c];
    
    [glossRect draw:c];
    
    [shadowRect draw:c];
    
}

-(void)setTopLeftRadius:(CGFloat)radius;
{
    [super setTopLeftRadius:radius];
    glossRect.topLeftRadius = radius;
    shadowRect.topLeftRadius = radius;
}

-(void)setTopRightRadius:(CGFloat)radius;
{
    [super setTopRightRadius:radius];
    glossRect.topRightRadius = radius;
    shadowRect.topRightRadius = radius;
}

-(void)setBottomLeftRadius:(CGFloat)radius;
{
    [super setBottomLeftRadius:radius];
    glossRect.bottomLeftRadius = radius;
    shadowRect.bottomLeftRadius = radius;
}

-(void)setBottomRightRadius:(CGFloat)radius;
{
    [super setBottomRightRadius:radius];
    glossRect.bottomRightRadius = radius;
    shadowRect.bottomRightRadius = radius;
}

-(void)gradientDidComplete:(SmoothGradient *)theGradient
{
    for(id delegate in delegates)
    {
        [delegate glossDidComplete:self];
    }
}

-(void)setColor:(UIColor*)c
{
    [super setColor:c];
    if (self.async)
    {
        if([self stateChanged])
        {
            [self buildGradients:true];
        }
    }
    
}

-(UIColor*)color
{
    return [super color];
}

-(void)setGloss:(CGFloat)g
{
    gloss = g;
    if (self.async)
    {
        if([self stateChanged])
        {
            [self buildGradients:true];
        }
    }
    
}

-(CGFloat)gloss
{
    return gloss;
}

-(void)setShadow:(CGFloat)s
{
    shadow = s;
    if (self.async)
    {
        if([self stateChanged])
        {
            [self buildGradients:true];
        }
    }
    
}

-(CGFloat)shadow
{
    return shadow;
}

-(void)addDelegate:(id)delegate
{
    [delegates insertObject:delegate atIndex:delegates.count];
}

@end
