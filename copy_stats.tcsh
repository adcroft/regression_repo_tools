#!/bin/csh

# Copies every ocean.stats or seaice.stats found in MOM6-examples into regressions

foreach compiler (gnu intel pgi)
  foreach file (`cd MOM6-examples ; find * -name ocean.stats.$compiler -o -name seaice.stats.$compiler`)
    mkdir -p regressions/$file:h
    \cp MOM6-examples/$file regressions/$file
  end
end
