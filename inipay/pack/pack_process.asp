<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	History	:  2015.11.09 한용민 생성
'	Description : 포장 서비스
'#######################################################
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->

<%
dim mode ,midx, itemidarr, itemoptionarr, itemeaarr, sqlStr, title, message, packitemcnt, jumunDiv, countryCode, returnurl
dim limitpackitemcnt, limitpackitemnocnt
	mode = requestCheckVar(request.Form("mode"),16)
	midx = getNumeric(requestCheckVar(request.Form("midx"),10))
    itemidarr     = request.Form("itemidarr")
    itemoptionarr = request.Form("itemoptionarr")
    itemeaarr = request.Form("itemeaarr")
    title = request.Form("title")
    message = request.Form("message")
    jumunDiv = getNumeric(requestCheckVar(request.Form("bTp"),10))
    countryCode = getNumeric(requestCheckVar(request.Form("ctrCd"),10))
    returnurl = requestCheckVar(request.Form("returnurl"),64)

packitemcnt=0
limitpackitemcnt=0
limitpackitemnocnt=0

dim ckdidx, ValidRet, retBool, iErrMsg
dim userid, guestSessionID, i, j, isBaguniUserLoginOK
If IsUserLoginOK() Then
	userid = getEncLoginUserID ''GetLoginUserID
	isBaguniUserLoginOK = true
Else
	''userid = GetLoginUserID
	userid = GetGuestSessionKey
	isBaguniUserLoginOK = false
End If
guestSessionID = GetGuestSessionKey

dim vShoppingBag_pojang_checkValidItem, pojangcompleteyn
	vShoppingBag_pojang_checkValidItem=0
	pojangcompleteyn="N"

dim refip
	refip = request.ServerVariables("HTTP_REFERER")

if (InStr(refip,"10x10.co.kr")<1) then
	response.write "<script type='text/javascript'>alert('정상적인 유입 경로가 아닙니다.');</script>"
	dbget.close()	:	response.end
end if

'선물포장서비스 노출
if not(G_IsPojangok) then
	response.write "<script type='text/javascript'>alert('현재 선물포장서비스는 점검중 입니다.'); location.replace('"& refip &"');</script>"
	dbget.close()	:	response.end
end if

'if not(isBaguniUserLoginOK) then
'	response.write "<script type='text/javascript'>alert('회원전용 서비스 입니다. 로그인을 해주세요.');</script>"
'	dbget.close()	:	response.end
'end if

response.write "<form name='pojangfrm' method='post' action='' style='margin:0px;'>"
response.write "<input type='hidden' name='reload'>"
response.write "<input type='hidden' name='mode'>"
response.write "<input type='hidden' name='midx'>"
response.write "<input type='hidden' name='bTp'>"
response.write "<input type='hidden' name='ctrCd'>"
response.write "</form>"

