curl "https://api-digital.enecogroup.com/dxpweb/nl/eneco/customers/40857840/accounts/2/usages?aggregation=Day&interval=Hour&start=$year-$month_start-01&end=2022-$month_end-01&addBudget=false&addWeather=false&extrapolate=false" -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/110.0' -H 'Accept: application/json' -H 'Accept-Language: nl-NL' -H 'apikey: 41ff1058fc7f4446b80db84e8857c347' -H "authorization: $(cat authorization)" -H 'request-id: |a9fce8e73b7444d182fd1a24258aa3fb.6b56eddb7b704e3c' -H 'traceparent: 00-a9fce8e73b7444d182fd1a24258aa3fb-6b56eddb7b704e3c-01' -H 'Origin: https://www.eneco.nl' -H 'Connection: keep-alive' -H 'Referer: https://www.eneco.nl/' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: cross-site' -H 'TE: trailers' --output data/$year-$month_start-$month_end.json
}

fetch-data 2022 06 









