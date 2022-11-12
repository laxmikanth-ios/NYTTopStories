//
//  NYTTopStoriesTests.swift
//  NYTTopStoriesTests
//
//  Created by Laxmikanth Reddy on 12/11/22.
//

import XCTest
@testable import NYTTopStories

class NYTTopStoriesTests: XCTestCase {
    
    // unit tests for our TopStory model
    func testTopStory() {
        // arrange
        let jsonData = """
        {
            "status": "OK",
            "copyright": "Copyright (c) 2022 The New York Times Company. All Rights Reserved.",
            "section": "New York",
            "last_updated": "2022-11-11T19:26:07-05:00",
            "num_results": 34,
            "results": [{
                    "section": "nyregion",
                    "subsection": "",
                    "title": "How a Sex Attack Suspect Slipped Past the N.Y.P.D. and Struck Again",
                    "abstract": "The first attack in Hudson River Park set off searches, but investigators made no arrest until two more women had been victimized.",
                    "url": "https://www.nytimes.com/2022/11/11/nyregion/nypd-rape-hudson-river-park.html",
                    "uri": "nyt://article/bc6196bc-2dd0-5597-b6f5-7a98cdf08eb1",
                    "byline": "By Ashley Southall and Rebecca Davis O’Brien",
                    "item_type": "Article",
                    "updated_date": "2022-11-12T01:43:36-05:00",
                    "created_date": "2022-11-11T05:00:15-05:00",
                    "published_date": "2022-11-11T05:00:15-05:00",
                    "material_type_facet": "",
                    "kicker": "",
                    "des_facet": [
                        "Sex Crimes",
                        "Crime and Criminals",
                        "Assaults"
                    ],
                    "org_facet": [
                        "Police Department (NYC)"
                    ],
                    "per_facet": ["Hudson River Park (Manhattan, NY)"],
                    "geo_facet": [
                        "Hudson River Park (Manhattan, NY)"
                    ],
                    "multimedia": [{
                            "url": "https://static01.nyt.com/images/2022/11/11/multimedia/11ny-park-rape-1-450e/11ny-park-rape-1-450e-superJumbo.jpg",
                            "format": "Super Jumbo",
                            "height": 1365,
                            "width": 2048,
                            "type": "image",
                            "subtype": "photo",
                            "caption": "In Hudson River Park, a four-mile stretch of landscaped piers and green space, violent crime is extremely rare. ",
                            "copyright": "Vincent Tullo for The New York Times"
                        },
                        {
                            "url": "https://static01.nyt.com/images/2022/11/11/multimedia/11ny-park-rape-1-450e/11ny-park-rape-1-450e-threeByTwoSmallAt2X.jpg",
                            "format": "threeByTwoSmallAt2X",
                            "height": 400,
                            "width": 600,
                            "type": "image",
                            "subtype": "photo",
                            "caption": "In Hudson River Park, a four-mile stretch of landscaped piers and green space, violent crime is extremely rare. ",
                            "copyright": "Vincent Tullo for The New York Times"
                        },
                        {
                            "url": "https://static01.nyt.com/images/2022/11/11/multimedia/11ny-park-rape-1-450e/11ny-park-rape-1-450e-thumbLarge.jpg",
                            "format": "Large Thumbnail",
                            "height": 150,
                            "width": 150,
                            "type": "image",
                            "subtype": "photo",
                            "caption": "In Hudson River Park, a four-mile stretch of landscaped piers and green space, violent crime is extremely rare. ",
                            "copyright": "Vincent Tullo for The New York Times"
                        }
                    ],
                    "short_url": "https://nyti.ms/3g0f3Li"
                },
                {
                    "section": "nyregion",
                    "subsection": "",
                    "title": "Judge Blocks Licenses for Some Cannabis Dispensaries in New York",
                    "abstract": "The move affects 63 of the 150 licenses that the state planned to issue.",
                    "url": "https://www.nytimes.com/2022/11/11/nyregion/cannabis-dispensary-license-blocked.html",
                    "uri": "nyt://article/911b91cc-233e-5f3a-b07a-f2ff52945d75",
                    "byline": "By Ashley Southall",
                    "item_type": "Article",
                    "updated_date": "2022-11-12T01:41:16-05:00",
                    "created_date": "2022-11-11T05:30:05-05:00",
                    "published_date": "2022-11-11T05:30:05-05:00",
                    "material_type_facet": "",
                    "kicker": "",
                    "des_facet": [
                        "Marijuana",
                        "Law and Legislation",
                        "Decisions and Verdicts",
                        "Suits and Litigation (Civil)",
                        "Shopping and Retail",
                        "Regulation and Deregulation of Industry"
                    ],
                    "short_url": "https://nyti.ms/3EhqxTO"
                }
            ]
        }
        """.data(using: .utf8)!
        
        let expectedTitle = "How a Sex Attack Suspect Slipped Past the N.Y.P.D. and Struck Again"
        
        // act
        do {
            let topStories = try JSONDecoder().decode(TopStories.self, from: jsonData)
            // assert
            let supTitle = topStories.results.first?.title ?? ""
            XCTAssertEqual(expectedTitle, supTitle)
        } catch {
            XCTFail("decoding error \(error)")
        }
        
        
        // assert
    }
    
    
}
