/*
 * Copyright 2010-2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
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

// HTTP Method Constants

#define kHttpMethodDelete                    @"DELETE"
#define kHttpMethodGet                       @"GET"
#define kHttpMethodHead                      @"HEAD"
#define kHttpMethodPost                      @"POST"
#define kHttpMethodPut                       @"PUT"

// HTTP Header Constants

#define kHttpHdrAuthorization                @"Authorization"
#define kHttpHdrCacheControl                 @"Cache-Control"
#define kHttpHdrContentDisposition           @"Content-Disposition"
#define kHttpHdrContentEncoding              @"Content-Encoding"
#define kHttpHdrContentLength                @"Content-Length"
#define kHttpHdrContentMD5                   @"Content-MD5"
#define kHttpHdrContentRange                 @"Content-Range"
#define kHttpHdrContentType                  @"Content-Type"
#define kHttpHdrDate                         @"Date"
#define kHttpHdrHost                         @"Host"
#define kHttpHdrExpect                       @"Expect"
#define kHttpHdrExpires                      @"Expires"
#define kHttpHdrIfModified                   @"If-Modified-Since"
#define kHttpHdrIfMatch                      @"If-Match"
#define kHttpHdrIfNoneMatch                  @"If-None-Match"
#define kHttpHdrIfUnmodified                 @"If-Unmodified-Since"
#define kHttpHdrRange                        @"Range"
#define kHttpHdrUserAgent                    @"User-Agent"

// Amazon-specific HTTP Header Constants


#define kHttpHdrAmzAcl                       @"x-amz-acl"
#define kHttpHdrAmzCopySource                @"x-amz-copy-source"
#define kHttpHdrAmzCopySourceIfMatch         @"x-amz-copy-source-if-match"
#define kHttpHdrAmzCopySourceIfNoneMatch     @"x-amz-copy-source-if-none-match"
#define kHttpHdrAmzCopySourceIfModified      @"x-amz-copy-source-if-modified-since"
#define kHttpHdrAmzCopySourceIfUnmodified    @"x-amz-copy-source-if-unmodified-since"
#define kHttpHdrAmzGrantRead                 @"x-amz-grant-read"
#define kHttpHdrAmzGrantWrite                @"x-amz-grant-write"
#define kHttpHdrAmzGrantReadAcp              @"x-amz-grant-read-acp"
#define kHttpHdrAmzGrantWriteAcp             @"x-amz-grant-write-acp"
#define kHttpHdrAmzGrantFullControl          @"x-amz-grant-full-control"
#define kHttpHdrAmzMfa                       @"x-amz-mfa"
#define kHttpHdrAmzMetaFormat                @"x-amz-meta-%@"
#define kHttpHdrAmzMetaDirective             @"x-amz-metadata-directive"
#define kHttpHdrAmzSecurityToken             @"x-amz-security-token"
#define kHttpHdrAmzServerSideEncryption      @"x-amz-server-side-encryption"
#define kHttpHdrAmzStorageClass              @"x-amz-storage-class"
#define kHttpHdrAmzWebsiteRedirectLocation   @"x-amz-website-redirect-location"

#define kS3SubResourceAcl                    @"acl"
#define kS3SubResourceCrossOrigin            @"cors"
#define kS3SubResourceDelete                 @"delete"
#define kS3SubResourceLifecycle              @"lifecycle"
#define kS3SubResourceLogging                @"logging"
#define kS3SubResourcePolicy                 @"policy"
#define kS3SubResourceRestore                @"restore"
#define kS3SubResourceTagging                @"tagging"
#define kS3SubResourceTorrent                @"torrent"
#define kS3SubResourceUploads                @"uploads"
#define kS3SubResourceUploadId               @"uploadId"
#define kS3SubResourceVersionId              @"versionId"
#define kS3SubResourceVersioning             @"versioning"
#define kS3SubResourceVersions               @"versions"
#define kS3SubResourceWebsite                @"website"


// pre-signed URL query string parameters

#define kS3QueryParamAccessKey               @"AWSAccessKeyId"
#define kS3QueryParamDelimiter               @"delimiter"
#define kS3QueryParamExpires                 @"Expires"
#define kS3QueryParamKeyMarker               @"key-marker"
#define kS3QueryParamMarker                  @"marker"
#define kS3QueryParamMaxKeys                 @"max-keys"
#define kS3QueryParamMaxParts                @"max-parts"
#define kS3QueryParamPartNumber              @"partNumber"
#define kS3QueryParamPartNumberMarker        @"part-number-marker"
#define kS3QueryParamPrefix                  @"prefix"
#define kS3QueryParamSignature               @"Signature"
#define kS3QueryParamUploadId                @"uploadId"
#define kS3QueryParamVersionIdMarker         @"version-id-marker"


// Endpoint
#define kS3ServiceEndpoint                   @"http://s3.amazonaws.com"


// Server Side Encryption
#define kS3ServerSideEnryptionAES256         @"AES256"

// Put Speed
#define kS3UploadInputStreamChunkSize	1024


