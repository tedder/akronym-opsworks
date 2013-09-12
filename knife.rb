# good hints for creating this:
# http://docs.opscode.com/essentials_repository_many_users_same_repo.html

current_dir = File.dirname(__FILE__)
#user = ENV['OPSCODE_USER'] || ENV['USER']
log_level :info
log_location STDOUT
#node_name user

cookbook_path [ current_dir ]


#knife[:identity_file] = ssh pemfile, .ssh/key.pem ?? "#{ENV['AWS_ACCESS_KEY_ID']}"
#knife[:aws_ssh_key_id] = ENV['AWS_SSH_KEY_ID'] || user
knife[:aws_access_key_id] = "#{ENV['AWS_ACCESS_KEY_ID']}"
knife[:aws_secret_access_key] = "#{ENV['AWS_SECRET_ACCESS_KEY']}"

## more config options: https://github.com/opscode/knife-ec2#configuration
##knife[:availability_zone]
knife[:region] = "us-west-2"
knife[:flavor] = "m1.small"
knife[:image] = "ami-a4b83294"
