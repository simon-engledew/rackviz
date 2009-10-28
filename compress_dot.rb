#!/usr/bin/env ruby

require 'zlib'
require 'red_raw'

input = RedRaw.encode_url64(Zlib::Deflate.deflate(STDIN.read.strip))

puts input