//
//  PromotionsListViewModel.swift
//  offersApp
//
//  Created by Роман Плахов on 10.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

enum PromotionsListType{
	case active
	case inactive
	
	var title: String {
		switch self {
		case .active:
			return "Активированные"
		case .inactive:
			return "Неактивированные"
		}
	}
	
	var emptyTitle: String {
		switch self {
		case .active:
			return "Ни одно персональное\nпредложение\nне активировано"
		case .inactive:
			return "Все персональные\nпредложения\nактивированы"
		}
	}
	
	var emptyBody: String {
		switch self {
		case .active:
			return "Активируйте предложение через кнопку в карточке или смахните его влево из списка неактивированных предложений."
		case .inactive:
			return ""
		}
	}
	
	var filter: ([MDPersonalPromotion], ActivePromotionsManager) -> ([MDPersonalPromotion]) {
		switch self {
		case .active:
			return {promotions, manager in
				return promotions.filter({manager.isPromotionActive(promotionId: $0.promoId)})
			}
		case .inactive:
			return {promotions, manager in
				return promotions.filter({!manager.isPromotionActive(promotionId: $0.promoId)})
			}
		}
	}
}

class PromotionsListViewModel: RedirectSignalsProducer {
	//MARK: Public members
	func numberOfRowsForSection(_ section: Int) -> Int {
		return promotions.count
	}
	
	func prepareCellForRowAt(cell: PromotionsListTableViewCell, indexPath: IndexPath) -> PromotionsListTableViewCell {
		cell.configureCell(with: promotions[indexPath.row])
		cell.setMultiselected(false)
		cell.setMultiselectableMode(editingMode.value)
		return cell
	}
	
	func didSelectItem(at indexPath: IndexPath) {
		redirectSignalObserver.send(value: .promotionDetails(promotion: promotions[indexPath.row]))
	}
	
	func changeActivationStatus(forItemAt indexPath: IndexPath) {
		let promotion = promotions[indexPath.row]
		
		if activePromotionsManager.isPromotionActive(promotionId: promotion.promoId)  {
			activePromotionsManager.deactivatePromotion(promotionId: promotion.promoId)
		} else {
			activePromotionsManager.activatePromotion(promotionId: promotion.promoId)
		}
		
		updateData()
	}
	
	func setEditingMode(_ value: Bool) {
		selectionList.removeAll()
		editingMode.value = value
	}
	
	func updateData() {
		loadData()
	}
	
	func addItemToSelectionList(at indexPath: IndexPath) {
		selectionList.update(with: promotions[indexPath.row].promoId)
	}
	
	func removeItemFromSelectionList(at indexPath: IndexPath) {
		selectionList.remove(promotions[indexPath.row].promoId)
	}
	
	func commitSelection() {
		selectionList.forEach {promoId in
			if self.type == .active {
				activePromotionsManager.deactivatePromotion(promotionId: promoId)
			} else {
				activePromotionsManager.activatePromotion(promotionId: promoId)
			}
		}
		
		selectionList.removeAll()
		
		self.updateData()
	}
	
	
	var promotions: [MDPersonalPromotion] = [] {
		didSet {
			self.isEmpty.value = promotions.count == 0
			self.reloadSignalObserver.send(value: ())
		}
	}
	
	var type: PromotionsListType
	
	//MARK: Binding sources
	var emptyViewTitle = MutableProperty<String>("")
	var emptyViewBody = MutableProperty<String>("")
	
	var isLoading = MutableProperty<Bool>(false)
	var isEmpty = MutableProperty<Bool>(false)
	var editingMode = MutableProperty<Bool>(false)
	
	var redirectSignal: Signal<ScreenState, NoError>
    private var redirectSignalObserver: Signal<ScreenState, NoError>.Observer
	
	var reloadSignal: Signal<Void, NoError>
    private var reloadSignalObserver: Signal<Void, NoError>.Observer
	
	//MARK: Private members
	private var network: PromoDataProvider
	private var repository: Repository<MDPersonalPromotion>
	private var activePromotionsManager: ActivePromotionsManager
	
	private var selectionList = Set<Int>()
	
	init(type: PromotionsListType,
		 network: PromoDataProvider,
		 repository: Repository<MDPersonalPromotion>,
		 activePromotionsManager: ActivePromotionsManager) {
		self.type = type
		self.network = network
		self.repository = repository
		self.activePromotionsManager = activePromotionsManager
		
		(redirectSignal, redirectSignalObserver) = Signal.pipe()
		(reloadSignal, reloadSignalObserver) = Signal.pipe()
		
		setup()
		loadData()
	}
	
	private func setup() {
		emptyViewTitle.value = type.emptyTitle
		emptyViewBody.value = type.emptyBody
	}
	
	private func loadData() {
		isLoading.value = true
		network.getPromoData(completion: { [weak self](promotions) in
			guard let self = self else {return}
			promotions.forEach {self.repository.update(item: $0)}
			self.promotions = self.type.filter(promotions, self.activePromotionsManager)
			self.isLoading.value = false
			
		}) { [weak self](error) in
			guard let self = self else {return}
			print(error)
			self.promotions = self.type.filter(self.repository.getItemsFromDatabase(), self.activePromotionsManager)
			self.isLoading.value = false
		}
	}
}
