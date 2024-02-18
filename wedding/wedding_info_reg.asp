<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
Dim yyyy, mm, dd, ix, userid

yyyy=year(now())
userid = getloginuserid()

Function ZeroTime(hs)
	If hs<10 Then
		ZeroTime="0"+hs
	Else
		ZeroTime=hs
	End If
End Function

Dim sqlStr, UserName, Sex, PartnerName, WeddingDate, SMS, Email, DateArr, Dday, mode
sqlStr = "SELECT top 1 UserName, Sex, PartnerName, WeddingDate, SMS, Email FROM [db_sitemaster].[dbo].[tbl_wedding_user_info] WHERE isusing='Y' and userid='"&userid&"'"
rsget.CursorLocation = adUseClient
rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
	UserName = rsget("UserName")
	Sex  = rsget("Sex")
	PartnerName = rsget("PartnerName")
	WeddingDate = rsget("WeddingDate")
	SMS = rsget("SMS")
	Email = rsget("Email")
	mode="edit"
Else
	Sex="F"
	WeddingDate=yyyy&"-"&Month(now())&"-"&Day(now())
	SMS="Y"
	Email ="Y"
	mode="add"
End IF
rsget.close

DateArr = split(WeddingDate,"-")
Dday = DateDiff("D",Now(),WeddingDate)
%>
<link rel="stylesheet" type="text/css" href="/lib/css/wedding2018.css?v=1.01" />
<script type="text/javascript">
<!--

	$(function () {
		if($('#gotop').hasClass('btn-top')){
			console.log('ok');
			$('.btn-top').css({'opacity':'0'});
		}
	});

	function fnSelectYear(objval){
		document.wfrm.yyyy.value=objval;
	}
	function fnSelectMonth(objval){
		document.wfrm.mm.value=objval;
	}
	function fnSelectDay(objval){
		document.wfrm.dd.value=objval;
	}
	function fnWeddingInfo(){
		var frm=document.wfrm;
		if(frm.username.value=="")
		{
			alert("이름을 입력해 주세요.");
			frm.username.focus();
		}
		else if(frm.partnername.value=="")
		{
			alert("배우자 이름을 입력해 주세요.");
			frm.partnername.focus();
		}
		else if(frm.yyyy.value=="")
		{
			alert("결혼 예정일을 선택해 주세요.");
		}
		else if(frm.mm.value=="")
		{
			alert("결혼 예정일을 선택해 주세요.");
		}
		else if(frm.dd.value=="")
		{
			alert("결혼 예정일을 선택해 주세요.");
		}
		else if(!$("#agreeY").is(":checked"))
		{
			alert("개인정보 수집에 동의해주세요.");
		}
		else
		{
			var smscheck;
			var emailcheck;
			if($("#sms").is(":checked"))
			{
				 smscheck="Y";
			}
			else
			{
				 smscheck="N";
			}
			if($("#email").is(":checked"))
			{
				 emailcheck="Y";
			}
			else
			{
				 emailcheck="N";
			}
			var str = $.ajax({
				type: "POST",
				url: "/wedding/doweddinginfo.asp",
				data: {
					mode:$("#mode").val(),
					yyyy:$("#yyyy").val(),
					mm:$("#mm").val(),
					dd:$("#dd").val(),
					username:$("#username").val(),
					sex:$("input:radio[name='sex']:checked").val(),
					partnername:$("#partnername").val(),
					sms:smscheck,
					email:emailcheck
				},
				dataType: "text",
				async: false
			}).responseText;
			var str1 = str.split("|")
			if (str1[0] == "98"){
				opener.location.reload();
				alert('정상 등록 되었고 쿠폰이 발급되었습니다.');
				self.close();
				return false;
			}else if (str1[0] == "99"){
				alert('수정 되었습니다.');
				opener.location.reload();
				self.close();
				return false;
			}else if (str1[0] == "97"){
				alert('삭제 되었습니다.');
				opener.location.reload();
				self.close();
				return false;
			}else if (str1[0] == "02"){
				alert('로그인 후 참여 가능합니다.');
				return false;
			}else if (str1[0] == "01"){
				alert('잘못된 접속입니다.');
				return false;
			}else if (str1[0] == "03"){
				alert('정상적인 경로가 아닙니다.');
				return false;
			}else if (str1[0] == "04"){
				alert('일정이 지난 결혼 예정일은 등록이 불가능합니다.');
				return false;
			}else if (str1[0] == "06"){
				opener.location.reload();
				alert('정상 등록 되었습니다.');
				self.close();
				return false;
			}else{
				alert(str1[1]);
				return false;
			}
		}
	}
	
	function fnCloseWin(){
		event.preventDefault();
		$('.enroll-day').fadeOut();
	}
	
	function fnAddWeddingInfo(){
		event.preventDefault();
		$('.enroll-day').fadeIn();
		window.parent.$('html,body').animate({scrollTop:$(".enroll-day").offset().top+40},600);
	}

	function fnWeddingDel(){
		document.wfrm.mode.value="del";
		fnWeddingInfo();
	}
