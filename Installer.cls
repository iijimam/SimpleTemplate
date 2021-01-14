Class App.Installer
{

XData setup
{
<Manifest>
  <!--インストーラーの中で使用する変数NamespaceにTRYを設定 -->
  <Default Name="Namespace" Value="TRY"/>
  <!--変数appにWebアプリケーションパス名を代入：例ではtry -->
  <Default Name="app" Value="try" />
  
  <!--ネームスペース作成用の定義 -->
  <Namespace Name="${Namespace}" Code="${Namespace}" Data="${Namespace}" Create="yes" Ensemble="1">
    <!-- データベース作成用定義-->
    <Configuration>
      <!--データベースディレクトリをDockerfile内で予め作成した /opt/try 以下に設定するように指定 -->
      <Database Name="${Namespace}" Dir="/opt/${app}/data" Create="yes" Resource="%DB_${Namespace}"/>
    </Configuration>
    <!--ウェブアプリケーションパス /csp/try　の作成 -->
    <CSPApplication Url="/csp/${app}" Directory="${cspdir}${app}"  ServeFiles="1" Recurse="1" MatchRoles=":%DB_${Namespace}" AuthenticationMethods="32"
       
    />
  </Namespace>

</Manifest>
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  #; Let XGL document generate code for this method. 
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}

}
