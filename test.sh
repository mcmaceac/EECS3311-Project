#!/bin/bash
my.exe -b log/at1.txt > log/at1.actual.txt
messenger.exe -b log/at1.txt > log/at1.expected.txt
messenger.exe -b log/at1.txt > messenger-project/tests/acceptance/at1.expected.txt
diff log/at1.actual.txt log/at1.expected.txt

cp log/at2.txt messenger-project/tests/acceptance/student/
my.exe -b log/at2.txt > log/at2.actual.txt
messenger.exe -b log/at2.txt > log/at2.expected.txt
messenger.exe -b log/at2.txt > messenger-project/tests/acceptance/student/at2.expected.txt
diff log/at2.actual.txt log/at2.expected.txt

cp log/at3.txt messenger-project/tests/acceptance/student/
my.exe -b log/at3.txt > log/at3.actual.txt
messenger.exe -b log/at3.txt > log/at3.expected.txt
messenger.exe -b log/at3.txt > messenger-project/tests/acceptance/student/at3.expected.txt
diff log/at3.actual.txt log/at3.expected.txt

cp log/at4.txt messenger-project/tests/acceptance/student/
my.exe -b log/at4.txt > log/at4.actual.txt
messenger.exe -b log/at4.txt > log/at4.expected.txt
messenger.exe -b log/at4.txt > messenger-project/tests/acceptance/student/at4.expected.txt
diff log/at4.actual.txt log/at4.expected.txt

cp log/at5.txt messenger-project/tests/acceptance/student/
my.exe -b log/at5.txt > log/at5.actual.txt
messenger.exe -b log/at5.txt > log/at5.expected.txt
messenger.exe -b log/at5.txt > messenger-project/tests/acceptance/student/at5.expected.txt
diff log/at5.actual.txt log/at5.expected.txt

cp log/at6.txt messenger-project/tests/acceptance/student/
my.exe -b log/at6.txt > log/at6.actual.txt
messenger.exe -b log/at6.txt > log/at6.expected.txt
messenger.exe -b log/at6.txt > messenger-project/tests/acceptance/student/at6.expected.txt
diff log/at6.actual.txt log/at6.expected.txt
