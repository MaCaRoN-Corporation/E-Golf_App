import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.macaron.egolfapp',
  appName: 'E-Golf App',
  webDir: 'www',
  server: {
    androidScheme: 'https',
    cleartext: true
  },
  SplashScreen: {
    launchAutoHide: true,
    launchShowDuration: 0
  },
  cordova: {
    preferences: {
      LottieFullScreen: "true",
      LottieHideAfterAnimationEnd: "true",
      LottieAnimationLocation: "public/assets/splash.json",
      LottieScaleType: "CENTER_CROP",
      LottieFadeOutDuration: "300",
      LottieCancelOnTap: "true"
    }
  }
};

export default config;