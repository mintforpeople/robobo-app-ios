# robobo-remote-control-ws-ios

The Remote Control Module WS is the Websocket implementation of the Robobo Remote control interface. It allows the remote access to the robot using a websocket client.
This module opens a websocket server on the port 40404 of the iPhone, to use this module check if your firewall allows the access to this port. 
Connections to the websocket server must be using the "ws://ip:40404" format, using the secure version "wss://" won't work.
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

In the example, a instance of sensing module is instanced along with the websocket remote module via the ```modules.plist``` file. 
Connecting a client to the remote module server will show the status being sent from the sensing module.

## Requirements
This module depends on robobo-framework-ios-pod and robobo-remote-control-ios, add them to your podfile as follows:

```ruby
pod 'robobo-framework-ios-pod','~>0.1.0'
pod 'robobo-remote-control-ios','~>0.1.4'
```

## Installation

robobo-remote-control-ws-ios is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'robobo-remote-control-ws-ios'
```

Also add the following lines to the beginning of your Podfile, to allow the download of dependencies through our private Podspec repository:

```ruby
source "https://github.com/mintforpeople/mint-podspec-repo.git"
source "https://github.com/CocoaPods/Specs.git"
```

When importing it in your code, be aware that the dashes on the module name are converted to underscores:

```swift
import robobo_remote_control_ws_ios
```

## Author

Luis Llamas, luis.llamas@mintforpeople.com

## License

robobo-remote-control-ws-ios is available under the Apache 2.0 license. See the LICENSE file for more info.

## Acknowledgement
<!-- 
    ROSIN acknowledgement from the ROSIN press kit
    @ https://github.com/rosin-project/press_kit
-->

<a href="http://rosin-project.eu">
  <img src="http://rosin-project.eu/wp-content/uploads/rosin_ack_logo_wide.png" 
       alt="rosin_logo" height="60" >
</a>

Supported by ROSIN - ROS-Industrial Quality-Assured Robot Software Components.  
More information: <a href="http://rosin-project.eu">rosin-project.eu</a>

<img src="http://rosin-project.eu/wp-content/uploads/rosin_eu_flag.jpg" 
     alt="eu_flag" height="45" align="left" >  

This project has received funding from the European Union’s Horizon 2020  
research and innovation programme under grant agreement no. 732287. 
