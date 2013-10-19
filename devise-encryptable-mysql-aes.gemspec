Gem::Specification.new do |gem|
  gem.name          = %q{devise-encryptable-mysql-aes}
  gem.version       = %q{0.0.1}
  gem.date          = %q{2013-10-19}
  gem.description   = %q{AES encryption plugin for devise. Encrypt in such a way that the results work with MySQL's native AES_ENCRYPT and AES_DECRYPT functions}
  gem.summary       = %q{Devise AES encryption consistent with native MySQL AES}
  gem.authors       = ['Anthus Williams']
  gem.email         = %q{anthuswilliams@gmail.com}
  gem.files         = `git ls-files`.split($\)
  gem.require_paths = ['lib']

  gem.add_dependency('devise','>= 3.1.1')
  gem.add_dependency('devise-encryptable', '>= 0.1.2')
  gem.add_dependency('openssl')
end
