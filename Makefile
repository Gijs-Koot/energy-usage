data/raw: ./get-data.sh
	./get-data.sh
	touch data/raw
data/agg.json: data/20*.json
	cat data/20*.json | jq '.data.usages[].entries[].actual | {date: .date, gas_high: .gas.high, gas_low: .gas.low, elec_high: .electricity.high, elec_low: .electricity.low}' | jq -s '.' > data/agg.json
data/uurgeg_260_2021-2030.zip:
	wget https://cdn.knmi.nl/knmi/map/page/klimatologie/gegevens/uurgegevens/uurgeg_260_2021-2030.zip
data/weather.csv
