<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 마이텐바이텐 - 입고 알림 신청 내역
' History : 2018-01-30 원승현 
'####################################################

	Dim referer, refip, i, sqlStr, vMode
	referer = request.ServerVariables("HTTP_REFERER")
	refip = request.ServerVariables("REMOTE_ADDR")

	if InStr(referer,"10x10.co.kr")<1 Then
		Response.Write "<script>alert('잘못된 접속입니다.');return false;</script>"
		Response.End
	end If

	'// 로그인시에만 사용가능
	If not(IsUserLoginOK()) Then
		Response.Write "<script>alert('로그인이 필요한 서비스 입니다.');return false;</script>"
		Response.End
	End If

	Dim vUserid, vPrevDateType, vPrevDateValue, vStdnum, vPageSize, vIdx

	vUserid = tenDec(requestCheckVar(request("RUserId"),50))
	'// 특정일자 이전 입고알림 일자 type값(dateadd에 들어가는 d, m, y)
	vPrevDateType = requestCheckVar(request("RPrevDateType"),10)
	'// 특정일자 이전 입고알림 일자 값(type과 함께 들어가는 정수값)
	vPrevDateValue = requestCheckVar(request("RPrevDateValue"),20)
	vStdnum = requestCheckVar(request("Rstdnum"),10)
	vPageSize = requestCheckVar(request("Rpagesize"),10)
	vMode = requestCheckVar(request("Rmode"),10)
	vIdx = requestCheckVar(request("RIdx"),20)

	'// 회원확인
	If vUserid <> getEncLoginUserId Then
		Response.Write "<script>alert('잘못된 접속입니다.');return false;</script>"
		Response.End
	End If
