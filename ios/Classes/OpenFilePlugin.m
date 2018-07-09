#import "OpenFilePlugin.h"
#import <open_file/open_file-Swift.h>

@implementation OpenFilePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOpenFilePlugin registerWithRegistrar:registrar];
}
@end
