function day8(lineDict, visited) {
    var currPos = 0;
    var accumulated = 0;

    while (!visited.includes(currPos)) {
        visited.push(currPos);
        if (lineDict[currPos][0] === 'jmp') {
            currPos += parseInt(lineDict[currPos][1]);
        } else if (lineDict[currPos][0] === 'acc') {
            var acc = parseInt(lineDict[currPos][1]);
            currPos += 1;
            accumulated += acc;
        } else {
            currPos += 1;
        }
    }

    console.log("Accumulated: " + accumulated);
}

$(window).on("load", function () {
    var lineDict = {}
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
                lineDict[currLine] = content;
                currLine += 1;
            });

            var visited = [];
            day8(lineDict, visited);
        };

        reader.onerror = (event) => {
            alert(event.target.error.name);
        };

        reader.readAsText(file);
    });
});