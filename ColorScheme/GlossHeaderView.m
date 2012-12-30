/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  GlossHeaderView.m
//
//  Created by Mark Elrod on 12/22/12.
//

#import "GlossHeaderView.h"
#import "GlossFactory.h"

@implementation GlossHeaderView
@synthesize label;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initMembers];
    }
    return self;
}

-(GlossHeaderView*) init;
{
    self = [super initWithType:TableHeaderType];
    return self;
}

-(void) initMembers;
{
    self.position = TopView;
    self.topMargin = 10;
    self.bottomMargin = 0;
    self.leftMargin = 0;
    self.rightMargin = 0;
    self.label = [[UILabel alloc] init];
    label.textAlignment =  NSTextAlignmentCenter;
    
    label.opaque = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    label.shadowOffset = CGSizeMake(0, -1);
    [self addSubview:label];
    
}

- (void)drawRect:(CGRect)rect
{
    label.bounds = CGRectMake(0,0,self.frame.size.width -self.leftMargin -self.rightMargin,self.bounds.size.height - self.topMargin);
    
    label.frame = CGRectMake(self.leftMargin, self.topMargin, self.frame.size.width -self.leftMargin -self.rightMargin,self.bounds.size.height - self.topMargin);
    
    [super drawRect:rect];
    
}


@end
