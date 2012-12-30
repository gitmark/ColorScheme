/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  GlossSettingsViewController.h
//
//  Created by Mark Elrod on 12/23/12.
//

#import <UIKit/UIKit.h>
@class GlossButton;
@class GlossSettingsViewController;

@protocol GlossSettingsDelegate
-(void)glossSettingsComplete:(GlossSettingsViewController*)viewController;
@end

@interface GlossSettingsViewController : UIViewController
{
    UIBarButtonItem * backButton;
}
-(void)dataToControls;

@property (nonatomic, assign) id <GlossSettingsDelegate> delegate;
@property (weak, nonatomic) IBOutlet GlossButton *button;

- (IBAction)redSliderChanged:(UISlider*)sender;
- (IBAction)greenSliderChanged:(UISlider*)sender;
- (IBAction)blueSliderChanged:(UISlider*)sender;
- (IBAction)alphaSliderChanged:(UISlider*)sender;
- (IBAction)glossSliderChanged:(UISlider*)sender;
- (IBAction)glowSliderChanged:(UISlider*)sender;
- (IBAction)shadowSliderChanged:(UISlider*)sender;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;
@property (weak, nonatomic) IBOutlet UISlider *glossSlider;
@property (weak, nonatomic) IBOutlet UISlider *glowSlider;
@property (weak, nonatomic) IBOutlet UISlider *shadowSlider;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (nonatomic, strong) NSString* text;
@property int type;
@end
