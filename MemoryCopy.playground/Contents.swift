import UIKit
import Accelerate



let count = 2 << 16

var (values, byteCount) = generateFloatData(count)
let (memory, _, size) = setupSharedMemoryWithSize(byteCount)

memset(memory, 0, size)
let memmoveTime = executionTimeInterval {
    memmove(memory, values, byteCount)
}
print("memmove: \(memmoveTime) seconds")

memset(memory, 0, size)
let memcpyTime = executionTimeInterval {
    memcpy(memory, values, byteCount)
}
print("memcpy: \(memcpyTime) seconds")

memset(memory, 0, size)
let unsafeMutableFloat = UnsafeMutablePointer<Float>(memory)
let scopyTime = executionTimeInterval {
    cblas_scopy(Int32(count), values, 1, unsafeMutableFloat, 1)}
print("cblas_scopy: \(scopyTime) seconds")

memset(memory, 0, size)
let unsafeDouble = UnsafePointer<Double>(values)
let unsafeMutableDouble = UnsafeMutablePointer<Double>(memory)
let dcopyTime = executionTimeInterval {
    cblas_dcopy(Int32(count / 2), unsafeDouble, 1, unsafeMutableDouble, 1)
}
print("cblas_dcopy: \(dcopyTime) seconds")

memset(memory, 0, size)
let data = NSData(bytesNoCopy: &values, length: byteCount, freeWhenDone: false)
let nsdataTime = executionTimeInterval {
    data.getBytes(memory, length: byteCount)
}
print("nsdata: \(nsdataTime) seconds")

free(memory)

let speedup = memcpyTime / scopyTime
print("Speedup \(speedup)")
