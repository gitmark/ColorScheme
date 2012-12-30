/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  ColorSettingsViewController.m
//
//  Created by Mark Elrod on 12/27/12.
//

#import "ColorSettingsViewController.h"
#import "GlossFactory.h"
#import "GradientView.h"

@interface ColorSettingsViewController ()
{
    UIColor * color;
}
@end

@implementation ColorSettingsViewController
@synthesize type, text, redSlider, greenSlider, blueSlider, alphaSlider, glossLabel, label;

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
    color = getColor(type);
    glossLabel.glossRect.color = color;
    glossLabel.glossRect.gloss = 0;
    glossLabel.glossRect.glow = 0;
    glossLabel.glossRect.shadow = 0;
    const CGFloat *comp = CGColorGetComponents(color.CGColor);
    redSlider.value = comp[0];
    greenSlider.value = comp[1];
    blueSlider.value = comp[2];
    alphaSlider.value = comp[3];
    label.text = text;
}

- (void)viewDidLoad
{
    GradientView *grad = (GradientView*)self.view;
    grad.grid = true;
    
    [super viewDidLoad];
    
    glossLabel.glossRect = [[GlossRect alloc] init];
    [glossLabel.glossRect addDelegate:glossLabel];
    
    backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self dataToControls];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)redSliderChanged:(UISlider*)sender {
    const CGFloat *components = CGColorGetComponents(glossLabel.glossRect.color.CGColor);
    glossLabel.glossRect.async = true;
    color = [[UIColor alloc] initWithRed:sender.value green:components[1] blue:components[2] alpha:components[3]];
    glossLabel.glossRect.color = color;
    setColor(type, color);
    self.navigationItem.leftBarButtonItem.tintColor = color;
}

- (IBAction)greenSliderChanged:(UISlider*)sender {
    const CGFloat *components = CGColorGetComponents(glossLabel.glossRect.color.CGColor);
    glossLabel.glossRect.async = true;
    color = [[UIColor alloc] initWithRed:components[0] green:sender.value blue:components[2] alpha:components[3]];
    glossLabel.glossRect.color = color;
    setColor(type, color);
    self.navigationItem.leftBarButtonItem.tintColor = color;
}

- (IBAction)blueSliderChanged:(UISlider*)sender {
    const CGFloat *components = CGColorGetComponents(glossLabel.glossRect.color.CGColor);
    glossLabel.glossRect.async = true;
    color = [[UIColor alloc] initWithRed:components[0] green:components[1] blue:sender.value alpha:components[3]];
    glossLabel.glossRect.color = color;
    setColor(type, color);
    self.navigationItem.leftBarButtonItem.tintColor = color;
}

- (IBAction)alphaSliderChanged:(UISlider*)sender {
    const CGFloat *components = CGColorGetComponents(glossLabel.glossRect.color.CGColor);
    glossLabel.glossRect.async = true;
    color = [[UIColor alloc] initWithRed:components[0] green:components[1] blue:components[2] alpha:sender.value];
    glossLabel.glossRect.color = color;
    setColor(type, color);
    self.navigationItem.leftBarButtonItem.tintColor = color;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
