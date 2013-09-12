#
# Cookbook Name:: erlang-runner
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package 'mosh'
#package 'python'
package 'libssl0.9.8'
package 'erlang'

%w(boto awscli).each do |pkg|
  python_pip "#{pkg}"
end

#python/pip tips
#https://forums.aws.amazon.com/thread.jspa?messageID=468626
include_recipe 'python'

