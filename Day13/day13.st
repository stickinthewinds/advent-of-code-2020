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
        busTimes := Dictionary new.
    ]

    getMinimum [
        | min smallest |
        "busTimes keysAndValuesDo: [ :k :v |
            k printNl.
            v printNl.
        ]"
        min := nil.
        busTimes keysAndValuesDo: [:k :v |
          (min isNil or: [v < smallest])
            ifTrue: [
              min := k.
              smallest := v]].
        min printNl.
        ^(min * smallest).
    ]

    "SETTERS"
    setEstimate: newEstimate [estimate := newEstimate asNumber.]
    setBuses: newBuses [buses := newBuses.]
    setBusTimes: newBusTimes [busTimes := newBusTimes.]

    "GETTERS"
    getEstimate [^estimate.]
    getBuses [^buses.]
    getBusTimes [^busTimes]
]

Object subclass: FileReader [
    "Class variables"
    | fileName partOne partTwo |
    <comment:
        'Reader for completing the challenge'>

    init [
        <category: 'initialization'>
        partOne := (PartOne new) init.
        fileName = ''
    ]

    process [
        | f bus nextBus busTimes |
        "Just in case there wereno arguments but it didn't crash"
        (fileName == '') ifFalse: [
            f := FileStream open: fileName mode: FileStream read.

            partOne setEstimate: f nextLine.
            partOne setBuses: ((f nextLine) substrings: ','). "Gives an array of all the buses"

            f close.
            partOne getEstimate printNl.

            "Dictionary of {Bus number => Time until next arrives}"

            busTimes := (partOne getBusTimes).
            (partOne getBuses) do: [:each |
                "Ignore the 'x' buses"
                (each = 'x') ifFalse: [
                    bus := each asNumber. "Convert the value to an int"
                    Transcript show: 'Bus number: '.
                    bus printNl.
                    Transcript show: 'Time until next bus: '.
                    nextBus := (bus - ((partOne getEstimate) \\ bus)).
                    nextBus printNl.

                    "Append the bus to the dictionary along with the time of the next bus"
                    busTimes at: bus put: nextBus.
                ].
                "Transcript show: each ; cr. ]"
                ].

                partOne setBusTimes: busTimes.
                "waitTime := (partOne getMinimum)."
                (partOne getMinimum) printNl.
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