'/선물포장 임시 테이블 상품 입력
if mode="add_step1" then
	if itemidarr="" or itemoptionarr="" or itemeaarr="" then
		response.write "<script type='text/javascript'>alert('등록중 오류가 발생 하였습니다. ERR-01'); location.replace('"& refip &"');</script>"
		dbget.close()	:	response.end
	end if

	itemidarr = trim(itemidarr)
	itemoptionarr = trim(itemoptionarr)
	itemeaarr = trim(itemeaarr)
	if right(itemidarr,1)="," then itemidarr = left(itemidarr, len(itemidarr)-1)
	if right(itemoptionarr,1)="," then itemoptionarr = left(itemoptionarr, len(itemoptionarr)-1)
	if right(itemeaarr,1)="," then itemeaarr = left(itemeaarr, len(itemeaarr)-1)
    itemidarr   = split(itemidarr,",")
    itemoptionarr     = split(itemoptionarr,",")
    itemeaarr = split(itemeaarr,",")

	'/유효하지 않은 값이 있나 체크
	for i=LBound(itemidarr) to UBound(itemidarr)
		if getNumeric(trim(itemidarr(i)))="" then
			response.write "<script type='text/javascript'>alert('상품번호가 지정되지 않았습니다.'); location.replace('"& refip &"');</script>"
			dbget.close()	:	response.end
		end if
		if trim(itemoptionarr(i))="" then
			response.write "<script type='text/javascript'>alert('옵션번호가 지정되지 않았습니다.'); location.replace('"& refip &"');</script>"
			dbget.close()	:	response.end
		end if
		if getNumeric(trim(itemeaarr(i)))="" then
			response.write "<script type='text/javascript'>alert('상품수량을 정확하게 입력해주세요.'); location.replace('"& refip &"');</script>"
			dbget.close()	:	response.end
		end if

		limitpackitemcnt = limitpackitemcnt + 1
		limitpackitemnocnt = limitpackitemnocnt + trim(itemeaarr(i))
	next

	if limitpackitemcnt > 10 then
		response.write "<script type='text/javascript'>alert('특별하고 예쁜 포장을 위해\n포장 상품 개수는 10개로 제한됩니다.'); location.replace('"& refip &"');</script>"
		dbget.close()	:	response.end
	end if
	if limitpackitemnocnt > 10 then
		response.write "<script type='text/javascript'>alert('특별하고 예쁜 포장을 위해\n포장 상품 개수는 10개로 제한됩니다.'); location.replace('"& refip &"');</script>"
		dbget.close()	:	response.end
	end if

	'/임시 포장 일경우 packitemcnt를 0으로 저장함. 포장완료후 packitemcnt 값을 계산해서 꼿음. 실제 packitemcnt>0 이 실제 유효한 데이터임
    sqlStr = "insert into db_order.dbo.tbl_order_pack_temp_master" + vbcrlf
    sqlStr = sqlStr & " (userid, title, message, packitemcnt, regdate) values (" + vbcrlf
    sqlStr = sqlStr & " '" & trim(userid) & "'" + vbcrlf
    sqlStr = sqlStr & " ,''" + vbcrlf
    sqlStr = sqlStr & " ,''" + vbcrlf
    sqlStr = sqlStr & " ,0" + vbcrlf
    sqlStr = sqlStr & " ,getdate()" + vbcrlf
    sqlStr = sqlStr & " )"

	'response.write sqlStr & "<br>"
    dbget.Execute sqlStr

	'증상이 전혀 안나는데 특수한 상황에 에러가남. 상황 재현이 안되서 이부분인지 정확히 모르겠으나 쓰면 안될꺼 같음
	'sqlStr = "select IDENT_CURRENT('db_order.dbo.tbl_order_pack_temp_master') as midx"
	sqlStr = "select top 1 midx"
	sqlStr = sqlStr & " from db_order.dbo.tbl_order_pack_temp_master"
	sqlStr = sqlStr & " where packitemcnt=0"
	sqlStr = sqlStr & " and userid='"& trim(userid) &"'"
	sqlStr = sqlStr & " order by midx desc"

	'response.write sqlStr & "<br>"
	rsget.Open sqlStr,dbget
	IF Not rsget.EOF THEN
		midx = rsget("midx")
	else
		midx = 0
	END IF
	rsget.Close

	if midx="" or midx=0 or isnull(midx) then
		response.write "<script type='text/javascript'>alert('등록중 오류가 발생 하였습니다. ERR-02'); location.replace('"& refip &"');</script>"
		dbget.close()	:	response.end
	end if

	for i=LBound(itemidarr) to UBound(itemidarr)
	    sqlStr = "insert into db_order.dbo.tbl_order_pack_temp_detail" + vbcrlf
	    sqlStr = sqlStr & " (midx, itemid, itemoption, itemno) values (" + vbcrlf
	    sqlStr = sqlStr & " "& trim(midx) &"" + vbcrlf
	    sqlStr = sqlStr & " ,"& trim(itemidarr(i)) &"" + vbcrlf
	    sqlStr = sqlStr & " ,'"& trim(itemoptionarr(i)) &"'" + vbcrlf
	    sqlStr = sqlStr & " ,"& trim(itemeaarr(i)) &"" + vbcrlf
	    sqlStr = sqlStr & " )"
	
		'response.write sqlStr & "<br>"
	    dbget.Execute sqlStr
	next

	response.write "<script type='text/javascript'>"
	response.write "	pojangfrm.midx.value='"& midx &"';"
	response.write "	pojangfrm.action = '/inipay/pack/pack_step2.asp';"
	response.write "	pojangfrm.submit();"
	response.write "</script>"
	dbget.close()	:	response.end

