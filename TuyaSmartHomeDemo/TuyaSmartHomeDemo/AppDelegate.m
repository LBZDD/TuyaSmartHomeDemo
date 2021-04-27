//
//  AppDelegate.m
//  TuyaSmartHomeDemo
//
//  Created by 林波 on 2021/4/24.
//

#import "AppDelegate.h"
#import "TYLoginViewController.h"
#import "TYDeviceManagerViewController.h"

#define APP_KEY @"wusgwrfn95dcyfqsmp5a"
#define APP_SECRET_KEY @"5keq54evrnjuwhpkdehf9gtmgmxdpr9r"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self configureTuyaSDK];
    
    [self configureViewController];
        
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMaximumDismissTimeInterval:1.5f];
    return YES;
}

- (void)configureTuyaSDK{
#if DEBUG
    [[TuyaSmartSDK sharedInstance] setDebugMode:YES];
#endif
    [[TuyaSmartSDK sharedInstance] startWithAppKey:APP_KEY secretKey:APP_SECRET_KEY];
}

- (void)configureViewController{
    if ([TuyaSmartUser sharedInstance].isLogin) {
        TYDeviceManagerViewController *viewController = [[TYDeviceManagerViewController alloc] init];;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.window.rootViewController = navigationController;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        
    } else {
        TYLoginViewController *viewController = [[TYLoginViewController alloc] init];;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
       navigationController.navigationBarHidden = YES;
        self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.window.rootViewController = navigationController;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
    }
}

@end
