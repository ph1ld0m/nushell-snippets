# nushell-snippets

A snippet search and collection tool written in and for [nushell](https://github.com/nushell/nushell).

This version is based on the nushell nuon table format. The first version was compatible with TextMate and VSCode snippet's JSON format, but that proved somewhat cumbersome. Using nuon makes life easier and the VSCode JSON format currently isn't one of my use cases. If someone is interested, I can look into creating a compatible version again.

## Usage

### Searching for entries
If multiple search terms are given, the search terms are applied in a "fold" operation, i.e. first the 1. term is searched for, then the second term is search for on the result of the first term, and so on.

Search for entries and show them with the found words highlighted, the regexes search in an case insensitive manner:
```nushell
snip show nmap
```

Same as above but further limit and refine the search:
```nushell
snip show nmap version
```

Search for entries and output the unaltered nuon table structure:
```nushell
snip show nmap version -n
```

Search for entries and output the body of the first found entry:
```nushell
snip show nmap version -g 0
```

This can then be used in all kinds of manners, e.g.

Replace the commandline with the selected command
```
snip show nmap version -g 0 | commandline edit -r $in
```

Copy the selected command into the tmux buffer:
```
snip show nmap version -g 0 | tmux setb $in
```

Copy the selected command into the clipboard buffer using xclip:
```
snip show nmap version -g 0 | xclip -selection clipboard
```

Using the new `tee` command to print the command and then to copy it into the clipboard buffer using xclip:
```
snip show nmap version -g 0 | tee { to text | print } | xclip -selection clipboard
```

### Adding entries
You can add entries using the `snip add` command:

```
snip add "list users using smb null session #win #enum" "netexec smb <dc-ip> -u <username> -p <password> --sam"
```

You can also add lists, both for the description and the body, if you want, e.g. if you have multiple steps, or want to save multiple links, etc.

As a convenience `snip edit` opens `$env.snippets-path` in the `$env.EDITOR`.


## Dependencies
The code currently uses one dependency: [ripgrep (rg)](https://github.com/BurntSushi/ripgrep).
Rg is used as a somewhat quick and simple hack to highlight the found search terms.
Currently, it seems like this can't be done in a straightforward way in nushell natively (as far as I know).

ripgrep is available for basically all platforms, see [ripgrep installation](https://github.com/BurntSushi/ripgrep#installation)

## Installation
The current code relies on the environment variable `$env.snippets-path` to point to the `.nuon` file that stores the snippets.
For example:
```nushell
mkdir ~/snippets
cp template.nuon ~/snippets/snippets.nuon
echo '$env.snippets-path = "~/snippets/snippets.nuon"' o>> $nu.env-path
```

Then you can add snippets as a module in $nu.config-path (on *BSD and Linux usually `~/.config/nushell/config.nu`)
```nushell
use <PATH>/snippets *
```

## Todo
- [ ] Better examples, with example output
