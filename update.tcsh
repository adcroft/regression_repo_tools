#!/bin/tcsh

# Updates an existing repository of commits

set tool_dir = $0:h

if (! -x .git) exit 999

# Figure the range of commits to update
set current_commit = (`git diff MOM6-examples | tail -n -1 | awk '{print $3}'`)
set first_commit = (`git diff MOM6-examples | tail -n -2 | head -n -1 | awk '{print $3}'`)
echo $first_commit .. $current_commit

(cd MOM6-examples; git checkout dev/master)
#(cd MOM6-examples; git pull)
(cd MOM6-examples; git log --oneline $first_commit..) | tee flist | sed 's/ .*//' | tac > clist

# Search through each commit in MOM6-examples
foreach c (`cat clist`)
  (cd MOM6-examples; git checkout $c)
  rm -rf regressions
  tcsh $tool_dir/copy_stats.tcsh
  set res=`git status --porcelain regressions`
  if ($#res) then
    git add regressions
    git add MOM6-examples
    tcsh $tool_dir/commit.tcsh
  endif
end

rm clist flist
(cd MOM6-examples; git checkout dev/master)
