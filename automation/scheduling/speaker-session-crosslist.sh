#!/usr/bin/env bash

# generates list of Speaker Name:
#  - Sessions spoken at (session-id, title and description)

spklist=$(grep '^  id: ' speakers.yml | sed 's/  id: //'); for spk in ${spklist[@]}; do grep -A 2 '^  id: '"$spk"'$' speakers.yml | sed -e '/^  id:/ d; s/surname: //; s/name: //; s/"//g' | tr '\n' ' '; echo ""; grep -B 4 '^  speakers:.*'"$spk"'.*' sessions.yml | sed 's/^  id:/session-id:/'; echo ""; done
