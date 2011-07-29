#define PBRDebug(fmt, ...) do {} while(0)

#if DEBUG
#undef PBRDebug
#define PBRDebug(fmt, ...) NSLog(fmt, ##__VA_ARGS__)
#endif
