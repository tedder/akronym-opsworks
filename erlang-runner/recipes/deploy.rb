#json->[:deploy][:akronym_erlang_code][:scm][:repository]
#json->[:deploy][:akronym_erlang_code][:deploy_to]

include_recipe 'deploy'
require 'json'

node[:deploy].each do |application, deploy|
  if deploy[:akronym_app_type] != 'erlang-runner'
    Chef::Log.debug("only deploying 'erlang-runner' apps, which doesn't include this: #{application} because its type == #{deploy[:akronym_app_type]}")
    next
  end
  Chef::Log.debug("yep, deploying app == #{application} with config == #{deploy.to_json}")

  #opsworks_deploy_user
  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

	# get our IAM keys
  #Chef::Log.debug("prepping for restful")
	#client = Chef::REST.new('http://169.254.169.254', 'metadata', nil)
	#iam_user = client.get_rest("latest/meta-data/iam/security-credentials/")
	#creds = JSON.parse(client.get_rest("latest/meta-data/iam/security-credentials/#{iam_user}"), :create_additions => false)

  #Chef::Log.debug("we have our iam user: #{iam_user} and creds: #{creds} type: #{creds.type}")
	#key = creds["AccessKeyId"]
	#secret = creds["SecretAccessKey"]
  #Chef::Log.debug("key: #{key} secret: #{secret}")
	#creds.keys.each { |k| Chef::Log.debug("kk: #{k}: #{creds[k]}") }


  Chef::Log.debug("deploy time: #{deploy[:s3_source]}")
  Chef::Log.debug("headed to #{deploy[:deploy_to]}")
	python "deploycode" do
		code """
import boto
s3 = boto.connect_s3()
bucket = s3.get_bucket('akronym-internal')
key = bucket.get_key('akronym-prod.tgz')
deploy = key.get_contents_to_filename('#{deploy[:deploy_to]}/akronym-prod.tgz')
print \"deploy foo: %s\" % deploy
"""
	end

	execute "untar" do
		cwd deploy[:deploy_to]
		command "tar -zxvf #{deploy[:deploy_to]}/akronym-prod.tgz"
	end

end