//-->
</script>
</head>
<body class="default-font body-popup">
	<header class="tenten-header header-popup">
		<div class="title-wrap">
			<h1>디데이 등록하기</h1>
			<button type="button" class="btn-close" onclick="self.close();">닫기</button>
		</div>
	</header>

	<!-- contents -->
	<div id="content" class="content wedding2018">
		<div class="enroll-day">
		<form method="post" name="wfrm">
		<input type="hidden" name="mode" id="mode" value="<%=mode%>">
		<input type="hidden" name="yyyy" id="yyyy" value="<%=DateArr(0)%>">
		<input type="hidden" name="mm" id="mm" value="<%=DateArr(1)%>">
		<input type="hidden" name="dd" id="dd" value="<%=DateArr(2)%>">
			<div class="enroll-head">
				<h2>Wedding<br/ > D-Day</h2>
				<p>웨딩일을 등록하시면, 쿠폰을 발급해드립니다</p>
			</div>
			<div class="enroll-conts">
				<table>
					<tr>
						<th>본인 이름</th>
						<td><input type="text" name="username" id="username" value="<%=UserName%>" maxlength="7" placeholder="김천생" /></td>
					</tr>
					<tr>
						<th>본인 성별</th>
						<td class="select-sex">
							<p><input type="radio" id="male" name="sex" id="sex" value="M"<% If Sex="M" Then Response.write " checked"%> /><label for="male">남 </label></p>
							<p><input type="radio" id="female" name="sex" id="sex" value="F"<% If Sex="F" Then Response.write " checked"%> /><label for="female">여 </p></label>
						</td>
					</tr>
					<tr>
						<th>배우자 이름</th>
						<td><input type="text" name="partnername" id="partnername" value="<%=PartnerName%>" maxlength="7" placeholder="이연분" /></td>
					</tr>
					<tr>
						<th>결혼 예정일</th>
							<td>
								<div class="select-year select-date styled-selectbox styled-selectbox-default">
									<select class="select" title="결혼 예정 년도 선택옵션" onchange="fnSelectYear(this.value);">
										<% For ix=yyyy To yyyy+1%>
										<option value="<%=ix%>"<% If DateArr(0)=ix Then Response.write " selected" %>><%=ix%></option>
										<% Next %>
									</select>
								</div>
								<div class="select-month select-date styled-selectbox styled-selectbox-default">
									<select class="select" title="결혼 예정 월 선택옵션" onchange="fnSelectMonth(this.value);">
										<% For ix=1 To 12 %>
										<option value="<%=ZeroTime(Cstr(ix))%>"<% If CInt(DateArr(1))=CInt(ix) Then Response.write " selected" %>><%=ZeroTime(Cstr(ix))%></option>
										<% Next %>
									</select>
								</div>
								<div class="select-day select-date styled-selectbox styled-selectbox-default">
									<select class="select" title="결혼 예정 일 선택옵션" onchange="fnSelectDay(this.value);">
										<% For ix=1 To 31 %>
										<option value="<%=ZeroTime(Cstr(ix))%>"<% If CInt(DateArr(2))=CInt(ix) Then Response.write " selected" %>><%=ZeroTime(Cstr(ix))%></option>
										<% Next %>
									</select>
								</div>
							</td>
					</tr>
					<!-- <tr>
						<th style="line-height:1; vertical-align:top; padding-top:14px;">정보 수신 동의</th>
						<td class="agree-info">
							수신 동의를 하시면 텐바이텐의 다양한 혜택과 이벤트/신상품 등의 정보를 만나실 수 있습니다.
							<div class="agree-box">
								<p><input type="checkbox" id="sms" name="sms" value="Y" <% If SMS="Y" Then Response.write " checked"%>><label for="sms">SMS</label></p>
								<p><input type="checkbox" id="email" name="email" value="Y" <% If Email="Y" Then Response.write " checked"%>><label for="email">E-Mail</label></p>
							</div>
						</td>
					</tr> -->
				</table>
			</div>
			<div class="agree-privacy">
				<div class="policy">
					<div class="txt">
						<h4>[수집하는 개인정보 항목 및 수집방법]</h4>
						<div>1. 수집하는 개인정보의 항목<br/> 회사는 해당이벤트의 원활한 고객상담, 각종 서비스의 제공을 위해 아래와 같은 최소한의 개인정보를 필수항목을 수집하고 있습니다. - 아이디, 이름, 성별, 생년월일, 이메일주소, 휴대폰번호, 가입인증정보</div>
						<div>2. 개인정보 수집에 대한 동의<br/>회사는 귀하께서 텐바이텐의 개인정보취급방침에 따른 이벤트 이용약관의 내용에 대해 동의 절차를 마련하여, 「동의」버튼을 클릭하면 개인정보 수집에 대해 동의한 것으로 봅니다.</div>
						<h4>[개인정보의 수집목적 및 이용 목적]</h4>
						<div> 1. 이벤트 참여를 위한 관련 정보 수집 및 증빙 확인 목적 </div>
						<div>2. 고지사항 전달, 본인 의사 확인, 불만 처리 등 원활한 의사소통 경로의 확보</div>
						<h4>[개인정보의 보유 및 파기 절차]</h4>
						<div>1. 설문조사, 이벤트 등 일시적 목적을 위하여 수집한 경우 : 당해 설문조사, 이벤트 등의 종료 시점</div>
						<div>2. 회사는 원칙적으로 개인정보 수집 및 이용목적이 달성되면 해당 정보를 지체 없이 파기합니다. 파기절차 및 방법은 다음과 같습니다.</div>
						<div>① 파기절차 : 귀하가 이벤트등록을 위해 입력하신 정보는 이벤트가 완료 된 후 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라 일정 기간 저장된 후 파기되어집니다.</div>
						<div>② 파기대상 : 배우자 정보, 성별, 결혼 예정일</div>
					</div>
				</div>
			</div>
			<div class="agree-wrap">
				<div class="agree-box"><p><input type="checkbox" id="agreeY" name="agreeY" value="Y" checked="checked"><label for="agreeY">본 이벤트 참여를 위한 개인정보 수집에 동의합니다.</label></p></div>
				<% If UserName<>"" Then %>
				<ul class="btn-enroll modify">
					<li><a href="javascript:fnWeddingDel();">삭제하기</a></li>
					<li><a href="javascript:fnWeddingInfo();">수정하기</a></li>
				</ul>
				<% Else %>
				<button class="btn-enroll" onclick="fnWeddingInfo();return false;">등록하기</button>
				<% End If %>
			</div>
		</div>
		</form>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->