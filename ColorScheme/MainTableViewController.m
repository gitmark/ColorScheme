/* Copyright (C) 2012 Mark Elrod
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  MainTableViewController.m
//
//  Created by Mark Elrod on 12/22/12.
//

// Inspiring and infomative links ...
// http://www.raywenderlich.com/2079/core-graphics-101-shadows-and-gloss

#import "MainTableViewController.h"
#import "GlossHeaderView.h"
#import "GlossView.h"
#import "GradientView.h"
#import "GlossSettingsViewController.h"
#import "GlossFactory.h"
#import "GlossRect.h"
#import "AboutViewController.h"
#import "DemoNumPadViewController.h"

enum SectionNumber
{
    ColorSection,
    DemoSection,
    EmailSection,
    HelpSection
};

#define SectionCount 3

#define ColorRowCount 7
#define DemoRowCount 1
#define EmailRowCount 1
#define HelpRowCount 3

#define SendColorsRow 0

#define AboutRow 0
#define WebSiteRow 1
#define ContactRow 2


@interface MainTableViewController ()

@end

@implementation MainTableViewController
@synthesize glossSettingsViewController, colorSettingsViewController, gradientSettingsViewController, aboutViewController, demoNumPadViewController;

- (UIView *) tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    GlossHeaderView * header = [[GlossHeaderView alloc] init];
    
    header.topMargin = 6;
    header.bottomMargin = 0;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        header.leftMargin = 9;
        header.rightMargin = 9;
    }
    else
    {
        header.leftMargin = 44;
        header.rightMargin = 44;
    }
    
    header.position = 1;
    header.label.text = [self tableView:tableView titleForHeaderInSection:section];
    [header setNeedsDisplay];
    return header;
}

-(CGFloat) tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch(section)
    {
        case ColorSection:
            return @"Color Settings";
            break;
            
        case DemoSection:
            return @"Demo Screen";
            break;
            
        case EmailSection:
            return @"Email";
            break;
            
        case HelpSection:
            return @"Help";
            break;
            
        default:
            break;
    }
    
    return @"";
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    updateAppearance();
    [super viewDidLoad];
    demoNumPadViewController = 0;
    UITableView* tableView = (UITableView*)self.view;
    tableView.backgroundColor = [UIColor clearColor];
    
    GradientView *gradientView = [[GradientView alloc] init];
    [gradientView initSmoothGradient];
    
    tableView.backgroundView = gradientView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;
    switch(section)
    {
        case ColorSection:
            rows = ColorRowCount;
            break;
            
        case DemoSection:
            rows = DemoRowCount;
            break;
            
        case EmailSection:
            rows = EmailRowCount;
            break;
            
        case HelpSection:
            rows = HelpRowCount;
            break;
            
        default:
            break;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    GlossView* bkCell1 = [[GlossView alloc] initWithType:TableCellType];
    GlossView* bkCell2 = [[GlossView alloc] initWithType:TableCellType];
    cell.backgroundView = bkCell1;
    cell.selectedBackgroundView = bkCell2;
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor blackColor];
    
    if(indexPath.section == ColorSection)
    {
        switch (indexPath.row)
        {
            case BackgroundType:
                cell.textLabel.text = @"Background";
                bkCell1.position = MiddleView;
                bkCell2.position = MiddleView;
                break;
                
            case ButtonType:
                cell.textLabel.text = @"Button";
                bkCell1.position = MiddleView;
                bkCell2.position = MiddleView;
                break;
                
            case NavBarType:
                cell.textLabel.text = @"Navigation Bar";
                bkCell1.position = MiddleView;
                bkCell2.position = MiddleView;
                break;
                
            case TableHeaderType:
                cell.textLabel.text = @"Table Header";
                bkCell1.position = MiddleView;
                bkCell2.position = MiddleView;
                break;
                
            case TableCellType:
                cell.textLabel.text = @"Table Cell";
                bkCell1.position = MiddleView;
                bkCell2.position = MiddleView;
                break;
                
            case TextBackgroundType:
                cell.textLabel.text = @"Text Background";
                bkCell1.position = MiddleView;
                bkCell2.position = MiddleView;
                break;
                
            case NavBarButtonType:
                cell.textLabel.text = @"Nav Bar Button";
                bkCell1.position = BottomView;
                bkCell2.position = BottomView;
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section == DemoSection)
    {
        switch (indexPath.row)
        {
            case SendColorsRow:
                cell.textLabel.text = @"Number Pad";
                bkCell1.position = BottomView;
                bkCell2.position = BottomView;
                break;
                
                
            default:
                break;
        }
    }
    else if (indexPath.section == EmailSection)
    {
        switch (indexPath.row)
        {
            case SendColorsRow:
                cell.textLabel.text = @"Send Color Scheme";
                bkCell1.position = BottomView;
                bkCell2.position = BottomView;
                break;
                
                
            default:
                break;
        }
    }
    else if (indexPath.section == HelpSection)
    {
        switch (indexPath.row)
        {
            case AboutRow:
                cell.textLabel.text = @"About";
                bkCell1.position = MiddleView;
                bkCell2.position = MiddleView;
                break;
                
            case WebSiteRow:
                cell.textLabel.text = @"Web Site";
                bkCell1.position = MiddleView;
                bkCell2.position = MiddleView;
                break;
                
            case ContactRow:
                cell.textLabel.text = @"Contact";
                bkCell1.position = BottomView;
                bkCell2.position = BottomView;
                break;
                
            default:
                break;
        }
    }
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == ColorSection)
    {
        if (indexPath.row == 0)
        {
            bool newView = false;
            if (self.gradientSettingsViewController == nil)
            {
                newView = true;
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    gradientSettingsViewController = [[GradientSettingsViewController alloc] initWithNibName:@"GradientSettingsViewController" bundle:nil];
                }
                else {
                    gradientSettingsViewController = [[GradientSettingsViewController alloc] initWithNibName:@"GradientSettingsViewControllerIPad" bundle:nil];
                }
                
            }
            gradientSettingsViewController.type =  BackgroundType;
            gradientSettingsViewController.delegate = self;
            if(!newView)
            {
                [gradientSettingsViewController dataToControls];
            }
            [self.navigationController pushViewController:gradientSettingsViewController animated:YES];
        }
        
        if (indexPath.row >= ButtonType && indexPath.row <= TextBackgroundType)
        {
            bool newView = false;
            if (self.glossSettingsViewController == nil)
            {
                newView = true;
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    glossSettingsViewController = [[GlossSettingsViewController alloc] initWithNibName:@"GlossSettingsViewController" bundle:nil];
                }
                else{
                    glossSettingsViewController = [[GlossSettingsViewController alloc] initWithNibName:@"GlossSettingsViewControllerIPad" bundle:nil];
                }
                
            }
            
            glossSettingsViewController.delegate = self;
            
            switch(indexPath.row)
            {
                case ButtonType:
                    glossSettingsViewController.type = ButtonType;
                    glossSettingsViewController.text = @"Button Color";
                    break;
                    
                case NavBarType:
                    glossSettingsViewController.type = NavBarType;
                    glossSettingsViewController.text = @"Nav Bar Color";
                    break;
                    
                case TableHeaderType:
                    glossSettingsViewController.type = TableHeaderType;
                    glossSettingsViewController.text = @"Table Header Color";
                    break;
                    
                case TableCellType:
                    glossSettingsViewController.type = TableCellType;
                    glossSettingsViewController.text = @"Table Cell Color";
                    break;
                    
                case TextBackgroundType:
                    glossSettingsViewController.type = TextBackgroundType;
                    glossSettingsViewController.text = @"Text Background Color";
                    break;
                    
                default:
                    break;
            }
            
            if(!newView)
            {
                [glossSettingsViewController dataToControls];
            }
            
            [self.navigationController pushViewController:glossSettingsViewController animated:YES];
        }
        else if (indexPath.row >= NavBarButtonType)
        {
            bool newView = false;
            if (self.colorSettingsViewController == nil)
            {
                newView = true;
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    colorSettingsViewController = [[ColorSettingsViewController alloc] initWithNibName:@"ColorSettingsViewController" bundle:nil];
                }
                else {
                    colorSettingsViewController = [[ColorSettingsViewController alloc] initWithNibName:@"ColorSettingsViewControllerIPad" bundle:nil];
                }
            }
            
            switch(indexPath.row)
            {
                case NavBarButtonType:
                    colorSettingsViewController.type = NavBarButtonType;
                    colorSettingsViewController.text = @"Nav Bar Button Color";
                    break;
                    
                default:
                    break;
            }
            
            if(!newView)
            {
                [colorSettingsViewController dataToControls];
            }
            
            [self.navigationController pushViewController:colorSettingsViewController animated:YES];
        }
    }
    else if (indexPath.section == DemoSection)
    {
        if (indexPath.row == 0)
        {
            bool newView = false;
            if (self.demoNumPadViewController == nil)
            {
                newView = true;
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    demoNumPadViewController = [[DemoNumPadViewController alloc] initWithNibName:@"DemoNumPadViewController" bundle:nil];
                }
                else {
                    demoNumPadViewController = [[DemoNumPadViewController alloc] initWithNibName:@"DemoNumPadViewControllerIPad" bundle:nil];
                }
                
            }
            
            if(!newView)
            {
                // [colorSettingsViewController dataToControls];
            }
            
            [self.navigationController pushViewController:demoNumPadViewController animated:YES];
            
        }
    }
    else if (indexPath.section == EmailSection)
    {
        if (indexPath.row == 0)
        {
            if (![MFMailComposeViewController canSendMail])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"This device does not support email."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
            mailViewController.mailComposeDelegate = self;
            [mailViewController setSubject:@"Color Scheme"];
            [mailViewController setMessageBody:buildColorSchemeReport() isHTML:NO];
            
            [self presentViewController:mailViewController animated:YES completion:nil];
        }
    }
    else if (indexPath.section == HelpSection)
    {
        if (indexPath.row == AboutRow)
        {
            
            bool newView = false;
            if (self.aboutViewController == nil)
            {
                newView = true;
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
                }
                else {
                    aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewControllerIPad" bundle:nil];
                }
            }

            if(!newView)
            {
                [aboutViewController dataToControls];
            }

            [self.navigationController pushViewController:aboutViewController animated:YES];
        }
        else if (indexPath.row == WebSiteRow)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://northwell.com/colorscheme/"]];
            
        }
        else if (indexPath.row == ContactRow)
        {
            if (![MFMailComposeViewController canSendMail])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"This device does not support email."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
            mailViewController.mailComposeDelegate = self;
            [mailViewController setToRecipients:[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"code-mark%@", @"@northwell.com"], nil]];
            [mailViewController setSubject:@"Color Scheme"];
            
            [self presentViewController:mailViewController animated:YES completion:nil];
        }
    }
}

-(void)glossSettingsComplete:(GlossSettingsViewController *)viewController
{
}

-(void)gradientSettingsComplete:(GradientSettingsViewController *)viewController
{
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString*)buildColorSchemeReport
{
    
    return nil;
    
}


@end
