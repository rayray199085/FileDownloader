//
//  SCFileDownloaderManager.m
//  HTTP13
//
//  Created by Stephen Cao on 13/3/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

#import "SCFileDownloaderManager.h"
@interface SCFileDownloaderManager()
@property(nonatomic,strong)NSMutableDictionary *downloaderCache;
@end
@implementation SCFileDownloaderManager
- (NSMutableDictionary *)downloaderCache{
    if(!_downloaderCache){
        _downloaderCache = [[NSMutableDictionary alloc]init];
    }
    return _downloaderCache;
}
+(instancetype)defaultManager{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(instance == nil){
            instance = [[SCFileDownloaderManager alloc]init];
        }
    });
    return instance;
}
-(void)downloadWithUrlString:(NSString *)path WithProcess:(void(^)(float percentage))process andWithSucess:(void(^)(NSString * urlStr))success andWithError:(void(^)(NSError *error))error{
    if(self.downloaderCache[path]){
        NSLog(@"Downloading...");
        return;
    }
    __weak typeof(self) weakSelf = self;
    SCFileDownloader *downloader = [SCFileDownloader downloaderWithUrlString:path WithProcess:process andWithSucess:^(NSString * _Nonnull urlStr) {
        [weakSelf.downloaderCache removeObjectForKey:path];
        if(success){
            success(urlStr);
        }
    } andWithError:^(NSError * _Nonnull errorInfo) {
        [weakSelf.downloaderCache removeObjectForKey:path];
        if(error){
            error(errorInfo);
        }
    }];
    [self.downloaderCache setValue:downloader forKey:path];
    [[NSOperationQueue new]addOperation:downloader];
}
-(void)pauseDownloadProcessWithUrlStr:(NSString *)path{
    if(self.downloaderCache[path]){
        SCFileDownloader *downloader = [self.downloaderCache objectForKey:path];
        [downloader pauseDownloadProcess];
        [self.downloaderCache removeObjectForKey:path];
    }
}
@end
