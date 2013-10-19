# devise-encryptable-mysql-aes

This gem adds AES support to Plataforma's [Devise](https://github.com/plataformatec/devise) in such a way that the encrypted strings returned will match the results of MySQL's [AES_ENCRYPT()](http://dev.mysql.com/doc/refman/5.5/en/encryption-functions.html#function_aes-encrypt).

## Setup

This gem is tested on Rails 3.2 and Devise 3.1.1. To set up, add to your Gemfile:

```ruby
gem 'devise-encryptable-mysql-aes'
````

Then migrate the encrypted_password field of the table with which you are using devise to :binary rather than :string. 

```ruby
class ChangeUserEncryptedPasswordType < ActiveRecord::Migration
  def up
    change_column :users, :encrypted_password, :binary 
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
```

Next, add a password_salt field to the same table, e.g.

````console
rails generate migration add_password_salt_to_user
rake db:migrate
````

Add :encryptable to the model which is using devise
````ruby
devise :encryptable
````

Finally, change config/initializers/devise.rb

```ruby
config.encryptor = :mysql_aes128
```

You're set to go.

## Usage

This gem works in one of two ways. MySQL's AES implementation runs in ECB mode and does not use any initialization vector at all, so the security of your passwords lives and dies with the security of your key.


If config.pepper is set in config/initializers/devise.rb, then this is the value that will be used as the encryption key. 

If the pepper is not set, then Devise will generate a random key which will be stored in the password_salt field alongside the encrypted string. Obviously, it is not preferable to be storing keys in the same database record as the encrypted string, so it is HIGHLY recommended you use a pepper string.
