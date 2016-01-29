# bigsearch
Fast search for big arrays.  
Current functionality: binary search.  
To do: Levenshtein.  

## Usage
``` js
var bigsearch = require('bigsearch');

var indexFound = bigsearch.binarySearch(numericArray, target);
var indexFound = bigsearch.binarySearch(stringArray, target, bigsearch.comparators.stringAsc);
```

The comparators are fully compatible with the Array#sort function.
Defining custom comparators:
``` js
var indexFound = bigsearch.binarySearch(stringArray, target, function (tgt, elem) {
    return bigsearch.comparators.stringDesc(tgt.stringProp, elem.stringProp);
});
```

Even though the results are similar to Array#indexOf, this package runs thousands of times (literally) faster, especially when dealing with super large arrays.
