# myapp recipe

cookbook_file '/tmp/myapp.json' do
  source 'myapp.json'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/tmp/myapp.conf' do
  source 'myapp.conf.erb'
  owner 'root'
  group 'root'
  mode  '0644'
end
