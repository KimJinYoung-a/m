<%
'#######################################################
'	History	:  2012.01.16 허진원 생성
'	Description : Favorite Color 관리
'#######################################################
%>
<%
Class CfavoriteColorItem

	public Fidx
	Public Fcategory
	public FcolorCD
	public Fcoloricon
	public Fitemid
	public Fisusing
	public FsortNo
	public FitemName
	public FlistImage
	public FSellyn
	public FLimityn
	public FLimitno
	public FLimitsold
	Public FImageIcon1
	Public FImageIcon2

	public function IsSoldOut()
		IsSoldOut = (FSellyn="N") or (FSellyn="S") or ((FLimityn="Y") and (FLimitno-FLimitsold<1))
	end function

	Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub

end Class

Class CfavoriteColor
	public FItemList()

	public FTotalCount
	public FResultCount

	public FCurrPage
	public FTotalPage
	public FPageSize
	public FScrollCount

	Public FRectCategory
	Public FRectColorCD

	public FBasicImage
	public Ficon1Image
	public Fitemno

	'// 상품 이미지 폴더 반환(컬러코드 유무에 따라 일반/컬러칩 구분)
	Function getItemImageUrl()
		IF application("Svr_Info")	= "Dev" THEN
			if FRectColorCD="" or FRectColorCD="0" then
				getItemImageUrl = "http://webimage.10x10.co.kr/image"
			else
				getItemImageUrl = "http://webimage.10x10.co.kr/color"
			end if
		Else
			if FRectColorCD="" or FRectColorCD="0" then
				getItemImageUrl = "http://webimage.10x10.co.kr/image"
			else
				getItemImageUrl = "http://webimage.10x10.co.kr/color"
			end if
		End If
	end function

	Private Sub Class_Initialize()
		'redim preserve FItemList(0)
		redim  FItemList(0)

		FCurrPage =1
		FPageSize = 12
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub

	Private Sub Class_Terminate()

	End Sub

	public Function GetfavoriteColor()
		dim sqlStr,addSql, i

		'추가 쿼리
		if FRectColorCD<>"" then
			addSql = addSql & " and ci.colorcode = '" & FRectColorCD & "'" & vbcrlf
		end if
	
		'총수 접수
		sqlStr = "select count(ci.idx), CEILING(CAST(Count(*) AS FLOAT)/" & FPageSize & ") " + vbcrlf
		sqlStr = sqlStr + " from db_item.dbo.tbl_colortrend_item ci " + vbcrlf
		sqlStr = sqlStr + "	inner join db_item.dbo.tbl_item_colorOption co " + vbcrlf
		sqlStr = sqlStr + "		on ci.itemid = co.itemid " + vbcrlf
		sqlStr = sqlStr + "		and ci.colorcode = co.colorcode " + vbcrlf
		sqlStr = sqlStr + " inner join db_item.dbo.tbl_item i " + vbcrlf
		sqlStr = sqlStr + "		on ci.itemid = i.itemid " + vbcrlf
		sqlStr = sqlStr + "	where ci.isusing = 'Y' " + vbcrlf
		sqlStr = sqlStr + "	and i.sellyn = 'Y' " + vbcrlf
		sqlStr = sqlStr + "	and i.isusing = 'Y' "  + addSql + vbcrlf

		rsget.Open sqlStr,dbget,1
			FTotalCount = rsget(0)
			FtotalPage = rsget(1)
		rsget.Close

		'내용 접수
		sqlStr = "select top " + CStr(FPageSize*FCurrPage) + "" + vbcrlf
		sqlStr = sqlStr + " ci.colorCode ,ci.itemid ,ci.orderno ,ci.isusing " + vbcrlf
		sqlStr = sqlStr + ",i.itemname, i.titleimage ,i.mainimage ,i.mainimage2 ,co.smallimage ,co.listimage,co.basicimage " + vbcrlf
		sqlStr = sqlStr + ",co.basicimage600 ,co.icon1image ,co.icon2image " + vbcrlf
		sqlStr = sqlStr + " from db_item.dbo.tbl_colortrend_item ci " + vbcrlf
		sqlStr = sqlStr + "		inner join db_item.dbo.tbl_item_colorOption co " + vbcrlf
		sqlStr = sqlStr + "		on ci.itemid = co.itemid " + vbcrlf
		sqlStr = sqlStr + "		and ci.colorcode = co.colorcode " + vbcrlf
		sqlStr = sqlStr + "		inner join db_item.dbo.tbl_item i " + vbcrlf
		sqlStr = sqlStr + "		on ci.itemid = i.itemid " + vbcrlf
		sqlStr = sqlStr + "where ci.isusing = 'Y' " + vbcrlf
		sqlStr = sqlStr + "and i.sellyn = 'Y' " + vbcrlf
		sqlStr = sqlStr + "and i.isusing = 'Y' "  + addSql + vbcrlf
		sqlStr = sqlStr + " order by ci.orderno asc ,i.itemscore desc,i.itemid desc " 

		'response.write sqlStr
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1

		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CfavoriteColorItem

				FItemList(i).Fidx = rsget("colorcode")
	            FItemList(i).Fitemid = rsget("itemid")
	            FItemList(i).Fitemname = rsget("itemname")
	            FItemList(i).fisusing = rsget("isusing")
				FItemList(i).FlistImage 	= getItemImageUrl & "/list/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" & rsget("listimage")
				FItemList(i).FImageIcon1 	= getItemImageUrl & "/icon1/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" & rsget("icon1image")
				FItemList(i).FImageIcon2 	= getItemImageUrl & "/icon2/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" & rsget("icon2image")

				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close
	end Function
	
	public Function GetfavoriteColorTop1() 'topimage1
		dim sqlStr,addSql, i

		'추가 쿼리
		if FReCtcategory<>"" then
			addSql = addSql & " and c.category = '" & FRectCategory & "'" & vbcrlf
		end if
		if FRectColorCD<>"" then
			addSql = addSql & " and d.colorcode = '" & FRectColorCD & "'" & vbcrlf
		end if
	
		'top1 - image
		sqlStr = "select top 1 " + vbcrlf
		sqlStr = sqlStr + " i.icon1image ,c.itemid " + vbcrlf
		sqlStr = sqlStr + " from db_sitemaster.dbo.tbl_favoriteColor c," + vbcrlf
		sqlStr = sqlStr + " db_sitemaster.dbo.tbl_favoriteColorCode d," + vbcrlf
		sqlStr = sqlStr + " [db_item].[dbo].tbl_item i" + vbcrlf
		sqlStr = sqlStr + " where c.itemid = i.itemid and c.colorCD = d.colorcode " + addSql + vbcrlf
		sqlStr = sqlStr + " order by c.sortNo, c.itemid ,i.itemscore desc"

		'response.write sqlStr
		rsget.Open sqlStr,dbget,1
			if  not rsget.EOF  then
				Ficon1Image	= "http://webimage.10x10.co.kr/image/icon1/" &  GetImageSubFolderByItemid(rsget(1)) & "/" & rsget(0)
				Fitemno = rsget(1)
			End if
	    rsget.Close

	end function

	public Function HasPreScroll()
		HasPreScroll = StarScrollPage > 1
	end Function

	public Function HasNextScroll()
		HasNextScroll = FTotalPage > StarScrollPage + FScrollCount -1
	end Function

	public Function StarScrollPage()
		StarScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	end Function
