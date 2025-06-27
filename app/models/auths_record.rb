class AuthsRecord < ActiveRecord::Base
  self.abstract_class = true
  connects_to database: { writing: :auths_primary, reading: :auths_replica }
end
