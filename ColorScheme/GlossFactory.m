/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */



#import "GlossFactory.h"
NSMutableArray *glossRects = 0;
GlossRect *nullObject;
char* glossRectNames[] = {
    "Background",
    "Button",
    "NavBar",
    "TableHeader",
    "TableCell",
    "TextBackground"
};

#define GLOSS_RECT_COUNT 6
#define GRADIENT_COUNT 1
#define COLOR_COUNT 7

NSString * glossRectToString(GlossRect *glossRect, NSString *name, int format)
{
    const CGFloat * comp1 = CGColorGetComponents(glossRect.color.CGColor);
    int comp2[4];
    
    if(format == 1)
    {
        return [NSString stringWithFormat:@"item name: %@\r\nred: %f\r\ngreen: %f\r\nblue: %f\r\nalpha: %f\r\ngloss: %f\r\nglow: %f\r\nshadow: %f\r\n\r\n", name, comp1[0], comp1[1], comp1[2], comp1[3], glossRect.gloss, glossRect.glow, glossRect.shadow];
    }
    
    for(int i = 0; i < 4; i++)
    {
        comp2[i] = round(comp1[i]*255.0);
    }
    
    return [NSString stringWithFormat:@"item name: %@\r\nred: %i\r\ngreen: %i\r\nblue: %i\r\nalpha: %i\r\ngloss: %f\r\nglow: %f\r\nshadow: %f\r\n\r\n", name, comp2[0], comp2[1], comp2[2], comp2[3], glossRect.gloss, glossRect.glow, glossRect.shadow];
}

NSString * buildGlossRectReport(int format)
{
    NSMutableString * result = [[NSMutableString alloc] init];
    
    for(int i = ButtonType; i <= TextBackgroundType; i++)
    {
        GlossRect *glossRect = glossRects[i];
        [result appendString:glossRectToString(glossRect, [[NSString alloc] initWithUTF8String:glossRectNames[i]], format)];
    }
    return result;
}



NSString * colorToString(UIColor* color, int format)
{
    const CGFloat * comp1 = CGColorGetComponents(color.CGColor);
    int comp2[4];
    
    if(format == 1)
    {
        return [NSString stringWithFormat:@"red: %f\r\ngreen: %f\r\nblue: %f\r\nalpha: %f\r\n", comp1[0], comp1[1], comp1[2], comp1[3]];
    }
    
    for(int i = 0; i < 4; i++)
    {
        comp2[i] = round(comp1[i]*255.0);
    }
    
    return [NSString stringWithFormat:@"red: %i\r\ngreen: %i\r\nblue: %i\r\nalpha: %i\r\n", comp2[0], comp2[1], comp2[2], comp2[3]];
}

NSString * gradientToString(SmoothGradient* gradient, int format)
{
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendString:@"gradient color: 1\r\n"];
    [result appendString:colorToString([gradient colorAtIndex:0], format)];
    [result appendString:@"gradient color: 2\r\n"];
    [result appendString:colorToString([gradient colorAtIndex:1], format)];
    [result appendString:@"\r\n"];
    return result;
}

NSString *buildColorSchemeReport()
{
    NSMutableString * result = [[NSMutableString alloc] init];
    [result appendString:@"The color data below is given in both 0-1 and 0-255 formats. \r\n\r\n"];
    [result appendString:@"\r\n****************************************\r\ncolor format: 0-1\r\n****************************************\r\n\r\n"];
    
    [result appendString:@"item name: Background\r\n"];
    SmoothGradient *backgroundGradient = getGradient(BackgroundType);
    [result appendString:gradientToString(backgroundGradient, 1)];
    
    [result appendString:buildGlossRectReport(1)];
    
    [result appendString:@"item name: NavBarButton\r\n"];
    UIColor *color = getColor(NavBarButtonType);
    [result appendString:colorToString(color, 1)];
    
    [result appendString:@"\r\n\r\n****************************************\r\ncolor format: 0-255\r\n****************************************\r\n\r\n"];
    
    [result appendString:@"item name: Background\r\n"];
    backgroundGradient = getGradient(BackgroundType);
    [result appendString:gradientToString(backgroundGradient, 2)];
    
    [result appendString:buildGlossRectReport(2)];
    
    [result appendString:@"item name: NavBarButton\r\n"];
    color = getColor(NavBarButtonType);
    [result appendString:colorToString(color, 2)];
    
    return result;
}


// todo, have separate init func

