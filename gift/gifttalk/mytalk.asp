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
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/gift/giftCls.asp" -->
<!-- #include virtual="/gift/Underconstruction_gift.asp" -->

<%
dim vCurrPage, vSort, PageSize
	vCurrPage = requestCheckVar(Request("cpg"),5)
	vSort = requestCheckVar(Request("sort"),1)

If vCurrPage = "" Then vCurrPage = 1
PageSize=10

If isNumeric(vCurrPage) = False Then
	Response.Write "<script>alert('잘못된 경로입니다.'); location.href='/';</script>"
	dbget.close()
	Response.End
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript" src="/lib/js/jquery.masonry.min.js"></script>
<script type="text/javascript">
	
<!-- #include file="./inc_Javascript.asp" -->

var isloading=true;
$(function(){
	// 저장된 해쉬 값을 불러와 셋팅
	 if(document.location.hash){
	 	//alert( document.location.hash );
		var str_hash = document.location.hash;
		str_hash = str_hash.replace("#","");
		var varr_curpage=str_hash.split("^");
		var vTsn=varr_curpage[0];
		var vPsz=varr_curpage[1];
		$("#cpg").val("1");
		$("#psz").val(vPsz);
		getList();
		$('body, html').delay(500).animate({ scrollTop: vTsn }, 50);
	 }else{
		//첫페이지 접수
		getList();
	}

	//스크롤 이벤트 시작
	//$(window).unbind("scroll");
	$(window).scroll(function() {
      if ($(window).scrollTop() >= $(document).height() - $(window).height() - 400){
          if (isloading==false){
            isloading=true;
			var pg = $("#mygiftfrm input[name='cpg']").val();
			pg++;
			$("#mygiftfrm input[name='cpg']").val(pg);

            setTimeout("getList()",150);
          }
      }
    });
});

function getList() {
	var str = $.ajax({
			type: "GET",
	        url: "/gift/gifttalk/mytalk_act.asp",
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

$("#Hlink1").live("click", function(e) {
	var tpsz;
	//tpsz = (Number($("#cpg").val())+1)*Number($("#psz").val());
	tpsz = (Number($("#cpg").val()))*Number($("#psz").val());
	document.location.hash=document.body.scrollTop+"^"+tpsz

});

$("#Hlink2").live("click", function(e) {
	var tpsz2;
	//tpsz2 = (Number($("#cpg").val())+1)*Number($("#psz").val());
	tpsz2 = (Number($("#cpg").val()))*Number($("#psz").val());
	document.location.hash=document.body.scrollTop+"^"+tpsz2
});

//코맨트리스트 아작스 호출
function getcommentlist_act(talkidx){
	var str = $.ajax({
			type: "GET",
	        url: "/gift/gifttalk/mytalk_comment_act.asp",
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
			parent.location.href = "<%=M_SSLUrl%>/login/login.asp?backpath=/gifttalk/mytalk.asp";
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
	        url: "/gift/gifttalk/iframe_talk_comment_proc.asp",
	        data: $("#delfrm").serialize(),
	        dataType: "text",
	        async: false
		}).responseText;
		
		if (str.length=='2'){
			if (str=='d1'){
				location.href = "/gift/gifttalk/mytalk.asp";
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

function closeTalkDivx() {
	<% if InStr(request.ServerVariables("HTTP_REFERER"),"/gift/gifttalk/mytalk.asp")>0 then %>
		top.location.href='/gift/gifttalk/mytalk.asp';
	<% else %>
		top.location.href='/gift/gifttalk/';
	<% end if %>
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin" style="background-color:#e7eaea;">
		<div class="header">
			<h1>내가 쓴 글</h1>
			<p class="btnPopClose"><button class="pButton" onclick="closeTalkDivx();">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content giftV15a" id="contentArea">
			<h2 class="hidden">MY TALK</h2>
			<form id="mygiftfrm" name="mygiftfrm" method="get" style="margin:0px;">
			<input type="hidden" name="cpg" id="cpg" value="<%= vCurrPage %>" />
			<input type="hidden" name="psz" id="psz" value="<%=PageSize%>">
			<input type="hidden" name="sort" value="<%=vSort%>" />
			<input type="hidden" name="beforepageminidx" />
			</form>
			<div id="giftArticle" class="giftArticle"></div>
			<p id="nodata" style="display:none;" class="noArticle">해당되는 GIFT TALK이 없습니다.</p>
			<p id="nodata_act" style="display:none;" class="noArticle">해당되는 GIFT TALK이 없습니다.</p>
			<form name="delfrm" id="delfrm" action="/gift/gifttalk/iframe_talk_comment_proc.asp" method="post" target="iframeproc">
				<input type="hidden" name="gubun" id="gubun" value="">
				<input type="hidden" name="talkidx" id="talkidx" value="">
				<input type="hidden" name="idx" value="">
				<input type="hidden" name="useyn" value="N">
			</form>
			<form name="frm1" action="/gift/gifttalk/mytalk_proc.asp" method="post">
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