json.fandoms @fandoms do |fandom|
  json.partial! 'api/v1/fandoms/fandom', fandom: fandom
end