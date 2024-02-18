<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<% const MenuSelect = "" %>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appCom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/cscenter/myqnacls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/designfingers/designfingersCls.asp" -->
<!-- #include virtual="/lib/classes/designfingers/dfCommentCls.asp" -->
<%
dim page
dim i, j, lp

page = request("page")
if (page = "") then page = 1

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script>
var isloading=true;
$(function(){
	//첫페이지 접수
	getList();

	//스크롤 이벤트 시작
	$(window).scroll(function() {
      if ($(window).scrollTop() >= $(document).height() - $(window).height() - 350){
          if (isloading==false){
            isloading=true;
			var pg = $("#frmItem input[name='page']").val();
			pg++;
			$("#frmItem input[name='page']").val(pg);
            setTimeout("getList()",500);
          }
      }
    });
});

function getList() {
	var str = $.ajax({
			type: "GET",
	        url: "myqnalist_act.asp",
	        data: $("#frmItem").serialize(),
	        dataType: "text",
	        async: false
	}).responseText;

	if(str!="") {
    	if($("#frmItem input[name='page']").val()=="1") {
        	$('#lySearchResult').html(str);
        } else {
       		$('#lySearchResult').append(str);
        }
        reMapStarAction();
        isloading=false;
    } else {
    	//더이상 자료가 없다면 스크롤 이벤트 종료
    	$(window).unbind("scroll");
    }
}

//qna 삭제
function DelQna(id){
	if (confirm('삭제 하시겠습니까?\n답변이 완료된 경우 답변까지 삭제됩니다.')){
		document.delfrm.mode.value='DEL';
		document.delfrm.id.value=id;
		document.delfrm.submit();
	}
}

function reMapStarAction() {
	$('.stars a').unbind('click');
	$('.stars a').each(function(index){
		$(this).on('click', function(){
			$('.stars a').addClass('active');
			$('.stars a:gt('+index+')').removeClass('active');
			var rate = index+1;
			console.log(rate);

			$('#evalPoint').attr("value",rate);
			return false;
		});
	});
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<!-- content area -->
		<form name="delfrm" method="post" action="myqna_process.asp" onsubmit="return false;">
			<input type="hidden" name="mode" value="del">
			<input type="hidden" name="id" value="">
		</form>
		<div class="content myQna" id="contentArea">
			<div class="inner10">
				<ul class="cpNoti">
					<li>한번 등록한 상담내용은 수정이 불가능합니다. 수정을 원하시는 경우, 삭제 후 재등록 하셔야 합니다.</li>
					<li>1:1 상담은 24시간 신청가능하며 접수된 내용은 빠른 시간내에 답변을 드리도록 하겠습니다.<br />문의하신 1:1 상담은 고객님의 메일로도 확인하실 수 있습니다.</li>
				</ul>
				<p class="ct tMar20"><span class="button btB1 btRed cWh1 w70p"><a href="myqnawrite.asp"><%=CHKIIF(IsVIPUser()=True,"VIP ","")%>1:1 상담 신청하기<em class="rdArr3"></em></a></span></p>
				<ul id="myqnanodata" style="display:none;" class="myQnaList">
					<li class="noData"><p>문의하신 <%=CHKIIF(IsVIPUser()=True,"VIP ","")%>1:1상담내역이 없습니다.</p></li>
				</ul>
				<div class="inner" id="lySearchResult"></div>
			</div>
		</div>
		<form id="frmItem" name="frmItem" method="get">
			<input type="hidden" name="page" value="">
		</form>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
