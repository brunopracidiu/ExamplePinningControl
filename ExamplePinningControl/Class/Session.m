//
//  Session.m
//  ExamplePinningControl
//
//  Created by Bruno Ferreira De Oliveira on 30/8/18.
//  Copyright © 2018 Bruno Ferreira De Oliveira. All rights reserved.
//

#import "Session.h"
#import "ServiceBase.h"

@implementation Session

@synthesize ListKeysCertificateHTTPSServer;

static Session* _session = nil;

-(id)initWithDictionary:(NSDictionary*) dict
{
    
    self = [super init];
    if (self) {
        NSString* KeyServer = [dict objectForKey:@"KEYCERTIFICATESERVER"];
        ListKeysCertificateHTTPSServer = [NSArray arrayWithObjects:[KeyServer stringByAppendingString:KEY], nil];
    }
    return self;
    
}

+(Session*)getSession
{
    return _session;
}

+(void)setSession:(id)value
{
    _session = value;
}

@end
