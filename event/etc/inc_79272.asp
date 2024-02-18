<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 설문조사
' History : 2017-01-20 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/coffeeCls.asp" -->
<%
dim eCode, userid, currenttime, page, i, ThisUrl
IF application("Svr_Info") = "Dev" THEN
	eCode = "66399"
Else
	eCode = "79272"
End If

Dim retUrl
retUrl = Request.ServerVariables("HTTP_REFERER")
If InStr(retUrl,"cafe.naver.com")>1 Then
'Response.write "<script>self.close();</script>"
Response.write "<script>location.href='http://m.10x10.co.kr';</script>"
Response.end
End If

ThisUrl = Request.ServerVariables("PATH_INFO")
page=requestcheckvar(request("page"),5)
If page="" Then  page=1
currenttime = now()
userid = GetEncLoginUserID()

dim subscriptcountend
subscriptcountend=0

'//본인 참여 여부
if userid<>"" then
	subscriptcountend = getevent_subscriptexistscount(eCode, userid, "", "2", "")
end If

Dim cEvtFan
set cEvtFan = new CEvtElectricFan
cEvtFan.FECode = eCode	'이벤트 코드
cEvtFan.FCurrPage = page
cEvtFan.FPageSize = 5
cEvtFan.GetElectricFanList

Dim myCom
set myCom = new CEvtCoffee
myCom.Frectuserid=userid
myCom.FECode = eCode	'이벤트 코드
myCom.GetMyComment

Function fnDisplayPaging_New(strCurrentPage, intTotalRecord, intRecordPerPage, intBlockPerPage, strJsFuncName)
	'변수 선언
	Dim intCurrentPage, strCurrentPath, vPageBody
	Dim intStartBlock, intEndBlock, intTotalPage
	Dim strParamName, intLoop

	'현재 페이지 설정
	intCurrentPage = strCurrentPage		'현재 페이지 값
	
	'해당페이지에 표시되는 시작페이지와 마지막페이지 설정
	intStartBlock = Int((intCurrentPage - 1) / intBlockPerPage) * intBlockPerPage + 1
	intEndBlock = Int((intCurrentPage - 1) / intBlockPerPage) * intBlockPerPage + intBlockPerPage
	
	'총 페이지 수 설정
	intTotalPage =   int((intTotalRecord-1)/intRecordPerPage) +1 
	''eastone 추가
	if (intTotalPage<1) then intTotalPage=1     
	
	vPageBody = ""
	
	vPageBody = vPageBody & "<div class=""paging pagingV15a"">" & vbCrLf
	
	'## 이전 페이지
	If intStartBlock > 1 Then
		vPageBody = vPageBody & "			<a href=""javascript:" & strJsFuncName & "(" & intStartBlock -1 & ")"" class=""first arrow""><span><img src='http://webimage.10x10.co.kr/eventIMG/2017/78770/m/btn_prev.png' alt='이전페이지로 이동' /></span></a>" & vbCrLf
	Else
		vPageBody = vPageBody & "			<a href=""javascript:"" class=""first arrow""><span><img src='http://webimage.10x10.co.kr/eventIMG/2017/78770/m/btn_prev.png' alt='이전페이지로 이동' /></span></a>" & vbCrLf
	End If

	'## 현재 페이지
	If intTotalPage > 1 Then
		For intLoop = intStartBlock To intEndBlock
			If intLoop > intTotalPage Then Exit For
			If Int(intLoop) = Int(intCurrentPage) Then
				vPageBody = vPageBody & "			<a href=""javascript:" & strJsFuncName & "(" & intLoop & ")"" class=""current""><span>" & intLoop & "</span></a>" & vbCrLf
			Else
				vPageBody = vPageBody & "			<a href=""javascript:" & strJsFuncName & "(" & intLoop & ")""><span>" & intLoop & "</span></a>" & vbCrLf
			End If
		Next
	Else
		vPageBody = vPageBody & "			<a href=""javascript:" & strJsFuncName & "(1)"" class=""current""><span>1</span></a>" & vbCrLf
	End If
	
	'## 다음 페이지
	If Int(intEndBlock) < Int(intTotalPage) Then	'####### 다음페이지
		vPageBody = vPageBody & "			<a href=""javascript:" & strJsFuncName & "(" & intEndBlock+1 & ")"" class=""end arrow""><span><img src='http://webimage.10x10.co.kr/eventIMG/2017/78770/m/btn_next.png' alt='다음페이지로 이동' /></a></span>" & vbCrLf
	Else
		vPageBody = vPageBody & "			<a href=""javascript:"" class=""end arrow""><span><img src='http://webimage.10x10.co.kr/eventIMG/2017/78770/m/btn_next.png' alt='다음페이지로 이동' /></a></span>" & vbCrLf
	End If
	
	vPageBody = vPageBody & "</div>" & vbCrLf
	
	fnDisplayPaging_New = vPageBody
	
