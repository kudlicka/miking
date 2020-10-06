-- Miking is licensed under the MIT license.
-- Copyright (C) David Broman. See file LICENSE.txt
--
-- File miking.mi is the main file of the Miking tool chain.

include "seq.mc"
include "string.mc"
include "compile.mc"
include "assoc.mc"

mexpr

-- Menu
let menu = strJoin "\n" [
  "Usage: mi [compile] <files>",
  "",
  "Options:",
  "  --debug-parse    Enables output of parsing"] in

-- Option structure
let options = {
  debugParse = false
} in

-- Option map, maps strings to structure updates
let optionsMap = [
("--debug-parse", lam o. {o with debugParse = true})
] in

-- Commands map, maps command strings to functions. The functions
-- always take two arguments: a list of filename and an option structure.
let commandsMap = [
("compile", compile)
] in

-- Simple handling of options before we have an argument parsing library.
let parseOptions = lam xs.
  (foldl (lam acc. lam s.
    match acc with (options,lst) then
      match findAssoc (lam s2. eqString s1 s2) optionsMap with Some f
      then (f options, lst)
      else [printLn (concat "Unknown option " s), exit 1]
    else never
  ) (options,[]) (reverse xs)).0 in


-- Main: find and run the correct command. See commandsMap above.
if lti (length argv) 2 then print menu else
  match  (eqString (get argv 1)) commandsMap with Some cmd
  then
    let argvp = partition (isPrefix eqc "--") (tail (tail argv)) in
    cmd argvp.1 (parseOptions argvp.0)
  else
    [printLn (join ["Unknown command '", get argv 1, "'"]), exit 1]
