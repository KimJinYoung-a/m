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
' PageName : /apps/appCom/wish/followListProc.asp
' Discription : Wish APP 팔로워/팔로잉 회원 목록 출력
' Request : json > type, offset, size, kind, id, OS, versioncode, versionname, verserion
' Response : response > 결과, requestoffset, requestsize, kind, user(array) > id, numofmate, product(array)
' History : 2014.01.14 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sType, sKind, sUId, sOffset, sSize, sFDesc, i, j
dim userid
Dim sData : sData = Request("json")
Dim oJson

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	sKind = oResult.kind			'처리 구분
	sUId = requestCheckVar(oResult.id,32)				'대상 회원ID
	sOffset = getNumeric(requestCheckVar(oResult.offset,8))		'페이지 시작지점
	sSize = getNumeric(requestCheckVar(oResult.size,8))			'페이지당 출력수

set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
elseif sType<>"followlist" then
	'// 페이지 타입 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."
''elseif IsUserLoginOK then
else
	'// 로그인 사용자
	userid = GetLoginUserID

	dim oUserList, oItemList

	set oUserList = new CWish
	oUserList.FRectUserID = sUid
	oUserList.FRectMyUID = userid
	oUserList.FRectKind = sKind
	oUserList.getFollowUserList()

	'// 결과 출력
	oJson("response") = getErrMsg("1000",sFDesc)
	oJson("requestoffset") = sOffset			'시작지점
	oJson("requestsize") = sSize				'페이지당 수
	oJson("kind") = sKind
	Set oJson("user") = jsArray()

	if oUserList.FResultCount>0 then
		for i=0 to oUserList.FResultCount-1
			Set oJson("user")(null) = jsObject()
			oJson("user")(null)("id") = oUserList.FItemList(i).Fuserid
			oJson("user")(null)("numofmate") = cStr(oUserList.FItemList(i).FwishMateItemCnt)		'매칭수
	
			'해당 회원의 위시 상품 접수
			set oItemList = new CWish
			oItemList.FPageSize = 3				'최대 상품수 3개
			oItemList.FRectIsInclude = "A"		'내상품 포함 (A:기본적으로 빼고 없으면 포함, Y:포함, N:제외, X:매칭만)
			oItemList.FRectUserID = oUserList.FItemList(i).Fuserid
			oItemList.FRectMyUID = userid
			Set oJson("user")(null)("product") = oItemList.getWishItemListJson()
			set oItemList = Nothing
		next
	end if

	set oUserList = Nothing

''else
''	'// 로그인 필요
''	oJson("response") = getErrMsg("9000",sFDesc)
''	oJson("faildesc") =	sFDesc
end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->