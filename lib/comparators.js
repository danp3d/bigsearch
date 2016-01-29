(function() {
    exports.numberAsc = function(a, b) {
        return a - b;
    };

    exports.numberDesc = function(a, b) {
        return exports.numberAsc(b, a);
    };

    exports.stringAsc = function(a, b) {
        if (a === b) {
            return 0;
        }
        if (!b) {
            return 1;
        }
        if (!a) {
            return -1;
        }
        return a.localeCompare(b);
    };

    exports.stringDesc = function(a, b) {
        return exports.stringAsc(b, a);
    };

}).call(this);