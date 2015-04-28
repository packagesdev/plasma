
#import "RSSPlasmaSettings.h"

NSString * const RSSPlasma_Settings_Zoom=@"Zoon";
NSString * const RSSPlasma_Settings_Focus=@"Focus";
NSString * const RSSPlasma_Settings_Speed=@"Speed";
NSString * const RSSPlasma_Settings_Resolution=@"Resolution";

@implementation RSSPlasmaSettings

- (id)initWithDictionaryRepresentation:(NSDictionary *)inDictionary
{
	self=[super init];
	
	if (self!=nil)
	{
		NSNumber * tNumber=inDictionary[RSSPlasma_Settings_Zoom];
		
		if (tNumber==nil)
		{
			[self resetSettings];
		}
		else
		{
			_zoom=[inDictionary[RSSPlasma_Settings_Zoom] unsignedIntegerValue];
			_focus=[inDictionary[RSSPlasma_Settings_Focus] unsignedIntegerValue];
			_speed=[inDictionary[RSSPlasma_Settings_Speed] unsignedIntegerValue];
			_resolution=[inDictionary[RSSPlasma_Settings_Resolution] unsignedIntegerValue];
		}
	}
	
	return self;
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary * tMutableDictionary=[NSMutableDictionary dictionary];
	
	if (tMutableDictionary!=nil)
	{
		tMutableDictionary[RSSPlasma_Settings_Zoom]=@(_zoom);
		tMutableDictionary[RSSPlasma_Settings_Focus]=@(_focus);
		tMutableDictionary[RSSPlasma_Settings_Speed]=@(_speed);
		tMutableDictionary[RSSPlasma_Settings_Resolution]=@(_resolution);
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
