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

Our vision for Q1 2022: 
- forum will be available 
- early development of learn
- the forum component will feature multiple great podcasts

### Getting started 
To get started with development on the mobile application you will first need to have one of the following code editors installed: [VsCode](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio). 

The following step will be downloading the [Flutter SDK](https://flutter.dev/docs/get-started/install), please choose your version carefully. Extract the zip file and place the flutter folder in the desired location and follow the installation steps. For people that use `VsCode` we insist on installing [these  plugins](https://flutter.dev/docs/get-started/editor?tab=vscode) for development. 

As Web developer you might be familiar with HTML and CSS [here](https://flutter.dev/docs/get-started/flutter-for/web-devs) is a great comparison between Flutter and CSS styling.

When installing an emulator from `Android studio` we recommend using the `Pixel 3a XL` and `Nexus one` for smaller screens. If you use `VsCode` we recommend installing the emulators from `Android Studio`.

To start developing you can press `ctrl/command` + `F5` to get started. Please make sure you have followed all steps including the installation steps on the Flutter website.

## Troubleshoot

- My emulator froze, when your emulator freezes you can simply go to the AVD Manager select the device the has been frozen and select `Wipe data`. Note that the device must not be running. If you do not know how to open the AVD manager on `Android Studio` there should be a little icon on the top right king like this: https://prnt.sc/1zovncm 

 Notes for users Mac with Apple Silicon
Follow the official guide but make the below 2 changes:
* Install the Beta build of Android Studio for Apple Silicon - Android Studio Arctic Fox (2020.3.1) Beta 5
Link for download - https://developer.android.com/studio/archive
* Download the "arm64" version of SDKs
* If "flutter doctor" gives an error about Java not found, then the fix for it is to copy the folder "/Applications/Android Studio Preview.app/Contents/jre/Contents" to "/Applications/Android Studio Preview.app/Contents/jre/jdk/Contents" .
Source - https://github.com/flutter/flutter/issues/76215#issuecomment-864407892

If you have any other issues getting started please contact us on the [freeCodeCamp chat server](https://chat.freecodecamp.org/).



