doall() {
	rm json.list
	rm json.url.list
	rm list.json.sh
	rm download.list
	rm download.sh
	find . -maxdepth 2 -type f -name "*.info.json" -print0 | sort -z | while IFS= read -r -d '' line;
	do
		l2=$(get_json.sh "$line")
		echo $l2
		echo $l2 >> json.list
	done
}


doall

sort -r json.url.list > json.url.sort
sort --key=6 -r list.json.sh > list.sorted.sh

#sort --key=2 -r download.list | sed "s/$/ --language nl\n/" | sed "s/ - url: /\nsa /"  > download.sh

