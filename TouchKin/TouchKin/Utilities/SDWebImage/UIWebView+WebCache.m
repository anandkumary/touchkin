//
//  UIWebView+WebCache.m
//  Nofomo
//
//  Created by Kislay Singh on 8/10/14.
//  Copyright (c) 2014 YMediaLabs. All rights reserved.
//

#import "UIWebView+WebCache.h"
#import "objc/runtime.h"

static char operationKey;

@implementation UIWebView(WebCache)


- (void)setWebImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock {
    [self cancelCurrentImageLoad];
    
    
    NSData *data = UIImagePNGRepresentation(placeholder);
    [self loadData:data MIMEType:@"image/png" textEncodingName:@"UTF-8" baseURL:nil];
    
    if (url) {
        __weak UIWebView *wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                if (!wself) return;
                if (image) {
                    NSData *data = UIImagePNGRepresentation(image);
                    [wself loadData:data MIMEType:@"image/png" textEncodingName:@"UTF-8" baseURL:nil];
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType);
                }
            });
        }];
        objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}




- (void)cancelCurrentImageLoad {
    // Cancel in progress downloader from queue
    id <SDWebImageOperation> operation = objc_getAssociatedObject(self, &operationKey);
    if (operation) {
        [operation cancel];
        objc_setAssociatedObject(self, &operationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}


@end
