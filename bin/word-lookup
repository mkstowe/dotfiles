#!/bin/sh

shift $((OPTIND-1))

word=$(wl-paste)
dictionaryUrl="https://api.dictionaryapi.dev/api/v2/entries/en_US/$word"
res=$(curl -s $dictionaryUrl)
regex=$'"definition":"\K(.*?)(?=")'
definitions=$(echo "$res" | grep -Po "$regex")
separatedDefinition=$(sed ':a;N;$!ba;s/\n/\n\n/g' <<< "$definitions")
notify-send -t 15000 -a "word-lookup" "$word" "$separatedDefinition\nhttps://www.dictionary.com/browse/$word"