'//선물포장 최종 입력
elseif mode="add_step2" then
	if midx="" or isnull(midx) then
		response.write "<script type='text/javascript'>alert('일렬번호가 없습니다.'); location.replace('"& refip &"');</script>"
		dbget.close()	:	response.end
	end if
	midx = trim(midx)

	if title<>"" then
		if checkNotValidHTML(title) then
			response.write "<script type='text/javascript'>alert('선물포장명에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.'); location.replace('"& refip &"');</script>"
			dbget.close()	:	response.end
		end if
	end if
	if message<>"" then
		if checkNotValidHTML(message) then
			response.write "<script type='text/javascript'>alert('선물메세지에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.'); location.replace('"& refip &"');</script>"
			dbget.close()	:	response.end
		end if
	end if

	'/선물포장 담은 박스의 상품 수량을 모두 더해서 가져옴
	sqlStr = "select sum(pd.itemno) as packitemcnt"
	sqlStr = sqlStr & " from db_order.[dbo].[tbl_order_pack_temp_master] pm"
	sqlStr = sqlStr & " Join db_order.[dbo].[tbl_order_pack_temp_detail] pd"
	sqlStr = sqlStr & " 	on pm.midx=pd.midx"
	sqlStr = sqlStr & " where pm.userid='"& userid &"' and pm.midx="& midx &""

	'response.write sqlStr & "<br>"
	rsget.Open sqlStr,dbget
	IF Not rsget.EOF THEN
		packitemcnt = rsget("packitemcnt")
	else
		packitemcnt = 0
	END IF
	rsget.Close

	packitemcnt = trim(packitemcnt)
	if packitemcnt=0 or packitemcnt="" or isnull(packitemcnt) then
		response.write "<script type='text/javascript'>alert('선물포장중 에러발생 ERR-01\n선물포장 서비스는 한개의 창에서만 포장 하셔야 합니다.'); location.replace('"& refip &"');</script>"
		dbget.close()	:	response.end
	end if

	'//마스터 테이블 저장
    sqlStr = "update db_order.dbo.tbl_order_pack_temp_master" + vbcrlf
    sqlStr = sqlStr & " set title='"& html2db(title) &"'" + vbcrlf
    sqlStr = sqlStr & " , packitemcnt="& packitemcnt &"" + vbcrlf		'/포장완료후 packitemcnt 값을 계산해서 꼿음. 실제 packitemcnt>0 이 실제 유효한 데이터임
    sqlStr = sqlStr & " , message='"& html2db(message) &"' where" + vbcrlf
    sqlStr = sqlStr & " userid='"& userid &"' and midx="& midx &""

	'response.write sqlStr & "<br>"
    dbget.Execute sqlStr

	'/장바구니 상품과 선물포장 임시 상품이 유효한 상품인지 체크
	vShoppingBag_pojang_checkValidItem = getShoppingBag_temppojang_checkValidItem("TT","Y")
	if vShoppingBag_pojang_checkValidItem=1 then
		'//선물포장서비스 임시 테이블 비움
		call getpojangtemptabledel("")
		response.write "<script type='text/javascript'>alert('장바구니에 담긴 상품 수량 보다 선물포장이 된 상품 수량이 더많습니다.\n\n다시 포장해 주세요.'); location.replace('"& refip &"');</script>"
		dbget.close()	:	response.end
	elseif vShoppingBag_pojang_checkValidItem=2 then
		'//선물포장서비스 임시 테이블 비움
		call getpojangtemptabledel("")
		response.write "<script type='text/javascript'>alert('장바구니에 담긴 상품이 없습니다.\n\n다시 포장해 주세요.'); self.close();</script>"
		dbget.close()	:	response.end
	elseif vShoppingBag_pojang_checkValidItem=3 then
		pojangcompleteyn="Y"
		'response.write "<script type='text/javascript'>alert('더이상 선물포장이 가능한 상품이 없습니다.');</script>"
		'dbget.close()	:	response.end
	end if

	response.write "<script type='text/javascript'>"
	response.write "	opener.reloadpojang('ON');"
	response.write "	self.focus();"
	response.write "	pojangfrm.midx.value='"& midx &"';"

	if returnurl="STEP1" then
		response.write "	pojangfrm.action = '/inipay/pack/pack_step1.asp';"
	else
		response.write "	pojangfrm.action = '/inipay/pack/pack_step3.asp';"
	end if

	response.write "	pojangfrm.submit();"
	response.write "</script>"
	dbget.close()	:	response.end

