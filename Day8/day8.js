function process(lineDict, visited) {
    var currPos = 0;
    var accumulated = 0;

    try {
        while (!visited.includes(currPos) && currPos < lineDict.size) {
            visited.push(currPos);
            var currContent = lineDict.get(currPos);
            if (currContent[0] === 'jmp') {
                currPos += parseInt(currContent[1]);
            } else if (currContent[0] === 'acc') {
                var acc = parseInt(currContent[1]);
                currPos += 1;
                accumulated += acc;
            } else {
                currPos += 1;
            }
        }
    } catch (err) {
        $("#result").append(`Error occured at position ${currPos}: ${err.message}<br/>`);
        console.log(`Error occured at position ${currPos}: ${err.message}`);
    }

    return accumulated;
}

function part1(lineDict) {
    // Don't need to initialize visited for part 1
    return process(lineDict, []);
}

function switch_value(value) {
    if (value === 'jmp') {
        value = 'nop';
    } else if (value === 'nop') {
        value = 'jmp';
    }
    return value;
}

function part2(lineDict) {
    var visited = [];
    var accumulated = 0;

    for (let i = 0; i < lineDict.size; i++) {
        const value = lineDict.get(i);
        // Switch the current value if it is nop or jmp
        lineDict.set(i, [switch_value(value[0]), value[1]]);
        console.log(lineDict.get(i));

        // Initialize visited so that it can be checked after the process
        visited = [];
        accumulated = process(lineDict, visited);

        const lastVisited = visited.slice(-1).pop();
        console.log(`Last visited for ${i}: ${lastVisited}`);
        if (lastVisited >= lineDict.size - 1) {
            return accumulated;
        }

        // Switch the value back before continuing
        lineDict.set(i, value);
    }
    
    return accumulated;
}


function day8(lineDict) {
    $("#result").append(`Number of values: ${lineDict.size}<br/>`);
    console.log(`Number of values: ${lineDict.size}`);
    var result = 0;

    // PART ONE
    $("#result").append(`Part One<br/>`);
    console.log(`Part One`);
    result = part1(lineDict);
    $("#result").append(`Accumulated: ${result}<br/>`);
    console.log(`Accumulated: ${result}`);

    // PART TWO
    $("#result").append('Part Two<br/>');
    console.log('Part Two');
    result = part2(lineDict);
    $("#result").append(`Accumulated: ${result}<br/>`);
    console.log(`Accumulated: ${result}`);
}

$(window).on("load", function () {
    $("#file").on("change", function () {
        $("#result").empty()
        const file = this.files[0];
        const reader = new FileReader();
        const lineDict = new Map();

        reader.onload = (event) => {
            const file = event.target.result;
            const allLines = file.split(/\r\n|\n/);
            var currLine = 0;
            // Reading line by line
            allLines.forEach((line) => {
                const content = line.split(' ');
                if (content.length > 1) {
                    lineDict.set(currLine, content);
                }
                currLine += 1;
            });

            day8(lineDict);
        };

        reader.onerror = (event) => {
            alert(event.target.error.name);
        };

        reader.readAsText(file);
    });
});