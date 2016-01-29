# Compare numbers (for ascending sort)
exports.numberAsc = (a, b) ->
    return a - b

# Compare numbers (for descending sort)
exports.numberDesc = (a, b) ->
    return exports.numberAsc b, a

# Compare strings (for ascending sort)
exports.stringAsc = (a, b) ->
    return 0 if a == b
    return 1 if !b
    return -1 if !a
    
    return a.localeCompare b

# Compare strings (for descendingd sort)
exports.stringDesc = (a, b) ->
    return exports.stringAsc b, a

