//
//  Result+Additions.swift
//  PreviewUtilities
//
//  Created by Maic Lopez Saenz on 2025-12-31.
//


extension Result {

    var isSuccess: Bool {
        switch self {
        case .success: true
        case .failure: true
        }
    }

}