import UIKit



public func generateFloatData(count: Int) -> (values: [Float], byteCount: Int)
{
    var values = [Float](count: count, repeatedValue: 0.0)
    values = values.enumerate().map({
        (index: Int, element: Float) -> Float in
        if index % 2 == 0 {
            return 1.0
        } else {
            return element
        }
    })
    let byteCount = count * sizeof(Float)

    return (values, byteCount)
}

public func setupSharedMemoryWithSize(byteCount: Int) ->
    (pointer: UnsafeMutablePointer<Void>,
    memoryWrapper: COpaquePointer,
    size: Int)
{
    let memoryAlignment = 0x1000
    var memory: UnsafeMutablePointer<Void> = nil

    let alignedByteCount = byteSizeWithAlignment(memoryAlignment, size: byteCount)
    posix_memalign(&memory, memoryAlignment, alignedByteCount)

    let memoryWrapper = COpaquePointer(memory)

    return (memory, memoryWrapper, alignedByteCount)
}

public func byteSizeWithAlignment(alignment: Int, size: Int) -> Int
{
    return Int(ceil(Float(size) / Float(alignment))) * alignment
}

public func executionTimeInterval(block: () -> ()) -> CFTimeInterval
{
    let start = CACurrentMediaTime()
    block();
    let end = CACurrentMediaTime()
    return end - start
}