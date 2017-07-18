
#import "RSSPlasmaView.h"

#import "RSSPlasmaConfigurationWindowController.h"

#import "RSSUserDefaults+Constants.h"

#import "RSSPlasmaSettings.h"

#include "Plasma.h"

#import <OpenGL/gl.h>

@interface RSSPlasmaView ()
{
	BOOL _preview;
	BOOL _mainScreen;
	
	BOOL _OpenGLIncompatibilityDetected;
	
	NSOpenGLView *_openGLView;
	
	scene *_scene;
	
	// Preferences
	
	RSSPlasmaConfigurationWindowController *_configurationWindowController;
}

+ (void)_initializeScene:(scene *)inScene withSettings:(RSSPlasmaSettings *)inSettings;

@end

@implementation RSSPlasmaView

+ (void)_initializeScene:(scene *)inScene withSettings:(RSSPlasmaSettings *)inSettings
{
	inScene->zoom=(int)inSettings.zoom;
	inScene->focus=(int)inSettings.focus;
	inScene->speed=(int)inSettings.speed;
	inScene->resolution=(int)inSettings.resolution;
}

- (instancetype)initWithFrame:(NSRect)frameRect isPreview:(BOOL)isPreview
{
	self=[super initWithFrame:frameRect isPreview:isPreview];
	
	if (self!=nil)
	{
		_preview=isPreview;
		
		if (_preview==YES)
			_mainScreen=YES;
		else
			_mainScreen= (NSMinX(frameRect)==0 && NSMinY(frameRect)==0);
		
		[self setAnimationTimeInterval:0.05];
	}
	
	return self;
}

#pragma mark -

- (void) setFrameSize:(NSSize)newSize
{
	[super setFrameSize:newSize];
	
	if (_openGLView!=nil)
		[_openGLView setFrameSize:newSize];
}

#pragma mark -

- (void) drawRect:(NSRect) inFrame
{
	[[NSColor blackColor] set];
	
	NSRectFill(inFrame);
	
	if (_OpenGLIncompatibilityDetected==YES)
	{
		BOOL tShowErrorMessage=_mainScreen;
		
		if (tShowErrorMessage==NO)
		{
			NSString *tIdentifier = [[NSBundle bundleForClass:[self class]] bundleIdentifier];
			ScreenSaverDefaults *tDefaults = [ScreenSaverDefaults defaultsForModuleWithName:tIdentifier];
			
			tShowErrorMessage=![tDefaults boolForKey:RSSUserDefaultsMainDisplayOnly];
		}
		
		if (tShowErrorMessage==YES)
		{
			NSRect tFrame=self.frame;
			
			NSMutableParagraphStyle * tMutableParagraphStyle=[[NSParagraphStyle defaultParagraphStyle] mutableCopy];
			[tMutableParagraphStyle setAlignment:NSCenterTextAlignment];
			
			NSDictionary * tAttributes = @{NSFontAttributeName:[NSFont systemFontOfSize:[NSFont systemFontSize]],
										   NSForegroundColorAttributeName:[NSColor whiteColor],
										   NSParagraphStyleAttributeName:tMutableParagraphStyle};

			
			NSString * tString=NSLocalizedStringFromTableInBundle(@"Minimum OpenGL requirements\rfor this Screen Effect\rnot available\ron your graphic card.",@"Localizable",[NSBundle bundleForClass:[self class]],@"No comment");
			
			NSRect tStringFrame;
			
			tStringFrame.origin=NSZeroPoint;
			tStringFrame.size=[tString sizeWithAttributes:tAttributes];
			
			tStringFrame=SSCenteredRectInRect(tStringFrame,tFrame);
			
			[tString drawInRect:tStringFrame withAttributes:tAttributes];
		}
	}
}

#pragma mark -

- (void)startAnimation
{
	_OpenGLIncompatibilityDetected=NO;
	
	[super startAnimation];
	
	NSString *tIdentifier = [[NSBundle bundleForClass:[self class]] bundleIdentifier];
	ScreenSaverDefaults *tDefaults = [ScreenSaverDefaults defaultsForModuleWithName:tIdentifier];
	
	BOOL tBool=[tDefaults boolForKey:RSSUserDefaultsMainDisplayOnly];
	
	if (tBool==YES && _mainScreen==NO)
		return;
	
	// Add OpenGLView
	
	NSOpenGLPixelFormatAttribute attribs[] =
	{
		NSOpenGLPFADoubleBuffer,
		NSOpenGLPFADepthSize,(NSOpenGLPixelFormatAttribute)16,
		NSOpenGLPFAMinimumPolicy,
		(NSOpenGLPixelFormatAttribute)0
	};
	
	NSOpenGLPixelFormat *tFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attribs];
	
	if (tFormat==nil)
	{
		_OpenGLIncompatibilityDetected=YES;
		return;
	}

	if (_openGLView!=nil)
	{
		[_openGLView removeFromSuperview];
		_openGLView=nil;
	}

	_openGLView = [[NSOpenGLView alloc] initWithFrame:self.bounds pixelFormat:tFormat];
	
	if (_openGLView!=nil)
	{
		[_openGLView setWantsBestResolutionOpenGLSurface:YES];
		
		[self addSubview:_openGLView];
	}
	else
	{
		_OpenGLIncompatibilityDetected=YES;
		return;
	}
	
	[[_openGLView openGLContext] makeCurrentContext];
	
	NSRect tPixelBounds=[_openGLView convertRectToBacking:_openGLView.bounds];
	NSSize tSize=tPixelBounds.size;
	
	_scene=new scene();
	
	if (_scene!=NULL)
	{
		[RSSPlasmaView _initializeScene:_scene
							   withSettings:[[RSSPlasmaSettings alloc] initWithDictionaryRepresentation:[tDefaults dictionaryRepresentation]]];
		_scene->resize((int)tSize.width, (int)tSize.height);
		_scene->create();
	}
	
	const GLint tSwapInterval=1;
	CGLSetParameter(CGLGetCurrentContext(), kCGLCPSwapInterval,&tSwapInterval);
}

- (void)stopAnimation
{
	[super stopAnimation];
	
	if (_scene!=NULL)
	{
		delete _scene;
		_scene=NULL;
	}
}

- (void)animateOneFrame
{
	if (_openGLView!=nil)
	{
		[[_openGLView openGLContext] makeCurrentContext];
		
		if (_scene!=NULL)
			_scene->draw();
		
		[[_openGLView openGLContext] flushBuffer];
	}
}

#pragma mark - Configuration

- (BOOL)hasConfigureSheet
{
	return YES;
}

- (NSWindow*)configureSheet
{
	if (_configurationWindowController==nil)
		_configurationWindowController=[[RSSPlasmaConfigurationWindowController alloc] init];
	
	NSWindow * tWindow=_configurationWindowController.window;
	
	[_configurationWindowController restoreUI];
	
	return tWindow;
}

@end