end Class

Class CItemColor '컬러코드 관리 2011-04-13 이종화
	public FItemList()
    
	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount

	public FRectColorCD
	public FRectItemId
	public FRectMakerId
	public FRectCDL
	public FRectCDM
	public FRectCDS
	public FRectUsing

	public FcolorIcon
	

	Private Sub Class_Initialize()
		'redim preserve FItemList(0)
		redim  FItemList(0)

		FCurrPage =1
		FPageSize = 12
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub

	Private Sub Class_Terminate()

	End Sub

	public function GetColorList()
        dim sqlStr, addSql, i

        '// 추가 쿼리
        if (FRectColorCD <> "") then addSql = addSql & " and ColorCode =" + FRectColorCD
        if (FRectUsing <> "") then addSql = addSql & " and isUsing ='" + FRectUsing + "'"
        
		'// 결과수 카운트
		sqlStr = "select Count(colorCode), CEILING(CAST(Count(colorCode) AS FLOAT)/" & FPageSize & ") "
        sqlStr = sqlStr & " from [db_item].[dbo].tbl_colorChips "
        sqlStr = sqlStr & " where 1=1 " & addSql

        rsget.Open sqlStr,dbget,1
			FTotalCount = rsget(0)
			FtotalPage = rsget(1)
        rsget.Close

        '// 본문 내용 접수
        sqlStr = "select top " + Cstr(FPageSize * FCurrPage)
        sqlStr = sqlStr & " c.colorCode, c.colorName, c.colorIcon, c.sortNo, c.isUsing "
        sqlStr = sqlStr & " from [db_item].[dbo].tbl_colorChips c "
        sqlStr = sqlStr & " where 1 = 1 " & addSql
		sqlStr = sqlStr & " Order by c.sortNo asc "

		'response.write  sqlStr

        rsget.pagesize = FPageSize
        rsget.Open sqlStr,dbget,1

		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
        if (FResultCount<1) then FResultCount=0
        
        redim preserve FItemList(FResultCount)

        i=0
        if Not(rsget.EOF or rsget.BOF) then
            rsget.absolutepage = FCurrPage
            do until rsget.EOF
                set FItemList(i) = new CItemColorItem

                FItemList(i).FcolorCode	= rsget("colorCode")
                FItemList(i).FcolorName	= rsget("colorName")
                FItemList(i).FcolorIcon	= "http://fiximage.10x10.co.kr/web2011/common/color/" & rsget("colorIcon")
                FItemList(i).FsortNo	= rsget("sortNo")
                FItemList(i).FisUsing	= rsget("isUsing")
                
                rsget.movenext
                i=i+1
            loop
        end if
        rsget.Close
    end Function
	
