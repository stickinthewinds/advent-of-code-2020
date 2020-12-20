#!/usr/bin/env gst

Object subclass: PartOne [
    "Class variables"
    | estimate buses busTimes |
    <comment:
        'Part one of day 13'>

    init [
        <category: 'initialization'>
        estimate = 0.
        buses = #().
        "Dictionary of {Bus number => Time until next arrives}"
        busTimes := Dictionary new.
    ]

    getMinimum [
        | min smallest |
        min := nil.
        busTimes keysAndValuesDo: [:k :v |
            "Will set min and smallest to the first value then change
            to the lower after that first"
            (min isNil or: [v < smallest])
                ifTrue: [
                    min := k.
                    smallest := v
                ]
        ].
        ^(min * smallest).
    ]

    "SETTERS"
    setEstimate: newEstimate [estimate := newEstimate asNumber.]
    setBuses: newBuses [buses := newBuses.]
    setBusTimes: newBusTimes [busTimes := newBusTimes.]

    "GETTERS"
    getEstimate [^estimate.]
    getBuses [^buses.]
    getBusTimes [^busTimes.]
]

Object subclass: PartTwo [
    "Class variables"
    | t buses busTimes |
    <comment:
        'Part one of day 13'>

    init [
        <category: 'initialization'>
        buses = #().
        busTimes := Dictionary new.
        t := 1.
    ]

    "Returns the length of the imported collection"
    getLength: inColl [
        | count |
        count := 0.
        inColl do: [:each |
            count := count + 1.
        ].
        ^count.
    ]

    reduceFunc: val nextVal: next [
        | result |
        result := val * next.
        ^result.
    ]

    "Based on python reduce function where the lambda function is a*b"
    reduce: array [
        | length value |
        length := (self getLength: array).
        value := nil.
        "array printNl."
        array do: [:each |
            (value isNil) ifFalse: [
                value := (self reduceFunc: value nextVal: each).
            ].
            (value isNil) ifTrue: [value := each.].
        ].
        ^value.
    ]

    "Chinese remainder algorithm based on:
    https://rosettacode.org/wiki/Chinese_remainder_theorem"
    chineseRemainder: buses expected: order [
        | sum prod count p result curr modmult |
        sum := 0.
        prod := (self reduce: buses).
        count := 1.
        buses do: [:v |
            "v printNl."
            p := (prod // v).
            curr := order at: count.
            "curr printNl."
            modmult := (self modMultInvA: p modMultInvB: v).
            sum := (sum + ((curr * modmult) * p)).
            count := count + 1.
        ].
        result := (sum \\ prod).
        result printNl.
    ]

    "Part of the above algorithm"
    modMultInvA: v1 modMultInvB: v2 [
        | a b b0 x0 x1 q temp |
        a := v1.
        b := v2.
        b0 := b.
        x0 := 0.
        x1 := 1.
        (b = 1) ifTrue: [^1.].
        [a > 1] whileTrue: [
            q := (a // b).

            temp := a.
            a := b.
            b := (temp \\ b).

            temp := x0.
            x0 := x1 - (q * x0).
            x1 := temp.
        ].
        (x1 < 0) ifTrue: [x1 := x1 + b0.].
        ^x1.
    ]

    "SETTERS"
    setBuses: newBuses [buses := newBuses.]
    setBusTimes: newBusTimes [busTimes := newBusTimes.]

    "GETTERS"
    getBuses [^buses.]
    getBusTimes [^busTimes.]
]

Object subclass: FileReader [
    "Class variables"
    | fileName partOne partTwo |
    <comment:
        'Reader for completing the challenge'>

    init [
        <category: 'initialization'>
        partOne := (PartOne new) init.
        partTwo := (PartTwo new) init.
        fileName = ''
    ]

    process [
        | f bus nextBus busTimes depart order count |
        "Just in case there wereno arguments but it didn't crash"
        (fileName == '') ifFalse: [
            f := FileStream open: fileName mode: FileStream read.

            partOne setEstimate: f nextLine.
            partOne setBuses: ((f nextLine) substrings: ','). "Gives an array of all the buses"
            partTwo setBuses: (partOne getBuses).

            f close.
            "partOne getEstimate printNl."

            busTimes := (partOne getBusTimes).
            (partOne getBuses) do: [:each |
                "Ignore the 'x' buses"
                (each = 'x') ifFalse: [
                    bus := each asNumber. "Convert the value to an int"
                    nextBus := (bus - ((partOne getEstimate) \\ bus)).

                    "Transcript show: 'Bus number: '.
                    bus printNl.
                    Transcript show: 'Time until next bus: '.
                    nextBus printNl."

                    "Append the bus to the dictionary along with the time of the next bus"
                    busTimes at: bus put: nextBus.
                ].
                "Transcript show: each ; cr. ]"
            ].

            "waitTime := (partOne getMinimum)."
            Transcript show: 'Minimum wait time multiplied by the bus ID: '.
            (partOne getMinimum) printNl.

            "
            PART TWO FROM HERE ON
            "

            depart := 0.
            count := 1.
            order := Dictionary new. "Set for the chinese remainder theorem values"

            "Get the initialized dictionary to fill with values"
            busTimes := (partTwo getBusTimes).
            (partTwo getBuses) do: [:each |
                "Ignore the 'x' buses"
                (each = 'x') ifFalse: [
                    bus := each asNumber. "Convert the value to an int"
                    nextBus := bus.

                    "Append the bus to the dictionary along with the time of the next bus"
                    busTimes at: count put: nextBus.
                    order at: count put: (bus - depart).
                    count := count + 1.
                    "busTimes add: nextBus."
                    "Add the number that the remainder for the current bus should be to
                    the array to use crt on"
                    "order add: depart."
                ].
                depart := depart + 1.
            ].

            "Call the chineseRemainder method from PartTwo class with busTimes and order as inputs"
            partTwo chineseRemainder: busTimes expected: order.
        ].
    ]

    "SETTERS"
    setFileName: newFileName [fileName := newFileName.]

    "GETTERS"
    getFileName [^fileName.]
]

Eval [
    fr := (FileReader new) init.

    fr setFileName: (Smalltalk arguments first).

    fr process.
]