/*
 * Copyright 2010-2011 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import "GetTokenRequest.h"
#import <AWSiOSSDk/AmazonAuthUtils.h>
#import "Crypto.h"

@implementation GetTokenRequest

-(id)initWithEndpoint:(NSString*)theEndpoint andUid:(NSString*)theUid andKey:(NSString*)theKey usingSSL:(bool)usingSSL
{
    if ( ( self = [super init] ) ) {
        endpoint = [theEndpoint retain];
        uid = [theUid retain];
        key = [theKey retain];
        useSSL = usingSSL;
    }
    
    return self;    
}

-(NSString*)buildRequestUrl
{
    NSDate *currentTime = [NSDate date];

    NSString *timestamp = [currentTime stringWithISO8601Format];
    NSData *signature = [Crypto sha256HMac:[timestamp dataUsingEncoding:NSUTF8StringEncoding] withKey:key];
    NSString *rawSig = [[[NSString alloc] initWithData:signature encoding:NSASCIIStringEncoding] autorelease];
    NSString *hexSign = [Crypto hexEncode:rawSig];
    
    return [NSString stringWithFormat:( useSSL ? SSL_GET_TOKEN_REQUEST : GET_TOKEN_REQUEST ), endpoint, [uid stringWithURLEncoding], [timestamp stringWithURLEncoding], [hexSign stringWithURLEncoding]];    
}

-(void)dealloc
{
    [endpoint release];
    [uid release];
    [key release];
    [super dealloc];
}

@end

