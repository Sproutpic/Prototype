//
//  AccountInformationViewController.m
//  Sprout
//
//  Created by Jeff Morris on 10/10/2016
//  Copyright © 2016 sprout. All rights reserved.
//

#import "AccountInformationViewController.h"
#import "AccountSignInViewController.h"
#import "AccountSignUpViewController.h"
#import "SignInWebService.h"
#import "UIUtils.h"

@interface AccountInformationViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *loggedOutView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UIButton *signOutBtn;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UILabel *orLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;

- (IBAction)signOutButtonTapped:(id)sender;
- (IBAction)signInButtonTapped:(id)sender;
- (IBAction)signUpButtonTapped:(id)sender;

@end

@implementation AccountInformationViewController

# pragma mark Private

- (void)editState
{
    [self displayUnderConstructionAlert];
}

- (IBAction)signOutButtonTapped:(id)sender
{
    // Place spinner on screen
    [self showFullScreenSpinner:YES];
    
    [UIUtils hapticFeedback];
    
    // All looks good, so lets call the web service...
    [SignInWebService signOutUserWithEmail:[CurrentUser emailAddress]
                              withCallback:
     ^(NSError *error, SproutWebService *service) {
         [self showFullScreenSpinner:NO];
         [CurrentUser setUser:nil];
         [[self navigationController] popViewControllerAnimated:YES];
     }];
}

- (IBAction)signInButtonTapped:(id)sender
{
    [UIUtils hapticFeedback];
    AccountSignInViewController *vc = [[AccountSignInViewController alloc] initWithNibName:@"AccountSignInViewController" bundle:nil];
    [[self navigationController] pushViewController:vc animated:YES];
}

- (IBAction)signUpButtonTapped:(id)sender
{
    [UIUtils hapticFeedback];
    AccountSignUpViewController *vc = [[AccountSignUpViewController alloc] initWithNibName:@"AccountSignUpViewController" bundle:nil];
    [[self navigationController] pushViewController:vc animated:YES];
}

# pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"Account Info", @"Account Info")];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] setFrame:[[self view] bounds]];
    
    [[self loggedOutView] setFrame:[[self tableView] bounds]];
    [[self loggedOutView] setAlwaysBounceVertical:YES];
    
    [[self mainView] setFrame:[[self view] bounds]];
    
    [self roundCornersForView:[self signOutBtn]];
    [self roundCornersForView:[self signInBtn]];
    [self roundCornersForView:[self signUpBtn]];

    if ([CurrentUser isLoggedIn]) {
        [[self loggedOutView] setHidden:YES];
        [[self tableView] reloadData];
        [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button-pencil"]
                                                                                      style:UIBarButtonItemStylePlain
                                                                                     target:self
                                                                                     action:@selector(editState)]];
    } else {
        [[self loggedOutView] setHidden:NO];
        [[self navigationItem] setRightBarButtonItem:nil];
    }
}

# pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseCell = @"UITableViewCellStyleValue1";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:reuseCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    if ([CurrentUser isLoggedIn]) {
        switch ([indexPath row]) {
            case 0: {
                [[cell textLabel] setText:NSLocalizedString(@"Name", @"Name")];
                [[cell detailTextLabel] setText:[CurrentUser fullName]];
            } break;
            case 1: {
                [[cell textLabel] setText:NSLocalizedString(@"Email", @"Email")];
                [[cell detailTextLabel] setText:[CurrentUser emailAddress]];
            } break;
            case 2: {
                [[cell textLabel] setText:NSLocalizedString(@"Gender", @"Gender")];
                [[cell detailTextLabel] setText:NSLocalizedString(@"--", @"--")];
            } break;
        }
    } else {
        [[cell textLabel] setText:nil];
        [[cell detailTextLabel] setText:nil];
    }
    return cell;
}

@end
