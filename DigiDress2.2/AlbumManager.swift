import UIKit

class AlbumManager {
    static let shared = AlbumManager()

    var albums: [Album] = [
        Album(name: "T-shirt"),
        Album(name: "Pants"),
        Album(name: "Longsleeve"),
        Album(name: "Shirt"),
        Album(name: "Dress"),
        Album(name: "Shorts"),
        Album(name: "Shoes"),
        Album(name: "Outerwear"),
        Album(name: "Hat"),
        Album(name: "Skirt"),
        Album(name: "Donated")
    ]

    private init() { }
}
