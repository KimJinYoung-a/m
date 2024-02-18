<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'###########################################################
' Description :  기프트
' History : 2015.02.09 한용민 생성
'###########################################################
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/gift/giftCls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/gift/Underconstruction_gift.asp" -->

<%
dim vCurrPage, vSort
	vCurrPage = requestCheckVar(Request("cpg"),5)
	vSort = requestCheckVar(Request("sort"),1)

If vCurrPage = "" Then vCurrPage = 1

If isNumeric(vCurrPage) = False Then
	Response.Write "<script>alert('잘못된 경로입니다.'); location.href='/';</script>"
	dbget.close()
	Response.End
End If
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript" src="/lib/js/jquery.masonry.min.js"></script>
<script type="text/javascript">
	
<!-- #include file="./inc_Javascript.asp" -->

var isloading=true;
$(function(){
	//첫페이지 로딩
	getList();

	//스크롤 이벤트 시작
	//$(window).unbind("scroll");
	$(window).scroll(function() {
      if ($(window).scrollTop() >= $(document).height() - $(window).height() - 350){
          if (isloading==false){
            isloading=true;
			var pg = $("#mygiftfrm input[name='cpg']").val();
			pg++;
			$("#mygiftfrm input[name='cpg']").val(pg);
            setTimeout("getList()",500);
          }
      }
    });
});

function getList() {
	var str = $.ajax({
			type: "GET",
	        url: "/apps/appCom/wish/web2014/gift/gifttalk/mytalk_act.asp",
	        data: $("#mygiftfrm").serialize(),
	        dataType: "text",
	        async: false
	}).responseText;

	if(str!="") {
    	if($("#mygiftfrm input[name='cpg']").val()=="1") {
        	$('#giftArticle').html(str);

			//$("#giftArticle").masonry({
			//	itemSelector: ".article",
			//	columnWidth:1
			//});
        } else {
       		//$('#giftArticle .box1').last().after(str);
       		$('#giftArticle').append(str);
       		//$str = $(str)
       		//$('.giftArticle').append($str).masonry('appended',$str);

        }
        isloading=false;
    } else {
    	$(window).unbind("scroll");
    }

	$('#giftArticle .cmtWrap').hide();
}

//코맨트리스트 아작스 호출
function getcommentlist_act(talkidx){
	var str = $.ajax({
			type: "GET",
	        url: "/apps/appCom/wish/web2014/gift/gifttalk/mytalk_comment_act.asp",
	        data: "talkidx="+talkidx,
	        dataType: "text",
	        async: false
	}).responseText;
	$('#comment'+talkidx).html(str);

	$('#comment'+talkidx).toggle();
	$('#commenttotal'+talkidx).toggleClass('on');
	return false;	
}

//코맨트 삭제
function DelComments(talkidx,cmtidx){
	<% IF not(IsUserLoginOK) THEN %>
		if(confirm("로그인을 하셔야 삭제할 수 있습니다.\n로그인 하시겠습니까?") == true) {
			fnAPPpopupLogin('<%=CurrURLQ()%>');
			return true;
		} else {
			return false;
		}
	<% end if %>

	if(confirm("선택한 글을 삭제하시겠습니까?") == true) {
		//'코멘트 idx 추가
		document.delfrm.gubun.value = "d";
		document.delfrm.idx.value = cmtidx;
		document.delfrm.talkidx.value = talkidx;
	
		var str = $.ajax({
			type: "GET",
	        url: "/apps/appcom/wish/web2014/gift/gifttalk/iframe_talk_comment_proc.asp",
	        data: $("#delfrm").serialize(),
	        dataType: "text",
	        async: false
		}).responseText;
		
		if (str.length=='2'){
			if (str=='d1'){
				location.href = "/apps/appCom/wish/web2014/gift/gifttalk/mytalk.asp";
			}else if (str=='99'){
				alert('로그인을 해주세요.');
				return;
			}
		}else{
			alert('정상적인 경로가 아닙니다.');
			return;
		}
	} else {
		return false;
	}
}
</script>

</head>
<body>

<div class="heightGrid">
	<div class="container bgGry" style="background-color:#e7eaea;">
		<!-- content area -->
		<div class="content giftV15a" id="contentArea" style="min-height:640px;">
			<% response.write fnTestLoginLabel() '//  app 쿠키 테스트용 %>
			<h1 class="hidden">GIFT</h1>
			<h2 class="hidden">MY TALK</h2>
			<form id="mygiftfrm" name="mygiftfrm" method="get" style="margin:0px;">
			<input type="hidden" name="cpg" value="1" />
			<input type="hidden" name="sort" value="<%=vSort%>" />
			<input type="hidden" name="beforepageminidx" />
			</form>
			<div id="giftArticle" class="giftArticle"></div>
			<p id="nodata" style="display:none;" class="noArticle">해당되는 GIFT TALK이 없습니다.</p>
			<p id="nodata_act" style="display:none;" class="noArticle">해당되는 GIFT TALK이 없습니다.</p>
			<form name="delfrm" id="delfrm" action="/apps/appCom/wish/web2014/gift/gifttalk/iframe_talk_comment_proc.asp" method="post" target="iframeproc">
				<input type="hidden" name="gubun" id="gubun" value="">
				<input type="hidden" name="talkidx" id="talkidx" value="">
				<input type="hidden" name="idx" value="">
				<input type="hidden" name="useyn" value="N">
			</form>
			<form name="frm1" action="/apps/appCom/wish/web2014/gift/gifttalk/mytalk_proc.asp" method="post">
				<input type="hidden" name="gubun" id="gubun" value="">
				<input type="hidden" name="userid" id="userid" value="<%=GetLoginUserID()%>">
				<input type="hidden" name="talkidx" id="talkidx" value="">
				<input type="hidden" name="mydell" value="m">
			</form>
			<iframe src="about:blank" name="iframeproc" frameborder="0" width="0" height="0"></iframe>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->