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

#import "ObjectViewController.h"
#import "AmazonClientManager.h"

@implementation ObjectViewController


@synthesize objectNameLabel, objectDataLabel, objectName, bucket;

-(id)init
{
    return [super initWithNibName:@"ObjectViewController" bundle:nil];
}

-(IBAction)done:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    @try {
        S3GetObjectRequest  *getObjectRequest  = [[[S3GetObjectRequest alloc] initWithKey:self.objectName withBucket:self.bucket] autorelease];
        S3GetObjectResponse *getObjectResponse = [[AmazonClientManager s3] getObject:getObjectRequest];

        self.objectNameLabel.text = self.objectName;
        self.objectDataLabel.text = [[NSString alloc] initWithData:getObjectResponse.body encoding:NSUTF8StringEncoding];
    }
    @catch (AmazonServiceException *exception) {
        if ( [exception.errorCode isEqualToString:@"ExpiredToken"] ) {
            [[Constants expiredCredentialsAlert] show];
            [AmazonClientManager wipeAllCredentials];
        }
    }
    @catch (AmazonClientException *exception) {
        NSLog(@"Exception = %@", exception);
    }
}

-(void)dealloc
{
    [super dealloc];
}


@end
