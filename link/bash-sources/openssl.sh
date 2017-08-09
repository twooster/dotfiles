openssl-show-remote-cert() {
  openssl s_client -showcerts -servername "$1" -connect "$1:${2-443}"
}

openssl-check-remote-cert-expiration() {
  openssl s_client -servername "$1" -connect "$1:${2-443}" | openssl x509 -noout -dates
}
