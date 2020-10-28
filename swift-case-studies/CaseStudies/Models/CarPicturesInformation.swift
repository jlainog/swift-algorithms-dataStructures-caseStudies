//
//  CarPicturesInformation.swift
//  MeLiCarViewer
//
//  Created by David A Cespedes R on 9/20/20.
//  Copyright © 2020 David A Cespedes R. All rights reserved.
//

import UIKit

// MARK: - CarPicturesInformation
struct CarPicturesInformation: Codable {
  let id, siteId, title: String
  let dateCreated, lastUpdated: String
  let pictures: [Picture]
  var images: [Data]?
}

// MARK: - Picture
struct Picture: Codable {
  let id: String
  let url: String
  let secureUrl: String
  let size: String
  let maxSize: String
  let quality: String
}
