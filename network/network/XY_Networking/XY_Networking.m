//
//  XY_Networking.m
//  network
//
//  Created by Yulin Zhao on 2018/11/15.
//  Copyright © 2018年 Yulin Zhao. All rights reserved.
//

#import "XY_Networking.h"
#import "BaseNetworking.h"
#import "FileObject.h"
@interface XY_Networking ()
@property(nonatomic,strong)BaseNetworking * manager;

@end
@implementation XY_Networking
static XY_Networking * _networking;
+(instancetype)instance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_networking) {
            _networking = [[self alloc]init];
            
        }
    });
    return _networking;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_networking) {
            _networking = [super allocWithZone:zone];
            
        }
    });
    return _networking;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
     _manager = [BaseNetworking share];
    }
    return _networking;
}

-(void)setHttpHeader:(NSDictionary*)dic{
    [_manager setHttpHeader:dic];
}

-(void)GetWithUrl:(NSString *)url parameters:(id)parameters {
    __weak typeof(self) weakself = self;
    if (parameters == nil) {
        parameters = @{};
    }
    [_manager getUrl:url parameters:parameters getSuccess:^(id responseObject) {
        
    id responseDict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:NULL];
        
        if ([weakself.delegate respondsToSelector:@selector(getTaskResult:)]) {
            [weakself.delegate getTaskResult:responseDict];
        }
        
    } getFailure:^(NSError *error) {
        if ([weakself.delegate respondsToSelector:@selector(getError:)]) {
            [weakself.delegate getError:error];
        }
    }];
}

-(void)PostWithUrl:(NSString *)url parameters:(id)parameters {
    __weak typeof(self) weakself = self;
    if (parameters == nil) {
        parameters = @{};
    }
    [_manager postUrl:url parameters:parameters postSuccess:^(id responseObject) {
        id responseDict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                          options:NSJSONReadingMutableContainers
                                                            error:NULL];
        
        if ([weakself.delegate respondsToSelector:@selector(getTaskResult:)]) {
            [weakself.delegate getTaskResult:responseDict];
        }
    } postFailure:^(NSError *error) {
        if ([weakself.delegate respondsToSelector:@selector(getError:)]) {
            [weakself.delegate getError:error];
        }
    }];
}

-(void)UploadWithUrl:(NSString *)url parameters:(id)parameters data:(NSData*)data name:(NSString*)name fileName:(NSString *)fileName mimeType:(NSString*)mimeType{
    __weak typeof(self) weakself = self;
    if (parameters == nil) {
        parameters = @{};
    }
    
    [_manager uploadUrl:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData  appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
    } currentProgress:^(CGFloat progress) {
        if ([weakself.delegate respondsToSelector:@selector(getProgress:)]) {
            [weakself.delegate getProgress:progress];
        }
    } uploadSuccess:^(id responseObject) {
        id responseDict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                          options:NSJSONReadingMutableContainers
                                                            error:NULL];
        
        if ([weakself.delegate respondsToSelector:@selector(getTaskResult:)]) {
            [weakself.delegate getTaskResult:responseDict];
        }
    } uploadFailure:^(NSError *error) {
        if ([weakself.delegate respondsToSelector:@selector(getError:)]) {
            [weakself.delegate getError:error];
        }
    }];
    
}

-(void)UploadOnceReturnWithUrl:(NSString *)url parameters:(id)parameters fileArray:(NSArray<FileObject *>*)fileArray{
    __weak typeof(self) weakself = self;
    if (parameters == nil) {
        parameters = @{};
    }
    [_manager uploadUrl:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i<fileArray.count; i++) {
            FileObject *  fileObject = fileArray[i];
        [formData  appendPartWithFileData:fileObject.data name:fileObject.name fileName:fileObject.fileName mimeType:fileObject.mimeType];
        }
    } currentProgress:^(CGFloat progress) {
        if ([weakself.delegate respondsToSelector:@selector(getProgress:)]) {
            [weakself.delegate getProgress:progress];
        }
    } uploadSuccess:^(id responseObject) {
        id responseDict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                          options:NSJSONReadingMutableContainers
                                                            error:NULL];

        if ([weakself.delegate respondsToSelector:@selector(getTaskResult:)]) {
            [weakself.delegate getTaskResult:responseDict];
        }
    } uploadFailure:^(NSError *error) {
        if ([weakself.delegate respondsToSelector:@selector(getError:)]) {
            [weakself.delegate getError:error];
        }
    }];
}