'/선물포장 임시 테이블 상품 다시 입력
elseif mode="reset_step1" then
	if midx="" then
		response.write "<script type='text/javascript'>alert('일렬번호가 없습니다.'); location.replace('"& refip &"');</script>"
		dbget.close()	:	response.end
	end if
	midx = trim(midx)

	'//선물포장서비스 임시 테이블 비움
	call getpojangtemptabledel(midx)

	response.write "<script type='text/javascript'>"
	'response.write "	pojangfrm.reload.value='ON';"
	response.write "	pojangfrm.action = '/inipay/pack/pack_step1.asp';"
	response.write "	pojangfrm.submit();"
	response.write "</script>"
	dbget.close()	:	response.end

'//선물포장서비스 임시 테이블 삭제
elseif mode="pojangdel" then
	if midx="" then
		response.write "<script type='text/javascript'>alert('일렬번호가 없습니다.'); location.replace('"& refip &"');</script>"
		dbget.close()	:	response.end
	end if
	midx = trim(midx)

	'//선물포장서비스 임시 테이블 비움
	call getpojangtemptabledel(midx)
	
	response.write "<script type='text/javascript'>"
	response.write "	opener.reloadpojang('ON');"
	response.write "	self.focus();"
	'response.write "	pojangfrm.reload.value='ON';"
	response.write "	pojangfrm.action = '/inipay/pack/pack_step1.asp';"
	response.write "	pojangfrm.submit();"
	response.write "</script>"
	dbget.close()	:	response.end

'//선물포장서비스 임시 테이블 삭제 결제단용
elseif mode="pojangdel_uinfo" then
	if midx="" then
		response.write "<script type='text/javascript'>alert('일렬번호가 없습니다.'); location.replace('"& refip &"');</script>"
		dbget.close()	:	response.end
	end if
	midx = trim(midx)

	'//선물포장서비스 임시 테이블 비움
	call getpojangtemptabledel(midx)

	response.write "<script type='text/javascript'>"
	response.write "	pojangfrm.reload.value='ON';"
	response.write "	pojangfrm.bTp.value='"& jumunDiv &"';"
	response.write "	pojangfrm.ctrCd.value='"& countryCode &"';"
	response.write "	pojangfrm.action = '/inipay/userinfo.asp';"
	response.write "	pojangfrm.submit();"
	response.write "</script>"
	dbget.close()	:	response.end

else
	'response.write "<script type='text/javascript'>location.replace('/inipay/pack/pack_step1.asp');</script>"
	response.write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.');</script>"
	dbget.close()	:	response.end
end if

%>

<!-- #include virtual="/lib/db/dbclose.asp" -->