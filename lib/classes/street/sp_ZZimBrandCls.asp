<%
'#######################################################
' Description : 찜브랜드
' History : 2014.09.21 한용민 생성
'#######################################################

Class CMyZZimBrandItem
    public Fmakerid		
    public Fsocname		
    public Fsocname_kor
    public Fsoclogo		
    public Fdgncomment	
    public Fmodelitem	 
    public Fmodelitem2	
    public Fmodelimg		
    public Fmodelbimg	 
    public Fmodelbimg2	
	public ficon2image
	public fbasicimage
    public Fcatecode   
    public FCateName
    public fiteminfo
    public fsaleflg
    public ficon1image
    public fitemid
	public Ftodayrecommendcount
	Public Frecommendcount
	public fitemcount
    public Fhitflg
	public Fnewflg
	public fsmileflg
	public fgiftflg
	public Fonlyflg
	public Fartistflg
	public Fkdesignflg
	public fitemarr

    Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
End Class

Class CZZimBrandCategoryCount
    public FCDL
	public FCount
	
    Private Sub Class_Initialize()
	End Sub

	Private Sub Class_Terminate()
	End Sub
end Class

Class CMyZZimBrand
    public FOneItem
	public FItemList()

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FScrollCount
	public FResultCount

	public FRectMakerid
	public FRectUserID
	public FRectCDL
	public FRectOrder
	public FRectDisp
	
    '// My 찜브랜드 카테고리 갯수
    public sub GetMyZimBrandCategoryCount()
        Dim SqlStr, i
        sqlStr = " select c.catecode,  count(m.makerid) as cnt"
        sqlStr = sqlStr + " from [db_my10x10].[dbo].tbl_mybrand m,"
        sqlStr = sqlStr + " [db_user].[dbo].tbl_user_c c"
        sqlStr = sqlStr + " where m.userid='" + FRectUserID + "'"
        sqlStr = sqlStr + " and m.makerid=c.userid"
        sqlStr = sqlStr + " and c.isusing='Y'"
        sqlStr = sqlStr + " group by c.catecode"
        
        rsget.Open sqlStr,dbget,1
		
		FResultCount = rsget.RecordCount
		
		if (FResultCount<1) then FResultCount=0
		
		redim preserve FItemList(FResultCount)
		
		if Not rsget.Eof then
		    do until rsget.eof
				set FItemList(i)    = new CZZimBrandCategoryCount
    		    FItemList(i).FCDL     = rsget("catecode")
    		    FItemList(i).FCount   = rsget("Cnt")
    		    
    		    FTotalCount           = FTotalCount + FItemList(i).FCount
    		    i=i+1
    		    rsget.MoveNext
    		loop
		end if
		rsget.close
		
    End Sub
    
    public function GetCateZimBrandCount(byval iCdL)
        dim i
        
        GetCateZimBrandCount = 0
        
        for i=0 to FResultCount-1
            if (FItemList(i).FCDL=iCdL) then
                GetCateZimBrandCount = FItemList(i).FCount
                Exit function
            end if
        next
    end function

    '// My 찜브랜드
	public sub GetMyZZimBrand()
		Dim SqlStr, i

		if FRectUserid = "" then
			FResultCount = 0
			FTotalCount = 0
			exit sub
		end if

		sqlStr = "EXEC db_my10x10.dbo.sp_Ten_MyZzimBrand_2013_cnt '" & FRectUserid & "'," & FPageSize & ",'" & FRectDisp & "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1
			FTotalCount = rsget(0)
			FtotalPage	= rsget(1)
		rsget.close

		'// 브랜드이미지 통합으로 2021로 프로시저 변경 & 필드 값만 변경이라 cnt프로시저는 2013 그대로 씀
		sqlStr = "EXEC db_my10x10.dbo.sp_Ten_MyZzimBrand_2021 '" & FRectUserid & "'," & FPageSize & ", " & FCurrPage & ",'" & FRectDisp & "','" & FRectOrder & "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1

		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
        if (FResultCount<1) then FResultCount=0
		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CMyZZimBrandItem

				FItemList(i).Fmakerid		= rsget("userid")
				FItemList(i).Fsocname		= db2html(rsget("socname"))
				FItemList(i).Fsocname_kor	= db2html(rsget("socname_kor"))
				FItemList(i).Fsoclogo		= db2html(rsget("soclogo"))
				FItemList(i).Fdgncomment	= db2html(rsget("dgncomment"))
				FItemList(i).Fmodelitem	    = rsget("modelitem")
				FItemList(i).Fmodelitem2	= rsget("modelitem2")
				FItemList(i).ficon2image	= rsget("icon2image")
				FItemList(i).Fmodelimg		= "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FItemList(i).Fmodelitem) + "/" + db2html(rsget("modelimg"))
				FItemList(i).Fmodelbimg	    = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(FItemList(i).Fmodelitem) + "/" + rsget("modelbimg")
				FItemList(i).Fmodelbimg2	= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(FItemList(i).Fmodelitem2) + "/" + rsget("modelbimg2")
				FItemList(i).ficon1image	= "http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(FItemList(i).Fmodelitem) & "/" + rsget("icon1image")
				FItemList(i).ficon2image	= "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(FItemList(i).Fmodelitem) + "/" + rsget("icon2image")
				FItemList(i).fbasicimage	= fnGetBrandImage(FItemList(i).Fmodelitem, rsget("basicimage"))

				FItemList(i).Frecommendcount= rsget("recommendcount")
				i=i+1
				rsget.moveNext
			loop

		end if
		rsget.Close
	end sub

    '//street/index.asp		'//2014.09.22
	public sub GetstreetMyZZimBrand()
		Dim SqlStr, i
		
		if FRectUserid="" then exit sub

		sqlStr = "exec db_brand.[dbo].[sp_Ten_street_MyZzimBrand_cnt] '" & FRectUserid & "'," & FPageSize & ",'" & FRectDisp & "'"
		
		'response.write sqlStr & "<BR>"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1
			FTotalCount = rsget(0)
			FtotalPage	= rsget(1)
		rsget.close

		if FTotalCount<1 then exit sub

		sqlStr = "exec db_brand.[dbo].[sp_Ten_street_MyZzimBrand] '" & FRectUserid & "'," & FPageSize & ", " & FCurrPage & ",'" & FRectDisp & "','" & FRectOrder & "'"
		
		'response.write sqlStr & "<BR>"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1

		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

        if (FResultCount<1) then FResultCount=0
		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CMyZZimBrandItem

				FItemList(i).Fmakerid		= rsget("userid")
				FItemList(i).Fsocname		= db2html(rsget("socname"))
				FItemList(i).Fsocname_kor	= db2html(rsget("socname_kor"))
				FItemList(i).Fsoclogo		= db2html(rsget("soclogo"))
				FItemList(i).Fdgncomment	= db2html(rsget("dgncomment"))
				FItemList(i).Ftodayrecommendcount	= rsget("todayrecommendcount")
				FItemList(i).Frecommendcount= rsget("recommendcount")
				FItemList(i).fitemcount	= rsget("itemcount")
				FItemList(i).Fhitflg				= rsget("hitflg")
				FItemList(i).Fnewflg				= rsget("newflg")
				FItemList(i).fsmileflg				= rsget("smileflg")
				FItemList(i).fgiftflg				= rsget("giftflg")
				FItemList(i).Fsaleflg				= rsget("saleflg")
				FItemList(i).Fonlyflg				= rsget("onlyflg")
				FItemList(i).Fartistflg				= rsget("artistflg")
				FItemList(i).Fkdesignflg			= rsget("kdesignflg")
				FItemList(i).fitemid			= rsget("itemid")
				FItemList(i).fbasicimage			= "http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(rsget("itemid")) & "/" &db2html(rsget("basicimage"))
				FItemList(i).fitemarr				= rsget("itemarr")

				i=i+1
				rsget.moveNext
			loop

		end if
		rsget.Close
	end sub

    '//추천 찜브랜드
	public sub GetbestMyZZimBranditem()
		Dim SqlStr, i

		sqlStr = "exec db_my10x10.dbo.sp_Ten_MyZzimBrand_bestitem"

		'response.write sqlStr&"<br>"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr, dbget, 1
		
		FTotalCount = rsget.RecordCount
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
        if (FResultCount<1) then FResultCount=0
		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CMyZZimBrandItem

				FItemList(i).Fmakerid		= rsget("userid")
				FItemList(i).Fsocname		= db2html(rsget("socname"))
				FItemList(i).Fsocname_kor	= db2html(rsget("socname_kor"))
				FItemList(i).fsaleflg		= rsget("saleflg")
				FItemList(i).fitemid		= rsget("itemid")
				FItemList(i).ficon1image	= "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FItemList(i).fitemid) + "/" + rsget("icon1image")
				'FItemList(i).ficon2image	= "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(FItemList(i).Fmodelitem) + "/" + rsget("icon2image")
				'FItemList(i).fbasicimage	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).Fmodelitem) + "/" + rsget("basicimage")
				
				FItemList(i).Frecommendcount= rsget("recommendcount")				
				i=i+1
				rsget.moveNext
			loop

		end if
		rsget.Close
	end sub

    '//street/index.asp		'/2014.09.22 한용민 생성
	public sub GetstreetbestMyZZimBranditem()
		Dim SqlStr, i

		sqlStr = "exec db_brand.dbo.sp_Ten_street_MyZzimBrand_bestitem"

		'response.write sqlStr&"<br>"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr, dbget, 1
		
		FTotalCount = rsget.RecordCount
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
        if (FResultCount<1) then FResultCount=0
		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CMyZZimBrandItem

				FItemList(i).Fmakerid		= rsget("userid")
				FItemList(i).Fsocname		= db2html(rsget("socname"))
				FItemList(i).Fsocname_kor	= db2html(rsget("socname_kor"))
				'FItemList(i).ficon1image	= "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FItemList(i).fitemid) + "/" + rsget("icon1image")
				'FItemList(i).ficon2image	= "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(FItemList(i).Fmodelitem) + "/" + rsget("icon2image")
				'FItemList(i).fbasicimage	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).Fmodelitem) + "/" + rsget("basicimage")
				FItemList(i).Ftodayrecommendcount	= rsget("todayrecommendcount")
				FItemList(i).Frecommendcount= rsget("recommendcount")
				FItemList(i).fitemcount	= rsget("itemcount")
				FItemList(i).Fhitflg				= rsget("hitflg")
				FItemList(i).Fnewflg				= rsget("newflg")
				FItemList(i).fsmileflg				= rsget("smileflg")
				FItemList(i).fgiftflg				= rsget("giftflg")
				FItemList(i).Fsaleflg				= rsget("saleflg")
				FItemList(i).Fonlyflg				= rsget("onlyflg")
				FItemList(i).Fartistflg				= rsget("artistflg")
				FItemList(i).Fkdesignflg			= rsget("kdesignflg")
				FItemList(i).fitemarr				= rsget("itemarr")

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.Close
	end sub
		
    Private Sub Class_Initialize()
		redim preserve FItemList(0)
		FCurrPage =1
		FPageSize = 10
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
		
	End Sub

	Private Sub Class_Terminate()

	End Sub


	public Function HasPreScroll()
		HasPreScroll = StartScrollPage > 1
	end Function

	public Function HasNextScroll()
		HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
	end Function

	public Function StartScrollPage()
		StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	end Function
End Class

%>
