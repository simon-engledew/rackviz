module RedRaw
  
  def self.encode_url64(s)
    [s].pack('m').tr("\n", '').tr('+/', '-_')
  end
  
  def self.decode_url64(s)
    s.tr('-_', '+/').unpack('m').first
  end
  
end