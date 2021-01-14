# コンテナ版IRISのシンプルな開発環境テンプレート
このテンプレートでは、コンテナ開始時に任意名のネームスペース、データベースを作成したあと、/src 以下に配置してるソースコードを作成したネームスペースにインポートしています。

設定については、適宜変更してご活用いただけます。


## Gitに含まれるファイルについて

|種類|ファイル|説明|
|:--|:--|:--|
|接続設定|[settings.json](/.vscode/settings.json)|VSCodeからIRISへ接続するときの設定用ファイル|
|ソースコードサンプル|[Person.cls](/src/Test/Person.cls)|コンテナビルド時にIRISにインポートするサンプルクラス定義|
|インストーラー|[Installer.cls](./Installer.cls)|コンテナビルド時に初期設定用定義が記載されているインストーラークラス|
|スクリプト|[iris.script](./iris.script)|コンテナビルド時に実行したいコマンドを記載したファイル（IRISログインに使用する irisコマンドに入力したいObjectScriptのコマンドを記述しています）|



## コンテナ起動までの手順
詳細は、[docker-compose.yml](./docker-compose.yml) をご参照ください。

Git展開後、**./ は コンテナ内 /ISC ディレクトリをマウントしています。**
また、IRISの管理ポータルの起動に使用するWebサーバポートは 52773 が割り当てられています。
既に使用中ポートの場合は、[docker-compose.yml](./docker-compose.yml) の15行目を修正してご利用ください。

≪62773に割り当てる例≫　- "62773:52773"

```
git clone このGitのURL
```
cloneしたディレクトリに移動後、以下実行します。

```
$ docker-compose build
```
ビルド後、コンテナを開始します。
```
$ docker-compose up -d
```
コンテナを停止する方法は以下の通りです。
```
$ docker-compose stop
```
コンテナを破棄する方法は以下の通りです（コンテナを消去します）。
```
$ docker-compose down
```



## [Dokerfile](./Dockerfile)で実行している内容
コンテナビルド時の処理が記載されています。

コンテナビルド時に /opt/try　を作成しビルド時の作業で使用したいファイルをこのディレクトリ以下にコピーしています。

また、TRYネームスペースが参照する、TRYデータベースの物理パスのルートとして利用しています。

ディレクトリは変更可能です。変更された場合は、[Installer.cls](./Installer.cls)の17行目と、[iris.script](./iris.script)の3行目、12行目のディレクトリ指定も変更してください。

[Dokerfile](./Dockerfile)の18行目は、IRISへログインしています（iris session IRIS）。
ログインと同時に、[iris.script](./iris.script) に記載されたコマンドを入力しています。


## [iris.script](./iris.script)で実行している内容
ObjectScriptのコマンドが記載されているファイルです。

[Dokerfile](./Dockerfile)の中で /opt/try　以下にコピーされたファイルを利用して初期設定を行っています。

### (1)　do $SYSTEM.OBJ.Load("/opt/try/Installer.cls", "ck")

[Installer.cls](./Installer.cls)をIRISログイン時のデフォルトネームスペース＝USERにインポートしています。

### (2)　set sc = ##class(App.Installer).setup()

(1)でインポートしたインストーラーを実行しています。この実行でTRYネームスペース／TRYデータベースが作成されます。


### (3)　ソースコードのインポート

set $namespace="TRY"　で作成したTRYネームスペースに移動し、

do $System.OBJ.LoadDir("/opt/try/src","ck",,1)　で ./src以下にあるファイルをインポートしています。
（他のバージョン、InterSystems製品からエクスポートしてきたXMLファイルを配置してもインポートされます）。


### (4)　システム設定の変更
事前定義ユーザ（_systemやSuperUserなど）の初期パスワードの期限を無効に設定しています。
通常、コンテナ版IRISの初回アクセス時に、パスワードを任意設定できるようにパスワード変更画面が開きます。

このテンプレートでは、デフォルトパスワードのSYSで起動できるように設定しています。

IRIS初回アクセス時に初期パスワードを変更したい場合は、以下の実行をコメント化（スラッシュ2つ //）してください。
 
    //Do ##class(Security.Users).UnExpireUserPasswords("*")

日本語ロケールへの変更を行っています。コンテナ版IRISは英語Ubuntuで起動するため、デフォルトでは英語ロケールで立ち上がります。

日本語が含まれるファイル入出力などを試す場合は、日本語のロケールに変更いただく必要があります。

    Do ##class(Config.NLS.Locales).Install("jpuw")



## [Installer.cls](./Installer.cls)で実行している内容
[Dokerfile](./Dockerfile)の6行目で作成したディレクトリ以下にTRYデータベースを作成し、TRYネームスペースから参照するように定義しています。

また、TRYネームスペースのデフォルトウェブアプリケーションパス（/csp/try）も設定しています。

ネームスペース名、データベース名を任意に変更する場合は、8行目と10行目を変更してください。
（ウェブアプリケーションパスは小文字で作成する必要があります。10行目に設定する文字列は小文字で設定してください。）

慣習として、ネームスペース名、データベース名、ネームスペースのデフォルトウェブアプリケーションパスは、名称を統一（例：TRY）する事が多いため、例では統一しています。

