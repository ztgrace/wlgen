#!/usr/bin/env python3

import argparse
import os
import re
import requests
import yaml

total_lines = 0

def main(args):
    lists = parse_lists(args)
    results = []

    # iterate over lists
    for l in lists:
        lines = getLines(args, l)
        results = results + clean(args, lines)

    # write results to output
    results = set(results)
    with open(args.output, 'w') as fout:
        for i in results:
            fout.write(f'{i}\n')

    print(f'[+] Total wordlist lines: {total_lines}')
    print(f'[+] Final wordlist lines: {len(results)}')

def getLines(config, f):
    if not re.search(r'https://', f):
        print(f'[+] Reading {f}')
        f = f.replace('seclists', config.seclists)
        lines = []
        for line in open(f, 'r').readlines():
            line = line.strip()
            lines.append(line)
        return lines
    else:
        print(f'[+] Retrieving {f}')
        res = requests.get(f)
        return res.text.split('\n')

def clean(config: dict, dirty: list) -> list:
    global total_lines
    cleaned = []
    for d in dirty:
        total_lines += 1

        # remove any white space on the beginning or end
        d = d.strip()

        # TODO move these rules into config.yml
        # Ignore empty lines
        if re.match(r'^$', d):
            continue

        # Ignore # comment lines, or lines that start with an asterisk, question mark or tilde
        if re.match(r'^(\*|~|#| ->|\?).*$', d):
            continue

        if re.match(r'^[*~#?].*$', d):
            continue

        # Normalize lines by remove leading /
        d = re.sub(r'^/', '', d)

        # URL encode Spaces
        d = d.replace(' ', '%20')


        if "%ext%" in d.lower():
            for ext in config.langs:
                cleaned.append(re.sub(r'%ext%', ext, d, flags=re.IGNORECASE))
        else: 
            cleaned.append(d)

    return cleaned


def parse_lists(args) -> list:
    """ Returns a list of files to be included """
    raw = open(args.lists, "r").read()

    # Normalize lines by remove leading /
    d = re.sub(r'^/', '', d)

    # URL encode Spaces
    d = d.replace(' ', '%20')


    if "%ext%" in d.lower():
        for ext in config.langs:
            cleaned.append(re.sub(r'%ext%', ext, d, flags=re.IGNORECASE))
    else:
        cleaned.append(d)

    return cleaned


def parse_lists(args) -> list:
    """ Returns a list of files to be included """
    raw = open(args.lists, "r").read()
    y = yaml.load(raw, Loader=yaml.FullLoader)

    lists = []
    for k in y.keys():
        if args.all or k in args.langs or (not args.skip and k == "general"):
            lists = lists + y[k]

    return lists
            

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-a', '--all', action='store_true', help='Compile all lists', default=False)
    #parser.add_argument('-c', '--config', type=str, default='config.yml', help='Config file to use')
    parser.add_argument('-l', '--langs', nargs='*', help='Language(s)')
    parser.add_argument('--lists', type=str, default="lists.yml", help='Lists yaml file')
    parser.add_argument('-o', '--output', type=str, default='discovery.txt', help='Config file to use')
    parser.add_argument('-s', '--seclists', type=str, default="~/tools/SecLists", required=False, help='Path to SecLists')
    parser.add_argument('--skip', action='store_true', help='Skip general lists', default=False)
    
    args = parser.parse_args()

    if args.all is False and args.langs is None:
        parser.error("-a or -l is required")

    args.seclists = os.path.expanduser(args.seclists)
    #args.config = os.path.expanduser(args.config)
    args.lists = os.path.expanduser(args.lists)

    if args.all:
        raw = open(args.lists, "r").read()
        y = yaml.load(raw, Loader=yaml.FullLoader)
        langs = list(y.keys())
        langs.remove('general')
        args.langs = langs
    
    main(args)
