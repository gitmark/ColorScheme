/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  GradientSettingsViewController.m
//
//  Created by Mark Elrod on 12/25/12.
//

#import "GradientSettingsViewController.h"
#import "GradientView.h"
#import "GlossFactory.h"

@interface GradientSettingsViewController ()

@end

@implementation GradientSettingsViewController
@synthesize type, delegate, redSlider1, greenSlider1, blueSlider1, redSlider2, greenSlider2, blueSlider2 ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dataToControls
{
    GradientView *grad = (GradientView*)self.view;
    gradient = getGradient(type);
    const CGFloat *comp1 = CGColorGetComponents([gradient colorAtIndex:0].CGColor);
    redSlider1.value = comp1[0];
    greenSlider1.value = comp1[1];
    blueSlider1.value = comp1[2];
    
    const CGFloat *comp2 = CGColorGetComponents([gradient colorAtIndex:1].CGColor);
    redSlider2.value = comp2[0];
    greenSlider2.value = comp2[1];
    blueSlider2.value = comp2[2];
    [grad setNeedsDisplay];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.hidesBackButton = YES;
    [self dataToControls];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)redSlider1Changed:(UISlider*)sender {
    const CGFloat *comp = CGColorGetComponents([gradient colorAtIndex:0].CGColor);
    [gradient setColor:[[UIColor alloc] initWithRed:sender.value green:comp[1] blue:comp[2] alpha:comp[3]] atIndex:0];
}

- (IBAction)greenSlider1Changed:(UISlider*)sender {
    const CGFloat *comp = CGColorGetComponents([gradient colorAtIndex:0].CGColor);
    [gradient setColor:[[UIColor alloc] initWithRed:comp[0] green:sender.value blue:comp[2] alpha:comp[3]] atIndex:0];
}
- (IBAction)blueSlider1Changed:(UISlider*)sender {
    const CGFloat *comp = CGColorGetComponents([gradient colorAtIndex:0].CGColor);
    [gradient setColor:[[UIColor alloc] initWithRed:comp[0] green:comp[1] blue:sender.value alpha:comp[3]] atIndex:0];
}

- (IBAction)redSlider2Changed:(UISlider*)sender {
    const CGFloat *comp = CGColorGetComponents([gradient colorAtIndex:1].CGColor);
    [gradient setColor:[[UIColor alloc] initWithRed:sender.value green:comp[1] blue:comp[2] alpha:comp[3]] atIndex:1];
}

- (IBAction)greenSlider2Changed:(UISlider*)sender {
    const CGFloat *comp = CGColorGetComponents([gradient colorAtIndex:1].CGColor);
    [gradient setColor:[[UIColor alloc] initWithRed:comp[0] green:sender.value blue:comp[2] alpha:comp[3]] atIndex:1];
}
- (IBAction)blueSlider2Changed:(UISlider*)sender {
    const CGFloat *comp = CGColorGetComponents([gradient colorAtIndex:1].CGColor);
    [gradient setColor:[[UIColor alloc] initWithRed:comp[0] green:comp[1] blue:sender.value alpha:comp[3]] atIndex:1];
}


-(void)back
{
    if(delegate)
    {
        [delegate gradientSettingsComplete:self];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
