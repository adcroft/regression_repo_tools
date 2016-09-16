#!/bin/csh

# Make a commit using the last log message in MOM6-examples

# Extract last log message
(cd MOM6-examples/ ; git log -n 1 ) > m6e.msg
# Create new log message
(tail +5 m6e.msg | sed 's/^    //') > new.msg
# Extract author and date
set author=(`grep '^Author: ' m6e.msg | sed 's/Author: //'`)
set date=(`grep '^Date:   ' m6e.msg | sed 's/Date:   //'`)

# Make commit
set subject=(`head -1 new.msg`)
echo Commiting: $author, $date, $subject
git commit --author="$author" --date="$date" --file=new.msg

rm new.msg m6e.msg
