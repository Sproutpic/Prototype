//
//  ProjectDetailViewController.m
//  Sprout
//
//  Created by Jeff Morris on 10/9/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "ProjectDetailViewController.h"
#import "TableAdapter.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIImage+animatedGIF.h"
#import "UIUtils.h"
#import "DataObjects.h"
#import "ProjectWebService.h"
#import "SyncQueue.h"

#import "TextFieldTableViewCell.h"
#import "SocialMediaButtonsTableViewCell.h"
#import "TimelineTableViewCell.h"
#import "SliderTableViewCell.h"
#import "SwitchTableViewCell.h"
#import "SproutDisplayTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "SelectTableViewController.h"
#import "DateSelectorViewController.h"

#define DATE_FORMAT_TIME NSLocalizedString(@"h:mm a", @"h:mm a")
#define DATE_FORMAT_SHORT_DATE NSLocalizedString(@"MM/dd/yy h:mma", @"MM/dd/yy h:mma")

@interface ProjectDetailViewController () <SelectTableViewControllerDelegate, DateSelectorViewControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *rows;
@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

typedef enum ProjectRowOrder {
    PO_StaticLabel = 0,
    PO_Title,
    PO_Sprout,
    PO_Description,
    PO_Timeline,
    PO_FrontFaceCamereSwitch,
    PO_DurationSlider,
    PO_ShowShadow,
    PO_RemindSwitch,
    PO_RemindOnLabel,
    PO_RemindRepeat,
    PO_CreateDate,
    PO_LastUpdate,
    PO_SocialButtons,
    PO_DeleteButton,
    PO_SyncButton
} ProjectRowOrder;

typedef enum RowDataOrder {
    RD_POType = 0,
    RD_Title,
    RD_CellName,
    RD_CellNib,
    RD_CellHeight
} RowDataOrder;

@implementation ProjectDetailViewController