GlossRect* getGlossRect(int objectType)
{
    if(!glossRects)
    {
        glossRects = [[NSMutableArray alloc] init];
        
        
        for(int i = 0; i < GLOSS_RECT_COUNT; i++)
        {
            
            GlossRect* glossRect = [[GlossRect alloc] init];
            switch(i)
            {
                case ButtonType:
                    glossRect.color = [[UIColor alloc] initWithRed:0.0 green:0.1 blue:0.3 alpha:1];
                    glossRect.gloss = 0.3;
                    glossRect.glow = 0.9;
                    glossRect.shadow = 0.6;
                    break;
                    
                case NavBarType:
                    glossRect.color = [[UIColor alloc] initWithRed:0.4 green:0.0 blue:0.0 alpha:1];
                    glossRect.gloss = 0.6;
                    glossRect.glow = 0.8;
                    glossRect.shadow = 0.8;
                    break;
                    
                case TableHeaderType:
                    glossRect.color = [[UIColor alloc] initWithRed:0.1 green:0.2 blue:0.4 alpha:1];
                    glossRect.gloss = 0.6;
                    glossRect.glow = 0.8;
                    glossRect.shadow = 0.8;
                    break;
                    
                case TableCellType:
                    glossRect.color = [[UIColor alloc] initWithRed:1 green:1 blue:0.9 alpha:1];
                    glossRect.gloss = 0;
                    glossRect.glow = 0;
                    glossRect.shadow = 0.2;
                    break;
                    
                    
                case TextBackgroundType:
                    glossRect.color = [[UIColor alloc] initWithRed:1 green:1 blue:0.9 alpha:1];
                    glossRect.gloss = 0;
                    glossRect.glow = 0;
                    glossRect.shadow = 0.3;
                    [glossRect buildGradients:false];
                    break;
                    
                default:
                    break;
            }
            
            [glossRects insertObject:glossRect atIndex:i];
        }
    }
    
    return [glossRects objectAtIndex:objectType];
}


NSMutableArray *gradients = 0;
SmoothGradient *nullGradient;

SmoothGradient* getGradient(int objectType)
{
    if(!gradients)
    {
        gradients = [[NSMutableArray alloc] init];
        
        
        for(int i = 0; i < GRADIENT_COUNT; i++)
        {
            
            SmoothGradient *gradient = [[SmoothGradient alloc] init];
            switch(i)
            {
                case BackgroundType:
                case ButtonType:
                case NavBarType:
                case TableHeaderType:
                case TableCellType:
                case TextBackgroundType:
                    [gradient addColorRed:0.8 green:0.0 blue:0.2 alpha:1 location:0];
                    [gradient addColorRed:0.2 green:0.4 blue:0.8 alpha:1 location:1];
                    [gradient buildWithSharpBoundary:false colors:BUILD_RED|BUILD_GREEN|BUILD_BLUE|BUILD_ALPHA];
                    break;
                    
                default:
                    break;
            }
            
            
            [gradients insertObject:gradient atIndex:i];
        }
    }
    return [gradients objectAtIndex:objectType];
}





NSMutableArray *colors = 0;
UIColor *nullColor = 0;

UIColor * getColor(int objectType)
{
    if(!colors)
    {
        colors = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < COLOR_COUNT; i++)
        {
            
            UIColor *color = 0;
            
            switch(i)
            {
                case BackgroundType:
                case ButtonType:
                case NavBarType:
                case TableHeaderType:
                case TableCellType:
                case TextBackgroundType:
                    color = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:1];
                    break;
                    
                case NavBarButtonType:
                    color = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1];
                    break;
                    
                default:
                    break;
            }
            
            [colors insertObject:color atIndex:i];
        }
    }
    
    return [colors objectAtIndex:objectType];
}

void setColor(int objectType, UIColor *color)
{
    if(!colors)
    {
        colors = [[NSMutableArray alloc] init];
        nullColor = [[UIColor alloc] init];
    }
    
    int count = colors.count;
    
    for(int i = count; i <= objectType; i++)
    {
        [colors insertObject:nullColor atIndex:i];
    }
    
    [colors setObject:color atIndexedSubscript:objectType];
    
    updateAppearance();
}


void updateAppearance()
{
    [[UIBarButtonItem appearance]  setTintColor:getColor(NavBarButtonType)];
    //[[UINavigationBar appearance] setTintColor:getColor(NavBarButtonType)];
    
}

