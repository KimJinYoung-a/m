<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 다이어리 스토리2017 브랜드 스페셜
' History : 2015.10.20 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2017/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2017/lib/classes/diary_class_B.asp" -->
<!-- #include virtual="/diarystory2017/lib/classes/specialbrandCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->

<%
Dim i , imglink, PageSize , CurrPage, totalpage

PageSize = 4
'
'''스페셜 브랜드 테스트
dim oSpecialBrand
set oSpecialBrand = new DiaryCls
	oSpecialBrand.fcontents_list
	totalpage = oSpecialBrand.FTotalCount/PageSize
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/diary2017.css" />
<script type="text/javascript">

function checkForHash() {
	if(document.location.hash){
		var HashLocationName = document.location.hash;
		HashLocationName = HashLocationName.replace("#","");
		$("#cpg").val(HashLocationName);
	} else {
		$("#cpg").val(1);
		document.location.hash = "#1";
	}
}

var isloading=true;
$(function(){

	//첫페이지 로딩
	checkForHash();
	if(document.location.hash){
		getListhash();
	} else {
		getList();
	}

	//스크롤 이벤트 시작
	$(window).unbind("scroll");
	$(window).scroll(function() {
      if ($(window).scrollTop() >= $(document).height() - $(window).height() - 350){
          if (isloading==false){
            isloading=true;

			var pg = $("#cpg").val();
			if (pg>0 && pg<<%=totalpage%>){
			//if (pg>0){
				pg++;
				$("#cpg").val(pg);
	            setTimeout("getList()",500);
	        }
          }
      }
    });
});

function getList(cpgval) {
	var cpage = $("#cpg").val();
	if (cpage>1){
		document.location.hash = "#" + cpage;
	}
	var str = $.ajax({
			type: "GET",
	        url: "/apps/appcom/wish/web2014/diarystory2017/brandspecial_act.asp",
	        data: $("#indexfrm").serialize(),
	        dataType: "text",
	        async: false
	}).responseText;

	if(str!="") {
    	if($("#cpg").val()=="1") {
        	$('#indexact').html(str);
        } else {
       		$str = $(str)
       		$('#indexact').append($str);
        }
        isloading=false;
    } else {
    	$(window).unbind("scroll");
    }
}

function getListhash() {
	var hcpg = $("#cpg").val();
	for(var i=1; i<=hcpg; i++) {
		$("#cpg").val(i);
		var str = $.ajax({
				type: "GET",
		        url: "/apps/appcom/wish/web2014/diarystory2017/brandspecial_act.asp",
		        data: $("#indexfrm").serialize(),
		        dataType: "text",
		        async: false
		}).responseText;
	
		if(str!="") {
	    	if($("#cpg").val()=="1") {
	        	$('#indexact').html(str);
	
	        } else {
	       		$str = $(str)
	       		$('#indexact').append($str);
	        }
	        isloading=false;
	    } else {
	    	$(window).unbind("scroll");
	    }
	}
}

$(function(){
	var swiper1 = new Swiper(".brandSpecial .swiper-container", {
		slidesPerView:'auto',
		speed:500
	});

//	$(".btnPlay").click(function(){
//		$(this).toggleClass("opened");
//		$(this).next(".videoWrap").slideToggle();
//	});
});

function mvclick(ididx) {
	$("#"+ididx).toggleClass("opened");
	$("#"+ididx).next(".videoWrap").slideToggle();
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry diarystory2017">
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="brandSpecial" id="brandSpecial">
					<ul id="indexact"></ul>
				</div>
				<form id="indexfrm" name="indexfrm" method="get" style="margin:0px;">
				<input type="hidden" id="cpg" name="cpg" value="1" />
				</form>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<% Set oSpecialBrand = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->