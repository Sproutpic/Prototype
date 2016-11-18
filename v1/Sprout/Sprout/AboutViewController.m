//
//  AboutViewController.m
//  Sprout
//
//  Created by Jeff Morris on 10/10/2016
//  Copyright © 2016 sprout. All rights reserved.
//

#import "AboutViewController.h"
#import "UIUtils.h"
#import "PrivacyPolicyViewController.h"
#import "VTAcknowledgementsViewController.h"

@interface AboutViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *rows;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation AboutViewController

# pragma mark Private

- (IBAction)termsAndConditionsButtonTapped:(id)sender
{
    [self displayUnderConstructionAlert];
}

- (IBAction)privacyAndPolicyButtonTapped:(id)sender
{
    [[self navigationController] pushViewController:[[PrivacyPolicyViewController alloc] init] animated:YES];
}

- (IBAction)acknowledgementsButtonTapped:(id)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Pods-SproutPic-acknowledgements" ofType:@"plist"];
    VTAcknowledgementsViewController *vc = [[VTAcknowledgementsViewController alloc] initWithPath:path];
    [vc setHeaderText:NSLocalizedString(@"We love open source software.", @"We love open source software.")];
    [[self navigationController] pushViewController:vc animated:YES];
}

- (NSArray*)rowDataAtIndex:(NSInteger)row
{
    return [[self rows] objectAtIndex:row];
}

# pragma mark UIViewController

- (void)viewDidLoad
{
    [self setRows:
     @[
       @[@(NO),@"What?",@"Easy to use application to track progression of your activities. Make shots and create sprout to view the all-in-one progression and share it with friends."],
       @[@(NO),@"Why?",@"We created SproutPic because we wanted to help you show the world change in action."],
       @[@(NO),@"Questions?",@"Check the FAQ section or contact us directly a support@sproutpic.com."],
       ]];
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"About", @"About")];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] setFrame:[[self view] bounds]];
}

# pragma mark BaseViewControllerDelegate

- (void)setController
{
    [super setController];
    [self setTableView:[self createBaseTableView:UITableViewStyleGrouped]];
    
    // Create Table Header
    UIView *tableHeader = [[UIView alloc] init];
    [tableHeader setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 125)];
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(((tableHeader.frame.size.width) / 2) - ((65 * 1.11)), 15, 65 * 1.11, 65)];
    logo.image = [UIImage imageNamed:@"logo-green"];
    [tableHeader addSubview:logo];
    
    UILabel *logoLabel = [[UILabel alloc] init];
    logoLabel.text = NSLocalizedString(@"SproutPic", @"SproutPic");
    logoLabel.font = [UIUtils fontRegularForSize:22];
    logoLabel.textColor =[UIUtils colorNavigationBar];
    [logoLabel sizeToFit];
    logoLabel.frame = CGRectMake(logo.frame.origin.x + logo.frame.size.width * 0.55, (15 + logo.frame.size.height) - logoLabel.frame.size.height, logoLabel.frame.size.width, logoLabel.frame.size.height);
    [tableHeader addSubview:logoLabel];
    
    UILabel *lblNote = [[UILabel alloc]init];
    lblNote.text = NSLocalizedString(@"Inspire Change", @"Inspire Change");
    lblNote.font = [UIUtils fontRegularForSize:16];
    lblNote.textColor =[UIUtils colorNavigationBar];
    [lblNote sizeToFit];
    lblNote.frame = CGRectMake((self.view.frame.size.width-lblNote.frame.size.width)/2, logoLabel.frame.origin.y + logoLabel.frame.size.height + 10, lblNote.frame.size.width, lblNote.frame.size.height);
    [tableHeader addSubview:lblNote];
    
    [[self tableView] setTableHeaderView:tableHeader];
    
    // Create Table Footer
    UIView *footer = [[UIView alloc] init];
    [footer setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 122.0)];
    
    UIButton *tBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, footer.frame.size.width, 44.0)];
    [tBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"Terms and Conditions", @"Terms and Conditions")
                                                             attributes:
                              @{ NSFontAttributeName: [UIUtils fontRegularForSize:14],
                                 NSForegroundColorAttributeName:[UIUtils colorNavigationBar]}]
                    forState:UIControlStateNormal];
    [tBtn addTarget:self action:@selector(termsAndConditionsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:tBtn];
    
    UIButton *pBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 44.0, footer.frame.size.width, 44.0)];
    [pBtn setTitle:NSLocalizedString(@"Privacy Policy", @"Privacy Policy") forState:UIControlStateNormal];
    [pBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"Privacy Policy", @"Privacy Policy")
                                                             attributes:
                              @{ NSFontAttributeName: [UIUtils fontRegularForSize:14],
                                 NSForegroundColorAttributeName:[UIUtils colorNavigationBar]}]
                    forState:UIControlStateNormal];
    [pBtn addTarget:self action:@selector(privacyAndPolicyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:pBtn];
    
    UIButton *aBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 88.0, footer.frame.size.width, 44.0)];
    [aBtn setTitle:NSLocalizedString(@"Acknowledgements", @"Acknowledgements") forState:UIControlStateNormal];
    [aBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"Acknowledgements", @"Acknowledgements")
                                                             attributes:
                              @{ NSFontAttributeName: [UIUtils fontRegularForSize:14],
                                 NSForegroundColorAttributeName:[UIUtils colorNavigationBar]}]
                    forState:UIControlStateNormal];
    [aBtn addTarget:self action:@selector(acknowledgementsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:aBtn];
    
    [[self tableView] setTableFooterView:footer];
    
    [[self view] addSubview:[self tableView]];
}

# pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *dataRow = [self rowDataAtIndex:indexPath.row];
    return ([[dataRow objectAtIndex:0] boolValue]) ? 90.0 : 90.0; // Make this height dynamic...
}

# pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return [[self rows] count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseCell = @"UITableViewCellStyleSubtitle";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:reuseCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [[cell textLabel] setTextColor:[UIUtils colorNavigationBar]];
        [[cell detailTextLabel] setNumberOfLines:100];
    }
    NSArray *dataRow = [self rowDataAtIndex:indexPath.row];
    [[cell textLabel] setText:[dataRow objectAtIndex:1]];
    [[cell detailTextLabel] setText:[dataRow objectAtIndex:2]];
    return cell;
}

@end
