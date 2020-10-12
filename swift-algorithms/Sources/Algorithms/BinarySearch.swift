import Foundation

public extension Range {
    var isValid: Bool { lowerBound < upperBound }
}

public extension RandomAccessCollection where Element: Comparable {
    /// Binary seach for an element
    /// - the collection needs to be sorted before search
    func binarySearch(for value: Element, in range: Range<Index>? = nil) -> Index? {
        let range = range ?? startIndex..<endIndex
        
        guard range.isValid else { return nil }
        
        let middle = middleIndex(in: range)
        let element = self[middle]
        
        if element == value {
            return middle
        } else if element > value {
            return binarySearch(for: value, in: range.lowerBound..<middle)
        } else {
            return binarySearch(for: value, in: index(after: middle)..<range.upperBound)
        }
    }
    
    internal func middleIndex(in range: Range<Index>) -> Index {
        let size = distance(from: range.lowerBound, to: range.upperBound)
        return index(range.lowerBound, offsetBy: size / 2)
    }
}

public func binarySearch<T>(
    for value: T.Element,
    in collection: T
) -> T.Index? where T: RandomAccessCollection, T.Element: Comparable {
    collection.binarySearch(for: value)
}

public func findIndices<T>(of value: T.Element,
                           in collection: T,
                           in range: Range<T.Index>? = nil) -> Range<T.Index>?
where T:RandomAccessCollection, T.Element: Comparable {
    guard
        let startIndex = startIndex(of: value, in: collection),
        let endIndex = endIndex(of: value, in: collection)
    else { return nil }
    return startIndex..<endIndex
}

func startIndex<T>(of value: T.Element,
                   in collection: T,
                   in range: Range<T.Index>? = nil) -> T.Index?
where T:RandomAccessCollection, T.Element: Comparable {
    let range = range ?? collection.startIndex..<collection.endIndex
    
    guard range.isValid else { return nil }
    
    let middleIndex = collection.middleIndex(in: range)
    let element = collection[middleIndex]
    
    if middleIndex == range.lowerBound
        || middleIndex == collection.index(before: range.upperBound) {
        if element == value {
            return middleIndex
        } else {
            return nil
        }
    }
    
    if element == value {
        let previousIndex = collection.index(before: middleIndex)
        if collection[previousIndex] != value {
            return middleIndex
        } else {
            let lowerRange = range.lowerBound..<middleIndex
            return startIndex(of: value, in: collection, in: lowerRange)
        }
    } else if value < element {
        let lowerRange = range.lowerBound..<middleIndex
        return startIndex(of: value, in: collection, in: lowerRange)
    } else {
        let upperRange = collection.index(after: middleIndex)..<range.upperBound
        return startIndex(of: value, in: collection, in: upperRange)
    }
}
func endIndex<T>(of value: T.Element,
                 in collection: T,
                 in range: Range<T.Index>? = nil) -> T.Index?
where T:RandomAccessCollection, T.Element: Comparable {
    let range = range ?? collection.startIndex..<collection.endIndex
    
    guard range.isValid else { return nil }
    
    let middleIndex = collection.middleIndex(in: range)
    let element = collection[middleIndex]
    
    if middleIndex == range.lowerBound
        || middleIndex == collection.index(before: range.upperBound) {
        if element == value {
            return collection.index(after: middleIndex)
        } else {
            return nil
        }
    }
    
    if element == value {
        let nextIndex = collection.index(after: middleIndex)
        if collection[nextIndex] != value {
            return collection.index(after: middleIndex)
        } else {
            let upperRange = middleIndex..<range.upperBound
            return endIndex(of: value, in: collection, in: upperRange)
        }
    } else if value < element {
        let lowerRange = range.lowerBound..<middleIndex
        return startIndex(of: value, in: collection, in: lowerRange)
    } else {
        let upperRange = collection.index(after: middleIndex)..<range.upperBound
        return startIndex(of: value, in: collection, in: upperRange)
    }
}