%>
	<% If Trim(vMode)="list" Then %>
		<%
			sqlStr = ""
			sqlStr = sqlStr & " SELECT SA.idx, SA.itemid, SA.ItemOptionCode, SA.AlarmType,  "
			sqlStr = sqlStr & " 	SA.PlatForm, SA.AlarmTerm, SA.AlarmValue, SA.LastUpDate, LimitPushDate, SA.SendPushDate, SA.SendStatus, SA.UserCheckStatus, "
			sqlStr = sqlStr & " 	i.itemname, "
			sqlStr = sqlStr & " 	'http://thumbnail.10x10.co.kr/webimage/image/list/'+  "
			sqlStr = sqlStr & " 	CASE WHEN LEN(CONVERT(VARCHAR(20),(SA.itemid / 10000)))=1 THEN '0'+convert(VARCHAR(20),(SA.itemid / 10000)) ELSE CONVERT(VARCHAR(20),(SA.itemid / 10000)) END+  "
			sqlStr = sqlStr & " 	'/'+i.listimage AS listimage, "
			sqlStr = sqlStr & " 	CASE WHEN o.optionname IS NULL THEN CONVERT(BIT,0) ELSE CONVERT(BIT,1) END AS OptionNameCheck, "
			sqlStr = sqlStr & " 	o.optionname, "
			sqlStr = sqlStr & " 	c.socname, "
			sqlStr = sqlStr & " 	i.makerid "
			sqlStr = sqlStr & " FROM db_my10x10.[dbo].[tbl_SoldOutProductAlarm] SA WITH (NOLOCK) "
			sqlStr = sqlStr & " INNER JOIN db_item.dbo.tbl_item i WITH (NOLOCK) ON SA.itemid = i.itemid "
			sqlStr = sqlStr & " LEFT JOIN db_item.dbo.tbl_item_option o WITH (NOLOCK) ON SA.itemid = o.itemid And SA.ItemOptionCode = o.itemoption "
			sqlStr = sqlStr & " LEFT JOIN db_user.dbo.tbl_user_c c WITH (NOLOCK) ON i.makerid = c.userid "
			sqlStr = sqlStr & " WHERE SA.userid='"&vUserid&"'  "
			sqlStr = sqlStr & " 	And SA.LastUpDate >= dateadd("&vPrevDateType&", "&vPrevDateValue&", getdate()) "
			sqlStr = sqlStr & " ORDER BY SA.idx DESC "
			sqlStr = sqlStr & " OFFSET "&vPageSize&"*("&vStdnum&"-1) ROWS FETCH NEXT "&vPageSize&" ROWS ONLY "
			rsget.CursorLocation = adUseClient
			rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
		%>
		<% If Not rsget.Eof Then %>
			<div class="myOrderView">
				<div class="cartGroup">
					<div class="groupCont">
						<ul>
							<% Do Until rsget.eof %>
							<li>
								<div class="pdtWrap">
									<div class="pPhoto">
										<% If isApp="1" Then %>
											<a href="" onclick="fnAPPpopupProduct('<%=rsget("itemid")%>');return false;"><img src="<%=rsget("listimage")%>" alt=""></a>
										<% Else %>
											<a href="/category/category_itemprd.asp?itemid=<%=rsget("itemid")%>" target="_blank"><img src="<%=rsget("listimage")%>" alt=""></a>
										<% End If %>
									</div>
									<div class="pdtCont">
										<p class="pBrand">
											<% If isApp="1" Then %>
												<a href="" onclick="fnAPPpopupBrand('<%=rsget("makerid")%>');return false;">[<%=rsget("socname")%>]</a>
											<% Else %>
												<a href="/street/street_brand.asp?makerid=<%=rsget("makerid")%>" target="_blank">[<%=rsget("socname")%>]</a>
											<% End If %>
										</p>
										<p class="pName">
											<% If isApp="1" Then %>
												<a href="" onclick="fnAPPpopupProduct('<%=rsget("itemid")%>');return false;"><%=rsget("itemname")%></a>
											<% Else %>
												<a href="/category/category_itemprd.asp?itemid=<%=rsget("itemid")%>" target="_blank"><%=rsget("itemname")%></a>
											<% End If %>
										</p>
										<% If rsget("OptionNameCheck") Then %>
											<p class="pOption">옵션: <%=rsget("optionname")%></p>
										<% End If %>
									</div>
									<% If LCase(Trim(rsget("SendStatus")))="y" Then %>
									<% Else %>
										<% If LCase(Trim(rsget("UserCheckStatus")))="y" Then %>
											<% If Now() >= CDate(rsget("LimitPushDate")) Then %>
											<% Else %>
												<span id="StatusBtn<%=rsget("idx")%>"><button class="btn cancel btn-xsmall btn-radius color-grey" onclick="btnCancelCk('<%=rsget("idx")%>');">취소</button></span>
											<% End If %>
										<% Else %>
										<% End If %>
									<% End If %>

								</div>
								<div class="stock-rqst-info">
									<dl class="date">
										<dt>신청일</dt>
										<dd><%=Left(rsget("LastUpDate"), 10)%></dd>
									</dl>
									<dl class="period">
										<dt>신청기간</dt>
										<dd>
											<% If LCase(Trim(rsget("AlarmTerm")))="month" Then %>
												<%=rsget("AlarmValue")%>개월
											<% End If %>
											<% If LCase(Trim(rsget("AlarmTerm")))="day" Then %>
												<%=rsget("AlarmValue")%>일
											<% End If %>
										</dd>
									</dl>
									<dl class="alert-way">
										<dt>알림방법</dt>
										<dd>
											<% If LCase(Trim(rsget("AlarmType")))="lms" Then %>
												문자메시지
											<% End If %>
											<% If LCase(Trim(rsget("AlarmType")))="apppush" Then %>
												App Push
											<% End If %>
										</dd>
									</dl>
									<dl class="progress">
										<dt>진행상태</dt>
										<dd class="color-blue" id="Status<%=rsget("idx")%>">
											<% If LCase(Trim(rsget("SendStatus")))="y" Then %>
												완료
											<% Else %>
												<% If LCase(Trim(rsget("UserCheckStatus")))="y" Then %>
													<% If Now() >= CDate(rsget("LimitPushDate")) Then %>
														기간 종료
													<% Else %>
														신청
													<% End If %>
												<% Else %>
													취소
												<% End If %>
											<% End If %>
										</dd>
									</dl>
								</div>
							</li>
							<% rsget.movenext %>
							<% Loop %>
						</ul>
					</div>
				</div>
			</div>
		<% Else %>
			<%' 입고 알림 신청 내역 없음 %>
			<% If vStdnum = "1" Then %>
				<div class="msg1">
					<span class="icon icon-sold-out"></span>
					<p>입고 알림<br/><span class="color-blue">신청 내역이 없습니다.</span></p>
				</div>
			<% End If %>
		<% End If %>
		<% rsget.close %>
	<% ElseIf vMode="Cancel" Then %>
		<%
			If Trim(vIdx)="" Then
				Response.Write "<script>alert('잘못된 접속입니다.');return false;</script>"
				Response.End
			End If
			sqlStr = ""
			sqlStr = sqlStr & " UPDATE db_my10x10.[dbo].[tbl_SoldOutProductAlarm] SET UserCheckStatus='N' WHERE idx='"&vIdx&"' "
			dbget.Execute sqlStr

			response.write "OK"
			response.End
		%>
	<% Else %>
		<%
			Response.Write "<script>alert('잘못된 접속입니다.');return false;</script>"
			Response.End
		%>
	<% End If %>
<!-- #include virtual="/lib/db/dbclose.asp" -->