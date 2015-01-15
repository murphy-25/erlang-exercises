# erlang-exercises
01 - pi.erl – calculates the value of pi to 5 decimal places.

02 - list.erl – removes duplicates and calculates length of a list. There is also another function which can read a file and remove duplicates and calculate the length of a list.

03 - charcount.erl – determines the character count without using multiple processes. I added a timer method so that I could compare this and ccharcount.erl.

04 - ccharcount.erl – determines the character count using multiple processes. A timer was also added.

The charcount.erl file took around 13s to count up the characters once the warandpeace.txt file was read in. In contrast the ccharcount.erl file took around 3s to count up the characters. Shows how concurrency is so useful even for something so trival.
