//
//  NYTTopStoriesTests.swift
//  NYTTopStoriesTests
//
//  Created by Brendon Crowe on 3/18/23.
//

import XCTest
@testable import NYTTopStories

final class NYTTopStoriesTests: XCTestCase {
    
    func testTopStories() {
        // arrange
        let jsonData = """
                {
                    "status": "OK",
                    "copyright": "Copyright (c) 2023 The New York Times Company. All Rights Reserved.",
                    "section": "U.S. News",
                    "last_updated": "2022-09-12T14:39:39-04:00",
                    "num_results": 24,
                    "results": [{
                        "section": "climate",
                        "subsection": "",
                        "title": "The Secret Behind Japan’s Wintry Strawberries",
                        "abstract": "The growing season has become completely reversed thanks to kerosene-burning greenhouses and the big prices paid for the earliest, best berries.",
                        "url": "https://www.nytimes.com/2023/03/18/climate/japan-winter-strawberries-greenhouse.html",
                        "uri": "nyt://article/16f2ef1d-4101-5231-a479-a652d384d11c",
                        "byline": "By Hiroko Tabuchi",
                        "item_type": "Article",
                        "updated_date": "2023-03-18T13:25:51-04:00",
                        "created_date": "2023-03-18T13:00:10-04:00",
                        "published_date": "2023-03-18T13:00:10-04:00",
                        "material_type_facet": "",
                        "kicker": "",
                        "des_facet": [
                            "Strawberries",
                            "Global Warming",
                            "Greenhouse Gas Emissions",
                            "Agriculture and Farming",
                            "Greenhouses",
                            "Fruit",
                            "Food"
                        ],
                        "org_facet": [],
                        "per_facet": [],
                        "geo_facet": [
                            "Japan"
                        ],
                        "multimedia": [{
                                "url": "https://static01.nyt.com/images/2023/03/10/multimedia/00CLI-strawberries-promo-pjzf/00CLI-strawberries-promo-pjzf-superJumbo.jpg",
                                "format": "Super Jumbo",
                                "height": 1365,
                                "width": 2048,
                                "type": "image",
                                "subtype": "photo",
                                "caption": "",
                                "copyright": "Noriko Hayashi for The New York Times"
                            },
                            {
                                "url": "https://static01.nyt.com/images/2023/03/10/multimedia/00CLI-strawberries-promo-pjzf/00CLI-strawberries-promo-pjzf-threeByTwoSmallAt2X.jpg",
                                "format": "threeByTwoSmallAt2X",
                                "height": 400,
                                "width": 600,
                                "type": "image",
                                "subtype": "photo",
                                "caption": "",
                                "copyright": "Noriko Hayashi for The New York Times"
                            },
                            {
                                "url": "https://static01.nyt.com/images/2023/03/10/multimedia/00CLI-strawberries-promo-pjzf/00CLI-strawberries-promo-pjzf-thumbLarge.jpg",
                                "format": "Large Thumbnail",
                                "height": 150,
                                "width": 150,
                                "type": "image",
                                "subtype": "photo",
                                "caption": "",
                                "copyright": "Noriko Hayashi for The New York Times"
                            }
                        ],
                        "short_url": "https://nyti.ms/3JNaRdI"
                    }]
                }
                """.data(using: .utf8)!
        
        let expected = "The growing season has become completely reversed thanks to kerosene-burning greenhouses and the big prices paid for the earliest, best berries."
        var desiredString = String()
        let decoder = JSONDecoder()
        
        // act
        do {
            let articleResults = try decoder.decode(TopStories.self, from: jsonData)
            desiredString = articleResults.results.first?.abstract ?? ""
        } catch {
            XCTFail("decoding error \(error.localizedDescription)")
        }
        
        // assert
        XCTAssertEqual(desiredString, expected)
    }
}
