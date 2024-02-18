<%
'==========================================================================
'	Description: 나의주소록 클래스, 이영진
'	History: 2009.04.10
'==========================================================================

' 나의주소록 아이템
Class clsMyAddressItem
	Dim idx			' 주소록번호
	Dim userID		' 회원아이디
	Dim countryCode	' 해외배송국가코드
	Dim reqPlace	' 배송지명
	Dim reqName		' 수령인명
	Dim reqZipcode	' 우편번호
	Dim reqZipaddr	' 동주소
	Dim reqAddress	' 상세주소
	Dim reqEmail	' 수령인메일
	Dim reqPhone	' 수령인전화번호
	Dim reqHp		' 수령인휴대폰
	Dim regDate		' 등록일

	Dim countryNameKr' 국가명(한글)
	Dim countryNameEn' 국가명(영문)
	Dim emsAreaCode	' EMS요금적용지역

	Dim orderSerial	' 과거배송지 주문번호

    Private Sub Class_initialize()	
	End Sub							
									
	Private Sub Class_Terminate()	
	End Sub							

End Class 

' 나의주소록 클래스
Class clsMyAddress

    Dim Item	' 아이템 인스턴스
	Dim Items()	' 리스트 컬렉션
	
	' 페이징
	Dim PageBlock
	Dim PageSize
	Dim CurrPage
	Dim TotalCount
	Dim TotalPage
	Dim ResultCount
	public FRectUserId
	public FRectCountryCode
	public FOLDCnt
	public FMYCnt

    Private Sub Class_initialize()	
		PageBlock	= 3
		PageSize	= 5
		CurrPage	= 1
		TotalCount	= 0
		TotalPage	= 1
		ResultCount	= 0
		ReDim Items(0)
	End Sub							

	Private Sub Class_Terminate()	
	End Sub							

	' 리스트
	Public Function GetList(ByVal countryCode, ByVal searchOption, ByVal userid)
		Dim i, strSql
		Dim paramInfo
		paramInfo = Array(Array("@RETURN_VALUE",adInteger,adParamReturnValue,,0) _
			,Array("@PageSize"		, adInteger	, adParamInput	,		, PageSize)	_
			,Array("@CurrPage"		, adInteger	, adParamInput	,		, CurrPage) _
			,Array("@userID"		, adVarchar	, adParamInput	, 32	, userid) _
			,Array("@countryCode"	, adVarchar	, adParamInput	, 2		, countryCode) _
			,Array("@searchOption"	, adVarchar	, adParamInput	, 10	, searchOption) _
		)

		strSql = "db_order.dbo.sp_Ten_MyAddress_GetList"
		Call fnExecSPReturnRSOutput(strSql, paramInfo)

		TotalCount = CDbl(GetValue(paramInfo, "@RETURN_VALUE"))	' 토탈카운트
		TotalPage  = Int ( (TotalCount - 1) / PageSize ) + 1
		If TotalCount = 0 Then	TotalPage = 1

		If Not rsget.EOF Then 
			i = 1
			Do Until rsget.EOF

				ReDim Preserve Items(i)

				Set Items(i) = new clsMyAddressItem

				Items(i).idx			= null2blank(rsget("idx"))
				Items(i).userID		= null2blank(rsget("userID"))
				Items(i).countryCode	= null2blank(rsget("countryCode"))
				Items(i).reqPlace	= null2blank(rsget("reqPlace"))
				Items(i).reqName		= null2blank(rsget("reqName"))
				Items(i).reqZipcode	= null2blank(rsget("reqZipcode"))
				Items(i).reqZipaddr	= null2blank(rsget("reqZipaddr"))
				Items(i).reqAddress	= null2blank(rsget("reqAddress"))
				Items(i).reqEmail	= null2blank(rsget("reqEmail"))
				Items(i).reqPhone	= null2blank(rsget("reqPhone"))
				Items(i).reqHp		= null2blank(rsget("reqHp"))
				Items(i).regDate		= null2blank(rsget("regDate"))

				Items(i).countryNameKr= null2blank(rsget("countryNameKr"))
				Items(i).countryNameEn= null2blank(rsget("countryNameEn"))
				Items(i).emsAreaCode	= null2blank(rsget("emsAreaCode"))

				Items(i).orderSerial	= null2blank(rsget("orderSerial"))

				i = i + 1
				rsget.MoveNext
			Loop 
		End If 

		rsget.close()

	End Function

	' 리스트 가변
	Public Function GetList_New(ByVal countryCode, ByVal searchOption , ByVal PBlock , ByVal PSize)

		If PBlock = "" Then 
			PageBlock = "3"
		Else
			PageBlock = PBlock
		End If 

		If Psize = "" Then
			PageSize = "5"
		Else
			PageSize = PSize
		End If 

		Dim i, strSql
		Dim paramInfo
		paramInfo = Array(Array("@RETURN_VALUE",adInteger,adParamReturnValue,,0) _
			,Array("@PageSize"		, adInteger	, adParamInput	,		, PageSize)	_
			,Array("@CurrPage"		, adInteger	, adParamInput	,		, CurrPage) _
			,Array("@userID"		, adVarchar	, adParamInput	, 32	, getLoginUserID) _
			,Array("@countryCode"	, adVarchar	, adParamInput	, 2		, countryCode) _
			,Array("@searchOption"	, adVarchar	, adParamInput	, 10	, searchOption) _
		)

		strSql = "db_order.dbo.sp_Ten_MyAddress_GetList"
		Call fnExecSPReturnRSOutput(strSql, paramInfo)

		TotalCount = CDbl(GetValue(paramInfo, "@RETURN_VALUE"))	' 토탈카운트
		TotalPage  = Int ( (TotalCount - 1) / PageSize ) + 1
		If TotalCount = 0 Then	TotalPage = 1

		If Not rsget.EOF Then 
			i = 1
			Do Until rsget.EOF

				ReDim Preserve Items(i)

				Set Items(i) = new clsMyAddressItem

				Items(i).idx			= null2blank(rsget("idx"))
				Items(i).userID		= null2blank(rsget("userID"))
				Items(i).countryCode	= null2blank(rsget("countryCode"))
				Items(i).reqPlace	= null2blank(rsget("reqPlace"))
				Items(i).reqName		= null2blank(rsget("reqName"))
				Items(i).reqZipcode	= null2blank(rsget("reqZipcode"))
				Items(i).reqZipaddr	= null2blank(rsget("reqZipaddr"))
				Items(i).reqAddress	= null2blank(rsget("reqAddress"))
				Items(i).reqEmail	= null2blank(rsget("reqEmail"))
				Items(i).reqPhone	= null2blank(rsget("reqPhone"))
				Items(i).reqHp		= null2blank(rsget("reqHp"))
				Items(i).regDate		= null2blank(rsget("regDate"))

				Items(i).countryNameKr= null2blank(rsget("countryNameKr"))
				Items(i).countryNameEn= null2blank(rsget("countryNameEn"))
				Items(i).emsAreaCode	= null2blank(rsget("emsAreaCode"))

				Items(i).orderSerial	= null2blank(rsget("orderSerial"))

				i = i + 1
				rsget.MoveNext
			Loop 
		End If 

		rsget.close()

	End Function

	' 데이터
	Public Function GetData(ByVal idx)

		Set Item = new clsMyAddressItem

		If idx <> "" Then 
			Dim i, strSql, objRs
			Dim paramInfo
			paramInfo = Array(Array("@RETURN_VALUE",adInteger,adParamReturnValue,,0) _
				,Array("@idx"			, adInteger	, adParamInput	,		, idx)	_
				,Array("@userID"		, adVarchar	, adParamInput	, 32	, getLoginUserID) _
			)

			strSql = "db_order.dbo.sp_Ten_MyAddress_GetData"
			Call fnExecSPReturnRSOutput(strSql, paramInfo)

			If Not rsget.EOF Then 

				Item.idx			= null2blank(rsget("idx"))
				Item.userID			= null2blank(rsget("userID"))
				Item.countryCode	= null2blank(rsget("countryCode"))
				Item.reqPlace		= null2blank(rsget("reqPlace"))
				Item.reqName		= null2blank(rsget("reqName"))
				Item.reqZipcode		= null2blank(rsget("reqZipcode"))
				Item.reqZipaddr		= null2blank(rsget("reqZipaddr"))
				Item.reqAddress		= null2blank(rsget("reqAddress"))
				Item.reqEmail		= null2blank(rsget("reqEmail"))
				Item.reqPhone		= null2blank(rsget("reqPhone"))
				Item.reqHp			= null2blank(rsget("reqHp"))
				Item.regDate		= null2blank(rsget("regDate"))

				Item.countryNameKr	= null2blank(rsget("countryNameKr"))
				Item.countryNameEn	= null2blank(rsget("countryNameEn"))
				Item.emsAreaCode	= null2blank(rsget("emsAreaCode"))

			End If 

			rsget.close()

		End If 

	End Function

	' 등록, 수정, 삭제
    Public Function ProcData(ByVal mode)

		Dim resultMsg		' 결과 메시지
		Dim ErrCode, ErrMsg
        
		Dim strSql
		Dim paramInfo
		paramInfo = Array(Array("@RETURN_VALUE",adInteger,adParamReturnValue,,0) _
			,Array("@mode"			, adVarchar	, adParamInput	, 10	, mode)	_
			,Array("@idx"			, adInteger	, adParamInput	, 4	, Item.idx) _
			,Array("@userID"		, adVarchar	, adParamInput	, 32	, getLoginUserID) _
			,Array("@countryCode"	, adChar	, adParamInput	, 2	, Item.countryCode) _
			,Array("@reqPlace"	, adVarchar	, adParamInput	, 32	, Item.reqPlace) _
			,Array("@reqName"		, adVarchar	, adParamInput	, 32	, Item.reqName) _
			,Array("@reqZipcode"	, adVarchar	, adParamInput	, 20	, Item.reqZipcode) _
			,Array("@reqZipaddr"	, adVarchar	, adParamInput	, 200	, Item.reqZipaddr) _
			,Array("@reqAddress"	, adVarchar	, adParamInput	, 500	, Item.reqAddress) _
			,Array("@reqEmail"	, adVarchar	, adParamInput	, 100	, Item.reqEmail) _
			,Array("@reqPhone"	, adVarchar	, adParamInput	, 20	, Item.reqPhone) _
			,Array("@reqHp"		, adVarchar	, adParamInput	, 20	, Item.reqHp) _

		)

		strSql = "db_order.dbo.sp_Ten_MyAddress_Proc"
		Call fnExecSP(strSql, paramInfo)

		ErrCode  = CInt(GetValue(paramInfo, "@RETURN_VALUE"))			' 에러코드

		ProcData = ErrCode 

	End Function 

	' 복사
    Public Function CopyData(ByVal orderSerial)

		Dim resultMsg		' 결과 메시지
		Dim ErrCode, ErrMsg
        
		Dim strSql
		Dim paramInfo
		paramInfo = Array(Array("@RETURN_VALUE",adInteger,adParamReturnValue,,0) _
			,Array("@userID"		, adVarchar	, adParamInput	, 32	, getLoginUserID) _
			,Array("@orderSerial"	, adVarchar	, adParamInput	, 32	, orderSerial) _
		)

		strSql = "db_order.dbo.sp_Ten_MyAddress_Copy"
		Call fnExecSP(strSql, paramInfo)

		ErrCode  = CInt(GetValue(paramInfo, "@RETURN_VALUE"))			' 에러코드

		CopyData = ErrCode 

	End Function 
	
	public Function fnRecentCntMyCnt
		Dim strSql
			strSql = "EXECUTE [db_order].[dbo].[sp_Ten_ordersheet_baesongtab] '" & FRectUserId & "', '" & FRectCountryCode & "'"
			'response.write strSql
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
			rsget.Open strSql,dbget,adOpenForwardOnly,adLockReadOnly
			
			if Not rsget.Eof Then
				FOLDCnt = rsget(0)
				FMYCnt	= rsget(1)
			end if
			rsget.close
	End Function

End Class
%>

