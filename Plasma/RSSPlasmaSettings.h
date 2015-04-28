
#import "RSSSettings.h"

@interface RSSPlasmaSettings : NSObject

@property NSUInteger zoom;
@property NSUInteger focus;
@property NSUInteger speed;
@property NSUInteger resolution;

- (id)initWithDictionaryRepresentation:(NSDictionary *)inDictionary;

- (NSDictionary *)dictionaryRepresentation;

- (void)resetSettings;

@end
