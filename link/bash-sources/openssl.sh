openssl-show-remote-cert() {
  openssl s_client -showcerts -connect "$1:${2-443}"
}

openssl-check-remote-cert-expiration() {
  openssl s_client -connect "$1:${2-443}" | openssl x509 -noout -dates
}
