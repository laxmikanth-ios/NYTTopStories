//
//  TopStory.swift
//  NYTTopStories
//
//  Created by Laxmikanth Reddy on 12/11/22.
//

import Foundation


enum ImageFormat: String, Codable {
    case largeThumbnail = "Large Thumbnail"
    case superJumbo = "Super Jumbo"
    case threeByTwoSmallAt2X = "threeByTwoSmallAt2X"
}

struct TopStories: Codable & Equatable {
    let status, copyright, section: String
    let lastUpdated: String
    let numResults: Int
    let results: [Article]
    
    enum CodingKeys: String, CodingKey {
        case status, copyright, section
        case lastUpdated = "last_updated"
        case numResults = "num_results"
        case results
    }
}

struct Article: Codable & Equatable {
    let section: String
//    let subsection: Subsection
    let title, abstract: String
    let url: String
    let uri, byline: String
    let itemType: ItemType
    let updatedDate, createdDate, publishedDate: String
    let materialTypeFacet: String
//    let kicker: Kicker
    let multimedia: [Multimedia]?
    let shortURL: String
    
    enum CodingKeys: String, CodingKey {
        case section, title, abstract, url, uri, byline
        case itemType = "item_type"
        case updatedDate = "updated_date"
        case createdDate = "created_date"
        case publishedDate = "published_date"
        case materialTypeFacet = "material_type_facet"
//        case kicker
        case multimedia
        case shortURL = "short_url"
    }
}
enum ItemType: String, Codable {
    case article = "Article"
    case interactive = "Interactive"
}

//enum Kicker: String, Codable {
//    case bigCITY = "Big CITY"
//    case empty = ""
//    case newYorkToday = "New York Today"
//    case onTheMarket = "On the Market"
//    case theNeediestCasesFund = "The Neediest Cases Fund"
//}
// MARK: - Multimedia
struct Multimedia: Codable & Equatable {
    let url: String
    let format: String
    let height, width: Int
    let type: TypeEnum
    let subtype: Subtype
    let caption, copyright: String
}

extension Article { // Article.getArticleImageURL(.superJumbo)
    func getAricleImageURL(for imageFormat: ImageFormat) -> String {
        let results = multimedia?.filter { $0.format == imageFormat.rawValue } // "thumbLarge" == "thumbLarge"
        guard let multimediaImage = results?.first else {
            // if results is 0
            return ""
        }
        return multimediaImage.url
    }
}

enum Subtype: String, Codable {
    case photo = "photo"
}

enum TypeEnum: String, Codable {
    case image = "image"
}

//enum Subsection: String, Codable {
//    case basketball = "basketball"
//    case design = "design"
//    case elections = "elections"
//    case empty = ""
//    case politics = "politics"
//}