# pragma mark Private

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    NSArray *rowData = [self rowDataAtIndex:[indexPath row]];
    switch ([[rowData objectAtIndex:RD_POType] integerValue]) {
        case PO_StaticLabel: {
            [[cell textLabel] setText:NSLocalizedString([rowData objectAtIndex:RD_Title], [rowData objectAtIndex:RD_Title])];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryView:nil];
        } break;
        case PO_Title: {
            TextFieldTableViewCell *tCell = (TextFieldTableViewCell*)cell;
            [[tCell textfield] setPlaceholder:NSLocalizedString([rowData objectAtIndex:RD_Title], [rowData objectAtIndex:RD_Title])];
            [[tCell textfield] setText:[[self project] title]];
            [[tCell textfield] setClearButtonMode:UITextFieldViewModeWhileEditing];
            [[tCell textview] setHidden:YES];
            [tCell setTextFieldCallback:^(UITextField *textfield){
                if (textfield) {
                    [[self project] setTitle:[[textfield text] copy]];
                    [[self project] setLastModified:[NSDate date]];
                    [[self project] save];
                }
            }];
            [tCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        } break;
        case PO_Sprout: {
            SproutDisplayTableViewCell *tCell = (SproutDisplayTableViewCell*)cell;
            [tCell setProject:[self project]];
            [tCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        } break;
        case PO_Description: {
            TextFieldTableViewCell *tCell = (TextFieldTableViewCell*)cell;
            [[tCell textview] setPlaceholder:NSLocalizedString([rowData objectAtIndex:RD_Title], [rowData objectAtIndex:RD_Title])];
            [[tCell textview] setText:[[self project] subtitle]];
            [[tCell textfield] setHidden:YES];
            [tCell setTextViewCallback:^(UITextView *textview){
                if (textview) {
                    [[self project] setSubtitle:[[textview text] copy]];
                    [[self project] setLastModified:[NSDate date]];
                    [[self project] save];
                }
            }];
            [tCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        } break;
        case PO_Timeline: {
            TimelineTableViewCell *tCell = (TimelineTableViewCell*)cell;
            [tCell setEditState:YES];
            [tCell setProject:[self project]];
            [tCell setProjectDelegate:self];
            [tCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        } break;
        case PO_DurationSlider: {
            SliderTableViewCell *tCell = (SliderTableViewCell*)cell;
            NSString *title = [NSString stringWithFormat:
                               NSLocalizedString(@"Duration between photos is %0.1f seconds",
                                                 @"Duration between photos is %0.1f seconds"),[[[self project] slideTime] floatValue]];
            [[tCell sliderTitle] setText:title];
            [[tCell slider] setMinimumValue:0.1];
            [[tCell slider] setMaximumValue:3.0];
            [[tCell minLbl] setText:[NSString stringWithFormat:@"%0.1f",[[tCell slider] minimumValue]]];
            [[tCell maxLbl] setText:[NSString stringWithFormat:@"%0.1f",[[tCell slider] maximumValue]]];
            [[tCell slider] setValue:[[[self project] slideTime] floatValue]];
            [tCell setSliderCallback:^(UISlider *slider, UITableViewCell *cell){
                if (slider) {
                    [[self project] setSlideTime:@([slider value])];
                    [[self project] setLastModified:[NSDate date]];
                    [[self project] save];
                    SliderTableViewCell *tCell = (SliderTableViewCell*)cell;
                    NSString *title = [NSString stringWithFormat:
                                       NSLocalizedString(@"Duration between photos is %0.1f seconds",
                                                         @"Duration between photos is %0.1f seconds"),[[[self project] slideTime] floatValue]];
                    [[tCell sliderTitle] setText:title];
                }
            }];
            [tCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        } break;
        case PO_RemindSwitch: {
            SwitchTableViewCell *tCell = (SwitchTableViewCell*)cell;
            [[tCell textLabel] setText:NSLocalizedString([rowData objectAtIndex:RD_Title], [rowData objectAtIndex:RD_Title])];
            [[tCell switchView] setOn:[[[self project] remindEnabled] boolValue]];
            [tCell setSwitchCallback:^(UISwitch *switchView){
                if (switchView) {
                    [[self project] setRemindEnabled:@([switchView isOn])];
                    [[self project] updateScheduledNotification];
                    [[self project] setLastModified:[NSDate date]];
                    [[self project] save];
                    [[self tableView] performSelector:@selector(reloadData) withObject:nil afterDelay:0.25];
                }
            }];
            [tCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        } break;
        case PO_FrontFaceCamereSwitch: {
            SwitchTableViewCell *tCell = (SwitchTableViewCell*)cell;
            [[tCell textLabel] setText:NSLocalizedString([rowData objectAtIndex:RD_Title], [rowData objectAtIndex:RD_Title])];
            [[tCell switchView] setOn:[[[self project] frontCameraEnabled] boolValue]];
            [tCell setSwitchCallback:^(UISwitch *switchView){
                if (switchView) {
                    [[self project] setFrontCameraEnabled:@([switchView isOn])];
                    [[self project] setLastModified:[NSDate date]];
                    [[self project] save];
                }
            }];
            [tCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        } break;
        case PO_ShowShadow: {
            SwitchTableViewCell *tCell = (SwitchTableViewCell*)cell;
            [[tCell textLabel] setText:NSLocalizedString([rowData objectAtIndex:RD_Title], [rowData objectAtIndex:RD_Title])];
            [[tCell switchView] setOn:[[[self project] useShadow] boolValue]];
            [tCell setSwitchCallback:^(UISwitch *switchView){
                if (switchView) {
                    [[self project] setUseShadow:@([switchView isOn])];
                    [[self project] setLastModified:[NSDate date]];
                    [[self project] save];
                }
            }];
            [tCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        } break;
        case PO_RemindOnLabel: {
            [[cell textLabel] setText:NSLocalizedString([rowData objectAtIndex:RD_Title], [rowData objectAtIndex:RD_Title])];
            [[cell textLabel] setTextColor:([[[self project] remindEnabled] boolValue])?[UIColor blackColor]:[UIColor lightGrayColor]];
            NSString *description = nil;
            if ([[self project] repeatNextDate]) {
                [[self dateFormatter] setDateFormat:DATE_FORMAT_TIME];
                description = [[self dateFormatter] stringFromDate:[[self project] repeatNextDate]];
            }
            description = ([[[self project] remindEnabled] boolValue])?description:NSLocalizedString(@"--", @"--");
            [[cell detailTextLabel] setText:description];
            [cell setSelectionStyle:([[[self project] remindEnabled] boolValue])?UITableViewCellSelectionStyleGray:UITableViewCellSelectionStyleNone];
            [cell setAccessoryView:([[[self project] remindEnabled] boolValue])?[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-right"]]:nil];
        } break;
        case PO_RemindRepeat: {
            [[cell textLabel] setText:NSLocalizedString([rowData objectAtIndex:RD_Title], [rowData objectAtIndex:RD_Title])];
            [[cell textLabel] setTextColor:([[[self project] remindEnabled] boolValue])?[UIColor blackColor]:[UIColor lightGrayColor]];
            NSString *description = nil;
            if ([[[self project] repeatFrequency] intValue]>=0 && [[[self project] repeatFrequency] intValue]<RF_Count) {
                description = [REPEAT_FREQUENCY_STRS objectAtIndex:[[[self project] repeatFrequency] intValue]];
            }
            description = ([[[self project] remindEnabled] boolValue])?description:NSLocalizedString(@"--", @"--");
            [[cell detailTextLabel] setText:description];
            [cell setSelectionStyle:([[[self project] remindEnabled] boolValue])?UITableViewCellSelectionStyleGray:UITableViewCellSelectionStyleNone];
            [cell setAccessoryView:([[[self project] remindEnabled] boolValue])?[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-right"]]:nil];
        } break;
        case PO_CreateDate: {
            [[cell textLabel] setText:NSLocalizedString([rowData objectAtIndex:RD_Title], [rowData objectAtIndex:RD_Title])];
            [[cell textLabel] setTextColor:[UIColor blackColor]];
            NSString *description = NSLocalizedString(@"Never", @"Never");
            if ([[self project] created]) {
                [[self dateFormatter] setDateFormat:DATE_FORMAT_SHORT_DATE];
                description = [[self dateFormatter] stringFromDate:[[self project] created]];
            }
            [[cell detailTextLabel] setText:description];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryView:nil];
        } break;
        case PO_LastUpdate: {
            [[cell textLabel] setText:NSLocalizedString([rowData objectAtIndex:RD_Title], [rowData objectAtIndex:RD_Title])];
            NSString *description = NSLocalizedString(@"Never", @"Never");
            if ([[self project] lastModified]) {
                [[self dateFormatter] setDateFormat:DATE_FORMAT_SHORT_DATE];
                description = [[self dateFormatter] stringFromDate:[[self project] lastModified]];
            }
            [[cell detailTextLabel] setText:description];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryView:nil];
        } break;
        case PO_SocialButtons: {
            SocialMediaButtonsTableViewCell *tCell = (SocialMediaButtonsTableViewCell*)cell;
            [tCell setProject:[self project]];
            [tCell setSocialMediaCallBack:^(SocialMediaType mediaType, Project *project){
                if (project) {
                    switch (mediaType) {
                        case SocialMediaFacebook: {
                            [self displayUnderConstructionAlert];
                        } break;
                        case SocialMediaTwitter: {
                            [self displayUnderConstructionAlert];
                        } break;
                        case SocialMediaSprout: {
                            UIAlertController *alert = nil;
                            alert = [UIAlertController alertControllerWithTitle:
                                     NSLocalizedString(@"Sprout Privacy",
                                                       @"Sprout Privacy")
                                                                        message:
                                     NSLocalizedString(@"Sprouts can either be public or private. If you want to share this Sprout with others, you must make it public. Do you want this Sprout to be Public or Private?",
                                                       @"Sprouts can either be public or private. If you want to share this Sprout with others, you must make it public. Do you want this Sprout to be Public or Private?")
                                                                 preferredStyle:UIAlertControllerStyleAlert];
                            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Private", @"Private")
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:
                                              ^(UIAlertAction * _Nonnull action) {
                                                  [[self project] setSproutSocial:@(NO)];
                                                  [[self project] save];
                                                  [[self tableView] reloadData];
                                              }]];
                            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Public", @"Public")
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:
                                              ^(UIAlertAction * _Nonnull action) {
                                                  [[self project] setSproutSocial:@(YES)];
                                                  [[self project] save];
                                                  [[self tableView] reloadData];
                                              }]];
                            [[self navigationController] presentViewController:alert animated:YES completion:nil];
                        } break;
                    }
                }
            }];
            [tCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        } break;
        case PO_DeleteButton: {
            ButtonTableViewCell *tCell = (ButtonTableViewCell*)cell;
            [[tCell button] setTitle:NSLocalizedString([rowData objectAtIndex:RD_Title], [rowData objectAtIndex:RD_Title]) forState:UIControlStateNormal];
            [tCell setButtonCallBack:^(UIButton *button){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Delete Sprout Project", @"Delete Sprout Project")
                                                                               message:NSLocalizedString(@"Are you sure you want to delete this entire sprout project?", @"Are you sure you want to delete this entire sprout project?")
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Delete Project", @"Delete Project")
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            if ([[[self project] serverId] integerValue]>0) {
                                                                [[self project] setMarkedForDelete:@(YES)];
                                                                [[self project] save];
                                                                [[SyncQueue manager] addService:[ProjectWebService deleteProjectById:[[self project] serverId] withCallback:nil]];
                                                            } else {
                                                                [[self project] deleteAndSave];
                                                            }
                                                            [[self navigationController] popViewControllerAnimated:YES];
                                                        }]];
                [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil]];
                [[self navigationController] presentViewController:alert animated:YES completion:nil];
            }];
            [tCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        } break;
        case PO_SyncButton: {
            ButtonTableViewCell *tCell = (ButtonTableViewCell*)cell;
            [[tCell button] setTitle:NSLocalizedString([rowData objectAtIndex:RD_Title], [rowData objectAtIndex:RD_Title]) forState:UIControlStateNormal];
            [tCell setButtonCallBack:^(UIButton *button){
                [[SyncQueue manager] addService:[ProjectWebService syncProject:[self project] withCallback:nil]];
            }];
            [tCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        } break;
            
        default: {
            [[cell textLabel] setText:@"Unknown"];
        } break;
    }
}

- (NSArray*)rowDataAtIndex:(NSInteger)row
{
    return [[self rows] objectAtIndex:row];
}

- (void)setProject:(Project *)project
{
    if (project) {
        [self setMoc:[[CoreDataAccessKit sharedInstance] createNewManagedObjectContextwithName:@"EditProject"
                                                                                andConcurrency:NSMainQueueConcurrencyType]];
        _project = (Project*)[[CoreDataAccessKit sharedInstance] findAnObject:NSStringFromClass([Project class])
                                                                 forPredicate:[NSPredicate predicateWithFormat:@"self = %@",project]
                                                                     withSort:nil
                                                                        inMOC:[self moc]];
    } else {
        _project = nil;
        [self setMoc:nil];
    }
}

# pragma mark UIViewController

- (void)viewDidLoad
{
    // Row Data: [ RD_POType(Int), RD_Title(String), RD_CellName(String), RD_CellNib(String), RD_CellHeight(Int) ]
    [self setRows:
     @[
       @[@(PO_Title),@"Project Title",@"TextFieldTableViewCell",@"TextFieldTableViewCell",@(54)],
       @[@(PO_Sprout),@"Sprout Movie",@"SproutDisplayTableViewCell",@"SproutDisplayTableViewCell",@(225)],
       @[@(PO_Description),@"Description",@"TextFieldTableViewCell",@"TextFieldTableViewCell",@(100)],
       @[@(PO_Timeline),@"Timeline",@"TimelineTableViewCell",@"TimelineTableViewCell",@(110)],
       @[@(PO_FrontFaceCamereSwitch),@"Use Front Facing Camera",@"SwitchTableViewCell",@"SwitchTableViewCell",@(44)],
       @[@(PO_DurationSlider),@"Duration Slider",@"SliderTableViewCell",@"SliderTableViewCell",@(88)],
       @[@(PO_ShowShadow),@"Use Shadow with Sprout",@"SwitchTableViewCell",@"SwitchTableViewCell",@(44)],
       @[@(PO_RemindSwitch),@"Remind Me",@"SwitchTableViewCell",@"SwitchTableViewCell",@(44)],
       @[@(PO_RemindOnLabel),@"Remind On",@"UITableViewCellStyleValue1",@"",@(44)],
       @[@(PO_RemindRepeat),@"Repeat",@"UITableViewCellStyleValue1",@"",@(44)],
       @[@(PO_CreateDate),@"Created",@"UITableViewCellStyleValue1",@"",@(44)],
       //@[@(PO_LastUpdate),@"Last Updated",@"UITableViewCellStyleValue1",@"",@(44)],
       @[@(PO_SocialButtons),@"Socail Media",@"SocialMediaButtonsTableViewCell",@"SocialMediaButtonsTableViewCell",@(54)],
       @[@(PO_DeleteButton),@"Delete Sprout",@"ButtonTableViewCell",@"ButtonTableViewCell",@(54)],
       @[@(PO_SyncButton),@"Sync Project",@"ButtonTableViewCell",@"ButtonTableViewCell",@(54)],
       ]];
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"Project Details", @"Project Details")];
    
    if (![self dateFormatter]) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:DATE_FORMAT_SHORT_DATE];
        [self setDateFormatter:df];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[[self project] managedObjectContext] refreshAllObjects];
    [[self tableView] reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self tableView] setFrame:[[self view] bounds]];
    if ([[self project] isDeleted] || [[[self project] markedForDelete] boolValue]) {
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

# pragma mark BaseViewControllerDelegate

- (void)setController
{
    [super setController];
    [self setTableView:[self createBaseTableView:UITableViewStylePlain]];
    [[self tableView] setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSproutLogoTableFooter:[self tableView]];
    [[self view] addSubview:[self tableView]];
}

# pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tv deselectRowAtIndexPath:indexPath animated:YES];

    NSArray *rowData = [self rowDataAtIndex:[indexPath row]];
    switch ([[rowData objectAtIndex:RD_POType] integerValue]) {
        case PO_RemindOnLabel: {
            if ([[[self project] remindEnabled] boolValue]) {
                DateSelectorViewController *vc = [[DateSelectorViewController alloc] initWithNibName:@"DateSelectorViewController" bundle:nil];
                [vc setDateDelegate:self];
                [vc setTag:[[rowData objectAtIndex:RD_POType] integerValue]];
                [CATransaction begin];
                [[self navigationController] pushViewController:vc animated:YES];
                [CATransaction setCompletionBlock:^{
                    [[vc datePicker] setDatePickerMode:UIDatePickerModeTime];
                    [[vc datePicker] setMinuteInterval:5];
                    if ([[self project] repeatNextDate]) {
                        [[vc datePicker] setDate:[[self project] repeatNextDate] animated:YES];
                    }
                }];
                [CATransaction commit];
                [vc setTitle:NSLocalizedString(@"Repeat On", @"Repeat On")];
            }
        } break;
        case PO_RemindRepeat: {
            if ([[[self project] remindEnabled] boolValue]) {
                SelectTableViewController *vc = [[SelectTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                [vc setSelectDelegate:self];
                [vc setTag:[[rowData objectAtIndex:RD_POType] integerValue]];
                [vc setTitle:NSLocalizedString(@"Repeat", @"Repeat")];
                // Row Data: [ SelectRD_Title(String), SelectRD_Subtitle(String), SelectRD_Selected(Bool) ]
                NSMutableArray *rowData = [@[] mutableCopy];
                for (NSString *str in REPEAT_FREQUENCY_STRS) {
                    NSInteger freq = [[[self project] repeatFrequency] integerValue];
                    [rowData addObject:@[str, @"", @((freq==[REPEAT_FREQUENCY_STRS indexOfObject:str]))]];
                }
                [vc setRows:rowData];
                [[self navigationController] pushViewController:vc animated:YES];
            }
        } break;
    }
}

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[self rowDataAtIndex:[indexPath row]] objectAtIndex:RD_CellHeight] floatValue];
}

# pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return [[self rows] count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseCell = [[self rowDataAtIndex:[indexPath row]] objectAtIndex:RD_CellName];
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:reuseCell];
    if (!cell) {
        if ([[[self rowDataAtIndex:[indexPath row]] objectAtIndex:RD_CellNib] length]>0) {
            UIViewController *vc = [[UIViewController alloc] initWithNibName:reuseCell bundle:nil];
            cell = (UITableViewCell*)[vc view];
        } else if ([reuseCell isEqualToString:@"UITableViewCellStyleDefault"]){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseCell];
        } else if ([reuseCell isEqualToString:@"UITableViewCellStyleValue1"]){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseCell];
        } else if ([reuseCell isEqualToString:@"UITableViewCellStyleValue2"]){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseCell];
        } else if ([reuseCell isEqualToString:@"UITableViewCellStyleSubtitle"]){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseCell];
        }
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

# pragma mark ProjectTableViewCellDelegate

- (void)useCameraToAddNewSproutToProject:(Project*)project
{
    [self showCameraForNewSprout:project withCameraCallback:nil];
}

# pragma mark SelectTableViewControllerDelegate

- (void)selectionMade:(NSArray*)rows forIndex:(NSInteger)index withTag:(NSInteger)tag
{
    switch (tag) {
        case PO_RemindOnLabel: {
            //[[self project] setRepeatFrequency:@(index)];
        } break;
        case PO_RemindRepeat: {
            [[self project] setRepeatFrequency:@(index)];
            NSCalendar *cal = [NSCalendar currentCalendar];
            NSDate *yesterday = [cal dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:[NSDate date] options:NSCalendarMatchNextTime];
            NSDate *curDate = [[self project] repeatNextDate];
            NSDate *date = [cal dateBySettingHour:[cal component:NSCalendarUnitHour fromDate:curDate]
                                           minute:[cal component:NSCalendarUnitMinute fromDate:curDate]
                                           second:0 ofDate:yesterday options:NSCalendarWrapComponents];
            [[self project] setRepeatNextDate:date];
            [[self project] updateScheduledNotification];
        } break;
    }
    [[self project] setLastModified:[NSDate date]];
    [[self project] save];
    [[self navigationController] popViewControllerAnimated:YES];
}

# pragma mark DateSelectorViewControllerDelegate

- (void)dateChanged:(UIDatePicker*)datePicker withTag:(NSInteger)tag
{
    switch (tag) {
        case PO_RemindOnLabel: {
            [[self project] setRepeatNextDate:[datePicker date]];
            [[self project] updateScheduledNotification];
        } break;
    }
    [[self project] setLastModified:[NSDate date]];
    [[self project] save];
}


@end
