DataMapper.setup(:default, ENV['DATABASE_URL'])
class UserRecord
  include(DataMapper::Resource)
  include(BCrypt)

  property(:id, Serial, key: true)
  property(:username, String, length: 3..50)
  property(:first_name, String)
  property(:last_name, String)
  property(:password, BCryptHash)

  def name
    "#{first_name} #{last_name}"
  end
end
DataMapper.finalize
DataMapper.auto_upgrade!