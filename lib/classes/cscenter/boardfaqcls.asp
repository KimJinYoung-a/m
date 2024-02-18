<%
Class CBoardFAQItem

    public FfaqId
    public FcommCd
    public Ftitle
    public Fcontents
    public Fuserid
    public Fregusername
    public Fregdate
    public FhitCount
    public Fisusing
    public Flinkname
    public Flinkurl
    public Fdisporder
    
    public Fcomm_name
    
    Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
end Class

Class CBoardFAQ
    public FItemList()
    public FOneItem
    
	public FResultCount
	public FPageSize
	public FCurrpage
	public FTotalCount
	public FTotalPage
	public FScrollCount
    public FRectCommCd
    public FRectOrderType
    public FRectFaqId
    
    public FRectSearchString
	public Fselectfaq
	public FPageCount
	
    public Sub getFaqTopList(ByVal opt)

		Dim i, strSql, objRs
		Dim paramInfo
		paramInfo = Array(Array("@RETURN_VALUE",adInteger,adParamReturnValue,,0) _
			,Array("@TopSize"		, adInteger	, adParamInput	,		, FPageSize)	_
			,Array("@opt"			, adVarchar	, adParamInput	, 20	, opt) _
			,Array("@commCD"		, adVarchar	, adParamInput	, 4		, FRectCommCd) _
			,Array("@title"			, adVarchar	, adParamInput	, 50	, FRectSearchString) _
		)
		strSql = "[db_cs].[dbo].sp_Ten_FaqListTop"
		Call fnExecSPReturnRSOutput(strSql, paramInfo)

		i=0
		if  not rsget.EOF  then
			do until rsget.eof

				redim preserve FItemList(i)

				set FItemList(i) = new CBoardFAQItem
				
				FItemList(i).FfaqId       = rsget("faqId")
                FItemList(i).FcommCd      = rsget("commCd")
                FItemList(i).Ftitle       = db2html(rsget("title"))
                FItemList(i).Fcontents    = db2html(rsget("contents"))
                FItemList(i).Fregdate     = rsget("regdate")
                FItemList(i).FhitCount    = rsget("hitCount")

				FItemList(i).Fcomm_name    = db2html(rsget("commName"))

				i=i+1
				rsget.moveNext
			loop
		end if

		FResultCount = i

		rsget.Close
	
	End Sub

    public Sub getFaqList()

		Dim i, strSql, objRs
		Dim paramInfo
		paramInfo = Array(Array("@RETURN_VALUE",adInteger,adParamReturnValue,,0) _
			,Array("@PageSize"		, adInteger	, adParamInput	,		, FPageSize)	_
			,Array("@CurrPage"		, adInteger	, adParamInput	,		, FCurrPage) _
			,Array("@isUsing"		, adVarchar	, adParamInput	, 1		, "Y") _
			,Array("@commCD"		, adVarchar	, adParamInput	, 4		, FRectCommCd) _
			,Array("@title"			, adVarchar	, adParamInput	, 50	, FRectSearchString) _
		)
		strSql = "[db_cs].[dbo].sp_Ten_FaqList"
		
		Call fnExecSPReturnRSOutput(strSql, paramInfo)
		FTotalCount = CDbl(GetValue(paramInfo, "@RETURN_VALUE"))	' 토탈카운트
		FtotalPage  = Int ( (FTotalCount - 1) / FPageSize ) + 1
		If FTotalCount = 0 Then	FtotalPage = 1
		

		i=0
		if  not rsget.EOF  then
			do until rsget.eof

				redim preserve FItemList(i)

				set FItemList(i) = new CBoardFAQItem
				
				FItemList(i).FfaqId       = rsget("faqId")
                FItemList(i).FcommCd      = rsget("commCd")
                FItemList(i).Ftitle       = db2html(rsget("title"))
                FItemList(i).Fcontents    = db2html(rsget("contents"))
                FItemList(i).Fuserid      = rsget("userid")
                FItemList(i).Fregusername = db2html(rsget("regusername"))
                FItemList(i).Fregdate     = rsget("regdate")
                FItemList(i).FhitCount    = rsget("hitCount")
                FItemList(i).Fisusing     = rsget("isusing")
                FItemList(i).Flinkname    = db2html(rsget("linkname"))
                FItemList(i).Flinkurl     = db2html(rsget("linkurl"))
                FItemList(i).Fdisporder   = rsget("disporder")

                FItemList(i).Fcomm_name    = db2html(rsget("commName"))
				i=i+1
				rsget.moveNext
			loop
		end if

		FResultCount = i

		rsget.Close
	
	End Sub




	Public Sub getFaqList_new
		Dim sqlStr, i, where
		' 갯수 구하기 '
		sqlStr = "db_cs.[dbo].[sp_Ten_FaqList_cnt] '" + FRectCommCd + "','"+FRectSearchString+"', '" +Fselectfaq + "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1
		If not rsget.EOF Then
			FTotalCount = rsget("cnt")
		Else
			FTotalCount = 0
		End If
		rsget.Close
		sqlStr = "db_cs.[dbo].[sp_Ten_FaqList_new] '" + FRectCommCd + "','"+FRectSearchString+"', '" +Fselectfaq + "', '" + Cstr(FPageSize * FCurrPage) + "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1

		if (FCurrPage * FPageSize < FTotalCount) then
			FResultCount = FPageSize
		else
			FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
		end if

		FTotalPage = (FTotalCount\FPageSize)
		if (FTotalPage<>FTotalCount/FPageSize) then FTotalPage = FTotalPage +1

		redim preserve FItemList(FResultCount)

		FPageCount = FCurrPage - 1

		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.EOF
				Set FItemList(i) = new CBoardFAQItem
				FItemList(i).FfaqId       = rsget("faqId")
                FItemList(i).FcommCd      = rsget("commCd")
                FItemList(i).Ftitle       = db2html(rsget("title"))
                FItemList(i).Fcontents    = db2html(rsget("contents"))
                FItemList(i).Fuserid      = rsget("userid")
                FItemList(i).Fregusername = db2html(rsget("regusername"))
                FItemList(i).Fregdate     = rsget("regdate")
                FItemList(i).FhitCount    = rsget("hitCount")
                FItemList(i).Fisusing     = rsget("isusing")
                FItemList(i).Flinkname    = db2html(rsget("linkname"))
                FItemList(i).Flinkurl     = db2html(rsget("linkurl"))
                FItemList(i).Fdisporder   = rsget("disporder")
                FItemList(i).Fcomm_name    = db2html(rsget("commName"))
				i=i+1
				rsget.moveNext
			Loop
		End If
		rsget.Close
	End Sub





    public Sub getOneFaq()
        
		Dim i, strSql, objRs
		Dim paramInfo
		paramInfo = Array(Array("@RETURN_VALUE",adInteger,adParamReturnValue,,0) _
			,Array("@PKID", adInteger	, adParamInput	,		, FRectFaqId)	_
		)
		strSql = "[db_cs].[dbo].sp_Ten_FaqOne"
		Call fnExecSPReturnRSOutput(strSql, paramInfo)

        if Not rsget.Eof then
            set FOneItem = new CBoardFAQItem
            
            FOneItem.FfaqId       = rsget("faqId")
            FOneItem.FcommCd      = rsget("commCd")
            FOneItem.Ftitle       = db2html(rsget("title"))
            FOneItem.Fcontents    = db2html(rsget("contents"))
            FOneItem.Fuserid      = rsget("userid")
            FOneItem.Fregusername = db2html(rsget("regusername"))
            FOneItem.Fregdate     = rsget("regdate")
            FOneItem.FhitCount    = rsget("hitCount")
            FOneItem.Fisusing     = rsget("isusing")
            FOneItem.Flinkname    = db2html(rsget("linkname"))
            FOneItem.Flinkurl     = db2html(rsget("linkurl"))
            FOneItem.Fdisporder   = rsget("disporder")

            FOneItem.Fcomm_name    = db2html(rsget("commName"))
        end if
        rsget.Close
        
    End Sub
    
	' 카운트 증가
    Public Function AddCount(ByVal faqID)

		'On Error Resume Next 
		dbget.BeginTrans

		Dim ErrCode, ErrMsg
        
		Dim strSql
		Dim paramInfo
		paramInfo = Array(Array("@RETURN_VALUE",adInteger,adParamReturnValue,,0) _
			,Array("@mode"			, adVarchar	, adParamInput	, 10	, "HIT")	_
			,Array("@faqId"		, adInteger	, adParamInput	, 9	, faqID) _
			,Array("@commCd"		, adVarchar	, adParamInput	, 4	, "") _
			,Array("@title"		, adVarchar	, adParamInput	, 200	, "") _
			,Array("@contents"	, adVarchar	, adParamInput	, 8000	, "") _
			,Array("@userid"		, adVarchar	, adParamInput	, 32	, "") _
			,Array("@regusername"	, adVarchar	, adParamInput	, 64	, "") _
			,Array("@linkname"	, adVarchar	, adParamInput	, 255	, "") _
			,Array("@linkurl"		, adVarchar	, adParamInput	, 255	, "") _
			,Array("@disporder"	, adInteger	, adParamInput	, 4	, null) _
		)

		strSql = "db_cs.dbo.sp_Ten_FaqProc"
		Call fnExecSP(strSql, paramInfo)

		ErrCode  = CInt(GetValue(paramInfo, "@RETURN_VALUE"))			' 에러코드

		If Err Or ErrCode <> 0 Then
			dbget.RollBackTrans
			ErrMsg = "오류발생 : " & Err.Number & " : " & Err.Source & " : " & Replace(Err.Description,"'","") & " : " 
		Else
			dbget.CommitTrans
		End If 
		ProcData = ErrMsg 

	End Function 


    Private Sub Class_Initialize()
		redim preserve FItemList(0)
		FResultCount  = 0
		FTotalCount = 0
		FPageSize = 12
		FCurrpage = 1
		FScrollCount = 10
	End Sub

	Private Sub Class_Terminate()

	End Sub
	

End Class



%>
