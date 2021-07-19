def objectify(headers):
  def tonumberq: tonumber? // .;
  . as $in
  | reduce range(0; headers|length) as $i ({}; .[headers[$i]] = ($in[$i] | tonumberq) );

def csv2table:
  def trim: sub("^ +";"") |  sub(" +$";"");
  split("\n") | map( split(",") | map(trim) );

def fromcsv:
  csv2table
  | .[0] as $headers
  | reduce (.[1:][] | select(length > 0) ) as $row
      ( []; . + [ $row|objectify($headers) ]);
