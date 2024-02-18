<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	History	: 2014.09.17 한용민 생성
'	Description : CS Center
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/cscenter/boardfaqcls.asp" -->

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css">
<script type="text/javascript">

function fnCallCsTel() {
	var dtNow = new Date();
	// 요일검사
	if(dtNow.getDay()==0||dtNow.getDay()==6) {
		alert("주말,공휴일은 휴무입니다.");
		return;
	}
	// 시간검사
	if(dtNow.getHours()>=9&&dtNow.getHours()<18) {
		if(dtNow.getHours()==12) {
			alert("점심시간은 PM 12:00 ~ PM 01:00 입니다.");
			return;
		} else {
			self.location="tel:1644-6030";
		}
	} else {
		alert("고객행복센터 운영시간은 AM 09:00 ~ PM 06:00입니다.");
		return;
	}
}

</script>
</head>
<body class="mypage">
	<!-- modal#resendAuthcode  -->
	<div class="modal popup" id="csCenter">
		<div class="box" style="top:50%;margin-top:-160px;">
			<header class="modal-header">
				<h1 class="modal-title">고객센터 전화연결</h1>
				<a href="#csCenter" class="btn-close">&times;</a>
			</header>
			<div class="modal-body no-padding">
				<div class="inner">
					<div class="t-c inner">
						<p class="tMar25">텐바이텐 고객센터로 전화하시겠어요?</p>
					</div>
				</div>
			</div>
			<footer class="modal-footer">
				<div class="two-btns overHidden" style="margin-left:0;">
					<div class="col"><a href="" onclick="fnCallCsTel(); return false;" class="btn type-b full-size">확인</a></div>
					<div class="col"><a href="" onclick="fnCloseModal(); return false;" class="btn type-a full-size">취소</a></div>
				</div>
				<p class="t-c tPad5 lh12">상담시간은 평일 09:00 ~ 18:00이며<br />점심시간은 12:00 ~ 01:00까지 입니다.</p>
			</footer>
		</div>
	</div>
	<!-- modal#resendAuthcode  -->
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->