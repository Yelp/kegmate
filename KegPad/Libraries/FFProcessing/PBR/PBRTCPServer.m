/*
 File: PBRTCPServer.m
 Abstract: A TCP server that listens on an arbitrary port.
 Version: 1.7
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2009 Apple Inc. All Rights Reserved.
 
 */

#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <CFNetwork/CFSocketStream.h>

#import "PBRTCPServer.h"
#import "PBRDefines.h"

NSString *const PBRTCPServerErrorDomain = @"PBRTCPServerErrorDomain";

@interface PBRTCPServer ()
@property (retain, nonatomic) NSNetService *netService;
@property (assign) uint16_t port;
@end

@implementation PBRTCPServer

@synthesize delegate=_delegate, netService=_netService, port=_port;

- (void)dealloc {
  [self stop];
  [super dealloc];
}

- (void)handleNewConnectionFromAddress:(NSString *)address inputStream:(NSInputStream *)istr outputStream:(NSOutputStream *)ostr {
  // if the delegate implements the delegate method, call it  
  if (self.delegate && [self.delegate respondsToSelector:@selector(didAcceptConnectionForServer:address:inputStream:outputStream:)]) { 
    [self.delegate didAcceptConnectionForServer:self address:address inputStream:istr outputStream:ostr];
  }
}

NSString *NSStringFromSockAddr(const struct sockaddr_in *addr_in) {
  const UInt8 *b = (const UInt8 *)&addr_in->sin_addr.s_addr;
  return [NSString stringWithFormat: @"%u.%u.%u.%u", (unsigned)b[0], (unsigned)b[1], (unsigned)b[2], (unsigned)b[3]];
}

// This function is called by CFSocket when a new connection comes in.
// We gather some data here, and convert the function call to a method
// invocation on PBRTCPServer.
static void PBRTCPServerAcceptCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
  PBRTCPServer *server = (PBRTCPServer *)info;
  if (kCFSocketAcceptCallBack == type) { 
    // for an AcceptCallBack, the data parameter is a pointer to a CFSocketNativeHandle
    CFSocketNativeHandle nativeSocketHandle = *(CFSocketNativeHandle *)data;
    uint8_t name[SOCK_MAXADDRLEN];
    socklen_t namelen = sizeof(name);
    NSString *peerAddress = nil;
    if (0 == getpeername(nativeSocketHandle, (struct sockaddr *)name, &namelen)) {
      peerAddress = NSStringFromSockAddr((const struct sockaddr_in *)name);
    }
    CFReadStreamRef readStream = NULL;
		CFWriteStreamRef writeStream = NULL;
    CFStreamCreatePairWithSocket(kCFAllocatorDefault, nativeSocketHandle, &readStream, &writeStream);
    if (readStream && writeStream) {
      CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
      CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
      [server handleNewConnectionFromAddress:peerAddress inputStream:(NSInputStream *)readStream outputStream:(NSOutputStream *)writeStream];
    } else {
      // on any failure, need to destroy the CFSocketNativeHandle 
      // since we are not going to use it any more
      close(nativeSocketHandle);
    }
    if (readStream) CFRelease(readStream);
    if (writeStream) CFRelease(writeStream);
  }
}

- (BOOL)start:(NSError **)error {
  CFSocketContext socketCtxt = {0, self, NULL, NULL, NULL};
  _ipv4socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, (CFSocketCallBack)&PBRTCPServerAcceptCallBack, &socketCtxt);
	
  if (_ipv4socket == NULL) {
    if (error) *error = [[NSError alloc] initWithDomain:PBRTCPServerErrorDomain code:kPBRTCPServerNoSocketsAvailable userInfo:nil];
    if (_ipv4socket) CFRelease(_ipv4socket);
    _ipv4socket = NULL;
    return NO;
  }
	
	
  int yes = 1;
  setsockopt(CFSocketGetNative(_ipv4socket), SOL_SOCKET, SO_REUSEADDR, (void *)&yes, sizeof(yes));
	
  // set up the IPv4 endpoint; use port 0, so the kernel will choose an arbitrary port for us, which will be advertised using Bonjour
  struct sockaddr_in addr4;
  memset(&addr4, 0, sizeof(addr4));
  addr4.sin_len = sizeof(addr4);
  addr4.sin_family = AF_INET;
  addr4.sin_port = 0;
  addr4.sin_addr.s_addr = htonl(INADDR_ANY);
  NSData *address4 = [NSData dataWithBytes:&addr4 length:sizeof(addr4)];
	
  if (kCFSocketSuccess != CFSocketSetAddress(_ipv4socket, (CFDataRef)address4)) {
    if (error) *error = [[NSError alloc] initWithDomain:PBRTCPServerErrorDomain code:kPBRTCPServerCouldNotBindToIPv4Address userInfo:nil];
    if (_ipv4socket) CFRelease(_ipv4socket);
    _ipv4socket = NULL;
    return NO;
  }
  
	// now that the binding was successful, we get the port number 
	// -- we will need it for the NSNetService
	NSData *addr = [(NSData *)CFSocketCopyAddress(_ipv4socket) autorelease];
	memcpy(&addr4, [addr bytes], [addr length]);
	self.port = ntohs(addr4.sin_port);
  PBRDebug(@"Started on port: %d", (NSUInteger)self.port);
	
	
  // set up the run loop sources for the sockets
  CFRunLoopRef cfrl = CFRunLoopGetCurrent();
  CFRunLoopSourceRef source4 = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _ipv4socket, 0);
  CFRunLoopAddSource(cfrl, source4, kCFRunLoopCommonModes);
  CFRelease(source4);
	
	
  return YES;
}

- (BOOL)stop {
  PBRDebug(@"Stopping TCP server");
  [self disableBonjour];
  
	if (_ipv4socket) {
		CFSocketInvalidate(_ipv4socket);
		CFRelease(_ipv4socket);
		_ipv4socket = NULL;
	}
	
	
  return YES;
}

- (BOOL)enableBonjourWithDomain:(NSString*)domain applicationProtocol:(NSString*)protocol name:(NSString*)name {
	if (![domain length])
		domain = @""; //Will use default Bonjour registration doamins, typically just ".local"
	if (![name length])
		name = @""; //Will use default Bonjour name, e.g. the name assigned to the device in iTunes
	
	if (!protocol || ![protocol length] || _ipv4socket == NULL)
		return NO;
	
  
	self.netService = [[[NSNetService alloc] initWithDomain:domain type:protocol name:name port:self.port] autorelease];
	if (!self.netService)
		return NO;
	
	[self.netService scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[self.netService publish];
	[self.netService setDelegate:self];
	
	return YES;
}

/*
 Bonjour will not allow conflicting service instance names (in the same domain), and may have automatically renamed
 the service if there was a conflict.  We pass the name back to the delegate so that the name can be displayed to
 the user.
 See http://developer.apple.com/networking/bonjour/faq.html for more information.
 */

- (void)netServiceDidPublish:(NSNetService *)sender {
  if (self.delegate && [self.delegate respondsToSelector:@selector(serverDidEnableBonjour:withName:)])
		[self.delegate serverDidEnableBonjour:self withName:sender.name];
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict {
	//[super netService:sender didNotPublish:errorDict];
	if (self.delegate && [self.delegate respondsToSelector:@selector(server:didNotEnableBonjour:)])
		[self.delegate server:self didNotEnableBonjour:errorDict];
}

- (void)disableBonjour {
	if (self.netService) {
		[self.netService stop];
		[self.netService removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
		self.netService = nil;
	}
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@ = 0x%08X | port %d | netService = %@>", [self class], (long)self, self.port, self.netService];
}

@end
