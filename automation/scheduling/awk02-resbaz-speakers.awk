#!/usr/bin/awk -f

# usage: awk -f /path/to/awk02-resbaz-speakers.awk resbaz-speakers-spreadsheet.tsv > speakers.yml

BEGIN {
  FS="\t"
}

$1 ~ /^(0|[1-9][0-9]*)$/ {
  printf("-\n  id: %s\n  name: \"%s\" \n  surname: \"%s\"\n  company: \"%s\"\n  title: \"%s\"\n  bio: \"%s\"\n  thumbnailUrl: \"%s\"\n  rockstar: \"%s\"\n  ribbon: \"%s\"\n  social: \"%s\"\n",$1,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12)
}

