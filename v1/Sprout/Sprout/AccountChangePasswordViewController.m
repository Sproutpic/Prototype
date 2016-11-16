//
//  AccountChangePasswordViewController.m
//  Sprout
//
//  Created by Jeff Morris on 10/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "AccountChangePasswordViewController.h"
#import "NSString+WhiteSpacing.h"
#import "AccountWebService.h"
#import "JVFloatLabeledTextField.h"
#import "UIUtils.h"

@interface AccountChangePasswordViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *currentPasswordTxtField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *passwordNewTxtField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *passwordRepeatTxtField;
@property (weak, nonatomic) IBOutlet UILabel *changePasswordLbl;
@property (weak, nonatomic) IBOutlet UIButton *changePasswordBtn;
@property (weak, nonatomic) IBOutlet UIView *textBKView1;
@property (weak, nonatomic) IBOutlet UIView *textBKView2;
@property (weak, nonatomic) IBOutlet UIView *textBKView3;

- (IBAction)changePasswordButtonTapped:(id)sender;

@end

@implementation AccountChangePasswordViewController

# pragma mark Private

- (IBAction)changePasswordButtonTapped:(id)sender {
    
    NSString *currentPwd = [[[self currentPasswordTxtField] text] stringByTrimmingLeadingAndTailingWhitespace];
    NSString *passwordNew = [[[self passwordNewTxtField] text] stringByTrimmingLeadingAndTailingWhitespace];
    NSString *passwordRepeat = [[[self passwordRepeatTxtField] text] stringByTrimmingLeadingAndTailingWhitespace];
    
    [UIUtils hapticFeedback];

    // Verify all 3 fields have data entered
    if (currentPwd==nil || passwordNew==nil || passwordRepeat==nil ||
        [currentPwd length]<=0 || [passwordNew length]<=0 || [passwordRepeat length]<=0) {
        [self displayMessageWithTitle:NSLocalizedString(@"Missing Data", @"Missing Data")
                              andBody:NSLocalizedString(@"You must enter all the needed passwords to change your password.",
                                                        @"You must enter all the needed passwords to change your password.")];

        [self displayMessageWithBody:NSLocalizedString(@"All fields are not entered",
                                                       @"New password does not match")];
        return;
    }
    
    // Verify that the new password is atleast 8 characters long
    if ([passwordNew length]<=7) {
        [self displayMessageWithTitle:NSLocalizedString(@"Password Validation", @"Password Validation")
                              andBody:NSLocalizedString(@"You must enter a password that is 8 characters or longer. We also recommend that you use a combination of uppercase, lowercase, and number characters.",
                                                        @"You must enter a password that is 8 characters or longer. We also recommend that you use a combination of uppercase, lowercase, and number characters.")];
        return;
    }
    
    // Verify that the new and repeat passwords match
    if (![passwordNew isEqualToString:passwordRepeat]) {
        [self displayMessageWithTitle:NSLocalizedString(@"Passwords Don't Match", @"Passwords Don't Match")
                              andBody:NSLocalizedString(@"The password or confirmation password that you entered do not match",
                                                        @"The password or confirmation password that you entered do not match")];
        return;
    }
    
    // Place spinner on screen
    [self showFullScreenSpinner:YES];
    
    // All looks good, so lets call the web service...
    [AccountWebService changePasswordForEmail:[CurrentUser emailAddress]
                              currentPassword:currentPwd
                                  newPassword:passwordNew
                                 withCallback:
     ^(NSError *error, SproutWebService *service) {
         [self showFullScreenSpinner:NO];
         if (error) {
             [self displayMessageWithTitle:NSLocalizedString(@"Problem", @"Problem")
                                   andBody:[error localizedDescription]];
         } else {
             [[self navigationController] popViewControllerAnimated:YES];
             [self displayMessageWithTitle:NSLocalizedString(@"Success", @"Success")
                                   andBody:NSLocalizedString(@"Your password has been changed!",
                                                             @"Your password has been changed!")];
         }
     }];
}

# pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"Change Password", @"Change Password")];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self mainView] setFrame:[[self view] bounds]];
    
    [self roundCornersForView:[self changePasswordBtn]];
    [self themeFloatTextField:[self currentPasswordTxtField] withBK:[self textBKView1]];
    [self themeFloatTextField:[self passwordNewTxtField] withBK:[self textBKView2]];
    [self themeFloatTextField:[self passwordRepeatTxtField] withBK:[self textBKView3]];
}

# pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:[self currentPasswordTxtField]]) {
        [textField resignFirstResponder];
        [[self passwordNewTxtField] becomeFirstResponder];
    } else if ([textField isEqual:[self currentPasswordTxtField]]) {
        [textField resignFirstResponder];
        [[self passwordRepeatTxtField] becomeFirstResponder];
    } else if ([textField isEqual:[self currentPasswordTxtField]]) {
        [textField resignFirstResponder];
        [self changePasswordButtonTapped:[self changePasswordBtn]];
    }
    return YES;
}

@end
