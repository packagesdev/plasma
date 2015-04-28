
#import "RSSPlasmaConfigurationWindowController.h"

#import "RSSPlasmaSettings.h"

@interface RSSPlasmaConfigurationWindowController ()
{
	IBOutlet NSSlider *_zoomSlider;
	IBOutlet NSTextField *_zoomValueLabel;
	
	IBOutlet NSSlider *_focusSlider;
	IBOutlet NSTextField *_focusValueLabel;
	
	IBOutlet NSSlider *_speedSlider;
	IBOutlet NSTextField *_speedValueLabel;
	
	IBOutlet NSSlider *_resolutionSlider;
	IBOutlet NSTextField *_resolutionValueLabel;
}

- (IBAction)setZoom:(id)sender;
- (IBAction)setFocus:(id)sender;
- (IBAction)setSpeed:(id)sender;
- (IBAction)setResolution:(id)sender;

@end

@implementation RSSPlasmaConfigurationWindowController

- (Class)settingsClass
{
	return [RSSPlasmaSettings class];
}

- (void)restoreUI
{
	[super restoreUI];
	
	RSSPlasmaSettings * tPlasmaSettings=(RSSPlasmaSettings *) sceneSettings;
	
	[_zoomSlider setIntegerValue:tPlasmaSettings.zoom];
	[_zoomValueLabel setIntegerValue:tPlasmaSettings.zoom];
	
	[_focusSlider setIntegerValue:tPlasmaSettings.focus];
	[_focusValueLabel setIntegerValue:tPlasmaSettings.focus];
	
	[_speedSlider setIntegerValue:tPlasmaSettings.speed];
	[_speedValueLabel setIntegerValue:tPlasmaSettings.speed];
	
	[_resolutionSlider setIntegerValue:tPlasmaSettings.resolution];
	[_resolutionValueLabel setIntegerValue:tPlasmaSettings.resolution];
}

#pragma mark -

- (IBAction)setZoom:(id)sender
{
	((RSSPlasmaSettings *) sceneSettings).zoom=[sender integerValue];
	
	[_zoomValueLabel setIntegerValue:((RSSPlasmaSettings *) sceneSettings).zoom];
}

- (IBAction)setFocus:(id)sender
{
	((RSSPlasmaSettings *) sceneSettings).focus=[sender integerValue];
	
	[_focusValueLabel setIntegerValue:((RSSPlasmaSettings *) sceneSettings).focus];
}

- (IBAction)setSpeed:(id)sender
{
	((RSSPlasmaSettings *) sceneSettings).speed=[sender integerValue];
	
	[_speedValueLabel setIntegerValue:((RSSPlasmaSettings *) sceneSettings).speed];
}

- (IBAction)setResolution:(id)sender
{
	((RSSPlasmaSettings *) sceneSettings).resolution=[sender integerValue];
	
	[_resolutionValueLabel setIntegerValue:((RSSPlasmaSettings *) sceneSettings).resolution];
}

@end
