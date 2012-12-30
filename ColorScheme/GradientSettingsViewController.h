/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  GradientSettingsViewController.h
//
//  Created by Mark Elrod on 12/25/12.
//

#import <UIKit/UIKit.h>
#import "SmoothGradient.h"
@class GradientSettingsViewController;

@protocol GradientSettingsDelegate
-(void)gradientSettingsComplete:(GradientSettingsViewController*)viewController;
@end

@interface GradientSettingsViewController : UIViewController
{
UIBarButtonItem * backButton;
SmoothGradient *gradient;
}

-(void)dataToControls;

@property (nonatomic,assign) id <GradientSettingsDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISlider *redSlider1;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider1;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider1;
@property (weak, nonatomic) IBOutlet UISlider *redSlider2;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider2;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider2;
- (IBAction)redSlider1Changed:(id)sender;
- (IBAction)greenSlider1Changed:(id)sender;

- (IBAction)blueSlider1Changed:(id)sender;
- (IBAction)redSlider2Changed:(id)sender;
- (IBAction)greenSlider2Changed:(id)sender;
- (IBAction)blueSlider2Changed:(id)sender;
@property int type;
@end