end Class

Class CItemColorItem '컬러코드 관리 2011-04-13 이종화
    public FcolorCode
    public FcolorName
    public FcolorIcon
    public FsortNo
    public FisUsing
    public FitemId
    public FitemName
    public FmakerId
    public Fregdate
    public FsmallImage
    public FlistImage
    public Fsellyn
    public Flimityn
    public Fmwdiv

    Private Sub Class_Initialize()
	End Sub

	Private Sub Class_Terminate()
	End Sub
end Class

'//컬러 문구 선언
Dim arrColorDesc(31)
arrColorDesc(1) = "The color of wine is one of the most easily recognizable characteristics of wines."
arrColorDesc(2) = "Something that is red is the color of blood or fire."
arrColorDesc(3) = "Something that is orange is of a color between passion and brightness."
arrColorDesc(4) = "Something that is brown is the color of earth or wood."
arrColorDesc(5) = "Camel is the color of a specific type of overcoat kown as a polo coat or camel-hair coat."
arrColorDesc(6) = "Something that is yellow is the color of lemons, butter or the middle part of an eggs."
arrColorDesc(7) = "Something that is beige is pale brown in color."
arrColorDesc(8) = "Ivory is an off-white color that resembles ivory. It has a very slight tint of yellow."
arrColorDesc(9) = "The name of the color khaki coined in British India, meaning ""dusty, dust covered or earth colored."""
arrColorDesc(10) = "Green is a pleasant break to imagine."
arrColorDesc(11) = "Something that is mint is the color of pale pastel tint of spring green."
arrColorDesc(12) = "Sky blue is used to describe things that are bright blue."
arrColorDesc(13) = "Something that is blue is the color of sky or sea."
arrColorDesc(14) = "Navy blue is a very dark shade of the color blue which almost appears as black."
arrColorDesc(15) = "Violet is magical. Something that is violet is a bluish color."
arrColorDesc(16) = "Lilac is a color that is pale tone of violet the is a representation of the average color of mast lilac flower."
arrColorDesc(17) = "A light shade of pink. Baby pink is used to symbolize baby girl."
arrColorDesc(18) = "Something that is pink is the color of Rose, Love or Heart."
arrColorDesc(19) = "White something that is white is color of snow or milk."
arrColorDesc(20) = "Grey is the color of ashes or of clouds on a rainy day."
arrColorDesc(21) = "Charcoal is a color of that is a representation of the dark gray color of burned wood."
arrColorDesc(22) = "Black is pure and simple. The color of objects that do not emit or reflect light in any part of the visible spectrum."
arrColorDesc(23) = "Silver is a valuable pale grey color that is used for making jewellery and ornaments."
arrColorDesc(24) = "Gold is a valuable, yellow color that is used for making jewellery and as an international currency."
arrColorDesc(25) = "A pattern of squares, usually of two colors, can be referred to as checks or a check."
arrColorDesc(26) = "A stripe color is a long line which is a different color from the areas next to it."
arrColorDesc(27) = "Dot is very small spots printed on a piece of material."
arrColorDesc(28) = "A flower is the part of a plant which is often brightly colored."
arrColorDesc(29) = "A drawing is a picture made with a pencil or pen."
arrColorDesc(30) = "An animal pattern is representing wild and sexy. It makes you more powerful."
arrColorDesc(31) = "Geometric pattern is made by a motif, circles, ellipses, triangles, rectangles and polygons."
%>
