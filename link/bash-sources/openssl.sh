openssl-check-remote-cert() {
  openssl s_client -showcerts -connect "$1"
}
