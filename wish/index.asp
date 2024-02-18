<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description :  모바일 위시 리스트
' History : 2014.09.15 원승현 생성
'           2015.10.28 유태욱 수정
'           2016.05.30 허진원 수정
'           2017-04-26 이종화 수정 PC->Mobile 맞춤
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/wish/WishCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
	Dim cPopular, vDisp, vSort, vCurrPage, i, j, vArrEval , PageSize
	vDisp = RequestCheckVar(Request("disp"),18)
	vSort = requestCheckVar(request("sort"),12)
	vCurrPage = RequestCheckVar(Request("cpg"),5)
	PageSize = getNumeric(requestCheckVar(request("psz"),9))
	
	If vCurrPage = "" Then vCurrPage = 1

	If vSort = "" Then vSort = "3"

	If Trim(PageSize) = "" Or Len(Trim(PageSize))=0 Then
		PageSize="6"
	End If
%>
<title>10x10: WISH</title>
<script>
var isloading=true;
var rCheck=false;
var vAddScr;
$(function() {
	$("#viewLoading").hide();

	// 저장된 해쉬 값을 불러와 셋팅
	 if(document.location.hash) {
		var str_hash = document.location.hash;
		str_hash = str_hash.replace("#","");
		var varr_curpage=str_hash.split("^");
		var vTsn=varr_curpage[0];
		var vPsz=varr_curpage[1];
		$("#cpg2").val("0");
		$("#psz2").val(vPsz);		
		getWishList2();
		$('body, html').delay(500).animate({ scrollTop: vTsn }, 50);
	} else {
		getWishList();
	}

	//스크롤 이벤트 시작
	vAddScr = $(window).on("scroll",function() {
      if ($(window).scrollTop() >= $(document).height() - $(window).height() - 400){
          if (isloading==false){
			$("#viewLoading").css('top',$(document).height()-347);
			$("#viewLoading").fadeIn(100);
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

	//content area height calculate
	function contHCalc() {
		var contH = $('.content').outerHeight();
		$('.contBlankCover').css('height',contH+'px');
	}

	//Open option Nani control
	$(".viewSortV16a button").click(function(){
		if($(this).parent('.sortGrp').hasClass('current')){
			$(".sortGrp").removeClass('current');
			$("#contBlankCover").fadeOut();
		} else {
			$(".sortGrp").removeClass('current');
			$(this).parent('.sortGrp').addClass('current');
			$("#contBlankCover").fadeIn();
			contHCalc();
		}
	});

	//Close option Nani control
	$(".contBlankCover").click(function(){
		$(".contBlankCover").fadeOut();
		$(".viewSortV16a div").removeClass('current');
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
		$("#viewLoading").fadeOut(500);
	} else {
    	$(window).off("scroll",vAddScr);
		$("#viewLoading").hide();

		//alert("위시 리스트가 더 이상 없습니다.");
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
		$("#viewLoading").fadeOut(500);
	} else {
    	$(window).off("scroll",vAddScr);
		$("#viewLoading").hide();
	}
}

$("#Hlink").on("click", function(e) {
	var tpsz;
	tpsz = (Number($("#cpg").val())+1)*Number($("#psz").val());
	document.location.hash=document.body.scrollTop+"^"+tpsz
});

$("#Hlink2").on("click", function(e) {
	var tpsz2;
	tpsz2 = (Number($("#cpg").val())+1)*Number($("#psz").val());
	document.location.hash=document.body.scrollTop+"^"+tpsz2
});

$("#Hlink3").on("click", function(e) {
	var tpsz3;
	tpsz3 = (Number($("#cpg").val())+1)*Number($("#psz").val());
	document.location.hash=document.body.scrollTop+"^"+tpsz3
});



function goWishPop(i, w){
	if (w=="1") {
		alert("이미 위시한 상품입니다.");
		return;
	}
	top.location.href="/common/popWishFolder.asp?itemid="+i+"&ErBValue=2";
}

function fnChgDispCate(disp) {
	var frm = document.popularfrm;
	frm.cpg.value=1;
	frm.disp.value=disp;
	frm.submit();
}

//이전 버전
function fnChgListGubun(gbn) {
	var frm = document.popularfrm;
	frm.cpg.value=1;
	frm.disp.value="";
	frm.sort.value=gbn;
	frm.submit();
}

//신규 버전
function goPopularWish(d,s){
	$('input[name="cpg"]').val("1");
	$('input[name="disp"]').val(d);
	$('input[name="sort"]').val(s);
	popularfrm.submit();
}
</script>
</head>
<body>
<form id="popularfrm" name="popularfrm" method="get" style="margin:0px;">
	<input type="hidden" name="cpg" id="cpg" value="<%=vCurrPage%>" />
	<input type="hidden" name="psz" id="psz" value="<%=PageSize%>">
	<input type="hidden" name="sort" id="sort" value="<%=vSort%>" />
	<input type="hidden" name="disp" id="disp" value="<%=vDisp%>" />
</form>

<form id="popularfrm2" name="popularfrm2" method="post" style="margin:0px;">
	<input type="hidden" name="cpg2" id="cpg2" value="<%=vCurrPage%>" />
	<input type="hidden" name="psz2" id="psz2" value="<%=PageSize%>">
	<input type="hidden" name="sort2" id="sort2" value="<%=vSort%>" />
	<input type="hidden" name="disp2" id="disp2" value="<%=vDisp%>" />
</form>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container wishMainV15a">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<!-- tab -->
				<ul class="commonTabV16a">
					<li <%=CHKIIF(vSort="3","class='current'","")%> onclick="goPopularWish('<%=vDisp%>','3');">급상승위시</li>
					<li <%=CHKIIF(vSort="1","class='current'","")%> onclick="goPopularWish('<%=vDisp%>','1');">최근위시</li>
					<li <%=CHKIIF(vSort="2","class='current'","")%> onclick="goPopularWish('<%=vDisp%>','2');">신상품위시</li>
				</ul>
				<!-- sorting -->
				<div class="viewSortV16a wishSortV16a">
					<div class="sortV16a">
						<div class="sortGrp category">
						<%
							'정렬상자 호출; sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명 (via functions.asp)
							Call fnPrntDispCateNaviV16(vDisp,"F","fnChgDispCate")
						%>
						</div>
						<div class="sortGrp linkBtn">
							<p><a href="/my10x10/mywish/mywish.asp" class="mywishBtn">나의 위시</a></p>
						</div>
					</div>
					<div id="contBlankCover" class="contBlankCover"></div>
				</div>

				<div class="wishListV15a">
					<ul id="incwishListValue"></ul>
				</div>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
	<div id="viewLoading" style="position:absolute; left:50%; margin:-25px 0 0 -25px;z-index:1000 ">
		<img src="http://fiximage.10x10.co.kr/m/2014/common/loading.gif" width="50x" height="50px">
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->