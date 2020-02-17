//
//  RedirectSignalsProducer.swift
//  offersApp
//
//  Created by Роман Плахов on 12.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol RedirectSignalsProducer {
	var redirectSignal: Signal<ScreenState, NoError> {get set}
}
