<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
	Dim sNid, sPsId, sUuid, isList, sStat, sqlStr, appRdt, sSdt, sEdt, sParam
	Dim isList2, sStat2, sSdt2
	Dim dataExists : dataExists=false

	Dim evtStartDT : evtStartDT = "2021-11-22"
	Dim evtEndDT : evtEndDT		= "2021-12-31"

	'** iOS **
	'uuid : 앱 구동과 함께 항상 바로 생성 (항상 생성) (키체인에 저장하기 때문에 앱을 삭제하고 다시 설치하여도 유지 됨)
	'pushid : 푸시 동의 확인 이후 바로 생성 (항상 생성) (앱을 재 설치하면 새로 생성됨)
	'nid(idfa) : att 동의 이후 허용시 생성 (설정- 추적 허용여부에따라 값이 있고 없다)

	'** Android **
	'uuid : 앱 구동과 함께 항상 바로 생성 (항상 생성) (앱을 삭제하고 다시 설치하여도 유지 됨)
	'pushid : 푸시 동의 확인 이후 바로 생성 (항상 생성) (앱을 재 설치하면 새로 생성됨)
	'nid(nudgeid) : 앱 구동과 함께 항상 바로 생성 (항상 생성) (앱을 삭제하고 다시 설치하여도 유지 됨)

	sNid = requestCheckVar(request.form("nid"),40)
	sPsId = requestCheckVar(request.form("pid"),512)
	sUuid = requestCheckVar(request.form("uid"),40)
	sParam = "nid=" & server.UrlEncode(sNid) & "&pid=" & server.UrlEncode(sPsId) & "&uid=" & server.UrlEncode(sUuid)

	'// 오프샾 상태
	isList = false 		'쿠폰 대상자 여부
	sStat = 0			'현재 쿠폰 상태 (1: 대기중, 2:사용완료, 3:만료)

	'// 2018 BML (2018.5.12~13)
	isList2 = false
	sStat2 = 0

	'// 파라메터 정보가 없으면 종료
	if sNid="" and sPsId="" and sUuid="" then
		dbget.close: Response.End
	end if


	'// Step 2 - Nid에 대해서 설치 이력이 있는지 확인
	if sNid="00000000-0000-0000-0000-000000000000" then
	    sqlStr = "select min(regdate) as rdt from db_contents.dbo.tbl_app_NidInfo_CHK"
		sqlStr = sqlStr & "	where Nid='"&sNid&"'"
		sqlStr = sqlStr & " and uuid='" & sUuid & "'"
	else
	    sqlStr = "select min(regdate) as rdt from db_contents.dbo.tbl_app_NidInfo"
		sqlStr = sqlStr & "	where Nid='"&sNid&"'"
	end if
		
		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly

		if not(isNull(rsget("rdt"))) then
		    dataExists = TRUE
			appRdt = rsget("rdt")
			if datediff("h",appRdt,date)<=48 then
				isList = true
				isList2 = true
			end if
			if datediff("h",appRdt,now)<=24 then
				sStat = 1
			else
				sStat = 3
			end if

			'2018 BML(5.12~13)
			if datediff("d",evtStartDT,appRdt)>=0 and datediff("d",appRdt,evtEndDT)>=0 then
				sStat2 = 1
			else
				sStat2 = 3
			end if
		end if
		rsget.Close	

    '// Step 1 - PushId에 대해 앱 설치 이력이 있는지 확인
	if not(isList) and (sPsId<>"") and not(dataExists) then
		sqlStr = "select min(regdate) as rdt from db_contents.dbo.tbl_app_regInfo"
		sqlStr = sqlStr & "	where  deviceid='"&sPsId&"'"

		rsget.CursorLocation = adUseClient
	    rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly
		if not(isNull(rsget("rdt"))) then
			appRdt = rsget("rdt")
			if datediff("h",appRdt,date)<=48 then
				'신규등록 48시간이내면 목록표시 대상
				isList = true
				isList2 = true
			end if

			if datediff("h",appRdt,now)<=24 then					'신규등록 24시간 이내면 쿠폰 지급 대상
				sStat = 1
			else
				sStat = 3
			end if

			'2018 BML(5.12~13)
			if datediff("d",evtStartDT,appRdt)>=0 and datediff("d",appRdt,evtEndDT)>=0 then
				sStat2 = 1
			else
				sStat2 = 3
			end if

		end if
		rsget.Close	
	end if

	'// Step 3 - 대상자일경우 쿠폰 유효성 확인 (오프 사은품:3)
	sqlStr = "select min(regdate) as rdt from db_contents.dbo.tbl_app_offshop_inflow"
	sqlStr = sqlStr & "	where eventNo=3 and ("
	if sNid<>"" then sqlStr = sqlStr & " Nid='"&sNid&"' or"
	if sUuid<>"" then sqlStr = sqlStr & " uuid='"&sUuid&"' or"
	if sPsId<>"" then sqlStr = sqlStr & " deviceid='"&sPsId&"' or"
    sqlStr = LEFT(sqlStr,LEN(sqlStr)-3)
	sqlStr = sqlStr & ")"
    
	rsget.CursorLocation = adUseClient
    rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly
	if not(isNull(rsget("rdt"))) then
		if datediff("d",rsget("rdt"),date)>=7 then
			isList = false		'// 7일 이후에는 표시안함
		else
			isList = true		'// 7일 이내 등록한 쿠폰이 있는 경우 출력
			sStat = 2			'// 등록된 쿠폰정보가 있으므로 사용 완료
		end if
	end if
	rsget.Close	

	'// Step 3 - 대상자일경우 쿠폰 유효성 확인 (BML:5)
	if datediff("d",evtStartDT,now)>=0 and datediff("d",now,evtEndDT)>=0 then
		sqlStr = "select min(regdate) as rdt from db_contents.dbo.tbl_app_offshop_inflow"
		sqlStr = sqlStr & "	where eventNo=5 and ("
		if sNid<>"" then sqlStr = sqlStr & " Nid='"&sNid&"' or"
		if sUuid<>"" then sqlStr = sqlStr & " uuid='"&sUuid&"' or"
		if sPsId<>"" then sqlStr = sqlStr & " deviceid='"&sPsId&"' or"
	    sqlStr = LEFT(sqlStr,LEN(sqlStr)-3)
		sqlStr = sqlStr & ")"
	    
		rsget.CursorLocation = adUseClient
	    rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly
		if not(isNull(rsget("rdt"))) then
			if datediff("d",rsget("rdt"),date)>=7 then
				isList2 = false		'// 7일 이후에는 표시안함
			else
				isList2 = true		'// 7일 이내 등록한 쿠폰이 있는 경우 출력
				sStat2 = 2			'// 등록된 쿠폰정보가 있으므로 사용 완료
			end if
		end if
		rsget.Close
	end if

	'BML 기간이 아니면 제낌
	if isList2 and datediff("d",evtStartDT,now)<0 and datediff("d",now,evtEndDT)>0 then
		isList2=false
	end if
	isList2=false
	'if GetLoginUserID="kobula" then isList = true

	'// 오프샾 사은쿠폰 표시
	if isList then
		sSdt = FormatDate(appRdt,"00.00.00") & " " & FormatDate(appRdt,"00:00")
		sEdt = FormatDate(dateadd("D",1,appRdt),"00.00.00") & " " & FormatDate(dateadd("n",-1,appRdt),"00:00")
