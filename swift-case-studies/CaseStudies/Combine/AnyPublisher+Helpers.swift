import Combine
import Foundation

extension AnyPublisher {
    /// Creates a publisher that immediately terminates with the specified failure.
    ///
    /// - Parameter error: The failure to send when terminating the publisher.
    public static func fail(error: Failure) -> Self {
        Fail(error: error)
            .eraseToAnyPublisher()
    }
    
    /// Initializes a publisher that emits the specified output just once.
    ///
    /// - Parameter output: The one element that the publisher emits.
    public static func just(_ output: Output) -> Self {
        Just(output)
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }
    
    /// Creates an empty publisher.
    ///
    /// - Parameter completeImmediately: A Boolean value that indicates whether the publisher should immediately finish.
    public static func empty(
        completeImmediately: Bool
    ) -> Self {
        Empty(completeImmediately: completeImmediately)
            .eraseToAnyPublisher()
    }
    
    /// Creates an empty publisher that immediately finish.
    public static var empty: Self { Empty().eraseToAnyPublisher() }
}
