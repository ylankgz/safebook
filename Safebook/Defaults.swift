//
//  Defaults.swift
//  Keinex
//
//  Created by Андрей on 07.08.16.
//  Copyright © 2016 Keinex. All rights reserved.
//

import Foundation
import UIKit

let userDefaults = UserDefaults.standard
let isiPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
let latestPostValue = "postValue"

//Sources
let sourceUrl:NSString = "SourceUrlDefault"
let sourceUrlKeinexRu:NSString = "https://gist.githubusercontent.com/ylankgz/f22089e4824a0845da64a7978736eab8/raw/8e4902f4d8689d179113e8fe0621043808a7ea5e/data.json"
let sourceUrlKeinexCom:NSString = "https://gist.githubusercontent.com/ylankgz/f22089e4824a0845da64a7978736eab8/raw/8e4902f4d8689d179113e8fe0621043808a7ea5e/data.json"
let autoDelCache:NSString = "none"
