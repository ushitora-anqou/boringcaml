type position = { line : int; column : int }
type range = { startpos : position; endpos : position }
type location = { fname : string; ran : range option }
type 'a with_location = { v : 'a; loc : location }
