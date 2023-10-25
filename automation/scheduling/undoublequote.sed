#!/usr/bin/sed -f

# change all double-quotes inside YAML "" strings for the description key 
# to single-quotes by doing
# sed -f undoublequote.sed sessions.yml
# apply this to other headers using double sed!
# for example, to undoublequote titles instead of descriptions:
# sed -e "$(sed 's/description/title/' undoublequote.sed)" sessions.yml

/^  description/ s/"/'/g
/^  description/ s/'/"/
/^  description/ s/'$/"/
