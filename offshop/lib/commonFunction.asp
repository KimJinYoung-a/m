<%
'########################################################
' PageName : /offshop/lib/commonFunction.asp
' Description : 오프라인샾 공통함수
' History : 2009.07.13 허진원 생성
'########################################################

'--[index]-----------------------------------------------
'	fnGetShopSerialNo(shopID)		: 오프라인샾 일련번호 접수
'	fnGetNoticeGubun(gubun1,gubun2)	: 글구분이미지
'	fnGetShopName(shopID)			: 오프샾 이름 접수(DB사용)
'	GetImageFolerName(FItemID)		: 상품 이미지 폴더명 접수
'--------------------------------------------------------

	'// 오프라인샾 일련번호 접수(2009년용으로 일련번호 임의 생성)
	Function fnGetShopSerialNo(shopID)
		Select Case shopID
			Case "streetshop011"
				'대학로점
				fnGetShopSerialNo = 1
			Case "streetshop012"
				'인천점
				fnGetShopSerialNo = 2
			'Case "streetshop803"
				'일산점
			'	fnGetShopSerialNo = 3
			'Case "streetshop014"
				'두타점
				'fnGetShopSerialNo = 9
			Case "streetshop018"
				'김포롯데점
				fnGetShopSerialNo = 12				
			Case "streetshop809"
				'제주점
				fnGetShopSerialNo = 13
			Case "streetshop019"
				'롯데영플라자점
				fnGetShopSerialNo = 14				
			Case "streetshop810"
				'신제주점
				fnGetShopSerialNo = 15
			Case Else
				'샾ID가 없으면 대학로점으로 지정
				fnGetShopSerialNo = 1
		End Select
	End Function
	
	
	'글구분이미지
	Function fnGetNoticeGubun(gubun1,gubun2)
		Select Case gubun1
			Case "01"
				'신상품
				If gubun2 = "1" Then
				'	fnGetNoticeGubun = "<img src='http://fiximage.10x10.co.kr/tenbytenshop/ico_new.gif' style='margin-right:10px;'>"
				Else
					fnGetNoticeGubun = "신상품"
				End If
			Case "02"
				'이벤트
				If gubun2 = "1" Then
				'	fnGetNoticeGubun = "<img src='http://fiximage.10x10.co.kr/tenbytenshop/ico_new.gif' style='margin-right:10px;'>"
				Else
					fnGetNoticeGubun = "이벤트"
				End If
			Case "03"
				'할인행사
				If gubun2 = "1" Then
					fnGetNoticeGubun = "<img src='http://fiximage.10x10.co.kr/tenbytenshop/ico_sale.gif' style='margin-right:10px;'>"
				Else
					fnGetNoticeGubun = "할인행사"
				End If
			Case "04"
				'사은품증정
				If gubun2 = "1" Then
					fnGetNoticeGubun = "<img src='http://fiximage.10x10.co.kr/tenbytenshop/ico_gift.gif' style='margin-right:10px;'>"
				Else
					fnGetNoticeGubun = "사은품증정"
				End If
			Case "10"
				'공지
				If gubun2 = "1" Then
				'	fnGetNoticeGubun = "<img src='http://fiximage.10x10.co.kr/tenbytenshop/ico_new.gif' style='margin-right:10px;'>"
				Else
					fnGetNoticeGubun = "공지"
				End If
			Case Else
				fnGetNoticeGubun = ""
		End Select
	End Function
	
	

	Function fnGetShopName(ByVal shopID)
		Dim strSql
	
		strSql = "SELECT shopname FROM [db_shop].[dbo].[tbl_shop_user] WHERE userid='"&shopID&"'"
		rsget.Open strSql,dbget
		IF Not rsget.EOF THEN
			fnGetShopName = rsget("shopname")
		END IF	
		rsget.Close	
	End Function


	Public Function GetImageFolerName(byval FItemID)
		'GetImageFolerName = "0" + CStr(FItemID\10000)
		GetImageFolerName = GetImageSubFolderByItemid(FItemID)
	
	End Function
	
	
	' 현재 페이지 URL에서 파일명 뽑기
	Public Function GetFileName()
		On Error Resume Next
		Dim vUrl			'/소스 경로저장 변수
		Dim FullFilename		'파일이름
		Dim strName			'확장자를 제외한 파일이름
	
		vUrl = Request.ServerVariables("SCRIPT_NAME")
		FullFilename = mid(vUrl,instrrev(vUrl,"/")+1)
		strName = Mid(FullFilename, 1, Instr(FullFilename, ".") - 1)
	
		GetFileName = strName
	End Function
%>	