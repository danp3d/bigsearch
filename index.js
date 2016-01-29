(function() {
    var bigsearch, binarysearch, comparators, fs;

    comparators = require('./lib/comparators');

    binarysearch = require('./lib/binarysearch');

    fs = require('fs');

    bigsearch = {};

    bigsearch.comparators = comparators;

    bigsearch.binarySearch = binarysearch.binarySearch;

    bigsearch.binarySearchAsync = binarysearch.binarySearchAsync;

    module.exports = bigsearch;

}).call(this);