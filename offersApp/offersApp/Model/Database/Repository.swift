//
//  Repository.swift
//  offersApp
//
//  Created by Роман Плахов on 17.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import Foundation
import RealmSwift

class Repository<EntityType: Object>: DatabaseInstance {
	func update(item: EntityType) {
		return _box.update(item: item)
	}
	
	func add(item: EntityType) {
		return _box.add(item: item)
	}
	
	func deleteItem(item: EntityType) {
		return _box.deleteItem(item: item)
	}
	
	func deleteAll() {
		return _box.deleteAll()
	}
	
	func getItemsFromDatabase() -> [EntityType] {
		return _box.getItemsFromDatabase()
	}
	
	private let _box: _AnyDatabaseInstanceBox<EntityType>
	
	init<InstanceType: DatabaseInstance>(_ instance: InstanceType) where InstanceType.EntityType == EntityType {
		_box = _DatabaseInstanceBox(instance)
	}
}

fileprivate class _DatabaseInstanceBox<Base: DatabaseInstance>: _AnyDatabaseInstanceBox<Base.EntityType> {
	private let _base: Base
	
	init(_ base: Base) {
		_base = base
	}
	
	override func update(item: EntityType) {
		return _base.update(item: item)
	}
	
	override func add(item: EntityType) {
		return _base.add(item: item)
	}
	
	override func deleteItem(item: EntityType) {
		return _base.deleteItem(item: item)
	}
	
	override func deleteAll() {
		return _base.deleteAll()
	}
	
	override func getItemsFromDatabase() -> [EntityType] {
		return _base.getItemsFromDatabase()
	}
}

fileprivate class _AnyDatabaseInstanceBox<Entity: Object>: DatabaseInstance {
	typealias EntityType = Entity
	

	func update(item: EntityType) {
		fatalError("This method is abstract")
	}
	
	func add(item: EntityType) {
		fatalError("This method is abstract")
	}
	
	func deleteItem(item: EntityType) {
		fatalError("This method is abstract")
	}
	
	func deleteAll() {
		fatalError("This method is abstract")
	}
	
	func getItemsFromDatabase() -> [EntityType] {
		fatalError("This method is abstract")
	}
}

protocol DatabaseInstance {
	associatedtype EntityType where EntityType: Object
	
	func update(item: EntityType)
	func add(item: EntityType)
	func deleteItem(item: EntityType)
	func deleteAll()
	func getItemsFromDatabase() -> [EntityType]
}
