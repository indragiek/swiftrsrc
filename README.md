## swiftrsrc
### Resource code generation tool for Swift

`swiftrsrc` generates Swift code for accessing elements of asset catalogs, storyboards, and color lists in order to avoid the error-prone practice of hardcoding strings into your code. It is heavily inspired by Square's [objc-codegenutils](https://github.com/square/objc-codegenutils), which you should definitely look into if you're working on an Objective-C project.

### Installing

The simplest way to install `swiftrsrc` is to download the latest binary from the [Releases](https://github.com/indragiek/swiftrsrc/releases) page.

If you want to compile from source, the project uses [Carthage](https://github.com/Carthage/Carthage) for dependency manangement, so you will need to clone the project and run `carthage checkout` to fetch the dependencies before building.

### Usage

```swift
swiftrsrc generate [--platform osx|ios] input_path output_path
```

**_[--platform ios|osx]_**  
platform to generate code for. Must be either "ios" or "osx"

**_input_path_**  
input path to generate code from. Must be an *.xcassets, *.storyboard, or *.clr path

**_output_path_**  
output path to write the generated code to. If a directory path is specified, the generated code will be placed in a Swift source code file with the same name as the struct

#### Asset Catalogs

The generated code for asset catalogs only includes image sets, and purposely omits app icons and launch images (as these are not typically referred to programatically). If you put image sets inside folders, a corresponding nested struct will be created for the folder. In the example below, `Posts` and `Main` are folders inside `Images.xcassets`:

```swift
struct ImagesCatalog {
	struct Posts {
		static var Star: UIImage { return UIImage(named: "Star")! }
	}
	static var LaunchIcon: UIImage { return UIImage(named: "LaunchIcon")! }
	struct Main {
		static var SearchTabIcon: UIImage { return UIImage(named: "SearchTabIcon")! }
		static var ProfileTabIcon: UIImage { return UIImage(named: "ProfileTabIcon")! }
	}
}
```

Note that the properties are computed rather than assigned directly in order to avoid the images beind cached for the entire lifecycle of the application. 

#### Storyboards

The generated code for storyboards contains constants for storyboard identifiers, reuse identifiers, and segue identifiers:

```swift
struct MainStoryboard {
	struct StoryboardIdentifiers {
		static let MainViewController = "MainViewController"
	}
	struct ReuseIdentifiers {
		static let PostTableViewCell = "PostTableViewCell"
		static let CommentTableViewCell = "CommentTableViewCell"
	}
	struct SegueIdentifiers {
		static let MainToDetail = "MainToDetail"
	}
}
```

#### Color Lists

Color lists can be created and edited visually by using the OS X color picker or programmatically using the [`NSColorList`](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/NSColorList_Class/index.html) class. `swiftrsrc` automatically handles the task of converting colors to the appropriate color space depending on the platform that the code is being generated for.

```swift
struct AppLightColorList {
	static let Blue = UIColor(red: 0.045, green: 0.549, blue: 0.995, alpha: 1.000)
	static let Red = UIColor(red: 0.998, green: 0.261, blue: 0.321, alpha: 1.000)
	static let Orange = UIColor(red: 0.986, green: 0.525, blue: 0.060, alpha: 1.000)
}
```

### Contact

* Indragie Karunaratne
* [@indragie](http://twitter.com/indragie)
* [http://indragie.com](http://indragie.com)

### License

`swiftrsrc` is licensed under the MIT License. See `LICENSE` for more information.
