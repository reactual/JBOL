module {
    name: "types",
    description: "Type predicates",
    namespace: "fadado.github.io",
    author: {
        name: "Joan Josep Ordinas Rosa",
        email: "jordinas@gmail.com"
    }
};

include "fadado.github.io/prelude";

# Data type predicates
def isnull: #:: a| => boolean
    type == "null"
;
def isboolean: #:: a| => boolean
    type == "boolean"
;
def isnumber: #:: a| => boolean
    type == "number"
;
def isinteger: #:: a| => boolean
    type == "number" and . == floor
;
def isfloat: #:: a| => boolean
    type == "number" and . != floor
;
def isstring: #:: a| => boolean
    type == "string"
;
def isarray: #:: a| => boolean
    type == "array"
;
def isobject: #:: a| => boolean
    type == "object"
;
def isscalar: #:: a| => boolean
    type| . == "null" or . == "boolean" or . == "number" or . == "string"
;
def isiterable: #:: a| => boolean
    type| . == "array" or . == "object"
;
def isvoid: #:: a| => boolean
    isiterable and length == 0
;
def isleaf: #:: a| => boolean
    isscalar or isvoid
;

def isnull($a): #:: (a) => boolean
    $a|isnull
;
def isboolean($a): #:: (a) => boolean
    $a|isboolean
;
def isnumber($a): #:: (a) => boolean
    $a|isnumber
;
def isinteger($a): #:: (a) => boolean
    $a|isinteger
;
def isfloat($a): #:: (a) => boolean
    $a|isfloat
;
def isstring($a): #:: (a) => boolean
    $a|isstring
;
def isarray($a): #:: (a) => boolean
    $a|isarray
;
def isobject($a): #:: (a) => boolean
    $a|isobject
;
def isscalar($a): #:: (a) => boolean
    $a|isscalar
;
def isiterable($a): #:: (a) => boolean
    $a|isiterable
;
def isvoid($a): #:: (a) => boolean
    $a|isvoid
;
def isleaf($a): #:: (a) => boolean
    $a|isleaf
;

# is unknown?
def isunk($p): #:: array^object|(number^string) => boolean
    has($p) and .[$p] == null
;

# is undefined?
def isund($p): #:: array^object|(number^string) => boolean
    has($p) | not
;

# coerce to bool (exactly true or false)
def tobool: #:: a| => boolean
    if . then true else false end
;

def tobool(a): #:: (a) => boolean
    if first(a)//false then true else false end
;

# Variation on `with_entries`
#
# PAIR: {"name":string, "value":value}
#
def mapobj(filter): #:: object|(PAIR->PAIR) => object
    reduce (keys_unsorted[] as $k
            | {name: $k, value: .[$k]}
            | filter
            | {(.name): .value})
        as $pair
        ({}; . + $pair)
;

# Variation on `walk`
#
def mapdoc(filter): #:: a|(a->b) => b
    . as $doc |
    if isobject then
        reduce keys_unsorted[] as $k
            ({}; . + {($k): ($doc[$k] | mapdoc(filter))})
        | filter
    elif isarray then
        [.[] | mapdoc(filter)]
        | filter
    else
        filter
    end
;

# vim:ai:sw=4:ts=4:et:syntax=jq
