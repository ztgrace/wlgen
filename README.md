# Wordlist Generator

Script to automate building wordlists for AppSec directory/resource bruting.

```
$ python3 wlgen.py -h
usage: wlgen.py [-h] [-a] [-c CONFIG] [-l [LANGS [LANGS ...]]] [--lists LISTS]
                [-o OUTPUT] [-s SECLISTS] [--skip]

optional arguments:
  -h, --help            show this help message and exit
  -a, --all             Compile all lists
  -c CONFIG, --config CONFIG
                        Config file to use
  -l [LANGS [LANGS ...]], --langs [LANGS [LANGS ...]]
                        Language(s)
  --lists LISTS         Lists yaml file
  -o OUTPUT, --output OUTPUT
                        Config file to use
  -s SECLISTS, --seclists SECLISTS
                        Path to SecLists
  --skip                Skip general lists
```