End Function
%>
<style type="text/css">
.enter {position:relative;}
.enter > div {position:absolute; top:50%; left:0; right:0; padding:7.8%;}
.enter > div p {width:100%; height:12rem; border-radius:0.5rem 0.5rem 0 0; background-color:#fff;}
.enter > div p textarea {width:100%; height:12rem; padding:2rem; color:#007142; font-size:1.35rem; font-weight:500; border:none;}
.enter .btnEnter {width:100%; height:4.5rem; color:#fff; font-size:1.75rem; font-weight:bold; background-color:#007142; border-radius:0 0 0.5rem 0.5rem;}
.myCheck {position:relative;}
.myCheck > div {position:absolute; top:20%; left:0; right:0; padding:7.8%;}
.myCheck > div p {width:100%; height:12rem; border-radius:0.5rem 0.5rem 0 0.5rem; background-color:#fff;}
.myCheck > div p textarea {width:99%; height:12rem; padding:2rem; color:#5f5f5f; font-size:1.35rem; font-weight:600; border:none;}
.myCheck .btnEnter {margin-left:82.1%; width:18%; height:2.7rem; color:#fff; font-size:1.1rem; background-color:#007142; border-radius:0; border:none;}
.enteredList {position:relative; padding:7.8%; background:url(http://webimage.10x10.co.kr/eventIMG/2017/79272/m/bg_cmt.png) repeat 50% 0;}
.enteredList ul {width:100%; height:100%;}
.enteredList ul li {position:relative; padding:3.75rem 1.5rem 2rem; margin:2rem 0; font-size:1.25rem; line-height:1.7rem; color:#fff; background-color:#f2efe6; border-radius:0.5rem}
.enteredList ul li > .num,
.enteredList ul li > .wirter {position:absolute; top:1.5rem; color:#401305; font-size:1rem; font-weight:600;}
.enteredList ul li > .wirter img {width:0.85rem; margin-top:0.15rem; margin-right:0.4rem; vertical-align:top;}
.enteredList ul li .wirter {left:1.5rem;}
.enteredList ul li .num {right:1.5rem;}
.enteredList ul li .userContet {display:block; position:relative; padding:0 0.5rem; font-size:1.25rem; line-height:2.14; color:#333; background:url(http://webimage.10x10.co.kr/eventIMG/2017/79272/m/img_cmt_line.png) repeat 0 0; background-size:auto 2.65rem;}
.enteredList .pageWrapV15 {position:relative; width:100%; height:2.1rem; margin-bottom:3rem;}
.enteredList .paging { height:100%; margin:0;}
.enteredList .paging a.arrow {display:inline-block; width:2.5%; height:3.2%;}
.enteredList .paging a span {position:relative; width:2.1rem; height:2.1rem; margin:0 .6rem; border:none; color:#e8f0f9; font-weight:bold; font-size:1.2rem; line-height:2.3rem;}
.enteredList .paging a.arrow span {position:absolute; top:0.45rem; width:0.7rem;}
.enteredList .paging a.arrow.first span {left:10.31%;}
.enteredList .paging a.arrow.end span {right:10.31%;}
.enteredList .paging a.current span {background-color:#f2efe6; color:#006339; border-radius:1.05rem;}
.shareSns {position:relative;}
.shareSns ul {position:absolute; top:0; right:0; width:50%; height:100%;}
.shareSns ul li{position:absolute; top:0; width:50%; height:100%;}
.shareSns ul li:nth-child(1){left:0;}
.shareSns ul li:nth-child(2){right:0;}
.shareSns ul li a {display:inline-block; width:100%; height:100%; text-indent:-999em;}
.evntNoti {background-color:#252525;}
.evntNoti ul {padding:2rem 3rem 2rem 2.8rem; color:#fff; font-size:1.1rem; line-height:1.7rem;}
.evntNoti ul li {text-indent:-.8rem;}
</style>
<script>
<!--
function chkevt(){
	<% If not(IsUserLoginOK()) Then %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% else %>
	var frm =  document.frm;
	if (GetByteLength(frm.comment.value) > 200){
		alert("100자 까지 작성 가능합니다.");
		frm.comment.focus();
		return false;
	}
	if (frm.comment.value==""){
		alert("빈칸을 정확하게 모두 채워 주세요.");
		frm.comment.focus();
		return false;
	}
	jsEventSubmit();
	<% End IF %>
}

function jsEventSubmit(){
	<% If IsUserLoginOK() Then %>
		<% If now() > #07/28/2017 23:59:59# then %>
			alert("이벤트 기간이 아닙니다.");
			return false;
		<% else %>
			var str = $.ajax({
				type: "POST",
				url: "/event/etc/doEventSubscript79272.asp",
				data: $("#frm").serialize(),
				dataType: "text",
				async: false
			}).responseText;
			var str1 = str.split("||")
			console.log(str);
			if (str1[0] == "01"){
				alert(str1[1]);
				return false;
			}else if (str1[0] == "02"){
				alert(str1[1]);
				return false;
			}else if (str1[0] == "03"){
				alert(str1[1]);
				return false;
			}else if (str1[0] == "05"){
				alert(str1[1]);
				location.reload();
				return false;
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}

function TnDelComment(){
	<% If IsUserLoginOK() Then %>
		var str = $.ajax({
			type: "POST",
			url: "/event/etc/doEventSubscript79272.asp",
			data: $("#frmcom").serialize(),
			dataType: "text",
			async: false
		}).responseText;
		var str1 = str.split("||")
		console.log(str);
		if (str1[0] == "01"){
			alert(str1[1]);
			return false;
		}else if (str1[0] == "02"){
			alert(str1[1]);
			return false;
		}else if (str1[0] == "03"){
			alert(str1[1]);
			return false;
		}else if (str1[0] == "05"){
			alert(str1[1]);
			location.reload();
			return false;
		}else{
			alert('오류가 발생했습니다.');
			return false;
		}
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}

function jsGoComPage(iP){
	//alert("/event/eventmain.asp?eventid=<%=eCode%>&page="+iP + "#enteredList");
	document.frmcom.page.value = iP;
	<% if isApp=1 then %>
	location.href="/apps/appcom/wish/web2014/event/eventmain.asp?eventid=<%=eCode%>&page="+iP + "#enteredList"
	<% else %>
	location.href="/event/eventmain.asp?eventid=<%=eCode%>&page="+iP + "#enteredList"
	<% end if %>
	//document.frmcom.submit();
}
//-->
</script>
<div class="evt79272">
<form name="frm" id="frm" method="post" onsubmit="return false;">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/79272/m/txt_project_bar.png" alt="<%=InStr(retUrl,"cafe.naver.com")%>" /></p>
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/79272/m/tit_coffee.jpg" alt="텐바이텐이 커피 기프트 카드 100만원권을 쏩니다!" /></h2>
	<!-- 응모하기 -->
	<div class="enter">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/79272/m/txt_howto.png" alt="" /></h3>
		<div>
			<p><textarea name="comment" id="comment" placeholder="100자 이내로 입력해주세요!" rows="5"></textarea></p>
			<button class="btnEnter" onclick="chkevt();">응모하기</button>
		</div>
	</div>
	<% If myCom.Fcomment <> "" Then %>
	<div class="myCheck">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/79272/m/txt_mycheck.png" alt="나의 신청 내역" /></h3>
		<div>
			<p><textarea rows="4"><%=myCom.Fcomment%></textarea></p>
			<button class="btnEnter" onClick="TnDelComment();">삭제</button>
		</div>
	</div>
	<% End If %>
	<% If cEvtFan.FresultCount < 1 Then %>
	<% Else %>
	<!-- for dev msg : 5개씩 노출-->
	<div class="enteredList" id="enteredList">
		<ul>
			<% For i=0 To cEvtFan.FresultCount-1 %>
			<li>
				<span class="wirter"><% If cEvtFan.FItemList(i).Fdevice="M" Then %><img src="http://webimage.10x10.co.kr/eventIMG/2017/79272/icon_m.png" alt="모바일로 작성" /> <% End If %><%= printUserId(cEvtFan.FItemList(i).Fuserid,3,"*") %></span><!-- for dev msg : 모바일로 작성한 글 아이콘 표시 -->
				<span class="num">No.<%= (cEvtFan.FTotalCount - (cEvtFan.FPageCount * cEvtFan.FPageSize)) -i %></span>
				<span class="userContet"><%= cEvtFan.FItemList(i).Fcomment %></span>
			</li>
			<% Next %>
		</ul>
		<div class="pageWrapV15">
			<%= fnDisplayPaging_New(page,cEvtFan.FTotalCount,5,5,"jsGoComPage") %>
		</div>
	</div>
	<% End If %>

	<!-- 이벤트 유의사항 -->
	<div class="evntNoti">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/79272/m/tit_evnt_noti.png" alt="이벤트 유의사항" /></h3>
		<ul>
			<li>- 본 이벤트는 ID당 1번씩만 응모하실 수 있습니다.</li>
			<li>- 욕설 및 비속어는 삭제될 수 있습니다.</li>
			<li>- 당첨자 발표는 8월 2일 (수) 사이트 공지사항에 게시될 예정입니다.</li>
			<li>- 제세공과금은 텐바이텐 부담이며, 세무신고를 위해 개인정보를 요청할 수 있습니다.</li>
			<li>- 당첨된 기프티콘은 회원정보상의 핸드폰번호로 발송됩니다. 정확한 배송을 위해 개인정보를 업데이트해주세요.</li>
		</ul>
	</div>
</form>
</div>
<form method="post" name="frmcom" id="frmcom">
<input type="hidden" name="idx" value="<%=myCom.Fidx%>">
<input type="hidden" name="eCode" value="<%=eCode%>">
<input type="hidden" name="page" value="<%=page%>">
</form>
<%
Set cEvtFan = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->