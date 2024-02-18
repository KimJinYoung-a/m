<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/apps/appCom/wish/inc_constVar.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/setFollowProc.asp
' Discription : Wish APP 지정회원을 팔로우~
' Request : json > type, id, OS, versioncode, versionname, verserion
' Response : response > 결과
' History : 2014.01.15 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sType, sUId, sKind, sFDesc, i
Dim sData : sData = Request("json")
Dim oJson, userid

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	sUId = requestCheckVar(oResult.id,32)
	sKind = oResult.kind
set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."

elseif sType<>"setfollowing" then
	'// 페이지 타입 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."

elseif sUId="" then
	'// 잘못된 접근
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "파라메터 정보가 없습니다."

elseif IsUserLoginOK then
	'// 로그인 사용자
	userid = GetLoginUserID

	if sUId=userid then
		'// 자기를 팔로우 할 수는 없음
		oJson("response") = getErrMsg("9999",sFDesc)
		oJson("faildesc") = "나를 팔로우 할 수 없습니다."
	else
		dim sqlStr, chkRst
	
		'// 중복 확인
		sqlStr = "select count(*) cnt, (select count(*) from db_user.dbo.tbl_user_n where userid='" & sUId & "') as isUsr "
		sqlStr = sqlStr & " from db_contents.dbo.tbl_app_wish_followInfo "
		sqlStr = sqlStr & " where userid='" & userid & "' "
		sqlStr = sqlStr & " 	and followUid='" & sUId & "'"
		rsget.Open sqlStr,dbget,1
		if rsget(0)>0 then
			chkRst = "e1"
		elseif rsget(1)=0 then
			chkRst = "e2"
		else
			chkRst = "ok"
		end if
		rsget.Close

		if chkRst="e1" and sKind="set" then
			oJson("response") = getErrMsg("9999",sFDesc)
			oJson("faildesc") = "이미 팔로우되어 있습니다."
		elseif chkRst="ok" and sKind="reset" then
			oJson("response") = getErrMsg("9999",sFDesc)
			oJson("faildesc") = "팔로우되지 않은 회원입니다."
		elseif chkRst="e2" then
			oJson("response") = getErrMsg("9999",sFDesc)
			oJson("faildesc") = "사용이 중지되었거나 없는 회원입니다."
		else
			'#트랜잭션 시작
			dbget.beginTrans

			'// WishApp 대상 회원정보 확인 및 생성
			sqlStr = "IF Not EXISTS(Select userid from db_contents.dbo.tbl_app_wish_userInfo where userid='" & sUid & "') " & vbCrLf
			sqlStr = sqlStr & "begin " & vbCrLf
			sqlStr = sqlStr & "	Insert Into db_contents.dbo.tbl_app_wish_userInfo (userid) values ('" & sUid & "') " & vbCrLf
			sqlStr = sqlStr & "end"
			dbget.Execute(sqlStr)

			Select Case sKind
				Case "set"
					'// 팔로우 정보 저장
					sqlStr = "insert into db_contents.dbo.tbl_app_wish_followInfo (userid, followUid, regdate) "
					sqlStr = sqlStr & " values ('" & userid & "','" & sUId & "', getdate())"
					dbget.Execute(sqlStr)
				Case "reset"
					'// 팔로우 정보 삭제
					sqlStr = "Delete from db_contents.dbo.tbl_app_wish_followInfo "
					sqlStr = sqlStr & " Where userid='" & userid & "' and followUid='" & sUId & "'"
					dbget.Execute(sqlStr)
			End Select

			'// 나의 팔로잉 정보 업데이트
			sqlStr = "update db_contents.dbo.tbl_app_wish_userInfo "
			sqlStr = sqlStr & " set followerCnt=( "
			sqlStr = sqlStr & " 	select count(*) cnt "
			sqlStr = sqlStr & " 	from db_contents.dbo.tbl_app_wish_followInfo "
			sqlStr = sqlStr & " 	where followUid='" & userid & "') "
			sqlStr = sqlStr & " 	,followingCnt=( "
			sqlStr = sqlStr & " 	select count(*) fcn "
			sqlStr = sqlStr & " 	from db_contents.dbo.tbl_app_wish_followInfo "
			sqlStr = sqlStr & " 	where userid='" & userid & "') "
			sqlStr = sqlStr & " 	,lastupdate=getdate() "
			sqlStr = sqlStr & " where userid='" & userid & "'"
			dbget.Execute(sqlStr)

			'// 대상회원의 팔로잉 정보 업데이트
			sqlStr = "update db_contents.dbo.tbl_app_wish_userInfo "
			sqlStr = sqlStr & " set followerCnt=( "
			sqlStr = sqlStr & " 	select count(*) cnt "
			sqlStr = sqlStr & " 	from db_contents.dbo.tbl_app_wish_followInfo "
			sqlStr = sqlStr & " 	where followUid='" & sUId & "') "
			sqlStr = sqlStr & " 	,lastupdate=getdate() "
			sqlStr = sqlStr & " where userid='" & sUId & "'"
			dbget.Execute(sqlStr)

			'// 결과 출력
			IF (Err) then
				dbget.RollBackTrans
				oJson("response") = getErrMsg("9999",sFDesc)
				oJson("faildesc") = "처리중 오류가 발생했습니다."
			else
				dbget.CommitTrans
				oJson("response") = getErrMsg("1000",sFDesc)

				if sKind="set" then
					'// PUSH알림 발송
					Call sendFollowingPushMsg(userid,sUId)
				end if
			end if
		end if
	end if
else
	'// 로그인 필요
	oJson("response") = getErrMsg("9000",sFDesc)
	oJson("faildesc") =	sFDesc
end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->