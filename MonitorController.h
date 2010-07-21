#import <Cocoa/Cocoa.h>

@class PreferencesController;
@class MonitorWindow;
@class SimulatorFrameView;
@class SimulatorHomeView;
@class SimulatorGlassView;
@class SimulatorGlassWindow;
@class MonitorViewController;
@class ProcessControl;

@interface MonitorController : NSObject
{
    NSPanel *prefsWindow;
    PreferencesController *_preferencesController;
    NSMenu *devicesMenu;
    NSMenu *versionsMenu;
    MonitorWindow *_monitorWindow;
    NSMenuItem *_ringerMenuItem;
    SimulatorFrameView *_simulatorBox;
    SimulatorView *_simulatorView;
    SimulatorHomeView *_homeView;
    SimulatorGlassView *_glassView;
    SimulatorGlassWindow *_glassWindow;
    float _rotation;
    float _uiRotation;
    struct CGAffineTransform _transform;
    BOOL _inRotation;
    MonitorViewController *_monitorViewController;
    NSConditionLock *eventForwardingLock;
    ProcessControl *_simulatedProcess;
    NSAppleScript *_showProgrammingGuideScript;
    struct _NSPoint _startingSimulatorViewInset;
    BOOL _useLegacyEventStructSize;
    BOOL _demoMode;
    BOOL _enableMirrorScreens;
    BOOL _mirrorOnly;
    BOOL _mirrorScreenConnected;
    BOOL _mirrorScreenEvents;
    NSWindow *_mirrorWindow;
    SimulatorView *_mirrorView;
    struct CGAffineTransform _mirrorTransform;
    BOOL _mirrorNeedsRotation;
}

+ (id)sharedInstance;
+ (void)setStartingURL:(char *)arg1;
- (void)openURLInMobileSafari:(id)arg1;
- (struct CGAffineTransform)transform;
- (id)monitorWindow;
- (id)simulatorBox;
- (id)simulatorView;
- (id)glassView;
- (id)mirrorView;
- (BOOL)mirrorNeedsRotation;
- (struct CGAffineTransform)mirrorTransform;
- (void)setUseLegacyEventStructSize:(BOOL)arg1;
- (void)simulatorAlreadyRunningSheetDidEnd:(id)arg1 returnCode:(int)arg2 contextInfo:(void *)arg3;
- (void)awakeFromNib;
- (void)establishConnection:(id)arg1;
- (BOOL)applicationShouldHandleReopen:(id)arg1 hasVisibleWindows:(BOOL)arg2;
- (unsigned int)applicationShouldTerminate:(id)arg1;
- (void)application:(id)arg1 openFiles:(id)arg2;
- (void)dealloc;
- (void)showPrefs:(id)arg1;
- (void)resetContent:(id)arg1;
- (void)resetContentSheetDidEnd:(id)arg1 returnCode:(int)arg2 contextInfo:(void *)arg3;
- (BOOL)validateMenuItem:(id)arg1;
- (float)rotation;
- (void)setRotation:(float)arg1;
- (int)orientationFromRadians:(float)arg1;
- (int)orientation;
- (int)uiOrientation;
- (void)copy:(id)arg1;
- (void)paste:(id)arg1;
- (void)copyScreen:(id)arg1;
- (void)toggleRotationLeft:(id)arg1;
- (void)toggleRotationRight:(id)arg1;
- (void)animateToRotation:(id)arg1;
- (void)simulateDevice:(id)arg1;
- (void)simulateVersion:(id)arg1;
- (void)homeButtonDown:(id)arg1;
- (void)homeButtonUp:(id)arg1;
- (void)homeButtonPressed:(id)arg1;
- (void)lockButtonPressed:(id)arg1;
- (void)shakeDevice:(id)arg1;
- (void)volumeUpPressed:(id)arg1;
- (void)volumeDownPressed:(id)arg1;
- (void)toggleRingerSwitch:(id)arg1;
- (void)simulateMemoryWarning:(id)arg1;
- (void)toggleInCallStatusBar:(id)arg1;
- (void)toggleDemoMode:(id)arg1;
- (void)showProgrammingGuide:(id)arg1;
- (void)forwardEvents;
- (void)sendPreferencesChangedEvent;
- (void)sendClearCache;
- (void)sendClearHistory;
- (void)sendOpenURLEvent:(id)arg1;
- (void)sendDeviceEvent:(struct _PurpleEventMessage *)arg1;

@end

