assert = require 'assert'
bigsearch = require './../index'
fs = require 'fs'

randomNbr = (low, high) ->
    return Math.floor Math.random() * (high - low) + low

describe 'Comparators', ->
    it 'should return right comparison for integer', ->
        # Just normal comparison checks. You know... ticking all the boxes
        assert.equal bigsearch.comparators.numberAsc(1, 2), -1
        assert.equal bigsearch.comparators.numberAsc(2, 1), 1
        assert.equal bigsearch.comparators.numberAsc(1, 1), 0
        
        assert.equal bigsearch.comparators.numberDesc(1, 2), 1
        assert.equal bigsearch.comparators.numberDesc(2, 1), -1
        assert.equal bigsearch.comparators.numberDesc(1, 1), 0
    
    it 'should return right comparison for strings', ->
        # Just normal comparison checks. You know... ticking all the boxes
        assert.equal bigsearch.comparators.stringAsc('asd', 'bsd'), -1
        assert.equal bigsearch.comparators.stringAsc('bsd', 'asd'), 1
        assert.equal bigsearch.comparators.stringAsc('asd', 'asd'), 0
        
        assert.equal bigsearch.comparators.stringDesc('asd', 'bsd'), 1
        assert.equal bigsearch.comparators.stringDesc('bsd', 'asd'), -1
        assert.equal bigsearch.comparators.stringDesc('asd', 'asd'), 0
        
describe 'Binary search', ->
    it 'should find item in numeric array', ->
        # Generate numeric array (from 0 to 50) and try to find one of the items
        arr = (num for num in [0..50])
        target = randomNbr 0, 50
        assert.equal bigsearch.binarySearch(arr, target), target
        
    it 'should find item in string array', ->
        # Generate a string array (50 lines of 15 characters) and try to find a random element
        arr = []
        for i in [0..50] # 50 lines
            line = ''
            for j in [0..15] # 15 letters
                line += String.fromCharCode randomNbr 97, 122
            
            arr.push line
            
        arr.sort()        
            
        randomIndex = randomNbr 0, 50
        randomItem = arr[randomIndex]
        foundIndex = bigsearch.binarySearch arr, randomItem, bigsearch.comparators.stringAsc
                
        assert.equal arr[foundIndex], randomItem
        
    it 'should be faster than Array.prototype.indexOf (numeric array)', ->
        arr = (num for num in [0..10000000])
        target = randomNbr 0, 9999999

        binaryStart = process.hrtime()
        bigsearch.binarySearch arr, target
        binaryDiff = process.hrtime binaryStart
        binaryMsec = Math.round (binaryDiff[0] * 1e9 + binaryDiff[1]) / 1e6

        normalStart = process.hrtime()
        arr.indexOf target
        normalDiff = process.hrtime normalStart
        normalMsec = Math.round (normalDiff[0] * 1e9 + normalDiff[1]) / 1e6
        
        assert binaryMsec < normalMsec, 'Binary search not working very well :('    
    
    it 'should be faster than Array.prototype.indexOf (string array)', ->
        arr = []
        for i in [0..100000]
            line = ''
            for j in [0..15] # 15 letters
                line += String.fromCharCode randomNbr 97, 122
            
            arr.push line
            
        arr.sort()
        
        target = arr[randomNbr 0, 99999]

        binaryStart = process.hrtime()
        bigsearch.binarySearch arr, target, bigsearch.comparators.stringAsc
        binaryDiff = process.hrtime binaryStart
        binaryMsec = Math.round (binaryDiff[0] * 1e9 + binaryDiff[1]) / 1e6

        normalStart = process.hrtime()
        arr.indexOf target
        normalDiff = process.hrtime normalStart
        normalMsec = Math.round (normalDiff[0] * 1e9 + normalDiff[1]) / 1e6
        
        assert binaryMsec < normalMsec, 'Binary search not working very well :('
        
    it 'should pass the smoke test (geolookup)', ->
        # This test has been copied from AdSlot's node-puzzles
        # it was initially intended to test the answers for a puzzle
        # which focused on speeding up the country lookup based on ip addresses
        # It's supposed to run all lookups in less than 500msecs. This code finishes the lookups in roughly 10msecs
        data = fs.readFileSync "#{__dirname}/fixtures/geo.txt", 'utf8'
        data = data.toString().split '\n'

        # Load the array (this actually takes longer than the 10k lookups :P)
        gindex = []
        for line in data when line
            line = line.split '\t'
            # GEO_FIELD_MIN, GEO_FIELD_MAX, GEO_FIELD_COUNTRY
            gindex.push [+line[0], +line[1], line[3]]

        gindex.sort (a, b) ->
            return +a[0] - +b[0]
        
        # now start the lookups
        start = process.hrtime()

        octet = -> ~~(Math.random() * 254)
        genip = -> octet() * 16777216 + octet() * 65536 + octet() * 256 + octet()
        
        for i in [1..1e4]
            bigsearch.binarySearch gindex, genip(), (tgt, val) ->
                if val[0] <= tgt and val[1] >= tgt then return 0                
                if val[1] < tgt then return 1
            
                return -1            

        diff = process.hrtime start
        msec = Math.round (diff[0] * 1e9 + diff[1]) / 1e6

        assert msec < 500, "It is damn too slow: #{msec}ms for 10k lookups"
        bigsearch.binarySearch gindex, 
