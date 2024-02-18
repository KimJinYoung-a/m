<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description :  모바일 위시 리스트
' History : 2014.09.15 원승현 생성
'           2015.10.28 유태욱 수정
'           2016.05.30 허진원 수정
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/wish/WishCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%

	Dim vListGubun : vListGubun = requestCheckVar(request("LstGun"),12)
	Dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),9))
	Dim CurrPage 	: CurrPage = getNumeric(requestCheckVar(request("cpg"),9))
	Dim vCateCode : vCateCode = getNumeric(requestCheckVar(request("catecode"),12))

	If Trim(PageSize) = "" Or Len(Trim(PageSize))=0 Then
		PageSize="10"
	End If

	If Trim(CurrPage)="" Or Len(Trim(CurrPage))=0 Then
		CurrPage = "0"
	End If

	If Trim(vListGubun)="" Or Len(Trim(vListGubun))=0 Then
		vListGubun = "TrendList"
	End If

	If Trim(vListGubun)="TrendList" And vCateCode<>"" Then
		vListGubun = "CateList"
	End If

	If Trim(vListGubun)="CateList" And vCateCode="" Then
		vListGubun = "TrendList"
	End If

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/newV15a.css" />
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
	fnAPPpopupBrowserURL("위시폴더","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popWishFolder.asp?itemid="+i+"&ErBValue=2");
}

function fnChgDispCate(disp) {
	var frm = document.popularfrm;
	frm.cpg.value=0;
	frm.catecode.value=disp;
	//frm.submit();
	location.replace("/apps/appCom/wish/web2014/wish/index.asp?" + $(frm).serialize());
}

function fnChgListGubun(gbn) {
	var frm = document.popularfrm;
	frm.cpg.value=0;
	frm.catecode.value="";
	frm.LstGun.value=gbn;
	//frm.submit();
	location.replace("/apps/appCom/wish/web2014/wish/index.asp?" + $(frm).serialize());
}

function FnPlusWishCntNg(iid) {
    setTimeout("fnAPPsetNudgeTrack('incrCustParam',2,'wish_count',1);",400);
    FnPlusWishCnt(iid);
}
      
function goWishReturn() {
	location.replace("/apps/appCom/wish/web2014/wish/index.asp");
	return false;
}
</script>


<script>
<% if (flgDevice="I") then %>
<% if InStr(uAgent,"tenapp i1.6")>0 then %>
<%
dim wsapp_loaded, wsapp_loaded_next, wsapp_loaded_pre
dim wsapp_Ccd 
dim wsapp_Ncd 
dim wsapp_Nurl 
dim wsapp_Pcd 
dim wsapp_Purl

	wsapp_loaded = session("wloaded")

	wsapp_Ccd = "wish"
	wsapp_Ncd = "gift"  : wsapp_Nurl = "http://m.10x10.co.kr/apps/appCom/wish/web2014/gift/gifttalk/index_TT.asp"
	wsapp_Pcd = "event" : wsapp_Purl = "http://m.10x10.co.kr/apps/appCom/wish/web2014/shoppingtoday/shoppingchance_allevent_TT.asp"
	
	if InStr(wsapp_loaded,wsapp_Ccd)<1 then
	    wsapp_loaded = wsapp_loaded & ","&wsapp_Ccd
	    session("wloaded") = wsapp_loaded
	end if
	
	if (wsapp_Ncd="") then
	    wsapp_loaded_next = true
	else
	    wsapp_loaded_next = InStr(wsapp_loaded,wsapp_Ncd)>0 
    end if
    
    if (wsapp_Pcd="") then
	    wsapp_loaded_pre  = true
	else
	    wsapp_loaded_pre = InStr(wsapp_loaded,wsapp_Pcd)>0 
    end if
	
%>

var _Rchk =<%=LCASE(wsapp_loaded_next)%>;
var _Lchk =<%=LCASE(wsapp_loaded_pre)%>;
var _evtalive =true;

function _delEvtHandle(){
    if (_Rchk&&_Lchk&&_evtalive){
        document.removeEventListener('touchstart', handleTouchStart, false);        
        document.removeEventListener('touchmove', handleTouchMove, false);
        _evtalive = false;
    }
}

function _goRight(){
    <% if (NOT wsapp_loaded_next) then %>
    if (!_Rchk){
        fnAPPselectGNBMenu('<%=wsapp_Ncd%>','<%=wsapp_Nurl%>');
        _Rchk = true;
    }
    <% end if %>
    _delEvtHandle();
}

