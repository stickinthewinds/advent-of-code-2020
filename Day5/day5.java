import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class day5
{
    public static void main(String[] args)
    {
        if (args.length == 1)
        {
            try
            {
                List<String> lines = readFile(args[0]);
                List<Integer> seats = processLines(lines);
                System.out.format("Max ID: %d\n", Collections.max(seats));
                int mySeat = getMySeat(seats);
                System.out.format("My seat is at ID: %d\n", mySeat);
            }
            catch (Exception e)
            {
                System.err.println(e.getMessage());
                e.printStackTrace();
            }
        }
    }

    private static List<String> readFile(String filename)
    {
        BufferedReader br;
        List<String> lines = new ArrayList<>();
        try
        {
            br = new BufferedReader(new FileReader(filename));
            String line = br.readLine();

            while (line != null)
            {
                lines.add(line);
                line = br.readLine();
            }
            br.close();
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
        return lines;
    }

    private static List<Integer> processLines(List<String> lines)
    {
        List<Integer> seats = new ArrayList<>();

        for (String line : lines)
        {
            int row = getSeating(line, 'F', 'B');
            int column = getSeating(line, 'L', 'R');
            int result = (row * 8) + column;
            seats.add(result);
        }
        Collections.sort(seats);
        return seats;
    }

    private static int getSeating(String line, char lowChar, char highChar)
    {
        int minRange = 0;
        int maxRange = lowChar == 'F' ? 127 : 7;
        int difference = maxRange - minRange;
        char lastChar = lowChar;
        int addOnOdd;

        for (int i = 0; i < line.length(); i++)
        {
            addOnOdd = difference % 2 == 0 ? 0 : 1;

            if (line.charAt(i) == lowChar)
            {
                lastChar = lowChar;
                maxRange -= difference / 2 + addOnOdd;
                difference = maxRange - minRange;
            }
            else if (line.charAt(i) == highChar)
            {
                lastChar = highChar;
                minRange += difference / 2 + addOnOdd;
                difference = maxRange - minRange;
            }
        }
        int seat = lastChar == lowChar ? minRange : maxRange;
        return seat;
    }

    private static int getMySeat(List<Integer> seats)
    {
        if (seats.size() > 1)
        {
            int old = seats.get(0), curr = seats.get(1), result = curr - 1;
            for (int i = 3; i < seats.size(); i++)
            {
                if (old == curr - 2)
                {
                    System.out.format("My potential seat ID: %d\n", curr - 1);
                    result = curr - 1;
                }
                old = curr;
                curr = seats.get(i);
            }
            return result;
        }
        else
        {
            return seats.get(0);
        }
    }
}