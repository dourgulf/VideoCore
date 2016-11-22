
#VideoCore branch for me

This project fork from [VideoCore](https://github.com/jgh-/VideoCore). Thanks the great work of jgh-.

Coz jgh- had not focus on this project for a long time. And I was using and improving this project for a long time, so I want to only update this branch later. 

BTW: There are some Chinese company using VideoCore(like Baidu and Tencent), but I can't see any improvement from such "great" company. It that a bad news?

For more dicuss, join my QQ group:1360583

---
About compile error after Pods:
1. fatal error: 'type_half.inl' file not found :
    a) select Pods project's in workspace, and select "VideoCore" target
    b) locate "Header Search Paths" setting items
    c) remove two item in this setting: ${PODS_ROOT}/Headers/Private" and "${PODS_ROOT}/Headers/Private/VideoCore"
---
#VideoCore
VideoCore is a project inteded to be an audio and video manipulation and streaming graph.  It currently works with iOS.

###Table of Contents
* [Setup](#setup)
* [Architecture Overview](#architecture-overview)
* [Version History](#version-history)

##Setup

Create a Podfile with the contents

```
platform :ios, '8.0'
source 'https://github.com/CocoaPods/Specs.git'
pod 'VideoCore', path: '../..'
```
*Note: the last line depend on the relationship between your project and the VideoCore source code*

####Demo Application
The SampleBroadcaster project in the demo folder uses CocoaPods to bring in
local VideoCore as a dependency:

```
cd demo/SampleBroadcaster
pod install
open SampleBroadcaster.xcworkspace
```
Maybe "pod install --verbose --no-repo-update" will be faster in China

Every time yo run the pod command you should do the setting modification:

```
select Pods project with VideoCore target, find "Header Search Paths" setting and remove "${PODS_ROOT}/Headers/Private" and "${PODS_ROOT}/Headers/Private/VideoCore" item

```

I want anybody can tell me how to change the pod file to avoid this action??

##Architecture Overview

VideoCore's architecture is inspired by Microsoft Media Foundation (except with saner naming).  Samples start at the source, are passed through a series of transforms, and end up at the output.

e.g. Source (Camera) -> Transform (Composite) -> Transform (H.264 Encode) -> Transform (RTMP Packetize) -> Output (RTMP)

```
videocore/
sources/
videocore::ISource
videocore::IAudioSource : videocore::ISource
videocore::IVideoSource : videocore::ISource
videocore::Watermark : videocore:IVideoSource
iOS/
videocore::iOS::CameraSource : videocore::IVideoSource
Apple/
videocore::Apple::MicrophoneSource : videocore::IAudioSource
OSX/
videocore::OSX::DisplaySource : videocore::IVideoSource
videocore::OSX::SystemAudioSource : videocore::IAudioSource
outputs/
videocore::IOutput
videocore::ITransform : videocore::IOutput
iOS/
videocore::iOS::H264Transform : videocore::ITransform
videocore::iOS::AACTransform  : videocore::ITransform
OSX/
videocore::OSX::H264Transform : videocore::ITransform
videocore::OSX::AACTransform  : videocore::ITransform
RTMP/
videocore::rtmp::H264Packetizer : videocore::ITransform
videocore::rtmp::AACPacketizer : videocore::ITransform

mixers/
videocore::IMixer
videocore::IAudioMixer : videocore::IMixer
videocore::IVideoMixer : videocore::IMixer
videocore::AudioMixer : videocore::IAudioMixer
iOS/
videocore::iOS::GLESVideoMixer : videocore::IVideoMixer
OSX/
videocore::OSX::GLVideoMixer : videocore::IVideoMixer

rtmp/
videocore::RTMPSession : videocore::IOutput

stream/
videocore::IStreamSession
Apple/
videocore::Apple::StreamSession : videocore::IStreamSession

```

##Version History
* 0.4.1
	 * Various crash case bugfixes
	 * Remove boost dependency
	 * Much function about camera, like zoom, focus etc added.
	 * Beautify filter added (import from project [LiveVideoCoreSDK](https://github.com/runner365/LiveVideoCoreSDK)), I can't find this project's license, I will take care this part later.
* 0.3.1
    * Various bugfixes
    * Introduction of pixel buffer sources so you can add images to broadcast.
* 0.3.0
    * Improvements to audio/video timestamps and synchronization
    * Adds an incompatible API call with previous versions.  Custom
    * graphs must now call IMixer::start() to begin mixing.
* 0.2.3
    * Add support for image filters
* 0.2.2
    * Fix video streaking bug when adaptative bitrate is enabled
    * Increase the aggressiveness of the adaptative bitrate algorithm
    * Add internal pixel buffer format
    * 
* 0.2.0
    * Removes deprecated functions
    * Adds Main Profile video
    * Improves adaptive bitrate algorithm
* 0.1.12 
    * Bugfixes
    * Red5 support
    * Improved Adaptive Bitrate algorithm
* 0.1.10
	* Bugfixes
	* Adaptive Bitrate introduced
* 0.1.9
	* Bugfixes, memory leak fixes
	* Introduces the ability to choose whether to use interface orientation or device orientation for Camera orientation.
* 0.1.8
    * Introduces VideoToolbox encoding for iOS 8+ and OS X 10.9+
    * Adds -lc++ for compatibility with Xcode 6
* 0.1.7 
    * Add a simplified iOS API for the common case of streaming camera/microphone
    * Deprecate camera aspect ratio and position
    * Add a matrix transform for Position
    * Add a matrix transform for Aspect Ratio
    * Bugfixes
* 0.1.6
	* Use device orientation for CameraSource rather than interface orientation
* 0.1.5 
	* Add aspect fill to CameraSource
* 0.1.4 
	* Switch from LGPL 2.1 to MIT licensing.
    * Add Camera preview layer. 
    * Add front/back camera toggle.
    * Fix aspect ratio bug in Camera source.
* 0.1.3 
	* Update sample app with a more efficient viewport render
* 0.1.2 
	* Fixes a serious bug in the GenericAudioMixer that was causing 100% cpu usage and audio lag.
* 0.1.1 
 	* Fixes Cocoapods namespace conflicts for UriParser-cpp
* 0.1.0 
	* Initial CocoaPods version