%>
<li class="offline">
	<a href="" onclick="fnAPPpopupBrowserURL('쿠폰 코드','<%=wwwUrl%>/apps/appcom/wish/web2014/shoppingtoday/offshop/offshop_chkCoupon.asp?<%=sParam%>&eno=3'); return false;">
		<div class="thumbnail">
			<img src="http://fiximage.10x10.co.kr/m/2017/event/img_bnr_offline_coupon9.jpg" alt="오프라인 매장 사은품" />
			<div class="sum">
				<p><span>대상</span> <span>텐바이텐 App 신규 설치 고객</span></p>
				<p><span>사용처</span> <span>텐바이텐 대학로점</span></p>
				<p><span>사용기간</span> <span class="date">24시간 (<%=sSdt%>~<%=sEdt%>)</span></p>
			</div>
			<% if sStat=2 then %>
			<div class="stamp"><strong><img src="http://fiximage.10x10.co.kr/m/2017/event/ico_stamp_finish_use.png" alt="사용 완료" /></strong></div>
			<% elseif sStat=3 then %>
			<div class="stamp"><strong><img src="http://fiximage.10x10.co.kr/m/2017/event/ico_stamp_date_complete.png" alt="기간 만료" /></strong></div>
			<% end if %>
		</div>
		<p class="desc">
			<b class="headline"><span class="ellipsis">APP 신규설치 고객 사은품 증정!</span></b>
			<span class="subcopy">지금 텐바이텐 앱을 설치하고,  매장에서 사은품 받으세요.</span>
		</p>
	</a>
</li>
<%
	end if
%>
<%
	'// 2018 BML 표시
	if isList2 then
%>
<li class="offline">
	<a href="" onclick="fnAPPpopupBrowserURL('쿠폰 코드','<%=wwwUrl%>/apps/appcom/wish/web2014/shoppingtoday/offshop/offshop_chkCoupon.asp?<%=sParam%>&eno=5'); return false;">
		<div class="thumbnail">
			<img src="http://fiximage.10x10.co.kr/m/2017/event/img_bnr_offline_coupon6.png" alt="뷰티풀 민트 라이프 이벤트" />
			<% if sStat2=2 then %>
			<div class="stamp"><strong><img src="http://fiximage.10x10.co.kr/m/2017/event/ico_stamp_finish_use.png" alt="사용 완료" /></strong></div>
			<% elseif sStat2=3 then %>
			<div class="stamp"><strong><img src="http://fiximage.10x10.co.kr/m/2017/event/ico_stamp_date_complete.png" alt="기간 만료" /></strong></div>
			<% end if %>
		</div>
		<div class="desc">
			<b class="headline"><span class="ellipsis">BML 사은품 증정 이벤트</span></b>
			<span class="subcopy">텐바이텐 부스에서 드리는 혜택!</span>
		</div>
	</a>
</li>
<%
	end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->