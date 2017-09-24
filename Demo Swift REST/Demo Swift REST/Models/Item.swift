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
