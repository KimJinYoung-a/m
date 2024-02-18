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
'해더 타이틀
strHeadTitleName = "입고 알림 신청 내역"

'####################################################
' Description : 마이텐바이텐 - 입고 알림 신청 내역
' History : 2018-01-30 원승현 
'####################################################
Dim page, pagesize, RMaxId, sqlStr

'// 페이지 사이즈
pagesize = 20

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript">

	vScrl=true;
	$(function(){
		getMyAlarmViewList();
	});

	function btnCancelCk(idx)
	{
		$("#Rmode").val("Cancel");
		$("#Ridx").val(idx);
		if (confirm("신청하신 입고 알림을 취소하시겠습니까?")) {
			$.ajax({
				type:"GET",
				url:"act_MyAlarmHistory.asp",
				data: $("#frmMyAlarmViewVal").serialize(),
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data, textStatus, jqXHR){
						if (jqXHR.readyState == 4) {
							if (jqXHR.status == 200) {
								if(Data=="OK") {
									$("#StatusBtn"+idx).hide();
									$("#Status"+idx).empty().html("취소");
								}
							}
						}
				},
				error:function(jqXHR, textStatus, errorThrown){
					alert("잘못된 접근 입니다.");
					//var str;
					//for(var i in jqXHR)
					//{
					//	 if(jqXHR.hasOwnProperty(i))
					//	{
					//		str += jqXHR[i];
					//	}
					//}
					//alert(str);
					//document.location.reload();
					return false;
				}
			});
		}
		else {
			return false;
		}
	}

	function getMyAlarmViewList()
	{
		$("#Rmode").val("list");
		$.ajax({
			type:"GET",
			url:"act_myalarmhistory.asp",
			data: $("#frmMyAlarmViewVal").serialize(),
			dataType: "text",
			async:false,
			cache:true,
			success : function(Data, textStatus, jqXHR){
					//$str = $(Data);
					res = Data.split("||");
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
								if($("#Rstdnum").val()=="1") {
									$('#myAlarmDiv').empty().html(res[0]);
									vScrl=true;
								} else {
									$('#myAlarmDiv').append(res[0]);
									vScrl=true;
								}
							} else {
								//alert("상품이 없습니다.");
							}
						}
					}
			},
			error:function(jqXHR, textStatus, errorThrown){
				alert("잘못된 접근 입니다.");
				var str;
				for(var i in jqXHR)
				{
					 if(jqXHR.hasOwnProperty(i))
					{
						str += jqXHR[i];
					}
				}
				//alert(str);
				//document.location.reload();
				return false;
			}
		});
	}


	<%'// 스크롤시 추가페이지 접수%>
	$(window).scroll(function() {
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-1200){
			if(vScrl) {
				vScrl = false;
				//alert((parseInt($("#Rstdnum").val())+<%=pagesize%>));
				$("#Rstdnum").val((parseInt($("#Rstdnum").val())+1));
				getMyAlarmViewList();
			}
		}
	});

	// 로딩중 표시
	$("#lyLoading").ajaxStart(function(){
		$(this).show();
	}).ajaxStop(function(){
		$(this).hide();
	});


	function hasScrolled() {
		var st = $(this).scrollTop();

		if(Math.abs(lastScrollTop - st) <= delta)
			return;

		if (st > lastScrollTop && st){
			// Scroll Down
			$("#gotop").removeClass("nav-down").addClass("nav-up");
		} else {
			// Scroll Up
			if(st + $(window).height() < $(document).height()) {
				$("#gotop").removeClass("nav-up").addClass("nav-down");
			}
		}
		lastScrollTop = st;
	}
</script>
</head>
<body class="default-font body-sub">
	<form name="frmMyAlarmViewVal" id="frmMyAlarmViewVal" method="post">
		<input type="hidden" name="Rstdnum" id="Rstdnum" value="1">
		<input type="hidden" name="Rpagesize" id="Rpagesize" value="<%=pagesize%>">
		<input type="hidden" name="Rmode" id="Rmode" value="">
		<input type="hidden" name="RUserId" id="RUserId" value="<%=tenEnc(getEncLoginUserID)%>">
		<input type="hidden" name="RPrevDateValue" id="RPrevDateValue" value="-3">
		<input type="hidden" name="RPrevDateType" id="RPrevDateType" value="m">
		<input type="hidden" name="Ridx" id="Ridx">
	</form>
	<!-- contents -->
	<div id="content" class="content stock-inform my-stock">
		<%' 입고 알림 신청 notice (공통)%>
		<div class="noti">
			<h3>신청 정보</h3>
			<ul>
				<li>고객님께서 3개월 이내에 입고 알림 신청하신 목록으로 선택하신 기간 내에 구매 가능할 경우 알림 메시지를 보내드립니다. <br/>※ PC/모바일 웹은 문자 발송되며, 모바일 앱에서 신청하신 건은 Push발송 됩니다.</li>
				<li>3개월 이전의 신청 정보는 PC에서 확인 할 수 있습니다.</li>
				<li>알림을 받으신 뒤 구매 시점에 따라 품절이 발생할 수 있으며, 판매가는 신청 시점과 차이가 날 수 있습니다.</li>
			</ul>
		</div>

		<div id="myAlarmDiv"></div>

		<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
	</div>
	<!-- //contents -->
	<div id="gotop" class="btn-top" onclick="fnAPPpopupScrollToTOP();"><button type="button">맨위로</button></div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->