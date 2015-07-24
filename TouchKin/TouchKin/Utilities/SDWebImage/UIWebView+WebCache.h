//
//  UIWebView+WebCache.h
//  Nofomo
//
//  Created by Kislay Singh on 8/10/14.
//  Copyright (c) 2014 YMediaLabs. All rights reserved.
//

#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"

@interface UIWebView(WebCache)

- (void)setWebImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock;

@end
