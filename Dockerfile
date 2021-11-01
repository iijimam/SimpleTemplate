#イメージのタグはこちら（https://hub.docker.com/_/intersystems-iris-data-platform）でご確認ください
ARG IMAGE=containers.intersystems.com/intersystems/iris-community:2021.1.0.215.3
ARG IMAGE=store/intersystems/iris-community:2021.1.0.215.3
FROM $IMAGE

USER root
# コンテナ内のワークディレクトリを /opt/try　に設定（後でここにデータベースを作成予定）
WORKDIR /opt/try
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/try

USER ${ISC_PACKAGE_MGRUSER}

# ファイルのコピー
COPY  Installer.cls .
COPY src src
COPY iris.script iris.script

# iris.scriptに記載された内容を実行
RUN iris start IRIS \
	&& iris session IRIS < iris.script \
    && iris stop IRIS quietly