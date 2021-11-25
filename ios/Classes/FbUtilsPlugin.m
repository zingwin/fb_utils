#import "FbUtilsPlugin.h"
#import <CommonCrypto/CommonDigest.h>

@implementation FbUtilsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"fb_utils"
            binaryMessenger:[registrar messenger]];
  FbUtilsPlugin* instance = [[FbUtilsPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getFileMD5" isEqualToString:call.method]) {
    NSString *path = call.arguments[@"file_path"];
      result([self fileMD5WithPath: path]);
   }else if ([@"getStringMD5" isEqualToString:call.method]) {
       NSString *target = call.arguments[@"target"];
       result([self md5: target]);
   }else if ([@"hideKeyboard" isEqualToString:call.method]) {
       [self hideKeyboard];
       result(@"true");
   } else {
    result(FlutterMethodNotImplemented);
  }
}

-(nullable NSString *)md5:(nullable NSString *)str {
    if (!str) return nil;

    const char *cStr = str.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);

    NSMutableString *md5Str = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [md5Str appendFormat:@"%02x", result[i]];
    }
    return md5Str;
}

-(nullable NSString *)fileMD5WithPath:(NSString*)filePath {
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (!handle) return nil;

    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    unsigned int length = 32 * 1024;
    while(!done){
        NSData* fileData = [handle readDataOfLength: length ];
        CC_MD5_Update(&md5, [fileData bytes], (unsigned int)[fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString *fileMD5 = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                       digest[0], digest[1],
                       digest[2], digest[3],
                       digest[4], digest[5],
                       digest[6], digest[7],
                       digest[8], digest[9],
                       digest[10], digest[11],
                       digest[12], digest[13],
                       digest[14], digest[15]];
    return fileMD5;
}

- (UIViewController *)topViewControllerFromViewController:(UIViewController *)viewController {
  if ([viewController isKindOfClass:[UINavigationController class]]) {
    UINavigationController *navigationController = (UINavigationController *)viewController;
    return [self
        topViewControllerFromViewController:[navigationController.viewControllers lastObject]];
  }
  if ([viewController isKindOfClass:[UITabBarController class]]) {
    UITabBarController *tabController = (UITabBarController *)viewController;
    return [self topViewControllerFromViewController:tabController.selectedViewController];
  }
  if (viewController.presentedViewController) {
    return [self topViewControllerFromViewController:viewController.presentedViewController];
  }
  return viewController;
}

- (UIViewController *)topViewController {
  return [self topViewControllerFromViewController:[UIApplication sharedApplication]
                                                       .keyWindow.rootViewController];
}

-(void)hideKeyboard{
    [[self topViewController].view endEditing:YES];
}
@end
