//
//  ServiceBase.m
//  TestCartonCloud
//
//  Created by Bruno Ferreira De Oliveira on 19/6/18.
//  Copyright © 2018 Bruno Ferreira De Oliveira. All rights reserved.
//

#import "ServiceBase.h"
#import "Keychain.h"
#import "Session.h"

#define TOKEN @"TOKENREQUEST"

typedef uint32_t CC_LONG;       /* 32 bit unsigned integer */
extern unsigned char *CC_SHA256(const void *data, CC_LONG len, unsigned char *md)
__OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_2_0);

@interface ServiceBase() {
    
    NSMutableData *DataDownloaded;
    HandlerResult _handlerResult;
    BOOL _success;
    int _codStatus;
    NSString* _service;
}

@end

@implementation ServiceBase

- (void) execute:(NSString *)serviceURL parameters:(NSDictionary *)parameters result:(HandlerResult)result
{
    DataDownloaded = [NSMutableData new];
    _handlerResult = result;
    
    NSURL *url = [NSURL URLWithString:serviceURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setTimeoutInterval:60];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    NSString* certificadoDoClientServidor = [Keychain loadValueForKey:TOKEN];
    
    NSArray* lsCertificados = [[Session getSession] ListKeysCertificateHTTPSServer];
    
    if (lsCertificados.count <= 0){
        [connection start];
        return;
    }else{
        for (NSString *chave in lsCertificados) {
            if ([chave isEqualToString:certificadoDoClientServidor]) {
                [connection start];
                return;
            }
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _success = [(NSHTTPURLResponse*)response statusCode] == 200;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [DataDownloaded appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _codStatus = (int)[error code];
    if ((_codStatus == -1009 || _codStatus == -1001)){
        _handlerResult(NO, @"Plz, Check your internet");
    }else{
        _handlerResult(NO, nil);
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    id resultJSON = [NSJSONSerialization JSONObjectWithData:DataDownloaded options:0 error:nil];
    _handlerResult(_success, resultJSON);
}
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(nonnull NSURLAuthenticationChallenge *)challenge
{
    if([connection.originalRequest.URL.host isEqualToString:challenge.protectionSpace.host]) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
             forAuthenticationChallenge:challenge];
        
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
    
    SecTrustRef trust = challenge.protectionSpace.serverTrust;
    NSString* tokenRequest = @"";
    
    SecCertificateRef serverCertificate = SecTrustGetCertificateAtIndex(trust, 0);
    SecKeyRef key = SecTrustCopyPublicKey(trust);
    NSString *atag = [NSString stringWithFormat:@"%@", key];
    NSLog(@"Cert: %@  Key:%@",serverCertificate,key);
    
    NSRange range;
    
    NSString *blockSizeRegex = @"(?<=block size:\\s?)[0-9]+";
    range = [atag rangeOfString:blockSizeRegex options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        NSString *blockSize = [atag substringWithRange:range];
        NSLog(@"blockSize: %@", blockSize);
    }
    
    NSString *modulusRegex = @"(?<=modulus:\\s?)[0-9A-Z]+";
    range = [atag rangeOfString:modulusRegex options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        NSString *modulus = [atag substringWithRange:range];
        tokenRequest = modulus;
        NSLog(@"modulus: %@", modulus);
    }
    
    NSString *exponentRegex = @"(?<=decimal:\\s?)[0-9]+";
    range = [atag rangeOfString:exponentRegex options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        NSString *exponent = [atag substringWithRange:range];
        tokenRequest = [tokenRequest stringByAppendingString:exponent];
        NSLog(@"exponent: %@", exponent);
    }
    
    NSData *dataIn = [tokenRequest dataUsingEncoding:NSASCIIStringEncoding];
    NSMutableData *macOut = [NSMutableData dataWithLength:32];
    CC_SHA256(dataIn.bytes, (CC_LONG)dataIn.length,  macOut.mutableBytes);
    NSString *tokenWithKey = [[macOut base64EncodedStringWithOptions:0] stringByAppendingString:KEY];
    [Keychain saveValue:tokenWithKey forKey:TOKEN];
}


@end
