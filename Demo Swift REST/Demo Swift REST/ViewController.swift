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
                let item = Mapper<Item>().map(JSONString: response.result.value!)!
                self.demoTextView.text = item.url!
                
                // Write the item to the database
                try! realm.write {
                    realm.add(item)
                }
                
                // Call and safely unwrap the url from the database, then assign to the textView
                if let url = realm.objects(Item).first?.url {
                    self.demoTextView.text = url
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
