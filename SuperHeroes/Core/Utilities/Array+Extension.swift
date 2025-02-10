//
//  Array+Extension.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 09/02/25.
//

extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
