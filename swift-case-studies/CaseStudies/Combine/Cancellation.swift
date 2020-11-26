import Combine
import Foundation

/*:
 Credits to Pointfree
 https://github.com/pointfreeco/swift-composable-architecture/blob/main/Sources/ComposableArchitecture/Effects/Cancellation.swift
 */

extension Publisher {
    /// Turns a Publisher into one that is capable of being canceled.
    /// - Parameters:
    ///   - id: The Publisher's identifier
    ///   - cancelInFlight: Determines if any in-flight effect with the same identifier should be
    ///     canceled before starting this new one.
    /// - Returns: A new Publisher that is capable of being canceled by an identifier.
    public func cancellable(id: AnyHashable, cancelInFlight: Bool = false) -> AnyPublisher<Output, Failure> {
        let publisher = Deferred { () -> AnyPublisher<Output, Failure> in
            cancellablesLock.lock()
            defer { cancellablesLock.unlock() }
            
            let subject = PassthroughSubject<Output, Failure>()
            let cancellable = self.subscribe(subject)
            
            var cancellationCancellable: AnyCancellable!
            cancellationCancellable = AnyCancellable {
                cancellablesLock.lock()
                defer { cancellablesLock.unlock() }
                
                subject.send(completion: .finished)
                cancellable.cancel()
                cancellationCancellables[id]?.remove(cancellationCancellable)
                
                if cancellationCancellables[id]?.isEmpty == .some(true) {
                    cancellationCancellables[id] = nil
                }
            }
            
            cancellationCancellables[id, default: []].insert(cancellationCancellable)
            
            return subject.handleEvents(
                receiveCompletion: { _ in cancellationCancellable.cancel() },
                receiveCancel: cancellationCancellable.cancel
            )
            .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
        
        return cancelInFlight ? .concatenate([.cancel(id: id), publisher]) : publisher
    }
    
    /// A Publisher that will cancel any currently in-flight effect with the given identifier.
    /// - Parameter id: A  Publisher identifier.
    /// - Returns: A new Publisher that will cancel any currently in-flight Publisher with the given
    ///   identifier.
    public static func cancel(id: AnyHashable) -> AnyPublisher<Output, Failure> {
        Deferred { () -> AnyPublisher<Output, Failure> in
            cancellablesLock.lock()
            defer { cancellablesLock.unlock() }
            
            cancellationCancellables[id]?.forEach { $0.cancel() }
            return .empty
        }
        .eraseToAnyPublisher()
    }
    
    /// Concatenates a collection of Publishers into one that run each Publisher in order
    /// - Parameter publishers: A collection of Publishers.
    /// - Returns: A new Publisher
    public static func concatenate<C: Collection>(
        _ publishers: C
    ) -> AnyPublisher<Output, Failure> where C.Element == AnyPublisher<Output, Failure> {
        guard let first = publishers.first else {
            return .empty(completeImmediately: true)
        }
        
        return publishers
            .dropFirst()
            .reduce(into: first) { effects, effect in
                effects = effects
                    .append(effect)
                    .eraseToAnyPublisher()
            }
    }
}

private var cancellationCancellables: [AnyHashable: Set<AnyCancellable>] = [:]
private let cancellablesLock = NSRecursiveLock()
