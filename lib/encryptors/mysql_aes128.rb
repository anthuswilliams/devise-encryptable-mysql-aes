require 'openssl'

module Devise
  module Encryptable
    module Encryptors
      # Use the AES (formerly Rijndael) algorithm to encrypt passwords, and then pad the results with \0 bytes in such away that the hashes are consistent with the results of mysql's AES_ENCRYPT() and AES_DECRYPT() functions
      class MysqlAes128 < Base 
      class << self
        # MySQL's AES_ENCRYPT runs in ECB mode and doesn't use any initialization vector at all
        # we use pepper as the common key for all our encryptions, only using the salt stored in the DB as a backup if pepper is undefined
        def digest(string, stretches, salt, pepper)
          self.aes(:encrypt, pepper ? self.mysql_key(pepper) : salt, string)
        end
        alias :encrypt :digest

        # format the token returned from Devise's base generator into 16-byte blocks for consumption by MySQL
        # this method is called by devise-encryptable when setting a new password
        def salt(stretches)
          self.mysql_key(super)
        end

        protected

        def aes(method, key, string)
          cipher = OpenSSL::Cipher::Cipher.new('aes-128-ecb').send(method)
          cipher.key = key
          cipher.update(string) + cipher.final
        end
                
        # given a token, produce a 16-byte key
        # note that this is idempotent in the sense that a key that is 16 bytes will return unchanged 
        def mysql_key(key)
          # start with an empty 16 byte buffer
          ret = "\0" * 16
          # on each byte of our key, perform a bitwise OR with each element of the original key which as the same index mod 16
          # except we use the ordinals of each character since we would need, for example, "hello"[0] to return 104 instead of "h" 
          key.length.times do |i|
            ret[i%16] = ( ret[i%16].ord ^ key[i].ord ).chr
          end

          ret
        end
      end
      end
    end
  end
end
