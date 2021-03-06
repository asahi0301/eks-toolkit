FROM amazonlinux:2.0.20200207.1

LABEL maintainer=asahi0301

RUN yum update -y && yum -y install python36-devel python3-libs python3-setuptools python3-pips git tar gzip wget unzip jq openssh-clients shadow-utils && \
    python3 -m ensurepip --upgrade && python3 -m pip install --upgrade pip && \
    # Install kubectl
    curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    # Install aws-iam-authenticator for EKS
    curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x ./aws-iam-authenticator && \
    mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator && \
    # Install aws cli v1
    pip install awscli && \
    # Install eksctl for EKS
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp && \
    mv /tmp/eksctl /usr/local/bin && \
    # Install cfssl, cfssljson for  Hard Way
    wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 && chmod +x cfssl_linux-amd64 && mv cfssl_linux-amd64 /usr/local/bin/cfssl && \
    wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 && chmod +x cfssljson_linux-amd64 && mv cfssljson_linux-amd64 /usr/local/bin/cfssljson && \
    # Install kops
    curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64 && \
    chmod +x ./kops && mv ./kops /usr/local/bin/ && \
    # Install ardocd cli v1.5.5
    wget https://github.com/argoproj/argo-cd/releases/download/v1.5.5/argocd-linux-amd64 && mv argocd-linux-amd64 /usr/local/bin/argocd && chmod +x /usr/local/bin/argocd  && \
    # Install helm v3
    cd /tmp && wget https://get.helm.sh/helm-v3.2.1-linux-amd64.tar.gz && tar -zxvf helm-v3.2.1-linux-amd64.tar.gz && mv linux-amd64/helm /usr/local/bin/helm && \
    # Install awscli v2
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install && \
    # Install istioctl
    curl -L https://istio.io/downloadIstio | sh - && mv istio-*/bin/istioctl /usr/local/bin/ && \
    # Install ecs-cli v1
    curl -o /usr/local/bin/ecs-cli https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest && chmod +x /usr/local/bin/ecs-cli && \
    # Remove cache
    rm -rf /tmp/* && \
    rm -rf /var/cache/yum/*  && \
    yum clean all

WORKDIR /src

CMD ["/bin/bash"]