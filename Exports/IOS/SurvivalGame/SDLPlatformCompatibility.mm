/**************************************************************************/
/*  SDLPlatformCompatibility.mm                                           */
/**************************************************************************/
/*  Provides missing SDL platform symbols referenced by the bundled engine. */
/**************************************************************************/

#import <TargetConditionals.h>

#if TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#endif

extern "C" bool SDL_IsIPad(void) {
#if TARGET_OS_IOS && !TARGET_OS_TV
    return UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad;
#else
    return false;
#endif
}

extern "C" bool SDL_IsAppleTV(void) {
#if TARGET_OS_TV
    return true;
#else
    return false;
#endif
}
