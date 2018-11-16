//
//  BaseNetworking.h
//  network
//
//  Created by Yulin Zhao on 2018/11/15.
//  Copyright © 2018年 Yulin Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
@interface BaseNetworking : NSObject

+(instancetype)share;

-(void)setHttpHeader:(NSDictionary*)dic;

-(void)getUrl:(NSString *)url parameters:(id)parameters getSuccess:(void(^)(id responseObject))getSuccess getFailure:(void(^)(NSError* error))getFailure;

-(void)postUrl:(NSString *)url parameters:(id)parameters postSuccess:(void(^)(id responseObject))postSuccess postFailure:(void(^)(NSError* error))postFailure;

-(void)uploadUrl:(NSString *)url parameters:(id)parameters constructingBodyWithBlock:(void(^)(id<AFMultipartFormData>  _Nonnull formData))constructingBodyWithBlock  currentProgress:(void(^)(CGFloat progress))currentProgress  uploadSuccess:(void(^)(id responseObject))uploadSuccess uploadFailure:(void(^)(NSError* error))uploadFailure;

-(void)downloadTaskWithUrl:(NSString*)url parameters:(id)parameters currentProgress:(void(^)(CGFloat progress))currentProgress downloadSuccess:(void(^)(id responseObject))downloadSuccess downloadFailure:(void(^)(NSError* error))downloadFailure;

//开始
-(void)downloadResume;
//挂起
-(void)downloadSuspend;
//取消
-(void)downloadCancel;
//删除所有
-(void)cancelAllTask;
@end
