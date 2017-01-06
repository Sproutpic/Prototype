//
//  EditAccountInfoViewController.m
//  Sprout
//
//  Created by Jeff Morris on 11/19/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "EditAccountInfoViewController.h"
#import "TextFieldTableViewCell.h"
#import "SelectTableViewController.h"
#import "NSString+WhiteSpacing.h"
#import "CurrentUser.h"
#import "UIUtils.h"
#import "AccountWebService.h"

@interface EditAccountInfoViewController () <SelectTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *updateAccountBtn;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) NSString *edittedFullName;
@property (strong, nonatomic) NSString *edittedGender;

- (IBAction)updateAccountButtonTapped:(id)sender;

@end

@implementation EditAccountInfoViewController

# pragma mark Private

- (IBAction)updateAccountButtonTapped:(id)sender
{
    [[self textField] resignFirstResponder];
    
    [self setEdittedFullName:[[self edittedFullName] stringByTrimmingLeadingAndTailingWhitespace]];
    
    [UIUtils hapticFeedback];
    [self showFullScreenSpinner:YES];
    [[AccountWebService updateAccountInfo:[CurrentUser emailAddress]
                                     name:[self edittedFullName]
                                   gender:[self edittedGender]
                             withCallback:^(NSError *error, SproutWebService *service) {
                                 [self showFullScreenSpinner:NO];
                                 if (error) {
                                     [self displayMessageWithTitle:NSLocalizedString(@"Problem", @"Problem")
                                                           andBody:[error localizedDescription]];
                                 } else {
                                     [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
                                 }
                             }] start];
}

# pragma mark UIViewController

- (void)viewDidLoad
{
    [self setEdittedFullName:[CurrentUser fullName]];
    if ([[self edittedFullName] isEqualToString:DEFAULT_DUMMY_PLACE_HOLDER]) {
        [self setEdittedFullName:@""];
    }
    [self setEdittedGender:[CurrentUser gender]];
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"Edit Account Info", @"Edit Account Info")];
    [self roundCornersForView:[self updateAccountBtn]];
    [self createCancelNavButton];
    [[self tableView] setBackgroundColor:[UIUtils colorLightGrey]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] setFrame:[[self view] bounds]];
    [[self tableView] reloadData];
}

# pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    if ([CurrentUser isLoggedIn]) {
        switch ([indexPath row]) {
            case 2: {
                SelectTableViewController *vc = [[SelectTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                [vc setSelectDelegate:self];
                [vc setTitle:NSLocalizedString(@"Gender", @"Gender")];
                NSString *gender = [self edittedGender];
                [vc setRows:
                 @[
                   @[NSLocalizedString(@"Female", @"Female"),@"",@([gender isEqualToString:NSLocalizedString(@"Female", @"Female")])],
                   @[NSLocalizedString(@"Male", @"Male"),@"",@([gender isEqualToString:NSLocalizedString(@"Male", @"Male")])]
                   ]];
                [[self navigationController] pushViewController:vc animated:YES];
            } break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([indexPath row]==0) ? 54.0 : 44.0;
}

# pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseCell = @"UITableViewCellStyleValue1";
    if ([indexPath row]==0) {
        reuseCell = @"TextFieldTableViewCell";
    }
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:reuseCell];
    if (!cell) {
        switch ([indexPath row]) {
            case 0: {
                UIViewController *vc = [[UIViewController alloc] initWithNibName:reuseCell bundle:nil];
                cell = (TextFieldTableViewCell*)[vc view];
            } break;
            default: {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseCell];
            } break;
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    switch ([indexPath row]) {
        case 0: {
            TextFieldTableViewCell *tCell = (TextFieldTableViewCell*)cell;
            [[tCell textfield] setPlaceholder:NSLocalizedString(@"Full Name", @"Full Name")];
            [[tCell textfield] setText:[self edittedFullName]];
            [[tCell textfield] setClearButtonMode:UITextFieldViewModeWhileEditing];
            [[tCell textview] setHidden:YES];
            [tCell setTextFieldCallback:^(UITextField *textfield){
                if (textfield) {
                    [self setEdittedFullName:[textfield text]];
                }
            }];
            [self setTextField:[tCell textfield]];
        } break;
        case 1: {
            [[cell textLabel] setText:NSLocalizedString(@"Email", @"Email")];
            [[cell detailTextLabel] setText:[CurrentUser emailAddress]];
        } break;
        case 2: {
            [[cell textLabel] setText:NSLocalizedString(@"Gender", @"Gender")];
            [[cell detailTextLabel] setText:[self edittedGender]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-right"]]];
        } break;
    }
    return cell;
}

# pragma mark SelectTableViewControllerDelegate

- (void)selectionMade:(NSArray*)rows forIndex:(NSInteger)index withTag:(NSInteger)tag
{
    [self setEdittedGender:[[rows objectAtIndex:index] objectAtIndex:0]];
    [[self tableView] reloadData];
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
