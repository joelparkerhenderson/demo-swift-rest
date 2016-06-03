# Demo Swift Alamofire

This is a demonstration of Apple iOS Xcode using the Swift language to create a project with the Alamofire networking framework.

This README describes how to create the project, if you want to try doing it yourself.

To learn more about Swift and Alamofire, see the official documentation for [Alamofire](https://github.com/Alamofire/Alamofire)

## How to create the project

1. Launch Xcode and create a new project. We call ours "Demo Swift Alamofire".

  * Need help? See our repo [demo_swift_hello_world](https://github.com/joelparkerhenderson/demo_swift_hello_world).

1. Create a simple way to print some text to the screen, such as a text view with an IBOutlet named "demoTextView".

  * Need help? See our repo [demo_swift_text_view](https://github.com/joelparkerhenderson/demo_swift_text_view).

1. Add Alamofire to the project.

  * To add Alamofire as a dependency, we prefer using Carthage.

  * If you prefer, you can add it by using a dynamic framework or using Cocoapods.

## Add Alamofire

1. Edit `ViewController.swift`.

1. Add Alamofire networking code:

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
		}

1. Verify Alamofire works by runing the app. The screen shows the response result value string, which looks something like this.

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

## Add an ObjectMapper model class

1. Create a directory named "Models".

1. Create a model called "Item" that implements the ObjectMappable interface:

        import Foundation
        import ObjectMapper

        class Item: Mappable {

          // Create some properties that correspond to the
          // key fields in the JSON data that we will fetch.
          var origin: String?
          var url: String?

          // Implement Mappable
          required init?(_ map: Map) {
          }

          // Implement Mappable
          func mapping(map: Map) {
            origin <- map["origin"]
            url <- map["url"]
          }

        }

## Instantiate an ObjectMapper model instance

1. Edit `ViewController.swift`.

1. Add simple code to create a model object, then print some output to the screen.

        import UIKit
        import Alamofire
        import ObjectMapper

        class ViewController: UIViewController {

          @IBOutlet weak var demoTextView: UITextView!

          override func viewDidLoad() {
            super.viewDidLoad()
            Alamofire.request(.GET, "https://httpbin.org/get")
              .validate()
              .responseString { response in
                let item = Mapper<Item>().map(response.result.value)
                self.demoTextView.text = item!.url!
              }
            }
          }
		  …
		}

1. Run the app. The screen shows the item URL, which is "https://httpbin.org/get".

## Upgrade the model to use Realm

1. Edit `Models/Item.swift`.

1. Add code to import RealmSwift, and add public init methods, and make the properties dynamic and default to nil.

        import UIKit
        import Alamofire
        import ObjectMapper
        import RealmSwift

        class Item: Object, Mappable {

          // Create some properties that correspond to the
          // key fields in the JSON data that we will fetch.
          dynamic var origin: String? = nil
          dynamic var url: String? = nil

          // Realm init
          convenience public init(data: [String: AnyObject]) {
            self.init()
          }

          // Implement Mappable
          required convenience public init?(_ map: Map) {
            self.init()
          }

          // Implement Mappable
          func mapping(map: Map) {
            origin <- map["origin"]
            url <- map["url"]
          }

        }

## Add Realm database

1. Edit `ViewController.swift`

1. Add code to open Realm, and write and item, and read an item.


        class ViewController: UIViewController {

          @IBOutlet weak var demoTextView: UITextView!

          override func viewDidLoad() {
            super.viewDidLoad()
            let realm = try! Realm()
            Alamofire.request(.GET, "https://httpbin.org/get")
              .validate()
              .responseString { response in
                let item = Mapper<Item>().map(response.result.value)
                // Write the item to the database
                try! realm.write {
                  realm.add(item!)
                }
                // Read the item from the database
                self.demoTextView.text = realm.objects(Item).first!.url!
              }
            }
          }
		  …
		}


## Tracking

* Package: demo_swift_alamofire
* Version: 1.0.5
* Created: 2016-05-30
* Updated: 2016-06-02
* License: GPL
* Contact: Joel Parker Henderson (joel@joelparkerhenderson.com)
