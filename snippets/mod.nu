# Search and list saved commands, or other information.
export def "snip show" [
  ...regex:string         # Search terms as regexes, may be more than one
  --get(-g):number        # Row to get
  --nuon(-n)              # With the table output (i.e. not -g), output the untransformed nuon output (i.e. no table | rg)
]: [nothing -> table, nothing -> string] {
  let rgregex = ($regex | str join "|")
  let cmds = open $"($env.snippets-path)"

  $regex | reduce -f $cmds { |it, acc| $acc | find -c [v] -ir $"($it)" }
  | match ($get | is-empty)  {
      true => {
        if $nuon {
          $in
        } else {
          $in | table -e | rg --passthru $"($rgregex)" }
      }
      false => { $in | get $get | get v.body | to text },
    }
}

# Add an entry to the snippets table
export def "snip add" [
  description: any       # The description of the entry
  body: any              # The body of the entry, in general a command
]: nothing -> nothing {
  let entry = {
    uuid: (random uuid | str upcase | str trim -r -c "\n"),
    v: {
      description: $description
      body: $body
    }
  }
  cp $"($env.snippets-path)" $"($env.snippets-path).bak"
  open $"($env.snippets-path)" | append $entry | to nuon -i 2 | save -f $"($env.snippets-path)"
}

# Open the default editor ($env.EDITOR) to edit the snippets file ($env.snippets-path)
export def "snip edit" []: nothing -> nothing {
  ^$"($env.EDITOR)" $"($env.snippets-path)"
}
