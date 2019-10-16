# robobo-rob-interface-module-pod
ROBOBO module to control de ROB using the robobo-rob-interface library and a bluetooth connection in iOS.

This module is composed by:
* bluetooth:
     
     In charge of all the bluetooth communication between the application and the robobo base.
* remoterob:

     The main function of the remoterob is send the status messages that receives from the robobo base and process and running the messages that receives from the remote control module in the base.
* robobo-rob-interface:

     Implements the communication protocol between the base and the library to access it from the application.
* simple-message-protocol:
     
     Contains all the class in charge of the codification and decodification of the messages. Inside the Example, there are a CodeAndDecodeTest to run and check if the code and decode messages are OK.


<!--
[![CI Status](https://img.shields.io/travis/lbajo/robobo-rob-interface-module-pod.svg?style=flat)](https://travis-ci.org/lbajo/robobo-rob-interface-module-pod)
[![Version](https://img.shields.io/cocoapods/v/robobo-rob-interface-module-pod.svg?style=flat)](https://cocoapods.org/pods/robobo-rob-interface-module-pod)
[![License](https://img.shields.io/cocoapods/l/robobo-rob-interface-module-pod.svg?style=flat)](https://cocoapods.org/pods/robobo-rob-interface-module-pod)
[![Platform](https://img.shields.io/cocoapods/p/robobo-rob-interface-module-pod.svg?style=flat)](https://cocoapods.org/pods/robobo-rob-interface-module-pod)
-->
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

robobo-rob-interface-module-pod is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'robobo-rob-interface-module-pod'
```

## Author

lbajo9@gmail.com

## License

robobo-rob-interface-module-pod is available under the Apache 2 license. See the LICENSE file for more info.

***
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
