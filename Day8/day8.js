function part1(lineDict, visited) {
    var currPos = 0;
    var accumulated = 0;

    while (!visited.includes(currPos)) {
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

    console.log("Accumulated: " + accumulated);
}

function day8(lineDict) {
    var visited = [];
    part1(lineDict, visited);
}

$(window).on("load", function () {
    const lineDict = new Map();
    $("#file").on("change", function () {
        const file = this.files[0];
        const reader = new FileReader();

        reader.onload = (event) => {
            const file = event.target.result;
            const allLines = file.split(/\r\n|\n/);
            var currLine = 0;
            // Reading line by line
            allLines.forEach((line) => {
                const content = line.split(' ');
                lineDict.set(currLine, content);
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