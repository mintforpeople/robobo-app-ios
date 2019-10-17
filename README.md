# robobo-app-ios

This repository contains the code and resources for the Robobo Developer app for iOS.

This app currently uses the websocket module for communications, but in the future will provide ROS 2 support for the Robobo robot.

A new branch has been generated with the source code corresponding to the new ros2-remote-control module for iOS.

# ros2 module

This module is composed by 3 directories:

* services: Instantiate the services nodes for ROS2.
* subscribers: Instantiate the subscribers nodes for ROS2.
* topics: Instantiate the publishers nodes for ROS2.

The `ROS2RemoteControlModule` implements a remote control for ROS2. This module allows the connection of the Robobo robot to a ROS2 network, publishing its functionality through ROS2 services and topics.


To test and use the nodes there are multiple options:

1. Install  ```ROS2```

     https://index.ros.org/doc/ros2/

2. Use the ```ros1_bridge```

     https://github.com/ros2/ros1_bridge

   It could be a good approach run the bridge with the next option:
   `ros2 run ros1_bridge dynamic_bridge --bridge-all-topics`

   Additionally, follow the next repository instructions are necessary to create the compatibility between robobo_msgs from ROS and ROS2:
   https://github.com/ros2/ros1_bridge/blob/master/doc/index.rst


In all the cases is necessary to create and generate a package with the required ```robobo_msgs``` for the communication:
https://github.com/mintforpeople/robobo-ros2-msgs

* To compile it (in the case 1 & 2):

  `colcon build --symlink-install --packages-select robobo_msgs `

Some examples to test from ROS2... you have to run the next commands from terminal:
* To test if the nodes are launched correctly:

  `ros2 node list`
* To view the topic list:

  `ros2 topic list`

# ros2 camera module

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
