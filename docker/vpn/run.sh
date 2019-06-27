docker rm -f openconnect
# https://stackoverflow.com/a/30555962/74167
docker run --rm --name openconnect -d -p 14722:22 --privileged jlarky/openconnect

(echo 8x8-RSA; echo ylapin; cat) | docker exec -i openconnect bash -c 'openconnect usc1-vpn.8x8.com'
