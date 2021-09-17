module EncodingHelpers
  def encrypt_values(attribute)
    encryptor = OpenSSL::Cipher.new "AES-256-CBC"
    encryptor.encrypt
    encryptor.pkcs5_keyivgen self.encrypt_password, ENV["CIPHER_SALT"]

    begin
      encryptor.update(self.send(attribute)) + encryptor.final
    rescue => exception
      return nil
    end
  end

  def decrypt_value(attribute, password)
    decryptor = OpenSSL::Cipher.new "AES-256-CBC"
    decryptor.decrypt
    decryptor.pkcs5_keyivgen password, ENV["CIPHER_SALT"]

    begin
      decryptor.update(self.send(attribute)) + decryptor.final
    rescue => exception
      puts exception
      return nil
    end
  end
end
