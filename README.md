# MPPersianDatePicker

[![Swift Version](https://img.shields.io/badge/swift-3.0-orange.svg)](https://swift.org/)
[![CI Status](http://img.shields.io/travis/Kautenja/MPPersianDatePicker.svg?style=flat)](https://travis-ci.org/Kautenja/MPPersianDatePicker)
[![Version](https://img.shields.io/cocoapods/v/MPPersianDatePicker.svg?style=flat)](http://cocoapods.org/pods/MPPersianDatePicker)
[![License](https://img.shields.io/cocoapods/l/MPPersianDatePicker.svg?style=flat)](http://cocoapods.org/pods/MPPersianDatePicker)
[![Platform](https://img.shields.io/cocoapods/p/MPPersianDatePicker.svg?style=flat)](http://cocoapods.org/pods/MPPersianDatePicker)

## Screenshots

![simulator screen shot dec 26 2016 11 04 04 am](https://image.ibb.co/dSrruk/1.png)


## Features

*   [ ] Custom Appearance
*   [ ] Landscape support (all devices)


## Requirements

This pod relies on:

*   [PopupDialog](https://github.com/Orderella/PopupDialog)
*   [JTAppleCalendar](https://github.com/patchthecode/JTAppleCalendar)

which will be installed with this pod.


## Installation

MPPersianDatePicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MPPersianDatePicker"
```


## Example

To run the example project, clone the repo, and run `pod install` from the Example
directory first. The example project can then be executed on a simulator or a
production device.


### Code

To use a MPPersianDatePicker in your project it's as easy as inserting this one line in
the view controller on which you want to display the popup:

```
let _ = MPPersianDatePicker.show(on: self, handledBy: nil)
```

This function returns an instance of MPPersianDatePicker in case you might want to
manipulate some of the controller manually.

The reccomended way of handling a date change is to implement a handler function
in the host view controller like this:

```
func HandleDateDidChange(newDate: MPDate?)
{
// handle date change in host view controller
}
```

see [ViewController](Example/MPPersianDatePicker/ViewController.swift) for a production example of how this might come together


## Author

mojtaba.developer@gmail.com


## License

MPPersianDatePicker is available under the MIT license. See the LICENSE file for more info.
