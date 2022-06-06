![freeCodeCamp.org Social Banner](https://s3.amazonaws.com/freecodecamp/wide-social-banner.png)

[![Pull Requests Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat)](http://makeapullrequest.com)
[![first-timers-only Friendly](https://img.shields.io/badge/first--timers--only-friendly-blue.svg)](http://www.firsttimersonly.com/)

## freeCodeCamp.org's open-source mobile app

[freeCodeCamp.org](https://www.freecodecamp.org) is a friendly community where you can learn to code for free. Our full-stack web development and machine learning curriculum is completely free and self-paced. We have thousands of interactive coding challenges to help you expand your skills.

This repository is an adaptation of the freecodecamp.org's interactive curriculum to a flutter based mobile application. The mobile app aims to enable a mobile first, offline first user experience for millions of users worldwide who have limited access to internet or a computer.

### Roadmap
The official freeCodeCamp mobile app will feature almost all our services, news, forum, podcast, radio and not to forget learn!

Our mobile developers @Nirajn2311 and @Sembauke will be working hard to accomplish this, but we could use your help in the meantime.
We would love to hear your opinion and great ideas you can come up with!

### Getting started 
1. Firstly you will have to install Flutter - https://docs.flutter.dev/get-started/install
2. Next setup(or install) an IDE to make developing the app a faster experience. - https://docs.flutter.dev/get-started/editor . It is also recommended to install the available IDE extensions for Flutter and Dart.
3. When installing an emulator from `Android studio` we recommend using the `Pixel 3a XL` and `Nexus One` for smaller screens. If you use any other IDE, we recommend installing the emulators from `Android Studio`.
4. To start developing the app, follow the steps(excluding the `Create the App` step) as mentioned in this link - https://docs.flutter.dev/get-started/test-drive

#### Note

* Mac Users with Apple Silicon
Follow the above guide but make the below 2 changes:
    * Install the Beta build of Android Studio for Apple Silicon - Android Studio Arctic Fox (2020.3.1) Beta 5
Link for download - https://developer.android.com/studio/archive
    * Download the "arm64" version of SDKs
    * If "flutter doctor" gives an error about Java not found, then the fix for it is to copy the folder "/Applications/Android Studio Preview.app/Contents/jre/Contents" to "/Applications/Android Studio Preview.app/Contents/jre/jdk/Contents" .
Source - https://github.com/flutter/flutter/issues/76215#issuecomment-864407892
* As a web developer you might be familiar with HTML and CSS. [Here](https://flutter.dev/docs/get-started/flutter-for/web-devs) is a great comparison between Flutter and CSS styling.

## Troubleshoot

- My emulator froze, when your emulator freezes you can simply go to the AVD Manager select the device the has been frozen and select `Wipe data`. Note that the device must not be running. If you do not know how to open the AVD manager on `Android Studio` there should be a little icon on the top right looking like this: 

![https://image.prntscr.com/image/pKI4uly-SfKEL158uHhyxw.png](https://image.prntscr.com/image/pKI4uly-SfKEL158uHhyxw.png)


#### If you have any other issues getting started please contact us on the [freeCodeCamp chat server](https://chat.freecodecamp.org/).
