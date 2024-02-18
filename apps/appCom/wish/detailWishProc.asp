<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/apps/appCom/wish/inc_constVar.asp"-->
<!-- #include virtual="/apps/appCom/wish/wishCls.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/detailWishProc.asp
' Discription : Wish APP 회원의 위시컬렉션(폴더목록) 출력
' Request : json > type, id
' Response : response > 결과, id,numofmate,numoffolowing,numoffollwers,following,badge(array),badgedesc,folder(array),numofwish,numofcoupon,mileage,balance,class
' History : 2014.01.03 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sType, sUid, sFDesc, i, j
dim userid
Dim sData : sData = Request("json")
Dim oJson

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	sUid = requestCheckVar(oResult.id,32)
set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
elseif sType<>"detail_wish_collection" then
	'// 메인페이지 타입 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."
elseif sUid="" then
	'// 검색 회원ID 없음
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "파라메터 정보가 없습니다."
else
	'// 로그인 사용자
	userid = GetLoginUserID

	dim oUserInfo, oItemList
	
	'// 위시 회원 정보 접수
	set oUserInfo = new CWish
	oUserInfo.FRectUserID = sUid
	oUserInfo.FRectMyUID = userid
	oUserInfo.getUserInfo()

	'// 결과 출력
	if oUserInfo.FResultCount>0 then
		oJson("response") = getErrMsg("1000",sFDesc)
		oJson("id") = sUid
		oJson("numofmate") = oUserInfo.FItemList(0).FwishMateItemCnt		'나와 같은 상품을 wish한 상품수
		oJson("numoffollowing") = oUserInfo.FItemList(0).FfollowingCnt		'회원의 팔로윙 수
		oJson("numoffollowers") = oUserInfo.FItemList(0).FfollowerCnt		'회원의 팔로워 수
		oJson("following") = oUserInfo.FItemList(0).FisMyFollow				'나의 팔로잉 여부(0:No, 1:Yes)
	
		Set oJson("badge") = oUserInfo.getUserBadgeListJson()				'뱃지 목록 (Array)
		oJson("badgedesc") = b64encode(cstBadgeInfoUrl & "?uid=" & sUid)	'뱃지설명 URL

		Set oJson("folder") = oUserInfo.getUserWishFolderListJson()			'폴더 목록 (Array)

		'// 내 정보일 때 출력 (아니면 공란)
		oJson("numofwish") = oUserInfo.FItemList(0).FfavCount				'나의 위시 상품수
		oJson("numofcoupon") = oUserInfo.FItemList(0).FcounponCnt			'나의 쿠폰 보유수
		oJson("mileage") = oUserInfo.FItemList(0).FcurrMileage				'나의 보유 마일리지
		oJson("balance") = oUserInfo.FItemList(0).FcurrDeposit				'나의 보유 예치금
		oJson("class") = oUserInfo.FItemList(0).Fuserlevel					'나의 회원 등급

	else
		oJson("response") = getErrMsg("9999",sFDesc)
		oJson("faildesc") = "회원 정보가 없습니다."
	end if

	set oUserInfo = Nothing
end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->