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
<!-- #include virtual="/event/etc/electricfanCls.asp" -->
<%
dim eCode, userid, currenttime, page, i
IF application("Svr_Info") = "Dev" THEN
	eCode = "66377"
Else
	eCode = "78770"
End If

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
cEvtFan.FPageSize = 3
cEvtFan.GetElectricFanList

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

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
dim snpTitle, snpLink, snpPre, snpTag, snpTag2
snpTitle = Server.URLEncode("[100 프로젝트] 선풍기")
snpLink = Server.URLEncode("http://10x10.co.kr/event/78770")
snpPre = Server.URLEncode("텐바이텐 이벤트")
snpTag = Server.URLEncode("텐바이텐 [100 프로젝트]선풍기")
snpTag2 = Server.URLEncode("#10x10")
''snpImg = Server.URLEncode(emimg)	'상단에서 생성
%>
<style type="text/css">
.enter > p {position:relative; }
.enter > p input {position:absolute; top:0; left:0; text-align:center; font-size:1.4rem; background-color:transparent; border:none; color:#227cdf; font-weight:bold;}
.enter > p input.inpTeam {left:17%; width:50.7%; height:100%;}
.enter > p input[type=tel] {top:11%; width:10.5%; height:61%;}
.enter > p input.inpNum1 {left:24%;}
.enter > p input.inpNum2 {left:35%;}
.enter .btnEnter {width:100%;}
.enter .enteredLayer {display:none; position:absolute; top:0; left:50%; width:100%; height:100%; margin-left:-50%; background-color:rgba(0,0,0,.5); z-index:10;}
.enter .enteredLayer div {position:relative; width:83.6%; margin:35% auto 0;}
.enter .enteredLayer div a {display:block; position:absolute; bottom:9.7%; left:14.5%; width:69.5%}
.enter .enteredLayer .btnClose {display:inline-block; position:absolute; top:-5%; right:-8%; width:30%; height:20%; background-color:transparent; text-indent:-999em;}
.enteredList {position:relative;}
.enteredList ul {position:absolute; top:20.31%; left:0; width:100%; height:100%;}
.enteredList ul li {position:relative; height:20.43%; padding:0 32.8% 0 13.2%; background:url(http://webimage.10x10.co.kr/eventIMG/2017/78770/m/bg_entered_list.jpg) no-repeat 50% 0; background-size:100%; font-size:1.25rem; line-height:1.7rem; color:#fff;}
.enteredList ul li > .num,
.enteredList ul li > .wirter{color:#5cc8ff; font-size:1rem;}
.enteredList ul li .num {position:relative; top:25.32%;}
.enteredList ul li .userContet {position:relative; top:23.34%;}
.enteredList ul li .userContet em {color:#ffea59; font-weight:bold;}
.enteredList ul li .userContet .team {overflow:hidden; display:inline-block; position:relative; top:0; max-width:75%; max-height:1.3rem; font-size:1.05rem; line-height:1.5rem; vertical-align:top; letter-spacing:.03rem;}
.enteredList ul li .wirter {position:absolute; bottom:11.6%; right:11.56%;}
.enteredList .pageWrapV15 {position:absolute; bottom:9.5%; left:0; width:100%; height:5.3%;}
.enteredList .paging {height:100%; margin:0;}
.enteredList .paging a.arrow {display:inline-block; width:2.5%; height:3.2%;}
.enteredList .paging a span {position:relative; width:2.1rem; height:2.1rem; margin:0 .6rem; border:none; color:#e8f0f9; font-weight:bold; font-size:1.2rem; line-height:2.3rem;}
.enteredList .paging a.arrow span {position:absolute; top:0.35rem; width:2.5%;}
.enteredList .paging a.arrow.first span {left:15.31%;}
.enteredList .paging a.arrow.end span {right:15.31%;}
.enteredList .paging a.current span {background-color:#ffe953; color:#1568c4; border-radius:50%;}
.shareSns {position:relative;}
.shareSns ul {position:absolute; top:0; right:0; width:50%; height:100%;}
.shareSns ul li{position:absolute; top:0; width:50%; height:100%;}
.shareSns ul li:nth-child(1){left:0;}
.shareSns ul li:nth-child(2){right:0;}
.shareSns ul li a {display:inline-block; width:100%; height:100%; text-indent:-999em;}
.evntNoti ul {padding:2rem 3rem 2rem 2.8rem; background-color:#252525; color:#fff; font-size:1.1rem; line-height:1.7rem;}
.evntNoti ul li {text-indent:-.8rem;}
</style>
<script type="text/javascript">
$(function(){
	//응모완료 레이어 팝업
	$(".enteredLayer").hide();
	$(".enteredLayer .btnClose").click(function(){
		$(".enteredLayer").hide();
	});
});

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
	if (GetByteLength(frm.teamname.value) > 32){
		alert("32자 까지 작성 가능합니다.");
		frm.teamname.focus();
		return false;
	}
	if (frm.teamname.value==""){
		alert("빈칸을 정확하게 모두 채워 주세요.");
		frm.teamname.focus();
		return false;
	}
	if (!IsDigit(frm.num1.value)){
		alert("숫자만 작성 가능합니다.");
		frm.num1.focus();
		return false;
	}
	if (!IsDigit(frm.num2.value)){
		alert("숫자만 작성 가능합니다.");
		frm.num2.focus();
		return false;
	}
	if (frm.num1.value=="" && frm.num2.value==""){
		alert("빈칸을 정확하게 모두 채워 주세요.");
		frm.num1.focus();
		return false;
	}
	jsEventSubmit();
	<% End IF %>
}

function jsEventSubmit(){
	<% If IsUserLoginOK() Then %>
		<% If now() > #07/09/2017 23:59:59# then %>
			alert("이벤트 기간이 아닙니다.");
			return false;
		<% else %>
			var str = $.ajax({
				type: "POST",
				url: "/event/etc/doEventSubscript78770.asp",
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
				//응모완료 레이어 팝업
				window.parent.$('html,body').animate({scrollTop:$(".fanHead").offset().top},300);
				$('.enteredLayer').show();
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

function jsGoComPage(iP){
	document.frmcom.page.value = iP;
	<% if isApp=1 then %>
	location.href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=eCode%>&page="+iP + "#enteredList";
	<% else %>
	location.href="/event/eventmain.asp?eventid=<%=eCode%>&page="+iP + "#enteredList";
	<% end if %>
	//document.frmcom.submit();
}

function tnKakaoLink(){
<% if isApp=1 then %>
	parent_kakaolink('[10x10=100 프로젝트 ①선풍기]\n\n지금, 텐바이텐이 선풍기 100개를 쏩니다!\n\n이벤트 참여하고 친구들과 함께 시원한 여름 보내세요.\n\n함께할수록 당첨확률이 UP!', 'http://webimage.10x10.co.kr/eventIMG/2017/78770/etcitemban20170629213751.JPEG' , '200' , '200' , 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=78770');
	return false;
<% Else %>
	parent_kakaolink('[10x10=100 프로젝트 ①선풍기]\n\n지금, 텐바이텐이 선풍기 100개를 쏩니다!\n\n이벤트 참여하고 친구들과 함께 시원한 여름 보내세요.\n\n함께할수록 당첨확률이 UP!' , 'http://webimage.10x10.co.kr/eventIMG/2017/78770/etcitemban20170629213751.JPEG' , '200' , '200' , 'http://m.10x10.co.kr/event/eventmain.asp?eventid=78770');
	return false;
<% End If %>
}
</script>
<div class="evt78770">
<form name="frm" id="frm" method="post">
	<div class="fanHead">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/78770/m/tit_fan.jpg" alt="10X10 = 100프로젝트 선풍기 무더운 여름, 텐바이텐이 선풍기 100대 를 쏩니다! 이벤트 기간은 07월 03일부터 07월.09일 입니다. 당첨자 발표는 07월 12일 수요일입니다." /></h2>
		<div class="prd">
			<a class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78770/m/img_prd_1.jpg" alt="OA 슈퍼팬 핸디미니선풍기" /></a>
			<a class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78770/m/img_prd_1.jpg" alt="OA 슈퍼팬 핸디미니선풍기" /></a>
		</div>
	</div>

	<!-- 응모하기 -->
	
	<div class="enter">
		<p class="">
			<img src="http://webimage.10x10.co.kr/eventIMG/2017/78770/m/txt_input_1.jpg" alt="***과(와)" />
			<input type="text" name="teamname" class="inpTeam" placeholder="함께 받고 싶은 모임/팀" maxlength="32"/>
		</p>
		<p>
			<img src="http://webimage.10x10.co.kr/eventIMG/2017/78770/m/txt_input_2.jpg" alt="선풍기 **대를 받고 싶습니다." />
			<!-- for dev msg // 숫자만 입력되도록 해주세요.-->
			<input type="tel" name="num1" class="inpNum1" placeholder="9" maxlength="1"/>
			<input type="tel" name="num2" class="inpNum2" placeholder="9" maxlength="1"/>
		</p>
		<button class="btnEnter" onclick="chkevt();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78770/m/btn_enter.jpg" alt="응모하기" /></button>

		<!-- 응모 완료 팝업 레이어-->
		<div class="enteredLayer" style="display:none">
			<div>
				<img src="http://webimage.10x10.co.kr/eventIMG/2017/78770/m/txt_completed.png" alt="응모가 완료되었습니다! 당첨되신 고객님께는 회원 정보상의 기본주소로 선풍기가 배송됩니다 개인정보를 업데이트해주세요!" />
				<!-- for dev msg 개인 정보 수정 페이지 링크 -->
				<a href="/my10x10/userinfo/membermodify.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78770/m/bnt_check_info.png" alt="내 정보 확인하기" /></a>
				<button type="button" class="btnClose">닫기</button>
			</div>
		</div>
	</div>
	
	<!-- 응모 참여 방법 -->
	<div class="howToEnter">
		<img src="http://webimage.10x10.co.kr/eventIMG/2017/78770/m/txt_how_to_enter.jpg" alt="Step 01 선풍기를 함께 받고 싶은 모임의 이름을 적는다 Step 02 필요한 선풍기의 수량을 적고 응모하면 완료!" />
	</div>
	<!-- for dev msg//  다른 친구들의 신청 현황 // 3개씩 노출-->
	<div class="enteredList" id="enteredList">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/78770/m/tit_entered_list.jpg" alt="다른 친구들의 신청 현황" /></h3>
		<ul>
			<% If cEvtFan.FresultCount < 1 Then %>
			<% Else %>
			<% For i=0 To cEvtFan.FresultCount-1 %>
			<li>
				<p class="num">No.<%= (cEvtFan.FTotalCount - (cEvtFan.FPageCount * cEvtFan.FPageSize)) -i %></p>
				<p class="userContet"><em class="team"><%= cEvtFan.FItemList(i).Fteamname %></em>과(와)<br/ > 선풍기 <em class="num"><%= cEvtFan.FItemList(i).Fnum %>대</em>를 받고 싶습니다!</p>
				<span class="wirter"><%= printUserId(cEvtFan.FItemList(i).Fuserid,3,"*") %></span>
			</li>
			<% Next %>
			<% End If %>
		</ul>
		<div class="pageWrapV15">
			<%= fnDisplayPaging_New(page,cEvtFan.FTotalCount,3,5,"jsGoComPage") %>
		</div>
	</div>

	<!-- sns 공유 -->
	<div class="shareSns">
		<img src="http://webimage.10x10.co.kr/eventIMG/2017/78770/m/txt_sns_share.jpg" alt="친구들에게 공유하면 당첨 확률이 올라가요" />
		<ul>
			<li><a href="" onclick="tnKakaoLink();return false;">카카오톡 공유</a></li>
			<li><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;">페이스북 공유</a></li>
		</ul>
	</div>

	<!-- 이벤트 유의사항 -->
	<div class="evntNoti">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/78770/m/tit_evnt_noti.png" alt="이벤트 유의사항" /></h3>
		<ul>
			<li>- 본 이벤트는 하루에 1번씩만 응모할 수 있습니다.</li>
			<li>- 당첨자 발표는 7월 12일(수) 사이트 공지사항에 게시될 예정입니다.</li>
			<li>- 당첨되신 분들께는 선풍기가 신청하신 수량대로 한 번에 배송됩니다.</li>
			<li>- 정확한 배송을 위해 마이텐바이텐의 개인정보를 업데이트 해주세요.</li>
		</ul>
	</div>
</form>
</div>
<form method="post" name="frmcom">
<input type="hidden" name="eCode" value="<%=eCode%>">
<input type="hidden" name="page" value="<%=page%>">
</form>
<%
Set cEvtFan = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
