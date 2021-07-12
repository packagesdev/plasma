
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
	
	_zoomSlider.integerValue=tPlasmaSettings.zoom;
	_zoomValueLabel.integerValue=tPlasmaSettings.zoom;
	
	_focusSlider.integerValue=tPlasmaSettings.focus;
	_focusValueLabel.integerValue=tPlasmaSettings.focus;
	
	_speedSlider.integerValue=tPlasmaSettings.speed;
	_speedValueLabel.integerValue=tPlasmaSettings.speed;
	
	_resolutionSlider.integerValue=tPlasmaSettings.resolution;
	_resolutionValueLabel.integerValue=tPlasmaSettings.resolution;
}

#pragma mark -

- (IBAction)setZoom:(id)sender
{
	((RSSPlasmaSettings *) sceneSettings).zoom=[sender integerValue];
	
	_zoomValueLabel.integerValue=((RSSPlasmaSettings *) sceneSettings).zoom;
}

- (IBAction)setFocus:(id)sender
{
	((RSSPlasmaSettings *) sceneSettings).focus=[sender integerValue];
	
	_focusValueLabel.integerValue=((RSSPlasmaSettings *) sceneSettings).focus;
}

- (IBAction)setSpeed:(id)sender
{
	((RSSPlasmaSettings *) sceneSettings).speed=[sender integerValue];
	
	_speedValueLabel.integerValue=((RSSPlasmaSettings *) sceneSettings).speed;
}

- (IBAction)setResolution:(id)sender
{
	((RSSPlasmaSettings *) sceneSettings).resolution=[sender integerValue];
	
	_resolutionValueLabel.integerValue=((RSSPlasmaSettings *) sceneSettings).resolution;
}

@end
