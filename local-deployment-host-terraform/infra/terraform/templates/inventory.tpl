[haproxy]
local-haproxy ansible_host=${haproxy_ip} ansible_ssh_private_key_file=${haproxy_private_key_path}

[microservices]
local-microservices ansible_host=${microservices_ip} ansible_ssh_private_key_file=${microservices_private_key_path}

[all:vars]
ansible_user=${ansible_user}
ansible_python_interpreter=/usr/bin/python3
dockerhub_user=${dockerhub_user}
image_tag=${image_tag}