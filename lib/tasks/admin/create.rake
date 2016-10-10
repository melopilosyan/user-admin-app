require 'rake'
# Rake task for creating an account

namespace :admin do |args|
  desc 'Creates user account with given credentials: rake user:create'
  # environment is required to have access to Rails models
  task create: :environment do
    puts 'Creating admin user'
    u = User.new parse_params
    if u.save
      puts "Admin with name=#{u.full_name} email=#{u.email} successfully created!"
    else
      puts nil
      u.errors.each do |k, v|
        puts "ERROR: #{k} #{v}"
      end
    end
    exit 0
  end

  def parse_params
    attrs = {}
    %w(full_name email password).each do |attr|
      attrs[attr] = ENV[attr] || print_hint_and_exit(attr)
    end
    attrs['bio'] = 'Edit me in the App'
    attrs['role'] = User::Type::ADMIN
    attrs
  end

  def print_hint_and_exit(for_attr)
    puts "#{for_attr} is required. Call me like this:\nrake admin:create full_name='Your Name' email=your@email.com password=yourpassword"
    exit 0
  end
end

