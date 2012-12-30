/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  GlossSettingsViewController.m
//
//  Created by Mark Elrod on 12/23/12.
//

#import "GlossSettingsViewController.h"
#import "GlossButton.h"
#import "GradientView.h"
#import "GlossFactory.h"

@interface GlossSettingsViewController ()

@end

@implementation GlossSettingsViewController
@synthesize delegate, type, button, redSlider, greenSlider, blueSlider, alphaSlider, glossSlider, glowSlider, shadowSlider, text, label;

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
    GlossRect *glossRect = getGlossRect(type);
    label.text = text;
    const CGFloat *comp = CGColorGetComponents(glossRect.color.CGColor);
    
    redSlider.value = comp[0];
    greenSlider.value = comp[1];
    blueSlider.value = comp[2];
    alphaSlider.value = comp[3];
    
    glossSlider.value = glossRect.gloss;
    glowSlider.value = glossRect.glow;
    shadowSlider.value = glossRect.shadow;
    
    button.glossRect = glossRect;
    [glossRect addDelegate:button]; // add code to limit
    glossRect.rect = [button bounds];
    [button setNeedsDisplay];
    
    GradientView *grad = (GradientView*)self.view;
    grad.async = true;
    grad.smoothGradient = getGradient(BackgroundType);
    [grad.smoothGradient addDelegate:grad];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    GradientView *grad = (GradientView*)self.view;
    grad.grid = true;
    self.navigationItem.hidesBackButton = YES;
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
    const CGFloat *components = CGColorGetComponents(button.color.CGColor);
    button.async = true;
    button.color = [[UIColor alloc] initWithRed:sender.value green:components[1] blue:components[2] alpha:components[3]];
}

- (IBAction)greenSliderChanged:(UISlider*)sender {
    const CGFloat *components = CGColorGetComponents(button.color.CGColor);
    button.async = true;
    button.color = [[UIColor alloc] initWithRed:components[0] green:sender.value blue:components[2] alpha:components[3]];
}

- (IBAction)blueSliderChanged:(UISlider*)sender {
    const CGFloat *components = CGColorGetComponents(button.color.CGColor);
    button.async = true;
    button.color = [[UIColor alloc] initWithRed:components[0] green:components[1] blue:sender.value alpha:components[3]];
}

- (IBAction)alphaSliderChanged:(UISlider*)sender {
    const CGFloat *components = CGColorGetComponents(button.color.CGColor);
    button.async = true;
    button.color = [[UIColor alloc] initWithRed:components[0] green:components[1] blue:components[2] alpha:sender.value];
}

- (IBAction)glossSliderChanged:(UISlider*)sender {
    button.async = true;
    button.gloss = sender.value;
}

- (IBAction)glowSliderChanged:(UISlider*)sender {
    button.async = true;
    button.glow = sender.value;
}

- (IBAction)shadowSliderChanged:(UISlider*)sender {
    button.async = true;
    button.shadow = sender.value;
}

-(void)done
{
    if(delegate)
    {
        [delegate glossSettingsComplete:self];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
