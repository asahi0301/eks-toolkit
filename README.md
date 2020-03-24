# eks-toolkit
AWS上で Kubernetes 環境を構築する方法は様々あり、いろいろ検証して最適なものを選びたいところですが、
kubectl,eksctl といったツールを揃えること自体結構大変だったりします。
これは、それらのツール群が予めインストールされたDockerイメージを作成するためのDockerfileです。

# 目次
* [前提条件](#前提条件)
* [初期セットアップ](#初期セットアップ)
* [検証開始](#検証開始)
* [注意点](#注意点)

# 環境
## Dockerイメージ
このレポジトリをcloneして、docker buildしてもいいですし、すでにdockerhubにイメージをあげているのでそちらを使っていただいても大丈夫です。
https://hub.docker.com/r/asahi0301/eks-toolkit

## インストールされている主要ソフトウェア
- kubectl 1.15.10
- aws-iam-authenticator 1.15.10
- aws cli v1 (githubへのcommit時点で pip でインストールできる最新のもの)
- eksctl (githubへのcommit時点で取得できる最新のもの)
- cfssl, cfssljson 1.2
- kops (githubへのcommit時点で取得できる最新のもの)


# 前提条件
## Dockerのローカルインストール
Linux, Windows, Mac それぞれインストール方法が違いますが、dockerをローカル環境にインストールされている必要があります。
インストール方法は割愛します。

## AWSアカウントの用意
事前にAWSアカウントの取得が必要です。
必須ではないですが、本番ワークロードが動いているAWSアカウントではなく、個人アカウントなど他ワークロードに影響を与えないアカウントを使うことを推奨します

## アカウントの管理者権限を持ったアクセスキーの用意
AWSのAPIへアクセスするためにアクセスキーID とシークレットキーが必要です。
IAMについて学ぶことが目的ではないため、管理者権限を持ったIAMユーザもしくはルートユーザのアクセスキーを発行します。

# 初期セットアップ
## dockerイメージの取得
### dockerhubを利用する場合
```sh
docker pull asahi0301/eks-toolkit
```
### ローカルでビルドする場合
```sh
git clone git@github.com:asahi0301/eks-toolkit.git
cd eks-toolkit
docker built -t eks-toolkit .
```
## dockerコンテナの起動
```sh
docker run -itd eks-toolkit
```

## dockerコンテナの中に入る
```sh
docker exec -it $(docker ps | grep eks-toolkit | awk '{print $1}') bash
bash-4.2#
```
**これ以降はdockerコンテナ内での作業です**
## クレデンシャルの設定
```sh
aws configure
```
と入力して、アクセスキーIDとシークレットキーを入力します。
リージョンは、EKSの検証する場合はEKSが提供されているリージョンを指定する必要がありますが、そうじゃない場合はどこでもいいと思います。
ちなみに、東京リージョンは、ap-northeast-1 です
outputの形式もなんでもいいですが、json にしておきます

# 検証開始
以下よりお好きな検証を初めてくださいませ
**すべての作業はdockerコンテナ内で行います**
- [EKS Workshop](https://eksworkshop.com/)
    - AWS公式のEKS Workshopです。EKS中心ではありますが、Kubernetes自体についても学ぶことができます
- [kubernetes-the-hard-way-aws](https://github.com/danonb10/kubernetes-the-hard-way-aws)
    - Kubernetesをスクラッチで構築するのでいい勉強になります
- TBD
- TBD
- TBD


# 注意点
## クレデンシャルが保存されています
作業されたdockerコンテナ内にはクレデンシャルが保存されているので、dockerコンテナをそのままイメージ化して、dockerhubで公開したりするととんでもないことになるのでご注意ください。

## Dockerコンテナ内で作成したファイルはコンテナを削除すると消えます
作業ログや生成したファイルをローカルにも残しておきたい場合は、
```sh
docker run -itd -v ~/path:/src eks-toolkit 
```
このような感じで ローカルのディレクトリとコンテナのディレクトリをmountしてください