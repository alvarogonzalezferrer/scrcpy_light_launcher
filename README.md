# Scrcpy light launcher

Control your Android phone or device from your desktop PC using screen mirroring.

scrcpy is a free and open-source screen mirroring application that allows control of an Android device from a Windows, macOS, or Linux desktop computer.

# What is this

This is a easy to use light launcher to control your android phone from a desktop PC.

I did this launcher because all the other tools were paid, or command line, or hard to use.

This is a very light, very fast, very easy and open source alternative.

I don't like bloated apps that depend on a million libraries to do simple things.

# How to use

Download one of the releases pre-compiled for your system.

Just run the executable file and select the options.

# How to compile

You need to use Lazarus IDE, https://www.lazarus-ide.org/

Should compile very easy, no weird dependencies.

# How it works

This launcher is based on scrcpy, https://github.com/genymobile/scrcpy/

Communication between the Android device and the computer is primarily performed via a USB connection and Android Debug Bridge (ADB).

The software functions by executing a server on the Android device, then communicating with the server via a socket over an ADB tunnel.

It does not require rooting or the installation of software on the Android device.

The screen content is streamed as H.264 video, which the software then decodes and displays on the computer. The software pushes keyboard and mouse input to the Android device over the server.

Setup involves enabling USB debugging on the Android device, connecting the device to the computer, and running the scrcpy application on the computer.

Access to more configuration options, such as changing the bit rate or enabling screen recording, is via a command-line interface.

The software also supports a wireless connection over Wi-Fi, but that requires more steps to set up.

A few features were added to scrcpy in its version 1.9 release in 2019, including the ability to turn the screen off while mirroring and to copy clipboard content between the two devices.

Chris Hoffman of How-To Geek compared scrcpy to AirMirror and Vysor, two other applications with a similar function. Hoffman also pointed to Miracast as an alternative, while noting that it is no longer widely supported among new Android devices, and that it does not support remotely controlling the device.
