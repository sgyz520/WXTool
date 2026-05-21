#import "../WCMediaStack.h"

#ifdef ENABLE_ANTI_RECALL

%hook CMessageMgr

- (void)onRevokeMsg:(id)arg {
    WCLog(WCFEATURE_ANTI_RECALL, @"Recall blocked (onRevokeMsg:): %@", arg);
}

- (void)onRevokeMessage:(id)arg {
    WCLog(WCFEATURE_ANTI_RECALL, @"Recall blocked (onRevokeMessage:): %@", arg);
}

- (void)RevokeMsg:(id)arg {
    WCLog(WCFEATURE_ANTI_RECALL, @"Recall blocked (RevokeMsg:): %@", arg);
}

%end

#endif