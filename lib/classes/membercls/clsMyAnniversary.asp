<%
'==========================================================================
'	Description: 나의 기념일 클래스, 이영진
'	History: 2009.04.16
'==========================================================================

' 나의 기념일 아이템
Class clsMyAnniversaryItem
	Dim idx			' 기념일일련번호
	Dim userID		' 회원아이디
	Dim alertDay	' 알림일자
	Dim solarDay	' 양력일자
	Dim lunarDay	' 음력일자
	Dim dayType		' 양력,음력
	Dim alertYN		' 알림여부
	Dim title		' 기념일명
	Dim regDate		' 등록일
	Dim isUsing		' 사용여부
	Dim memo		' 기념일메모
	Dim alarmcycle	' 알람유형

	Dim setDay		' 날짜세팅

	' 양력,음력 날짜리턴
	Public Function getSetDay
		Select Case dayType
			Case "S"	getSetDay = solarDay
			Case Else	getSetDay = lunarDay
		End Select
	End Function

	' 양력,음력 리턴
	Public Function dayTypeName
		Select Case dayType
			Case "S"	dayTypeName = "양력"
			Case Else	dayTypeName = "음력"
		End Select
	End Function

	' D-day 리턴
	Public Function getDecimalDay
		getDecimalDay = DateDiff("d",Date(),alertDay)
	End Function

	' 누적일자
	Public Function getPassedDay
		getPassedDay = DateDiff("d",solarDay,Date())
	End Function

	Private Sub Class_initialize()
	End Sub

	Private Sub Class_Terminate()
	End Sub

End Class

' 나의 기념일 클래스
Class clsMyAnniversary

    Dim Item	' 아이템 인스턴스
	Dim Items()	' 리스트 컬렉션

	' 페이징
	Dim PageBlock
	Dim PageSize
	Dim CurrPage
	Dim TotalCount
	Dim TotalPage
	Dim ResultCount

	' 검색
	Dim searchSDate
	Dim searchEDate
	Dim searchType
	Dim searchValue
	Dim searchCommCd

    Private Sub Class_initialize()
		PageBlock	= 10
		PageSize	= 10
		CurrPage	= 1
		TotalCount	= 0
		TotalPage	= 1
		ResultCount	= 0
		ReDim Items(0)
	End Sub

	Private Sub Class_Terminate()
	End Sub

	' 리스트
	Public Function FrontGetList()

		Dim i, strSql
		Dim paramInfo
		paramInfo = Array(Array("@RETURN_VALUE",adInteger,adParamReturnValue,,0) _
			,Array("@PageSize"		, adInteger	, adParamInput	,		, PageSize)	_
			,Array("@CurrPage"		, adInteger	, adParamInput	,		, CurrPage) _
			,Array("@userID"		, adVarchar	, adParamInput	, 32	, GetLoginUserID()) _
		)

		strSql = "db_my10x10.dbo.sp_Ten_MyAnniversary_GetList"
		Call fnExecSPReturnRSOutput(strSql, paramInfo)

		TotalCount = CDbl(GetValue(paramInfo, "@RETURN_VALUE"))	' 토탈카운트
		TotalPage  = Int ( (TotalCount - 1) / PageSize ) + 1
		If TotalCount = 0 Then	TotalPage = 1

		If Not rsget.EOF Then
			i = 1
			Do Until rsGet.EOF

				ReDim Preserve Items(i)

				Set Items(i) = new clsMyAnniversaryItem

				Items(i).idx			= null2blank(rsGet("idx"))
				Items(i).userID		= null2blank(rsGet("userID"))
				Items(i).alertDay	= null2blank(rsGet("alertDay"))
				Items(i).solarDay	= null2blank(rsGet("solarDay"))
				Items(i).lunarDay	= null2blank(rsGet("lunarDay"))
				Items(i).dayType		= null2blank(rsGet("dayType"))
				Items(i).alertYN		= null2blank(rsGet("alertYN"))
				Items(i).title		= null2blank(rsGet("title"))
				Items(i).regDate		= null2blank(rsGet("regDate"))
				Items(i).isUsing		= null2blank(rsGet("isUsing"))

				i = i + 1
				rsGet.MoveNext
			Loop
		End If

		rsGet.close()

	End Function

	' 데이터
	Public Function GetData(ByVal idx)

		Set Item = new clsMyAnniversaryItem

		If idx <> "" Then
			Dim i, strSql
			Dim paramInfo
			paramInfo = Array(Array("@RETURN_VALUE",adInteger,adParamReturnValue,,0) _
				,Array("@idx"			, adInteger	, adParamInput	,		, idx)	_
				,Array("@userID"		, adVarchar	, adParamInput	, 32	, GetLoginUserID()) _
			)

			strSql = "db_my10x10.dbo.sp_Ten_MyAnniversary_GetData_2013"
			Call fnExecSPReturnRSOutput(strSql, paramInfo)

			ResultCount = CDbl(GetValue(paramInfo, "@RETURN_VALUE"))	' 로우카운트

			If Not rsGet.EOF Then

				Item.idx			= null2blank(rsGet("idx"))
				Item.userID			= null2blank(rsGet("userID"))
				Item.alertDay		= null2blank(rsGet("alertDay"))
				Item.solarDay		= null2blank(rsGet("solarDay"))
				Item.lunarDay		= null2blank(rsGet("lunarDay"))
				Item.dayType		= null2blank(rsGet("dayType"))
				Item.alertYN		= null2blank(rsGet("alertYN"))
				Item.title			= null2blank(rsGet("title"))
				Item.regDate		= null2blank(rsGet("regDate"))
				Item.isUsing		= null2blank(rsGet("isUsing"))
				Item.memo			= null2blank(rsGet("memo"))
				Item.alarmcycle		= null2blank(rsGet("alarmcycle"))


			End If

			rsGet.close()

		End If

	End Function

    Public Function FrontProcData(ByVal mode)

		Dim resultMsg		' 결과 메시지
		Dim ErrCode, ErrMsg

		Dim strSql
		Dim paramInfo
		paramInfo = Array(Array("@RETURN_VALUE",adInteger,adParamReturnValue,,0) _
			,Array("@mode"			, adVarchar	, adParamInput	, 10	, mode)	_
			,Array("@idx"			, adInteger	, adParamInput	, 4		, Item.idx) _
			,Array("@userID"		, adVarchar	, adParamInput	, 32	, GetLoginUserID()) _
			,Array("@setDay"		, adVarchar	, adParamInput	, 10	, Item.setDay) _
			,Array("@dayType"		, adChar	, adParamInput	, 1		, Item.dayType) _
			,Array("@title"			, adVarchar	, adParamInput	, 50	, Item.title) _
			,Array("@memo"			, adVarchar	, adParamInput	, 70	, Item.memo) _
			,Array("@alarmcycle"			, adVarchar	, adParamInput	, 4		, Item.alarmcycle) _
		)

		strSql = "db_my10x10.dbo.sp_Ten_MyAnniversary_Proc_2013"
		Call fnExecSP(strSql, paramInfo)

		ErrCode  = CInt(GetValue(paramInfo, "@RETURN_VALUE"))			' 에러코드

		FrontProcData = ErrCode

	End Function

End Class
%>

