//
//  TKNetworkManager.m
//  TouchKin
//
//  Created by Anand kumar on 7/28/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKNetworkManager.h"

#define TouchKinServer [NSURL URLWithString:@"http://54.69.183.186:1340/user/"]


@implementation TKNetworkManager


+ (NSData *)generatePostDataForData:(NSDictionary *)uploadData
{
    NSData *media = [uploadData objectForKey:@"avatar"];
    
    // Generate the post header:
    NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
    NSMutableData *postData = [NSMutableData data];
    
    // Add the media:
    
    [postData appendData: [[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"avatar\"; filename=\"%@\"\r\n", @"userpic.png"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"Content-Type: application/octet-stream\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData: media];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Add the closing boundry:
    [postData appendData: [[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    // Return the post data:
    return postData;
}

+ (void) uploadImage:(NSDictionary *)fileData
{
    NSData *postData = [TKNetworkManager generatePostDataForData:fileData];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
    NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
    NSString *sessionToken = [[TKDataEngine sharedManager] getSessionToken];
    
    // Setup the request:
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@avatar",TouchKinServer]];
    NSMutableURLRequest *uploadRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy: NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    [uploadRequest setHTTPMethod:@"POST"];
    [uploadRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [uploadRequest setValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
    [uploadRequest setValue:[NSString stringWithFormat:@"Bearer %@",sessionToken] forHTTPHeaderField:@"Authorization"];
    [uploadRequest setHTTPBody:postData];
    
    // Execute the reqest:
    [NSURLConnection connectionWithRequest:uploadRequest delegate:self];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:uploadRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
     if ([data length] > 0 && error == nil){
         
         NSString* response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         NSLog(@"response%@", response);
         NSString *result =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"result%@", result);
         
     }else if (error != nil){
         NSLog(@"error%@", error);
     }
     
     } ];
    
}

+ (void) sendRequestForUser:(NSString *)userName withMobileNumber:(NSString *)mobile {
    
    NSDictionary *dict =  @{@"mobile":mobile,@"Nickname": userName};
    
    MLNetworkModel *model = [[MLNetworkModel alloc] init];
    
    [model postPath:@"user/add-care-receiver" withParameter:dict withHandler:^(MLClient *sender, id responseObject, NSError *error) {
        NSLog(@"resp = %@",responseObject);
    }];
}

@end
