//
//  BoardHandler.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/16/15.
//  Copyright © 2015 Phoenix Labs.
//
//  All Rights Reserved.

import Foundation

enum HGErrorType: Int {

	case info = 0
	case warn = 1
	case error = 2
	case alert = 3
	case assert = 4

	var string: String {
		switch self {
		case .info: return "Info"
		case .warn: return "Warn"
		case .error: return "Error"
		case .alert: return "Alert"
		case .assert: return "Assert"
		}
	}
}