-(void)UploadWithUrl:(NSString *)url parameters:(id)parameters fileArray:(NSArray<FileObject *>*)fileArray{
    __weak typeof(self) weakself = self;
    if (parameters == nil) {
        parameters = @{};
    }
    dispatch_queue_t queue0 = dispatch_queue_create("com.xyone", NULL);
    dispatch_queue_t queue1 = dispatch_queue_create("com.xytwo", NULL);
    
    for (int i = 0; i<fileArray.count; i++) {
         FileObject *  fileObject = fileArray[i];
        if (i%2 == 0) {
            // 初始化
            dispatch_semaphore_t semaphore_t = dispatch_semaphore_create(1);
            dispatch_async(queue0, ^{
                // 加锁
                dispatch_semaphore_wait(semaphore_t,DISPATCH_TIME_FOREVER);
               
                [weakself.manager uploadUrl:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                   
                    [formData  appendPartWithFileData:fileObject.data name:fileObject.name fileName:fileObject.fileName mimeType:fileObject.mimeType];
                    
                } currentProgress:^(CGFloat progress) {
                  
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([weakself.delegate respondsToSelector:@selector(uploadFileProgress:index:)]) {
                            [weakself.delegate uploadFileProgress:progress index:i];
                        }
                    });
                   
                } uploadSuccess:^(id responseObject) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        id responseDict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:NULL];
                        
                        if ([weakself.delegate respondsToSelector:@selector(uploadFileResult:index:)]) {
                            [weakself.delegate uploadFileResult:responseDict index:i];
                            // 解锁
                            dispatch_semaphore_signal(semaphore_t);
                        }
                    });
                   
                } uploadFailure:^(NSError *error) {
                  
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([weakself.delegate respondsToSelector:@selector(uploadFileError:index:)]) {
                           
                            [weakself.delegate uploadFileError:error index:i];
                            // 解锁
                            dispatch_semaphore_signal(semaphore_t);
                        }
                    });
                   
                }];
            });
           
        }else if(i%2 == 1){
            // 初始化
            dispatch_semaphore_t semaphore_t = dispatch_semaphore_create(1);
            dispatch_async(queue1, ^{
                // 加锁
                dispatch_semaphore_wait(semaphore_t,DISPATCH_TIME_FOREVER);
              
                [weakself.manager uploadUrl:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                   
                    [formData  appendPartWithFileData:fileObject.data name:fileObject.name fileName:fileObject.fileName mimeType:fileObject.mimeType];
                    
                } currentProgress:^(CGFloat progress) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([weakself.delegate respondsToSelector:@selector(uploadFileProgress:index:)]) {
                            [weakself.delegate uploadFileProgress:progress index:i];
                        }
                    });
                    
                } uploadSuccess:^(id responseObject) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        id responseDict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:NULL];
                        
                        if ([weakself.delegate respondsToSelector:@selector(uploadFileResult:index:)]) {
                            [weakself.delegate uploadFileResult:responseDict index:i];
                            // 解锁
                            dispatch_semaphore_signal(semaphore_t);
                             NSLog(@"---sucess----NSThread==%d",i);
                        }
                    });
                    
                } uploadFailure:^(NSError *error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([weakself.delegate respondsToSelector:@selector(uploadFileError:index:)]) {
                            [weakself.delegate uploadFileError:error index:i];
                            // 解锁
                            dispatch_semaphore_signal(semaphore_t);
                             NSLog(@"---error-----NSThread==%d",i);
                        }
                    });
                    
                }];
            });
        }
        
    }
}

-(void)downloadTaskWithUrl:(NSString*)url parameters:(id)parameters{
    __weak typeof(self) weakself = self;
    if (parameters == nil) {
        parameters = @{};
    }
    
    [weakself.manager downloadTaskWithUrl:url parameters:parameters currentProgress:^(CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([weakself.delegate respondsToSelector:@selector(getProgress:)]) {
                [weakself.delegate getProgress:progress];
            }
        });
        
    } downloadSuccess:^(id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([weakself.delegate respondsToSelector:@selector(getTaskResult:)]) {
                [weakself.delegate getTaskResult:responseObject];
            }
        });
    } downloadFailure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([weakself.delegate respondsToSelector:@selector(getError:)]) {
                [weakself.delegate getError:error];
            }
        });
    }];
}

-(void)downloadResume{
    [_manager downloadResume];
}

-(void)downloadSuspend{
    [_manager downloadSuspend];
}

-(void)downloadCancel{
    [_manager downloadCancel];
}

-(void)cancelAllTask{
    [_manager cancelAllTask];
}
@end
