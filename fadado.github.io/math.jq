module {
    name: "math",
    description: "Miscelaneous mathematical functions",
    namespace: "fadado.github.io",
    author: {
        name: "Joan Josep Ordinas Rosa",
        email: "jordinas@gmail.com"
    }
};

include "fadado.github.io/prelude";

########################################################################
# Simple utilities

def abs($n): #:: (number) => number
    $n|length
;

def even($n): #:: (number) => boolean
    $n%2 == 0
;

def odd($n): #:: (number) => boolean
    $n%2 == 1
;

def min($m; $n): #:: (number;number) => number
    if $m < $n then $m else $n end
;

def max($m; $n): #:: (number;number) => number
    if $m > $n then $m else $n end
;

def gcd($m; $n): #:: (number;number) => number
    if $n == 0
    then $m
    else gcd($n; $m % $n)
    end
;

def mod($m; $n): #:: (number;number) => number
    ($m % $n)
    | when(. < 0; . + $n)
;

def div($m; $n): #:: (number;number) => number
    ($m / $n) | floor
;

#def gcd($m; $n): #:: (number;number) => number
#    def step:
#        .x = .n      |
#        .n = .m % .n |
#        .m = .x
#        
#    ;
#    label $pipe
#    | {$m, $n}
#    | iterate(step)
#    | select(.n == 0)
#    | (.m, break $pipe)
#;

#def gcd($m; $n): #:: (number;number) => number
#    def step:
#        .n as $x     |
#        .n = .m % .n |
#        .m = $x;
#    {$m, $n} | until(.n == 0; step) | .m
#;

def sign($n): #:: (number) => number
    $n|if isnan or type!="number" then nan
    elif . > 0                    then 1
    elif . == 0                   then 0
                                  else -1
    end
;

def tobase($b): #:: number|(number) => ?string
    def digit: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"[.:.+1];
    def div: (. / $b)|floor;
    def mod: . % $b;
    def r: if . < $b then digit else (div|r)+(mod|digit) end;
    # do nothing if base out of range
    select(2 <= $b and $b <= 36)
    | r
;

# Inspired in https://www.rosettacode.org/wiki/URL_decoding#jq
def frombase($base): #:: string|(number) => number
    def downcase:
        when(65 <= . and . <= 90; . + 32)
    ;
    def toint: # "a" ~ 97 => 10 ~ 87
        if . > 96  then . - 87 else . - 48 end
    ;
    reduce (explode | reverse[] | downcase | toint) as $c
       ({power: 1, answer: 0};
        (.power * $base) as $b
        | .answer += (.power * $c)
        | .power = $b)
    | .answer
;

########################################################################
# Reductions

def sum(generator): #:: a|(a->*number) => number
    reduce generator as $item
        (0; . + $item)
;

def product(generator): #:: a|(a->*number) => number
    reduce generator as $item
        (1; . * $item)
;

def maximum(generator): #:: a|(a->*number) => number
    reduce generator as $item
        (0-infinite; max($item; .))
;

def minimum(generator): #:: a|(a->*number) => number
    reduce generator as $item
        (infinite; min($item; .))
;

# vim:ai:sw=4:ts=4:et:syntax=jq