function _goleft(){
    <% if (NOT wsapp_loaded_pre) then %>
    if (!_Lchk){
        fnAPPselectGNBMenu('<%=wsapp_Pcd%>','<%=wsapp_Purl%>');
        _Lchk = true;
    }
    <% end if %>
    _delEvtHandle();
}

<% if (Not wsapp_loaded_next) or (Not wsapp_loaded_pre) then %>
document.addEventListener('touchstart', handleTouchStart, false);        
document.addEventListener('touchmove', handleTouchMove, false);
<% end if %>

var xDown = null;                                                        
var yDown = null;                                                        


function handleTouchStart(evt) {                                         
    xDown = evt.touches[0].clientX;                                      
    yDown = evt.touches[0].clientY;                                      
};                                                

function handleTouchMove(evt) {
    if ( ! xDown || ! yDown ) {
        return;
    }

    var xUp = evt.touches[0].clientX;                                    
    var yUp = evt.touches[0].clientY;

    var xDiff = xDown - xUp;
    var yDiff = yDown - yUp;

    if ( Math.abs( xDiff ) > Math.abs( yDiff ) ) {/*most significant*/
        if ( xDiff > 2 ) {
            /* left swipe */ 
            _goRight(); 
        } else  if ( xDiff < - 2 ) {
            /* right swipe */
             _goleft();
        }                       
    } else {
        if ( yDiff > 0 ) {
            /* up swipe */ 
        } else { 
            /* down swipe */
        }                                                                 
    }
    /* reset values */
    xDown = null;
    yDown = null;                                             
};
<% end if %>
<% end if %>
</script>
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/newV15a.css" />
</head>
<body>
<form id="popularfrm" name="popularfrm" method="get" style="margin:0px;">
	<input type="hidden" name="cpg" id="cpg" value="<%=CurrPage%>" />
	<input type="hidden" name="psz" id="psz" value="<%=PageSize%>">
	<input type="hidden" name="LstGun" id="LstGun" value="<%=vListGubun%>" />
	<input type="hidden" name="catecode" id="catecode" value="<%=vCateCode%>" />
</form>

<form id="popularfrm2" name="popularfrm2" method="post" style="margin:0px;">
	<input type="hidden" name="cpg2" id="cpg2" value="<%=CurrPage%>" />
	<input type="hidden" name="psz2" id="psz2" value="<%=PageSize%>">
	<input type="hidden" name="LstGun2" id="LstGun2" value="<%=vListGubun%>" />
	<input type="hidden" name="catecode2" id="catecode2" value="<%=vCateCode%>" />
</form>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container wishMainV15a">
			<!-- content area -->
			<div class="content" id="contentArea">
				<!-- tab -->
				<ul class="commonTabV16a">
					<li <%=chkIIF(vListGubun="TrendList" or vListGubun="CateList","class=""current""","")%> name="tab01" style="width:33%;" onclick="fnChgListGubun('TrendList');">트렌드</li>
					<li <%=chkIIF(vListGubun="FollowList","class=""current""","")%> name="tab02" style="width:34%;" onclick="fnChgListGubun('FollowList');">팔로우</li>
					<li <%=chkIIF(vListGubun="MateList","class=""current""","")%> name="tab03" style="width:33%;" onclick="fnChgListGubun('MateList');">메이트</li>
				</ul>
				<% if vListGubun="TrendList" or vListGubun="CateList" then %>
				<!-- sorting -->
				<div class="viewSortV16a wishSortV16a">
					<div class="sortV16a">
						<div class="sortGrp category">
						<%
							'정렬상자 호출; sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명 (via functions.asp)
							Call fnPrntDispCateNaviV16(vCateCode,"F","fnChgDispCate")
						%>
						</div>
						<div class="sortGrp linkBtn">
							<p><a href="#" onclick="fnAPPpopupBrowserURL('위시 프로필','<%=wwwUrl%>/apps/appcom/wish/web2014/my10x10/myWish/myWish.asp');return false;" class="mywishBtn">나의 위시</a></p>
						</div>
					</div>
					<div id="contBlankCover" class="contBlankCover"></div>
				</div>
				<% end if %>

				<div class="wishListV15a">

					<ul id="incwishListValue"></ul>

				</div>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
		</div>
	</div>
	<div id="viewLoading" style="position:absolute; left:50%; margin:-25px 0 0 -25px;z-index:1000 ">
		<img src="http://fiximage.10x10.co.kr/m/2014/common/loading.gif" width="50x" height="50px">
	</div>

</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->