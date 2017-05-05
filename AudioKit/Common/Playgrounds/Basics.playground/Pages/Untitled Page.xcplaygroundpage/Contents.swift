//: [Previous](@previous)

import Foundation

func applyValuesToAKNodes(_ Value:Double,nodes:Any..., vale: Int){
    for var x in nodes{
        x = Value
    }
}

func test(V: inout Int){
    V = 999
}

func swapTwoInts(_ a: inout  Any, _ b: inout   Any) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var x = 1.0, y = 1, z = 9
applyValuesToAKNodes(2.0,nodes:x,vale: 1)
swapTwoInts(&z,&y)
print(x)

//: [Next](@next)
