//
//  Database.swift
//  offersApp
//
//  Created by Роман Плахов on 10.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmDatabaseModel {
	
}

class Database<T> where T: Object {
	
	lazy var realm = try! Realm()
	
	func update(item: T) {
		try? realm.write {
			realm.add(item, update: .all)
		}
	}
    
    func add(item: T) {
        try? realm.write {
            realm.add(item)
        }
    }
	
	func deleteItem(item: T) {
		try? realm.write {
			realm.delete(item)
		}
	}
	
	func delete(){
		try? realm.write {
			realm.delete(realm.objects(T.self))
		}
	}
	
	func deleteAll(){
		try? realm.write {
			realm.deleteAll()
		}
	}
	
	func getItemsFromDatabase() -> [T] {
		return realm.objects(T.self).map { $0 }
	}
	
	func getResultsFromDatabase() -> Results<T> {
		return realm.objects(T.self)
	}
    
    func getItemFromDatabaseBy(primaryKey: String) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: primaryKey)
    }
    
    func getItemFromDatabaseBy(primaryKey: Int) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: primaryKey)
    }
	
	func updateValue(_ completion: @escaping ()->()) {
		try? realm.write {
			completion()
		}
	}
}


