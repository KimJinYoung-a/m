<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description :  모바일 위시 리스트
' History : 2014.09.15 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
	Dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),9))
	Dim CurrPage 	: CurrPage = getNumeric(requestCheckVar(request("cpg"),9))

	If Trim(PageSize) = "" Or Len(Trim(PageSize))=0 Then
		PageSize="10"
	End If

	If Trim(CurrPage)="" Or Len(Trim(CurrPage))=0 Then
		CurrPage = "0"
	End If

%>
<title>10x10: 위시 리스트</title>

<script>
var isloading=true;
var rCheck=false;
$(function() {


	// 저장된 해쉬 값을 불러와 셋팅
	 if(document.location.hash)
	 {

		var str_hash = document.location.hash;
		str_hash = str_hash.replace("#","");
		var varr_curpage=str_hash.split("^");
		var vTsn=varr_curpage[0];
		var vPsz=varr_curpage[1];
		$("#cpg2").val("0");
		$("#psz2").val(vPsz);		
		getWishList2();
		$('body, html').delay(500).animate({ scrollTop: vTsn }, 50);
	 }
	else
	{
		getWishList();

	}

	//스크롤 이벤트 시작
	$(window).scroll(function() {
      if ($(window).scrollTop() >= $(document).height() - $(window).height() - 400){
          if (isloading==false){
            isloading=true;
			var pg = $("#popularfrm input[name='cpg']").val();
			pg++;
			$("#popularfrm input[name='cpg']").val(pg);
            setTimeout("getWishList()",50);
          }
      }
    });

	var sortW = $(".wishMain .sorting").outerWidth();
	$(".wishMain .sorting").css("margin-left", -sortW/2 +'px');

});

jQuery(function($){
	var loading = $('<img src="http://fiximage.10x10.co.kr/m/2014/common/loading.gif" alt="loading" style="border:0; position:absolute; left:50%; top:50%;" />').appendTo(document.body).hide();	
	$("*").ajaxStart(function(){
		loading.show();
	}).ajaxStop(function() {
		loading.hide();
	});
});

function getWishList() {

	var str=$.ajax({
		type:"GET",
		url:"inc_WishList.asp",
		data:$("#popularfrm").serialize(),
		dataType:"text",
		async:false
	}).responseText;

	if(str!="") {
    	if($("#popularfrm input[name='cpg']").val()=="0") {
        	//내용 넣기
        	$('#incwishListValue').html(str);
		} else {
			$('#incwishListValue').append(str);
		}
		isloading=false;
	} else {
		alert("위시 리스트가 더 이상 없습니다.");
    	$(window).unbind("scroll");
	}
}


function getWishList2() {

	var str=$.ajax({
		type:"POST",
		url:"inc_WishList2.asp",
		data:$("#popularfrm2").serialize(),
		dataType:"text",
		async:false
	}).responseText;

	if(str!="") {
    	if($("#popularfrm input[name='cpg2']").val()=="0") {
        	//내용 넣기
        	$('#incwishListValue').html(str);
		} else {
			$('#incwishListValue').append(str);
		}
		isloading=false;
	} else {
    	$(window).unbind("scroll");
	}
}

$("#Hlink").live("click", function(e) {

	var tpsz;

	tpsz = (Number($("#cpg").val())+1)*Number($("#psz").val());

	document.location.hash=document.body.scrollTop+"^"+tpsz

});

$("#Hlink2").live("click", function(e) {
	var tpsz2;
	tpsz2 = (Number($("#cpg").val())+1)*Number($("#psz").val());

	document.location.hash=document.body.scrollTop+"^"+tpsz2
});

$("#Hlink3").live("click", function(e) {
	var tpsz3;
	tpsz3 = (Number($("#cpg").val())+1)*Number($("#psz").val());

	document.location.hash=document.body.scrollTop+"^"+tpsz3
});



function goWishPop(i, w){

	if (w=="1")
	{
		alert("이미 위시한 상품입니다.");
		return;
	}
<% If IsUserLoginOK() Then %>
	top.location.href="/common/popWishFolder.asp?itemid="+i+"&ErBValue=2";
<% Else %>
	top.location.href = "/login/login.asp?backpath=<%=Server.URLencode(CurrURLQ())%>";
<% End If %>
}


function goMyWishPop(uid)
{
	$("#ucid").val(uid);
	document.popWishProfile.action="/my10x10/myWish/myWish.asp"
	document.popWishProfile.submit();
}

</script>
</head>
<body>
<form id="popularfrm" name="popularfrm" method="get" style="margin:0px;">
	<input type="hidden" name="cpg" id="cpg" value="<%=CurrPage%>" />
	<input type="hidden" name="psz" id="psz" value="<%=PageSize%>">
</form>

<form id="popularfrm2" name="popularfrm2" method="post" style="margin:0px;">
	<input type="hidden" name="cpg2" id="cpg2" value="<%=CurrPage%>" />
	<input type="hidden" name="psz2" id="psz2" value="<%=PageSize%>">
</form>

<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="wishMain">
					<div class="sorting">
						<p class="selected"><span class="button"><a href="">트랜드</a></span></p><%' for dev msg : 클릭시 selected 클래스 붙여주세요(작업시 퍼블리셔 문의) %>
						<p><span class="button"><a href="">팔로우</a></span></p>
						<p><span class="button"><a href="">메이트</a></span></p>
						<p><span class="button ctgySort"><a href="">카테고리</a></span></p>
					</div>
					<div class="wishListWrap" id="wishListWrapList" >
						<ul class="wishList" id="incwishListValue"></ul>
					</div>
				</div>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->