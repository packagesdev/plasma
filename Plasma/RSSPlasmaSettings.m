
#import "RSSPlasmaSettings.h"

NSString * const RSSPlasma_Settings_ZoomKey=@"Zoom";
NSString * const RSSPlasma_Settings_FocusKey=@"Focus";
NSString * const RSSPlasma_Settings_SpeedKey=@"Speed";
NSString * const RSSPlasma_Settings_ResolutionKey=@"Resolution";

@implementation RSSPlasmaSettings

- (id)initWithDictionaryRepresentation:(NSDictionary *)inDictionary
{
	self=[super init];
	
	if (self!=nil)
	{
		NSNumber * tNumber=inDictionary[RSSPlasma_Settings_ZoomKey];
		
		if (tNumber==nil)
		{
			[self resetSettings];
		}
		else
		{
			_zoom=[inDictionary[RSSPlasma_Settings_ZoomKey] unsignedIntegerValue];
			_focus=[inDictionary[RSSPlasma_Settings_FocusKey] unsignedIntegerValue];
			_speed=[inDictionary[RSSPlasma_Settings_SpeedKey] unsignedIntegerValue];
			_resolution=[inDictionary[RSSPlasma_Settings_ResolutionKey] unsignedIntegerValue];
		}
	}
	
	return self;
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary * tMutableDictionary=[NSMutableDictionary dictionary];
	
	if (tMutableDictionary!=nil)
	{
		tMutableDictionary[RSSPlasma_Settings_ZoomKey]=@(_zoom);
		tMutableDictionary[RSSPlasma_Settings_FocusKey]=@(_focus);
		tMutableDictionary[RSSPlasma_Settings_SpeedKey]=@(_speed);
		tMutableDictionary[RSSPlasma_Settings_ResolutionKey]=@(_resolution);
	}
	
	return [tMutableDictionary copy];
}

#pragma mark -

- (void)resetSettings
{
	_zoom=10;
	_focus=30;
	_speed=20;
	_resolution=25;
}

@end
