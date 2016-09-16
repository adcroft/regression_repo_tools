#!/bin/tcsh

# Re-create a repository of commits 

set first_commit = 0cc12f9 # This is the first commit before updating answers to Gaea c3
set tool_dir = $0:h

if (-x .git) exit 999

#git clone git@github:NOAA-GFDL/MOM6-examples
(cd MOM6-examples; git checkout dev/master)
#(cd MOM6-examples; git pull)
(cd MOM6-examples; git log --oneline $first_commit..) | head --lines=-1 | tee flist | sed 's/ .*//' | tac > clist

# Initialize a git repository
git init
git add labels.json
git add README.md
git add .gitignore
git commit --author="Alistair Adcroft <Alistair.Adcroft@noaa.gov>" --date="Tue Apr 25 01:23:45 2016 -0400" -m "Initial creation of regressions repo"
git submodule init
git submodule add ./MOM6-examples

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
