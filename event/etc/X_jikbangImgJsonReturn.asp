<%@ language="VBScript" codepage="65001" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [직방] 살림살이, 도와드릴게요(이미지 JSON RETURN)
' History : 2014.08.28 원승현 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/event/etc/event54443Cls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<!-- #include Virtual="/lib/util/JSON_2.0.4.asp" -->



<%

	Dim strIp, strIpChk

	strIp = Request.ServerVariables("REMOTE_ADDR")


	strIp = Split(strIp, ".")
	strIpChk = strIp(0)&strIp(1)


	If strIpChk="192168" Or strIpChk="221132" Or strIpChk="5464" Or strIpChk="61252" Then

	Else
		response.write "<script>alert('접근할 수 없는 페이지 입니다.');location.href='http://m.10x10.co.kr';</script>"
		response.End
	End If
	

	Dim RvJustDate '// oneDay 일자
	Dim JustImgReturn '// JSON
	Dim oJustItem
	RvJustDate = request("Jdate")

	If Len(RvJustDate) > 10 Then
		RvJustDate = Left(RvJustDate, 10)
	End If



	'// 오늘의 상품 접수
	set oJustItem = New CJustOneDay
	oJustItem.FRectDate = RvJustDate
	oJustItem.GetJustOneDayItemInfo

	If 	oJustItem.FResultCount > 0 Then
		Set JustImgReturn = jsObject()
		JustImgReturn("JustDate") = oJustItem.FItemList(0).FJustDate
		If IsNull(oJustItem.FItemList(0).FOutPutImgUrl1) Or oJustItem.FItemList(0).FOutPutImgUrl1<>"" Then
			JustImgReturn("ImgMain") = oJustItem.FItemList(0).FOutPutImgUrl1
		Else
			JustImgReturn("ImgMain") = Null
		End If
		If IsNull(oJustItem.FItemList(0).FOutPutImgUrl2) Or oJustItem.FItemList(0).FOutPutImgUrl2<>"" Then
			JustImgReturn("ImgPrd") = oJustItem.FItemList(0).FOutPutImgUrl2
		Else
			JustImgReturn("ImgPrd") = Null
		End If
		JustImgReturn.Flush
	Else
		Set JustImgReturn = jsObject()
		JustImgReturn("JustDate") = NULL
		JustImgReturn("ImgMain") = NULL
		JustImgReturn("ImgPrd") = NULL
		JustImgReturn.Flush		
	End If
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->