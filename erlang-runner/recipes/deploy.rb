#json->[:deploy][:akronym_erlang_code][:scm][:repository]
#json->[:deploy][:akronym_erlang_code][:deploy_to]

include_recipe 'deploy'

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
  Chef::Log.debug("prepping for restful")
	client = Chef::REST.new('http://169.254.169.254', 'metadata', nil)
	iam_user = client.get_rest("latest/meta-data/iam/security-credentials/")
	creds = client.get_rest("latest/meta-data/iam/security-credentials/#{iam_user}")

  Chef::Log.debug("we have our iam user: #{iam_user} and creds: #{creds}")
	key = creds[:AccessKeyId]
	key2 = creds["AccessKeyId"]
	secret = creds[:SecretAccessKey]
  Chef::Log.debug("key: #{key} key2: #{key2} secret: #{secret}")


  #execute "deployapp" do
    #command "aws s3 sync s3://akronym-internal/
  # Source accepts the protocol s3:// with the host as the bucket
  # access_key_id and secret_access_key are just that
  Chef::Log.debug("gonna do a deploy from #{deploy[:s3_source]}")
  Chef::Log.debug("headed to #{deploy[:deploy_to]}")

	ensure_scm_package_installed('s3')
	repo = prepare_s3_checkouts(:repository => deploy[:s3_source])
	#deploy[:scm] = {
		#:scm_type => 'git',
		#:repository => repo
	#}


  Chef::Log.debug("deploy time: #{repo} and #{deploy[:s3_source]}")
	deploy deploy[:deploy_to] do
		repository deploy[:s3_source]
	end

  Chef::Log.debug("scm time: #{repo} and #{deploy[:s3_source]}")
	scm "download code" do
		action :checkout
		destination deploy[:deploy_to]
		repository deploy[:s3_source]
	end

  #s3_file deploy[:deploy_to] do
    ##source "s3://your.bucket/the_file.tar.gz"
    #source deploy[:s3_source]
    #access_key_id your_key
    #secret_access_key your_secret
    #owner "root"
    #group "root"
    #mode 0644
  #end
end
