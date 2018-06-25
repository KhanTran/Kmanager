//
//  Server.h
//  Kmanager
//
//  Created by Khánh on 10/02/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface Server : NSObject
+ (Server*)sharedServer;

- (void)loginWithUsername:(NSString*)username pass:(NSString*)pass idcongty:(NSString*)idct
               completion:(void (^)(NSError* error, NSDictionary* data))completion;
- (void)logoutWithUsername:(NSString*)idnv token:(NSString*)token
               completion:(void (^)(NSError* error, NSDictionary* data))completion;
- (void)getData:(NSString*)url completion:(void (^)(NSError* error, NSDictionary* data))completion;
- (void)postData: (NSString*)url param:(NSDictionary*)param completion:(void (^)(NSError *error, NSDictionary* data))completion;
- (void)deleteData:(NSString*)url param:(NSDictionary*)param completion:(void (^)(NSError* error, NSDictionary* data))completion;
- (void)putData: (NSString*)url param:(NSDictionary*)param completion:(void (^)(NSError *error, NSDictionary* data))completion;
@property (strong,nonatomic) MBProgressHUD * hud;
- (void)hideAnimation:(UIView *)view;
- (void)showAnimation:(UIView *)view;

@end
