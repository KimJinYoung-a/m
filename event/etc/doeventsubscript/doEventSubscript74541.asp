<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 그린 크리스마스-이니스프리 MA
' History : 2016-11-24 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%	
dim eCode, userid, strSql , sqlstr , refer , totcnt , mode
Dim icpn1 , icpn2 , icpn3 , icpn4 , icpn5 '//상품쿠폰
Dim renloop , couponnum
Dim wincnt1 , wincnt2 , wincnt3 , wincnt4
Dim prizecnt1 , prizecnt2 , prizecnt3 , prizecnt4, prizecnt5
Dim snsno , rvalue, evtUserCell, device, itemcode
dim curruntday

'-------------------------------------------------------------
'	이벤트 오픈시 177줄 FALSE -> TRUE로 변경
'-------------------------------------------------------------
	mode = requestCheckvar(request("mode"),1)
	if isapp then
		device = "A"
	else
		device = "M"
	end if

	curruntday = date()
'	curruntday = "2016-11-29"

	randomize
	renloop=int(Rnd*1000)+1 '100%

	if curruntday = "2016-11-28" then
		prizecnt1 = 300		'당첨 제한 갯수
		icpn1 = 1604455	'상품 코드
	elseif curruntday = "2016-11-29" then
		prizecnt1 = 394
		icpn1 = 1604509
	elseif curruntday = "2016-11-30" then
		prizecnt1 = 294
		icpn1 = 1604510
	elseif curruntday = "2016-12-01" then
		prizecnt1 = 100
		icpn1 = 1604513
	elseif curruntday = "2016-12-02" then
		prizecnt1 = 172
		icpn1 = 1604514
	else
		prizecnt1 = 0
		icpn1 = 0
	end if

	IF application("Svr_Info") = "Dev" THEN
		eCode = "66243"
		icpn5 = "2829"	'무배 쿠폰
		icpn1=1231227
	Else
		eCode = "74541"
		icpn5 = "936"	'무배 쿠폰
	End If

	userid = getEncLoginUserID
	evtUserCell		= get10x10onlineusercell(userid) '// 참여한 회원 핸드폰번호

	refer = request.ServerVariables("HTTP_REFERER")
	If InStr(refer,"10x10.co.kr") < 1 Then
		Response.Write "{ "
		response.write """resultcode"":""88""" '// 잘못된 접속임
		response.write "}"
		dbget.close()
		response.end
	End If

	If userid = "" Then
		Response.Write "{ "
		response.write """resultcode"":""44""" '// 아이디 없음
		response.write "}"
		dbget.close()
		response.end
	End If

	'// 이벤트 기간 확인
	if mode<>"S" then
		If Not(Now() > #11/28/2016 10:00:00# and Now() < #12/02/2016 23:59:59#) Then
			Response.Write "{ "
			response.write """resultcode"":""33"""
			response.write "}"
			dbget.close()
			response.end
		End If 
	end if
'###########################################################################################################################################
	'//쿠폰 발급
	Sub fnGetCoupon(v)
		If v = 1 Then couponnum = icpn1
		If v = 5 Then couponnum = icpn5

		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& couponnum &"', "& v &", '"& device &"')" 
		dbget.execute sqlstr

		If v = 5 Then '꽝
			'//꽝이거나 소진됐을때
			sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
			sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
			sqlstr = sqlstr & " 	SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,convert(varchar(10),getdate(),120),convert(datetime,convert(varchar(10),getdate(),120) + ' 23:59:59'),couponmeaipprice,validsitename" + vbcrlf
			sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
			sqlstr = sqlstr & " 	where idx="& couponnum &""
			dbget.execute sqlstr
		Else 
			'//당첨시
			Response.Write "{ "
			response.write """resultcode"":""11"""
			If v = 1 Then	''당첨
				response.write ",""lypop"":""<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/74541/m/txt_win_01.png' alt='축하합니다 배송비만 내고 그린크리스박스를 받으세요' /></p><a href='' onclick='goDirOrdItem("&couponnum&"); return false;' class='btnClick'><img src='http://webimage.10x10.co.kr/eventIMG/2016/74541/m/btn_get_chrisbox.png' alt='구매하러 가기' /></a><button type='button' onclick='btnClose();' class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/74541/m/btn_close_02.png' alt='당첨 레이어팝업 닫기' /></button>"""

			ElseIf v = 5 Then	''꽝-무배쿠폰 발급
				response.write ",""lypop"":""<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/74541/m/txt_win_02.png' alt='헉! 이런!  그린크리스박스에 당첨되지 않았어요! 대신, 무료배송 쿠폰을 드릴게요! 1만원 이상 가능하며 텐배 상품만 사용하실 수 있습니다. MY TENBYTEN의 쿠폰/상품 쿠폰에서 확인하세요! 상품 쿠폰은 하나의 주문 건에서 중복 사용이 불가합니다!' /></p><button onclick='btnClose();' class='btnDownload'><img src='http://webimage.10x10.co.kr/eventIMG/2016/74541/m/btn_download.png' alt='확인' /></button><button type='button' onclick='btnClose();' class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/74541/m/btn_close_02.png' alt='당첨 레이어팝업 닫기' /></button>"""
			End If
			response.write "}"
			dbget.close()
			response.End
		End If 

		'꽝-무배쿠폰 발급
		Response.Write "{ "
		response.write """resultcode"":""11"""
		response.write ",""lypop"":""<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/74541/m/txt_win_02.png' alt='헉! 이런!  그린크리스박스에 당첨되지 않았어요! 대신, 무료배송 쿠폰을 드릴게요! 1만원 이상 가능하며 텐배 상품만 사용하실 수 있습니다. MY TENBYTEN의 쿠폰/상품 쿠폰에서 확인하세요! 상품 쿠폰은 하나의 주문 건에서 중복 사용이 불가합니다!' /></p><button onclick='btnClose();' class='btnDownload'><img src='http://webimage.10x10.co.kr/eventIMG/2016/74541/m/btn_download.png' alt='확인' /></button><button type='button' onclick='btnClose();' class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/74541/m/btn_close_02.png' alt='당첨 레이어팝업 닫기' /></button>"""
		response.write "}"
		dbget.close()
		response.End
	End Sub
'###########################################################################################################################################
	'//당첨 확인
	Sub fnGetWinner()
		strSql = "SELECT " + vbcrlf
		strSql = strSql & " isnull(sum(case when sub_opt2 = '1' then 1 else 0 end),0) as item1 " + vbcrlf
		strSql = strSql & " from db_event.dbo.tbl_event_subscript where evt_code = '"&eCode&"' and datediff(day,regdate,getdate()) = 0 "  + vbcrlf
		rsget.Open strSql,dbget,1
		IF Not rsget.Eof Then
			wincnt1 = rsget("item1")	'오늘 당첨된 갯수
		End If
		rsget.close()

		If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then		'당첨자 핸드폰번호로 걸러내기
			renloop = 9900
		End If

		If userBlackListCheck(userid) Then												'다량아이디(블랙리스트)체크
			renloop = 9990
		End If

		if date() = "2016-11-28" then
			If renloop >= 1 And renloop <= 10 Then 		'당첨 0.5% 
				If wincnt1 < prizecnt1 Then				'물량있음
					Call fnGetCoupon(1)
				Else
					Call fnGetCoupon(5)
				End If 
			ElseIf renloop >= 801 And renloop <= 1000 Then	'무배 쿠폰 20% 
				Call fnGetCoupon(5)
			Else											'1 ~ 1000 사이가 아니면 꽝
				Call fnGetCoupon(5)
			End If 	
		else
			If renloop >= 1 And renloop <= 50  Then 		'당첨 0.1% 
				If wincnt1 < prizecnt1 Then				'물량있음
					Call fnGetCoupon(1)
				Else
					Call fnGetCoupon(5)
				End If 
			ElseIf renloop >= 801 And renloop <= 1000 Then	'무배 쿠폰 20% 
				Call fnGetCoupon(5)
			Else											'1 ~ 1000 사이가 아니면 꽝
				Call fnGetCoupon(5)
			End If
		end if
			
	End Sub
'###########################################################################################################################################
'###########################################################################################################################################
if mode="I" then
	Dim evt_pass : evt_pass = False '이벤트 응모 여부 chkflag
	evt_pass = TRUE		' FALSE		'TRUE

	If evt_pass Then '응모
		'//응모 카운트 체크
		strSql = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "' and datediff(day,regdate,getdate()) = 0 "
		rsget.CursorLocation = adUseClient
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly

		IF Not rsget.Eof Then
			totcnt = rsget(0) '// 0 1
		End IF
		rsget.close

		If totcnt = 0 Then
			Call fnGetWinner()
		Else '이미 응모함
			Response.Write "{ "
			response.write """resultcode"":""99""" 
			response.write "}"
			dbget.close()
			response.End
		End If 
	Else '잠시 후 다시 시도해 주세요.
		Response.Write "{ "
		response.write """resultcode"":""00"""
		response.write "}"
		response.end
	End If 
end if
'###########################################################################################################################################
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->