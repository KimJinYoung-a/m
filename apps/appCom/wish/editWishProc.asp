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
' PageName : /apps/appCom/wish/editWishProc.asp
' Discription : Wish APP 지정한 상품을 Wish에 추가/이동/삭제 처리
' Request : json > type, kind, folderid, folderidfrom, product(array), OS, versioncode, versionname, verserion
' Response : response > 결과
' History : 2014.01.16 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sType, sKind, sFidx, sOldIfidx, aItemid, sFDesc, i
Dim sData : sData = Request("json")
Dim oJson, userid

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	sKind = oResult.kind
	sFidx = requestCheckvar(oResult.folderid,9)
	sOldIfidx = requestCheckvar(oResult.folderidfrom,9)
	set aItemid = oResult.product
set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."

elseif sType<>"editwish" then
	'// 페이지 타입 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."

elseif sKind="" then
	'// 잘못된 접근
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "파라메터 정보가 없습니다."

elseif IsUserLoginOK then
	'// 로그인 사용자
	userid = GetLoginUserID
	if sFidx="" then sFidx=0

	dim sqlStr, oItem
	Set oItem = aItemid

	if oItem.length>0 then

		dim itemarray, fidarray
		for i=0 to oItem.length-1
			if itemarray<>"" then itemarray = itemarray & ","
			itemarray = itemarray & oItem.get(i).productid
		next
		fidarray = sFidx
		if sOldIfidx<>"" then fidarray = fidarray & "," & sOldIfidx

		'DB 트랜잭션 시작
		dbget.beginTrans

		Select Case sKind
			Case "add"
				'# 신규 등록
				for i=0 to oItem.length-1
				    sqlStr = " IF Not Exists(SELECT itemid FROM db_my10x10.dbo.tbl_myfavorite WHERE userid ='" & userid & "' and itemid=" & oItem.get(i).productid & " and fidx=" & cStr(sFidx) & " ) "	 & VbCrlf
				    sqlStr = sqlStr & "	BEGIN " & VbCrlf
				    sqlStr = sqlStr & " insert into db_my10x10.dbo.tbl_myfavorite" & VbCrlf
				    sqlStr = sqlStr & " (userid,itemid,fidx,viewIsUsing)" & VbCrlf
				    sqlStr = sqlStr & " select '" & userid & "'," & CStr(oItem.get(i).productid) & "," & cStr(sFidx) & ",isNull((select top 1 viewIsUsing from db_my10x10.dbo.tbl_myfavorite_folder where fidx=" & Cstr(sFidx) & "),'N')" & VbCrlf
				    sqlStr = sqlStr & "	END "
				    dbget.Execute(sqlStr)
	    		next

			Case "move"
				if sOldIfidx="" then sOldIfidx=0

				'# 폴더 이동
				for i=0 to oItem.length-1
				    sqlStr = " IF not EXISTS(SELECT itemid FROM db_my10x10.dbo.tbl_myfavorite WHERE userid='" & userid & "' AND itemid =" & oItem.get(i).productid & " AND fidx=" & cStr(sFidx) & " ) " & VbCrlf
				    sqlStr = sqlStr & "		UPDATE  db_my10x10.dbo.tbl_myfavorite SET fidx = " & cStr(sFidx) & ", lastupdate = getdate()  " & VbCrlf
				    sqlStr = sqlStr & "			,viewIsUsing=isNull((select top 1 viewIsUsing from db_my10x10.dbo.tbl_myfavorite_folder where fidx=" & cStr(sFidx) & "),'N') " & VbCrlf
				    sqlStr = sqlStr & "		WHERE userid ='" & userid & "' AND itemid = " & oItem.get(i).productid & " and fidx = " & sOldIfidx & " " & VbCrlf
				    if cStr(sFidx)<>cStr(sOldIfidx) then
					    sqlStr = sqlStr & "	ELSE " & VbCrlf
					    sqlStr = sqlStr & "		Begin " & VbCrlf
					    sqlStr = sqlStr & "			UPDATE  db_my10x10.dbo.tbl_myfavorite SET lastupdate = getdate()  " & VbCrlf
					    sqlStr = sqlStr & "				,viewIsUsing=isNull((select top 1 viewIsUsing from db_my10x10.dbo.tbl_myfavorite_folder where fidx=" & cStr(sFidx) & "),'N') " & VbCrlf
					    sqlStr = sqlStr & "			WHERE userid ='" & userid & "' AND itemid = " & oItem.get(i).productid & " and fidx = " & cStr(sFidx) & "; " & VbCrlf
					    sqlStr = sqlStr & "			Delete  db_my10x10.dbo.tbl_myfavorite WHERE userid ='" & userid & "' AND itemid = " & oItem.get(i).productid & " and fidx = " & sOldIfidx & "; " & VbCrlf
					    sqlStr = sqlStr & "		end "
					end if
				    dbget.Execute(sqlStr)
				next

			Case "delete"
				'#삭제
				sqlStr = "delete from db_my10x10.dbo.tbl_myfavorite"
				sqlStr = sqlStr & " where userid='" & userid & "'"
				sqlStr = sqlStr & " and itemid in (" + itemarray + ")" +" and fidx= " & Cstr(sFidx)
				dbget.Execute(sqlStr)

		end Select

		'// 폴더 정보 업데이트
		sqlStr = " update A " + VbCrlf
	    sqlStr = sqlStr + "	Set A.itemCnt=isNULL(B.cnt,0) " + VbCrlf
	    sqlStr = sqlStr + "		,A.lastupdate=isNULL(B.updt,getdate()) " + VbCrlf
	    sqlStr = sqlStr + "	from db_my10x10.dbo.tbl_myfavorite_folder as A " + VbCrlf
	    sqlStr = sqlStr + "		left join  ( " + VbCrlf
	    sqlStr = sqlStr + "			select fidx, count(*) cnt, max(isNull(lastupdate,regdate)) updt " + VbCrlf
	    sqlStr = sqlStr + "			from db_my10x10.dbo.tbl_myfavorite " + VbCrlf
	    sqlStr = sqlStr + "			where userid='" + userid + "' " + VbCrlf
	    '''sqlStr = sqlStr + "				and fidx in (" & fidarray & ") " + VbCrlf
	    sqlStr = sqlStr + "			group by fidx " + VbCrlf
	    sqlStr = sqlStr + "		) as B " + VbCrlf
	    sqlStr = sqlStr + "			on A.fidx=B.fidx " + VbCrlf
	    sqlStr = sqlStr + "	where A.userid='" + userid + "' and (isNULL(A.itemCnt,0)<>isNULL(B.cnt,0) or A.lastupdate<>B.updt)"  + VbCrlf
		dbget.Execute sqlStr

		'// 상품 정보 업데이트
		sqlStr = "UPDATE R SET " & vbCrLf
		sqlStr = sqlStr & " 	favcount = D.cnt " & vbCrLf
		sqlStr = sqlStr & " FROM [db_item].[dbo].[tbl_item_Contents] AS R " & vbCrLf
		sqlStr = sqlStr & " INNER JOIN " & vbCrLf
		sqlStr = sqlStr & " ( " & vbCrLf
		sqlStr = sqlStr & " 	SELECT itemid, count(itemid) AS cnt FROM [db_my10x10].[dbo].[tbl_myfavorite] where itemid in(" & itemarray & ") " & vbCrLf
		sqlStr = sqlStr & " 	GROUP BY itemid " & vbCrLf
		sqlStr = sqlStr & " ) AS D ON R.itemid = D.itemid " & vbCrLf
		sqlStr = sqlStr & " where R.itemid in(" & itemarray & ") " & vbCrLf
		dbget.Execute sqlStr

		'// 결과 출력
		IF (Err) then
			dbget.RollbackTrans
			oJson("response") = getErrMsg("9999",sFDesc)
			oJson("faildesc") = "처리중 오류가 발생했습니다."
		else
			dbget.CommitTrans
			oJson("response") = getErrMsg("1000",sFDesc)
		end if
	else
		oJson("response") = getErrMsg("9999",sFDesc)
		oJson("faildesc") = "처리할 상품정보가 없습니다."
	end if

	Set oItem = Nothing

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