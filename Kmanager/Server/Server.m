//
//  Server.m
//  Kmanager
//
//  Created by Khánh on 10/02/2018.
//  Copyright © 2018 Khánh. All rights reserved.
//

#import "Server.h"
@implementation Server
+ (Server*)sharedServer
{
    static Server* server = nil;
    if (server == nil) {
        server = [[Server alloc] init];
    }
    return server;
}
- (void)request:(NSString*) url method:(NSString*)method paras:(NSDictionary*)paras completion:(void(^)(NSError* error, id data))completion
{
    NSDictionary *headers = @{ @"content-type": @"application/json"};
    NSDictionary *parameters = paras;
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //            NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (error == nil) {
                NSError* jsonErr;
                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonErr];
                if (jsonErr == nil) {
                    completion(nil, dict);
                }
                else {
                    completion(jsonErr, nil);
                }
            }
            else {
                completion(error, nil);
            }
        }];
    }] resume];
}
- (void)requestGET:(NSString*) url paras:(NSDictionary*)paras completion:(void(^)(NSError* error, id data))completion
{
    NSDictionary *headers = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
//    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //            NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (error == nil) {
                NSError* jsonErr;
                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonErr];
                if (jsonErr == nil) {
                    completion(nil, dict);
                }
                else {
                    completion(jsonErr, nil);
                }
            }
            else {
                completion(error, nil);
            }
        }];
    }] resume];
}
- (void)requestPOST:(NSString*) url paras:(NSDictionary*)paras completion:(void(^)(NSError* error, id data))completion
{
    NSDictionary *headers = @{@"content-type": @"application/json",
                              @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]
                              };
    NSDictionary *parameters = paras;
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //            NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (error == nil) {
                NSError* jsonErr;
                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonErr];
                if (jsonErr == nil) {
                    completion(nil, dict);
                }
                else {
                    completion(jsonErr, nil);
                }
            }
            else {
                completion(error, nil);
            }
        }];
    }] resume];
}
- (void)requestDELETE:(NSString*) url paras:(NSDictionary*)paras completion:(void(^)(NSError* error, id data))completion
{
    NSDictionary *headers = @{@"content-type": @"application/json",
                              @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]
                              };
    NSDictionary *parameters = paras;
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"DELETE"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //            NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (error == nil) {
                NSError* jsonErr;
                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonErr];
                if (jsonErr == nil) {
                    completion(nil, dict);
                }
                else {
                    completion(jsonErr, nil);
                }
            }
            else {
                completion(error, nil);
            }
        }];
    }] resume];
}
- (void)requestPUT:(NSString*) url paras:(NSDictionary*)paras completion:(void(^)(NSError* error, id data))completion
{
    NSDictionary *headers = @{@"content-type": @"application/json",
                              @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
    
    NSDictionary *parameters = paras;
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"PUT"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //            NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (error == nil) {
                NSError* jsonErr;
                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonErr];
                if (jsonErr == nil) {
                    completion(nil, dict);
                }
                else {
                    completion(jsonErr, nil);
                }
            }
            else {
                completion(error, nil);
            }
        }];
    }] resume];
}
- (void)loginWithUsername:(NSString*)username pass:(NSString*)pass idcongty:(NSString*)idct
               completion:(void (^)(NSError* error, NSDictionary* data))completion
{
    [self request:@"https://kmanager.herokuapp.com/api/user/login"
           method:@"POST"
            paras:@{@"username": username,
                     @"password": pass,
                     @"tokenfirebase": @""}
       completion:completion];
}
- (void)logoutWithUsername:(NSString*)idnv token:(NSString*)token
               completion:(void (^)(NSError* error, NSDictionary* data))completion
{
    NSString *url = [NSString stringWithFormat:@"https://kmanager.herokuapp.com/api/user/logout?id=%@", idnv];
    [self requestGET:url
            paras:@{}
       completion:completion];
}
- (void)getData:(NSString*)url completion:(void (^)(NSError* error, NSDictionary* data))completion
{
    [self requestGET:url
               paras:@{}
          completion:completion];
}
- (void)postData: (NSString*)url param:(NSDictionary*)param completion:(void (^)(NSError *error, NSDictionary* data))completion
{
    [self requestPOST:url
                paras:param
           completion:completion];
}
- (void)deleteData:(NSString*)url param:(NSDictionary*)param completion:(void (^)(NSError* error, NSDictionary* data))completion;
{
    [self requestDELETE:url
                  paras:param
           completion:completion];
}
- (void)putData: (NSString*)url param:(NSDictionary*)param completion:(void (^)(NSError *error, NSDictionary* data))completion
{
    [self requestPUT:url
               paras:param
          completion:completion];
}
- (void)showAnimation:(UIView *)view
{
    _hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
}
- (void)hideAnimation:(UIView *)view
{
    if (_hud != nil) {
        [_hud hideAnimated:YES];
        
    }
}
@end
