#json->[:deploy][:akronym_erlang_code][:scm][:repository]
#json->[:deploy][:akronym_erlang_code][:deploy_to]

#include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  apptype = deploy[:application_type]
  if deploy[:application_type] != 'other'
    Chef::Log.debug("only deploying 'other' apps, which doesn't include this: #{application} because its type == #{apptype}")
    next
  end

  #opsworks_deploy_user
  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  #execute "deployapp" do
    #command "aws s3 sync s3://akronym-internal/
  # Source accepts the protocol s3:// with the host as the bucket
  # access_key_id and secret_access_key are just that
  Chef::Log.debug("gonna do a deploy from #{deploy[:deploy_to]} to #{deploy[:scm][:repository]}")
  s3_file deploy[:deploy_to] do
    #source "s3://your.bucket/the_file.tar.gz"
    source deploy[:scm][:repository]
    #access_key_id your_key
    #secret_access_key your_secret
    owner "root"
    group "root"
    mode 0644
  end
end
