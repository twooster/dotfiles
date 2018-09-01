function dclog --argument-names container length
  test -n "$length" ; or set length 50
  echo docker-compose logs "--tail=$length" -f "$container"
end
