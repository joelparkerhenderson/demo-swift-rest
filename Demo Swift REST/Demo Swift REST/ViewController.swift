import UIKit
import Alamofire
import ObjectMapper
import RealmSwift

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

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

}

