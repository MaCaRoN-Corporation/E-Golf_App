import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.macaron.egolfapp',
  appName: 'E-Golf App',
  webDir: 'www',
  server: {
    androidScheme: 'https'
  }
};

export default config;
