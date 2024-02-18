<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.Charset="UTF-8"
%>
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<script type="text/javascript">
$(function() {
	$.ajax({
			url: "notice_ajax.asp?page=1",
			cache: false,
			success: function(message)
			{
				$("#noticenoticecontents").empty().append(message);
			}
	});
});

function jsViewNotice(a){
	var idHead = $("#noticeH"+a+"");
	var idView = $("#noticeV"+a+"");
	
	$(".noticeHead").next("div").slideUp(300);
	$(".noticeHead").removeClass('current');
	
	if(idHead.next("div").is(":visible")){
		idHead.next("div").slideUp(300);
		idHead.removeClass('current');
	} else {
		idHead.addClass('current');
		idView.slideUp(300);
		idHead.next("div").slideToggle(300);
		idHead.addClass('current');
	}
}

function jsNoticeList(){
	var pcnt = $("#pagecnt").val();
	pcnt = parseInt(pcnt)+1;
	$.ajax({
			url: "notice_ajax.asp?page="+pcnt+"",
			cache: false,
			success: function(message)
			{
				$("#noticenoticecontents").append(message);
				$("#pagecnt").val(pcnt);
			}
	});
}
</script>
</head>
<body>
<div class="wrapper" id="btwMypage">
	<div id="content">
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<div class="hWrap hrBlk">
				<h1 class="headingA">공지사항</h1>
			</div>
			
			<ul class="notice" id="noticenoticecontents">
			</ul>
			<div class="listAddBtn">
				<input type="hidden" name="pagecnt" id="pagecnt" value="1">
				<a href="javascript:" onClick="jsNoticeList();">공지사항 더 보기</a>
			</div>
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>