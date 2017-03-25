#!/bin/bash
my.exe -b log/at1.txt > log/at1.actual.txt
messenger.exe -b log/at1.txt > log/at1.expected.txt
messenger.exe -b log/at1.txt > messenger-project/tests/acceptance/at1.expected.txt
diff log/at1.actual.txt log/at1.expected.txt

my.exe -b log/at2.txt > log/at2.actual.txt
messenger.exe -b log/at2.txt > log/at2.expected.txt
messenger.exe -b log/at2.txt > messenger-project/tests/acceptance/at2.expected.txt
diff log/at2.actual.txt log/at2.expected.txt

my.exe -b log/at3.txt > log/at3.actual.txt
messenger.exe -b log/at3.txt > log/at3.expected.txt
messenger.exe -b log/at3.txt > messenger-project/tests/acceptance/at3.expected.txt
diff log/at3.actual.txt log/at3.expected.txt

my.exe -b log/at4.txt > log/at4.actual.txt
messenger.exe -b log/at4.txt > log/at4.expected.txt
messenger.exe -b log/at4.txt > messenger-project/tests/acceptance/at4.expected.txt
diff log/at4.actual.txt log/at4.expected.txt

my.exe -b log/at5.txt > log/at5.actual.txt
messenger.exe -b log/at5.txt > log/at5.expected.txt
messenger.exe -b log/at5.txt > messenger-project/tests/acceptance/at5.expected.txt
diff log/at5.actual.txt log/at5.expected.txt
