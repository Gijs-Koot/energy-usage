data/month-raw-*.json: ./get_data.sh
	for month in $$(seq 6 12)	; do \
	get_data $$month ; \
	done
data/agg.json:
	cat data/month-raw-*.json | jq '.data.usages[0].entries[].actual | {date: .date, gas_high: .gas.high}' | jq -s '.' > data/agg.json
