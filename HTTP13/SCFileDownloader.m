
//
//  SCFileDownloader.m
//  HTTP13
//
//  Created by Stephen Cao on 13/3/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

#import "SCFileDownloader.h"
@interface SCFileDownloader()<NSURLConnectionDataDelegate>
@property(nonatomic,assign)long long serverFileLength;
@property(nonatomic,assign)long long currentFileLength;
@property(nonatomic,copy)NSString *filePath;
@property(nonatomic,strong)NSOutputStream *stream;
@property(nonatomic,copy)void(^process)(float percentage);
@property(nonatomic,copy)void(^success)(NSString *urlStr);
@property(nonatomic,copy)void(^error)(NSError *error);
@property(nonatomic,strong)NSURLConnection *conn;
@property(nonatomic,copy)NSString *path;
@end
@implementation SCFileDownloader
- (void)main{
    @autoreleasepool {
        NSURL *url = [NSURL URLWithString:self.path];
        [self getServerFileInfoWithURLStr:url];
        if(self.isCancelled){
            return;
        }
        self.currentFileLength = [self checkLocalFileInfo];
        if(self.currentFileLength == -1){
            if(self.success){
                self.success(self.filePath);
            }
            NSLog(@"File has already been downloaded");
            return;
        }
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
        [request setValue:[NSString stringWithFormat:@"bytes=%lld-",self.currentFileLength] forHTTPHeaderField:@"Range"];
        self.conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
         [[NSRunLoop currentRunLoop]run];
    }
}
-(void)pauseDownloadProcess{
    [self.conn cancel];
    [self cancel];
}
+(instancetype)downloaderWithUrlString:(NSString *)path WithProcess:(void(^)(float percentage))process andWithSucess:(void(^)(NSString * urlStr))success andWithError:(void(^)(NSError *error))error{
    SCFileDownloader *downloader = [[SCFileDownloader alloc]init];
    downloader.path = path;
    downloader.process = process;
    downloader.success = success;
    downloader.error = error;
    return downloader;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.stream = [NSOutputStream outputStreamToFileAtPath:self.filePath append:YES];
    [self.stream open];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    self.currentFileLength += data.length;
    [self.stream write:data.bytes maxLength:data.length];
    float process = self.currentFileLength * 1.0 / self.serverFileLength;
    if(self.process){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.process(process);
        }];
    }
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if(self.success){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.success(self.filePath);
        }];
    }
    [self.stream close];
  
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if(self.error){
        self.error(error);
    }
}
-(void)getServerFileInfoWithURLStr:(NSURL *)url{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"head";
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
    self.serverFileLength = response.expectedContentLength;
    self.filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:response.suggestedFilename];
}
-(long long)checkLocalFileInfo{
    long long localFileSize = 0;
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL doesExist = [manager fileExistsAtPath:self.filePath];
    if(doesExist){
        NSDictionary *dict = [manager attributesOfItemAtPath:self.filePath error:NULL];
        localFileSize = dict.fileSize;
        if(localFileSize == self.serverFileLength){
            return -1;
        }else if(localFileSize > self.serverFileLength){
            [manager removeItemAtPath:self.filePath error:NULL];
            return 0;
        }
    }
    return localFileSize;
}
@end
