(function() {
    var comparators, fs, internalBinarySearch;

    comparators = require('./comparators');

    fs = require('fs');

    internalBinarySearch = function(arr, target, start, end, comparator, cb) {
        var error, error1, i, middle, result, value;
        try {
            i = 0;
            while (start >= 0 && end < arr.length && start <= end && i < arr.length) {
                middle = Math.floor((start + end) / 2);
                value = arr[middle];
                result = comparator(target, value);
                if (result === 0) {
                    if (cb) {
                        return cb(null, middle);
                    }
                    return middle;
                }
                if (result > 0) {
                    start = middle + 1;
                } else {
                    end = middle - 1;
                }
                i++;
            }
            if (cb) {
                return cb(null, -1);
            }
            return -1;
        } catch (error1) {
            error = error1;
            if (cb) {
                return cb(error);
            }
            throw error;
        }
    };

    module.exports.binarySearch = function(arr, target, comparator) {
        if (!arr || arr.length < 1) {
            return -1;
        }
        comparator = comparator || comparators.numberAsc;
        return internalBinarySearch(arr, target, 0, arr.length - 1, comparator);
    };

    module.exports.binarySearchAsync = function(arr, target, cb, comparator) {
        if (!arr || arr.length < 1) {
            return -1;
        }
        comparator = comparator || comparators.numberAsc;
        return process.nextTick(function() {
            return internalBinarySearch(arr, target, 0, arr.length - 1, comparator, cb);
        });
    };

}).call(this);