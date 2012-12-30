/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  AboutViewController.m
//
//  Created by Mark Elrod on 12/20/12.
//

// http://stackoverflow.com/questions/7266766/making-uitextview-scroll-programmatically

#import "AboutViewController.h"
#import "GlossLabel.h"

NSString * help = @"\r\nNorthwell Color Scheme\r\nVersion 1.0.0\r\n\r\nThe Northwell Color Scheme app allows you to explore different color schemes that you can use in your own apps. The program is intended primarily for software developers. The app lets you dynamically adjust the properties red, green, blue, alpha, gloss, glow and shadow for several graphical components. If you create a color scheme you like using this app, you can email the color settings to yourself or others making it easy for you to code the same settings in your own apps. \r\n\r\nThe Color Scheme app is an open source project with a permissive MIT license so you are free to use the code for any purpose. The code is available at https://github.com/gitmark/ColorScheme.git.\r\n\r\nPlease contact me if you have any questions or comments.\r\n\r\nEnjoy,\r\n\r\nMark Elrod\r\n";




@interface AboutViewController ()
{
    NSTimer *timer;
}
@end

@implementation AboutViewController
@synthesize viewController, text, textView, glossLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) scrollIt
{
    CGPoint point = self.textView.contentOffset;
    if (point.y == 380)
    {
        [timer invalidate];
        timer = nil;
    }
    point = CGPointMake(point.x, point.y + 1);
    [self.textView setContentOffset:point animated:NO];
}

-(void)dataToControls
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        if (timer)
        {
            [timer invalidate];
            timer = nil;
        }
        
        timer = [NSTimer scheduledTimerWithTimeInterval:(0.06)
                                                 target:self selector:@selector(scrollIt) userInfo:nil repeats:YES];
    }
    
    NSMutableString * result = [[NSMutableString alloc] init];
    [result appendString:help];
    [result appendString:[NSString stringWithFormat:@"code-mark%@", @"@northwell.com"]];
    textView.text = result;
    CGPoint point = self.textView.contentOffset;
    point = CGPointMake(point.x, 0);
    [self.textView setContentOffset:point animated:NO];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    viewController = nil;
    glossLabel.glossRect.orientation = ORIENT_HORIZONTAL;
    backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self dataToControls];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
