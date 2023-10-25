#!/usr/bin/awk -f

# usage: awk -f /path/to/awk01-resbaz-sessions.awk resbaz-sessions-spreadsheet.tsv > sessions.yml
# note double quotes in "description" will break the resulting YAML

BEGIN {
  FS="\t"
}

$5 ~ /^(0|[1-9][0-9]*)$/ {
  printf("-\n  id: %s\n  title: \"%s\" \n  description: \"%s\"\n  subtype: %s\n  speakers: [%s]\n  service: %s\n  hidden: %s\n",$5,$1,$10,$7,$6,$8,$9)
}
