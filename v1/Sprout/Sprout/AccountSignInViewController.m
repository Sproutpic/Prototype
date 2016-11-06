//
//  AccountSignInViewController.m
//  Sprout
//
//  Created by Jeff Morris on 10/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "AccountSignInViewController.h"
#import "NSString+WhiteSpacing.h"
#import "SignInWebService.h"
#import "JVFloatLabeledTextField.h"
#import "UIUtils.h"

@interface AccountSignInViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *emailAddressTxtField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *passwordTxtField;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UIButton *restorePasswordBtn;
@property (weak, nonatomic) IBOutlet UIView *textBKView1;
@property (weak, nonatomic) IBOutlet UIView *textBKView2;

- (IBAction)signInButtonTapped:(id)sender;
- (IBAction)resetPasswordButtonTapped:(id)sender;

@end

@implementation AccountSignInViewController

# pragma mark Private

- (IBAction)signInButtonTapped:(id)sender
{
    NSString *email = [[[self emailAddressTxtField] text] stringByTrimmingLeadingAndTailingWhitespace];
    NSString *password = [[[self passwordTxtField] text] stringByTrimmingLeadingAndTailingWhitespace];
    
    [UIUtils hapticFeedback];

    // Verify the email address
    if (email==nil || [email length]<=0) {
        [self displayMessageWithBody:NSLocalizedString(@"Enter your email address to Sign In",
                                                       @"Enter your email address to Sign In")];
        return;
    }
    
    // Verify the password
    if (password==nil || [password length]<=0) {
        [self displayMessageWithBody:NSLocalizedString(@"Enter your password to Sign In",
                                                       @"Enter your password to Sign In")];
        return;
    }
    
    // Place spinner on screen
    [self showFullScreenSpinner:YES];
    
    // All looks good, so lets call the web service...
    [SignInWebService requestResetPasswordForEmail:email
                                      withCallback:
     ^(NSError *error, SproutWebService *service) {
         [self showFullScreenSpinner:NO];
         if (error) {
             [self displayMessageWithTitle:NSLocalizedString(@"Invalid Username/Password", @"Invalid Username/Password")
                                   andBody:NSLocalizedString(@"Enter a valid username and/or password to Sign In",
                                                             @"Enter a valid username and/or password to Sign In")];
         } else {
             [CurrentUser setUser:@{ @"name" : @"Demo User", @"email" : email }];
             [[self navigationController] popToRootViewControllerAnimated:YES];
             [self displayMessageWithTitle:NSLocalizedString(@"Success", @"Success")
                                   andBody:NSLocalizedString(@"You are now Signed In",
                                                             @"You are now Signed In")];
         }
     }];
}

- (IBAction)resetPasswordButtonTapped:(id)sender
{
    NSString *email = [[[self emailAddressTxtField] text] stringByTrimmingLeadingAndTailingWhitespace];
    
    [UIUtils hapticFeedback];

    // Verify all 3 fields have data entered
    if (email==nil || [email length]<=0) {
        [self displayMessageWithBody:NSLocalizedString(@"Enter your email address to restore password",
                                                       @"Enter your email address to restore password")];
        return;
    }
    
    // Place spinner on screen
    [self showFullScreenSpinner:YES];
    
    // All looks good, so lets call the web service...
    [SignInWebService requestResetPasswordForEmail:email
                                      withCallback:
     ^(NSError *error, SproutWebService *service) {
         [self showFullScreenSpinner:NO];
         if (error) {
             [self displayMessageWithTitle:NSLocalizedString(@"Problem", @"Problem")
                                   andBody:[error localizedDescription]];
         } else {
             [self displayMessageWithTitle:NSLocalizedString(@"Check Email", @"Check Email")
                                   andBody:NSLocalizedString(@"We've sent you an email with more information on how to restore your password",
                                                             @"We've sent you an email with more information on how to restore your password")];
         }
     }];
}

# pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"Sign In", @"Sign In")];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self mainView] setFrame:[[self view] bounds]];
    
    [self roundCornersForView:[self signInBtn]];
    [self themeFloatTextField:[self emailAddressTxtField] withBK:[self textBKView1]];
    [self themeFloatTextField:[self passwordTxtField] withBK:[self textBKView2]];
}

# pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField isEqual:[self emailAddressTxtField]]) {
        [[self passwordTxtField] becomeFirstResponder];
    } else if ([textField isEqual:[self passwordTxtField]]) {
        [self signInButtonTapped:[self signInBtn]];
    }
    return YES;
}

@end
