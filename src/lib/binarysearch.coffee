comparators = require './comparators'
fs = require 'fs'

internalBinarySearch = (arr, target, start, end, comparator, cb) ->
    try
        i = 0
        while start >= 0 and end < arr.length and start <= end and i < arr.length
            # Get the index in the middle
            middle = Math.floor (start + end) / 2    
            # get the actual element for that index    
            value = arr[middle];
            result = comparator target, value

            if result == 0
                if cb then return cb null, middle
                return middle

            if result > 0
                start = middle + 1                    
            else 
                end = middle - 1

            i++

        if cb then return cb null, -1
        return -1
    catch error
        if cb then return cb error
        throw error

module.exports.binarySearch = (arr, target, comparator) ->
    return -1 if not arr or arr.length < 1
    
    comparator = comparator || comparators.numberAsc    
    return internalBinarySearch arr, target, 0, arr.length - 1, comparator
    
module.exports.binarySearchAsync = (arr, target, cb, comparator) ->
    return -1 if not arr or arr.length < 1
    
    comparator = comparator || comparators.numberAsc    
    process.nextTick () ->
        internalBinarySearch arr, target, 0, arr.length - 1, comparator, cb
