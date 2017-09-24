# Demo Swift REST

<img src="README.png" alt="REST" style="width: 100%;"/>

This is a demonstration of:

 * The [Swift](http://swift.org) programming language with
    [Apple](http://apple.com)
    [Xcode](https://developer.apple.com/xcode/)
    [iOS](http://www.apple.com/ios/)

  * How to create a simple [REST](https://en.wikipedia.org/wiki/REST) app

  * How to fetch data by using [Alamofire](https://github.com/Alamofire/Alamofire)

  * How to parse JSON by using [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)

  * How to save objects by using [Realm](https://github.com/realm/realm-cocoa)

This README describes how to create the demo.


## Start

To use this demo, you can clone this repo, or you can use this README to create your own project.

If you clone this repo, then be aware that there are multiple git branches, so pick the one you want.

  * swift-4-xcode-9: Swift version 4, Xcode version 9, iOS version 11.

  * swift-3-xcode-8: Swift version 3, Xcode version 8, iOS version 10.


## Create the project

Launch Xcode and create a new project. 

  * We call it "Demo Swift REST" and we use the template "Single View Application".

  * [Help](doc/setup/create_a_new_xcode_project.md)
        
Create a simple way to print some text to the screen.

  * We create a text view object and IBOutlet named "demoTextView".

  * [Help](doc/setup/create_a_text_view.md).

Add Alamofire, ObjectMapper, and Realm. We suggest using Carthage or Cocoapods.

  * Carthage Cartfile:

    ```
    github "Alamofire/Alamofire"
    github "Hearst-DD/ObjectMapper" ~> 2.2
    github "realm/realm-cocoa"
    ```
    
  * [Help](doc/setup/add_carthage_frameworks.md)

If you want a simpler introduction to each piece of this demo, then see these related repos:

  * [demo_swift_hello_world](https://github.com/joelparkerhenderson/demo_swift_hello_world)
  * [demo_swift_text_view](https://github.com/joelparkerhenderson/demo_swift_text_view)
  * [demo_swift_alamofire](https://github.com/joelparkerhenderson/demo_swift_alamofire)
  * [demo_swift_objectmapper](https://github.com/joelparkerhenderson/demo_swift_objectmapper)
  * [demo_swift_realm](https://github.com/joelparkerhenderson/demo_swift_realm)


## Add Alamofire

Edit `ViewController.swift`.

Add Alamofire networking code:

```swift
import UIKit
import Alamofire

class ViewController: UIViewController {

  @IBOutlet weak var demoTextView: UITextView!

  override func viewDidLoad() {
    super.viewDidLoad()
    Alamofire.request(.GET, "https://httpbin.org/get")
      .validate()
      .responseString { response in
         self.demoTextView.text = response.result.value
       }
     }
  }
  …
```

Verify Alamofire works by runing the app. 

The Simulator screen shows the response result value string, which looks something like this.

```json
{
  "args": {},
  "headers": {
    "Accept": "*/*",
    "Accept-Encoding": "gzip;q=1.0, compress;q=0.5",
    "Accept-Language": "en-US;q=1.0",
    "Host": "httpbin.org",
    "User-Agent": "MyApp/com.example.MyApp …"
  },
  "origin": "207.237.149.238",
  "url": "https://httpbin.org/get"
}
```


## Add an ObjectMapper model class

Create a directory named "Models".

Create a model called "Item" that implements the ObjectMappable interface:

```swift
import ObjectMapper

class Item: Mappable {

  // Create some properties that correspond to the
  // key fields in the JSON data that we will fetch.
  var origin: String?
  var url: String?

  // Implement Mappable
  required init?(map: Map) {
  }

  // Implement Mappable
  func mapping(map: Map) {
    origin <- map["origin"]
    url <- map["url"]
  }

}
```


## Instantiate an ObjectMapper model instance

Edit `ViewController.swift`.

Add simple code to create a model object, then print some output to the screen.

    import UIKit
    import Alamofire
    import ObjectMapper

    class ViewController: UIViewController {

      @IBOutlet weak var demoTextView: UITextView!

      override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("https://httpbin.org/get")
          .validate()
          .responseString { response in
            self.demoTextView.text = response.result.value
            let item = Mapper<Item>().map(JSONString: response.result.value!)
            self.demoTextView.text = item!.url!
          }
        }
      }
      …

Run the app. 

The Simulator screen shows the item URL, which is "https://httpbin.org/get".


## Upgrade the model to use Realm

Edit `Models/Item.swift`.

Add code to import RealmSwift, and add public init methods, and make the properties dynamic and default to nil.

```swift
import ObjectMapper
import RealmSwift

public class Item: Object, Mappable {

  // Create some properties that correspond to the
  // key fields in the JSON data that we will fetch.
  dynamic var origin: String? = nil
  dynamic var url: String? = nil

  // Realm init
  convenience public init(data: [String: AnyObject]) {
    self.init()
  }

  // Implement Mappable
  required convenience public init?(map: Map) {
    self.init()
  }

  // Implement Mappable
  public func mapping(map: Map) {
    origin <- map["origin"]
    url <- map["url"]
  }

}
```


## Upgrade the view to use Realm

Edit `ViewController.swift`

Add code to open Realm, and write and item, and read an item.

```swift
import UIKit
import Alamofire
import ObjectMapper
import RealmSwift

class ViewController: UIViewController {

  @IBOutlet weak var demoTextView: UITextView!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let realm = try! Realm()

    Alamofire.request("https://httpbin.org/get")
      .validate()
      .responseString { response in
        self.demoTextView.text = response.result.value
        let item = Mapper<Item>().map(JSONString: response.result.value!)
        self.demoTextView.text = item!.url!

        // Write the item to the database
        try! realm.write {
          realm.add(item!)
        }

        // Call and safely unwrap the url from the database, then assign to the textView
        if let url = realm.objects(Item).first?.url {
          self.demoTextView.text = url
        }
      }
      …
```


## Run

Run the app. 

The Simulator screen shows the item URL, which is "https://httpbin.org/get".

Congratulations, you're successful!


## Tracking

* Package: demo_swift_rest
* Version: 3.0.0
* Created: 2016-05-30
* Updated: 2017-09-22
* License: BSD, GPL, MIT
* Contact: Joel Parker Henderson (http://joelparkerhenderson.com)
