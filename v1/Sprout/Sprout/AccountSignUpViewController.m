//
//  AccountSignUpViewController.m
//  Sprout
//
//  Created by Jeff Morris on 10/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "AccountSignUpViewController.h"
#import "NSString+WhiteSpacing.h"
#import "AccountWebService.h"
#import "AccountSignInViewController.h"
#import "JVFloatLabeledTextField.h"
#import "UIUtils.h"

@interface AccountSignUpViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *fullNameTxtField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *emailAddressTxtField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *passwordTxtField;
@property (weak, nonatomic) IBOutlet UIButton *termsBtn;
@property (weak, nonatomic) IBOutlet UILabel *termsLbl;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UIView *textBKView1;
@property (weak, nonatomic) IBOutlet UIView *textBKView2;
@property (weak, nonatomic) IBOutlet UIView *textBKView3;

- (IBAction)termsButtonTapped:(id)sender;
- (IBAction)signUpButtonTapped:(id)sender;
- (IBAction)signInButtonTapped:(id)sender;

@end

@implementation AccountSignUpViewController

# pragma mark Private

- (IBAction)termsButtonTapped:(id)sender
{
    [UIUtils hapticFeedback];
    if ([[self termsBtn] tag]==0) {
        [[self termsBtn] setTag:1];
        [[self termsBtn] setImage:[UIImage imageNamed:@"check-on"] forState:UIControlStateNormal];
    } else {
        [[self termsBtn] setTag:0];
        [[self termsBtn] setImage:[UIImage imageNamed:@"check-off"] forState:UIControlStateNormal];
    }
}

- (IBAction)signUpButtonTapped:(id)sender
{
    NSString *fullName = [[[self fullNameTxtField] text] stringByTrimmingLeadingAndTailingWhitespace];
    NSString *email = [[[self emailAddressTxtField] text] stringByTrimmingLeadingAndTailingWhitespace];
    NSString *password = [[[self passwordTxtField] text] stringByTrimmingLeadingAndTailingWhitespace];
 
    [UIUtils hapticFeedback];

    // Verify the email address
    if (fullName==nil || [fullName length]<=0) {
        [self displayMessageWithBody:NSLocalizedString(@"You must enter your full name to Sign Up",
                                                       @"You must enter your full name to Sign Up")];
        return;
    }
    
    // Verify the email address
    if (email==nil || [email length]<=0) {
        [self displayMessageWithBody:NSLocalizedString(@"You must enter your email address to Sign Up",
                                                       @"You must enter your email address to Sign Up")];
        return;
    }
    
    // Verify that the new password is atleast 8 characters long
    if (password==nil || [password length]<=7) {
        [self displayMessageWithBody:NSLocalizedString(@"You must enter a password that is 8 characters or longer. We also recommend that you use a combination of uppercase, lowercase, and number characters.",
                                                       @"You must enter a password that is 8 characters or longer. We also recommend that you use a combination of uppercase, lowercase, and number characters.")];
        return;
    }
    
    // Verify user has accepted the terms and conditions
    if ([[self termsBtn] tag]!=1) {
        [self displayMessageWithBody:NSLocalizedString(@"You must accept the Terms and Conditions before Signing Up for an account",
                                                       @"You must accept the Terms and Conditions before Signing Up for an account")];
        return;
    }

    
    // Place spinner on screen
    [self showFullScreenSpinner:YES];
    
    // All looks good, so lets call the web service...
    [AccountWebService signUpUserWithName:fullName
                                withEmail:email
                             withPassword:password
                             withCallback:
     ^(NSError *error, SproutWebService *service) {
         [self showFullScreenSpinner:NO];
         if (error) {
             [self displayMessageWithTitle:NSLocalizedString(@"Problem", @"Problem")
                                   andBody:[error localizedDescription]];
         } else {
             [[self navigationController] popToRootViewControllerAnimated:YES];
             [self displayMessageWithTitle:NSLocalizedString(@"Success", @"Success")
                                   andBody:NSLocalizedString(@"You have Signed Up for a new account",
                                                             @"You have Signed Up for a new account")];
         }
     }];
}

- (IBAction)signInButtonTapped:(id)sender
{
    [UIUtils hapticFeedback];

    AccountSignInViewController *vc = [[AccountSignInViewController alloc] initWithNibName:@"AccountSignInViewController" bundle:nil];
    NSMutableArray *controllers = [[NSMutableArray alloc] initWithArray:[[self navigationController] viewControllers]] ;
    [controllers removeLastObject];
    [controllers addObject:vc];
    [[self navigationController] setViewControllers:controllers animated:YES];
}

# pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"Sign Up", @"Sign Up")];
    [[self termsBtn] setTag:0]; // Sets the terms agreement to off...
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self mainView] setFrame:[[self view] bounds]];
    
    [self roundCornersForView:[self signUpBtn]];
    [self themeFloatTextField:[self fullNameTxtField] withBK:[self textBKView1]];
    [self themeFloatTextField:[self emailAddressTxtField] withBK:[self textBKView2]];
    [self themeFloatTextField:[self passwordTxtField] withBK:[self textBKView3]];
}

# pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField isEqual:[self fullNameTxtField]]) {
        [[self emailAddressTxtField] becomeFirstResponder];
    } else if ([textField isEqual:[self emailAddressTxtField]]) {
        [[self passwordTxtField] becomeFirstResponder];
    } else if ([textField isEqual:[self passwordTxtField]]) {
        [self signUpButtonTapped:[self signUpBtn]];
    }
    return YES;
}

@end
