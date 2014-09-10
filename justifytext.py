#!/usr/bin/python
# Justify Text
# Author: Jeremy Hunt
# 9-8-14
# ELEC 424 Lab 01
import sys

# 
# Justify each line of the given file by taking each line and splitting it
# into segments by spaces, then inserting spaces between each so that the
# last character of the justified line lands on the justify_length character
# of the output line. Multiple consecutive spaces in the input text are
# considered one space. If the input line is longer than will fit on one line
# it will be split into multiple lines with as many words on each line as
# possible. If a line cannot be justified because a word is longer than
# justify_length, an error will be thrown. The only valid whitespace is 
# plain space.
#
def justify(file_name, justify_length):
    # Open up the file and read it line by line.
    with open(file_name, 'r') as f:
        for line in f:
            # Split it into words. This also deletes duplicate spaces.
            words = line.split()
            words_left = True;
            while words_left:
                words_left = False

                if len(words) < 1:
                    # Just print empty blank lines
                    print
                else:
                    # Figure out how many words we can fit on this line
                    words_on_line = []
                    used_chars = 0
                    for idx, cur_word in enumerate(words):
                        if len(cur_word) > justify_length:
                            raise RuntimeError(
                                'word in input too long to justify')
                        else:
                            if (used_chars + len(cur_word)) > justify_length:
                                # We've gone over the line. Reserve the rest of
                                # the words for the next line and finish
                                # justifying this one
                                words = words[idx:]
                                words_left = True
                                break
                            else:
                                used_chars += len(cur_word) + 1
                                words_on_line.append(cur_word)

                    if len(words_on_line) == 1:
                        # Just print lines with one word.
                        print words_on_line[0]
                        continue

                    # Print each word on the line with the needed number of
                    # extra spaces
                    # Get rid of the last space
                    used_chars -= 1
                    extra_spaces = (justify_length - used_chars)/(len(words_on_line)-1)
                    extra_extra_spaces = justify_length - used_chars - (extra_spaces)*(len(words_on_line)-1)
                    for cur_word in words_on_line[:-1]:
                        sys.stdout.write(cur_word + ' ' + ' '*extra_spaces)
                        # Spread any extra one-off spaces at the begining of the line
                        if extra_extra_spaces > 0:
                            sys.stdout.write(' ')
                            extra_extra_spaces -= 1
                    # Print out the last word and end-line
                    sys.stdout.write(words_on_line[-1])
                    print

# Program justifies text contents of a given file
# This is the actual code that gets run when the
# program is run. 
#
# DO NOT EDIT BELOW HERE.
if __name__ == "__main__":

    file_name = ''
    length = -1

    # Parse command line arguments
    try:
        for i in range(len(sys.argv)):
            if sys.argv[i] == '-f':
                file_name = sys.argv[i+1]
            elif sys.argv[i] == '-l':
                length = int(sys.argv[i+1])
    except:
        exit('Input error. Example input: justifytext -f mytextfile -l 80')

    if file_name == '' or length < 1:
        exit('Input error. Example input: justifytext -f mytextfile -l 80')
        
    justify(file_name, length)
