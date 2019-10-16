# robobo-sensing-ios


The sensing library is used to get infomation from the smartphone sensors in an easy way.
This library is composed by three modules:

### Acceleration module

This module can be used for getting information about the state of the accelerometer of the smartphone.


### Orientation module

This module can be used for getting information about the state of the orientation sensor of the smartphone. This virtual sensor uses a mix of the acceleration, gyroscope and magnetometer sensor to obtain the absolute position of the device, returning the yaw, pitch and roll of the device.


### Touch module

This module allows the detection of four different tactile gestures on the phone screen: 

* Taps: A fast tap on the screen

* Touch: A tap on the screen that lasts more than 0.5 seconds

* Fling: A fast swipe on the screen

* Caress: A slow swipe on the screen


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

In the example we can see how the three modules are instanced and how to suscribe to the notifications of the different status updates. 

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    manager = RoboboManager()
    manager.addFrameworkDelegate(self)
    remoteProxy = ProxyTest()

    do{
        var module = try manager.getModuleInstance("IAccelerationModule")
        accelModule = module as? IAccelerationModule
        module = try manager.getModuleInstance("IOrientationModule")
        orientationModule = module as? IOrientationModule
        module = try manager.getModuleInstance("ITouchModule")
        touchModule = module as? ITouchModule
        
        module = try manager.getModuleInstance("IRemoteControlModule")
        remoteModule = module as? IRemoteControlModule
        
        
        remoteModule.registerRemoteControlProxy(remoteProxy)
        
        accelModule.delegateManager.suscribe(self)
        orientationModule.delegateManager.suscribe(self)
        touchModule.delegateManager.suscribe(self)
        
        touchModule.setView(mainView)
    } catch {
        print(error)
    }
}
```

The different listeners of the sensing modules are also demonstrated:

```swift
func onAccelerationChange() {

}

func onAcceleration(_ xAccel: Double, _ yAccel: Double, _ zAccel: Double) {
    manager.log("x:\(xAccel) y:\(yAccel) z:\(zAccel)")
}

func onOrientation(_ yaw: Double, _ pitch: Double, _ roll: Double) {
    manager.log("yaw:\(yaw) pitch:\(pitch) roll:\(roll)")
}

func onTap(_ tapX: Double, _ tapY: Double) {
    manager.log("Tap x:\(tapX) y:\(tapY)")
}

func onTouch(_ tapX: Double, _ tapY: Double) {
    manager.log("Touch x:\(tapX) y:\(tapY)")
}

func onFling(_ direction: TouchGestureDirection, _ angle: Double, _ time: Double, _ distance: Double) {
    manager.log("Fling angle:\(angle) time:\(time)")
}

func onCaress(_ direction: TouchGestureDirection) {
    manager.log(String(direction.hashValue))
}
```

## Requirements

This module depends on robobo-framework-ios-pod and robobo-remote-control-ios, add them to your podfile as follows:

```ruby
pod 'robobo-framework-ios-pod','~>0.1.0'
pod 'robobo-remote-control-ios','~>0.1.4'
```

## Installation

robobo-sensing-ios is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'robobo-sensing-ios'
```
Also add the following lines to the beginning of your Podfile, to allow the download of dependencies through our private Podspec repository:

```ruby
source "https://github.com/mintforpeople/mint-podspec-repo.git"
source "https://github.com/CocoaPods/Specs.git"
```

When importing it in your code, be aware that the dashes on the module name are converted to underscores:

```swift
import robobo_sensing_ios
```
To allow loading the modules from the robobo framework, they must be declared on the ```modules.plist``` file in the desired load order:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>1.IRemoteControlModule</key>
<string>robobo_remote_control_ios.RemoteControlModule</string>
<key>2.ITouchModule</key>
<string>robobo_sensing_ios.TouchModuleImplementation</string>
<key>3.IAccelerationModule</key>
<string>robobo_sensing_ios.AccelerationModuleImplementation</string>
<key>4.IOrientationModule</key>
<string>robobo_sensing_ios.OrientationModuleImplementation</string>
</dict>
</plist>
```

## Author

luis.llamas@mintforpeople.com

## License

robobo-sensing-ios is available under the Apache 2.0 license. See the LICENSE file for more info.

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

