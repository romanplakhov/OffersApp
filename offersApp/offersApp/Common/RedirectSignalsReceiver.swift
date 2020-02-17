//
//  RedirectSignalsReceiver.swift
//  offersApp
//
//  Created by Роман Плахов on 10.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol RedirectSignalsReceiver {
	var redirectSignalObserver: Signal<ScreenState,NoError>.Observer {get}
}
