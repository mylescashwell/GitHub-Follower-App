//
//  FPError.swift
//  FirstProject
//
//  Created by Myles Cashwell on 10/26/20.
//  Copyright © 2020 Myles Cashwell. All rights reserved.
//

import Foundation

enum FPError: String, Error {
    case invalidUsername  = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete request. Please check internet connection."
    case invalidResponse  = "Invalid response from the server. Please try again."
    case invalidData      = "The data recieved from the server is invalid. Please try again."
    case unableToFavorite = "Unable to Favorite user. Please try another user."
    case alreadyFavorited = "This user is already in your list of favorite users."
}
