Class Test.Person Extends %Persistent
{
Property Name As %String;
Property Email As %String;

///　指定件数のレコードを作成します
ClassMethod CreateData(n As %Integer) As %Status [SqlProc]
{
    set status=$$$OK
    try {
        Set namelist= $LB( 
 "相原","青木","秋山","浅野","天野","新井","荒井","荒木","安藤",
 "飯島","飯田","飯塚","五十嵐","池田","石井","石川","石塚","石原","石渡","市川","伊藤","伊東","井上","今井","岩崎","岩田","岩本",
 "上田","上野","上原","内田","内山",
 "榎本","遠藤",
 "大川","大久保","大島","太田","大谷","大塚","大野","大橋","大森","岡田","岡本","小川","小沢","小澤","落合","小野","小野寺",
 "加藤","金井","金子","川上","川口","川崎","川島","川村","菅野",
 "菊地","岸","北村","木下","木村",
 "工藤","久保","久保田","熊谷","栗原",
 "小池","小泉","河野","小島","小林","小松","小山","近藤","後藤",
 "斉藤","斎藤","齋藤","酒井","坂本","佐久間","桜井","佐々木","佐藤","佐野",
 "柴田","渋谷","島田","清水","志村","白井",
 "菅原","杉本","杉山","鈴木","須藤",
 "関","関口","瀬戸",
 "高木","高野","高橋","田口","竹内","田代","田中","田辺","谷口","田村",
 "千葉","土屋","角田",
 "内藤","中川","中島","中野","中村","中山","永井","成田",	
 "西村","西山",
 "根本",
 "野口","野村",
 "萩原","橋本","長谷川","服部","浜田","早川","林","原","原田","馬場",
 "樋口","平井","平田","平野","広瀬",
 "福島","福田","藤井","藤田","藤本","古川",
 "星野","本田","本間",
 "前田","増田","松井","松尾","松岡","松下","松田","松本","丸山",
 "三浦","水野","宮崎","宮田","宮本",
 "武藤","村上","村田",
 "望月","森","森田",
 "八木","安田","矢野","山内","山口","山崎","山下","山田","山中","山本",
 "横田","横山","吉川","吉田",
 "渡辺","渡部","和田") 
		for i=1:1:n {
			// Name
			set name=$list(namelist,$random($listlength(namelist))+1)
			// Email
			if $Random(2)=1 { set email="T"_$random(1000)_"@mail.com" }
			else {set email="ABC"_$random(1000)_"@abc.com"}

			&sql(insert into Test.Person (Name,Email) values(:name,:email))
			if SQLCODE<0 {
				throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
			}
		}
        set %sqlcontext.%SQLCODE=$GET(SQLCODE)
    }
    catch ex {
        set status=ex.AsStatus()
        set %sqlcontext.%SQLCODE=ex.AsSQLCODE()
        set %sqlcontext.%Message=ex.AsSQLMessage()
    }
    return status
}
}