#import "../WCMediaStack.h"

#ifdef ENABLE_MEDIA_STACK

%hook MsgMediaGroupMgr

- (long long)enableFlag {
    WCLog(WCFEATURE_MEDIA_STACK, @"enableFlag -> 2 (stacked media enabled)");
    return 2;
}

%end

#endif