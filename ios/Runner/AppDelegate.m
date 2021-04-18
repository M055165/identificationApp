#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
// Add the following import.
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Add the following line, with your API key
  [GMSServices provideAPIKey: @"AIzaSyBQHK9QFl66awqfNtISUtuBleLbhEQCZ50"];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end