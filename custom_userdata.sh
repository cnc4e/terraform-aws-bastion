Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

# cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash
# gitインストール
yum update -y
yum install git-all -y
yum install -y yum-utils shadow-utils

# terraformインストール
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum -y install terraform

# kubectlインストール
curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# dockerインストール
yum install -y docker
systemctl start docker

# goインストール
wget https://dl.google.com/go/go1.24.3.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.24.3.linux-amd64.tar.gz
rm go1.24.3.linux-amd64.tar.gz
tee /etc/profile.d/golang_path.sh > /dev/null <<'EOF'
#!/bin/bash 
export PATH=$PATH:/usr/local/go/bin
EOF
chmod +x /etc/profile.d/golang_path.sh

# helmインストール
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh

# trivyインストール
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# tree、nc、ansibleインストール
yum install tree -y
yum install nmap-ncat -y
yum install ansible -y

# SSMエージェントインストール
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl start amazon-ssm-agent

# ユーザーデータ実行テスト用ファイル作成
echo "!?!?custom_userdata executed: $(date)" > /tmp/userdata_test.txt
--//--