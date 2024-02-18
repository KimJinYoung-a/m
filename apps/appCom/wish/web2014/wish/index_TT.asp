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
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/wish/WishCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<%

	Dim vListGubun : vListGubun = requestCheckVar(request("LstGun"),12)
	Dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),9))
	Dim CurrPage 	: CurrPage = getNumeric(requestCheckVar(request("cpg"),9))
	Dim vCateCode : vCateCode = requestCheckVar(request("catecode"),12)

	If Trim(PageSize) = "" Or Len(Trim(PageSize))=0 Then
		PageSize="10"
	End If

	If Trim(CurrPage)="" Or Len(Trim(CurrPage))=0 Then
		CurrPage = "0"
	End If


	If Trim(vListGubun)="" Or Len(Trim(vListGubun))=0 Then
		vListGubun = "TrendList"
	End If

	If Trim(vListGubun)="CateList" And vCateCode="" Then
		vListGubun = "TrendList"
	End If

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script>
var isloading=true;
var rCheck=false;
$(function() {

	$("#viewLoading").hide();

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
    	$(window).unbind("scroll");
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
    	$(window).unbind("scroll");
		$("#viewLoading").hide();
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
	fnAPPpopupBrowserURL("위시폴더","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popWishFolder.asp?itemid="+i+"&ErBValue=2");
}


function goMyWishPop(uid)
{
	$("#ucid").val(uid);
	document.popWishProfile.action="<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/myWish/myWish.asp"
	document.popWishProfile.submit();
}

function fnChgDispCate(cdl,nm)
{
	if (cdl=="")
	{
		top.location.href = "/apps/appCom/wish/web2014/wish/";	
	}
	else
	{
		top.location.href = "/apps/appCom/wish/web2014/wish/index.asp?LstGun=CateList&catecode="+cdl;	
	}
}

// Wish Cnt 증가
function FnPlusWishCnt(iid) {

	$("#Hlink2"+iid).addClass("wishActive");
	var vCnt = $("#wish"+iid).html();
	if(vCnt=="") vCnt=0;
	vCnt++;
	$("#wish"+iid).html(vCnt);
}


function goWishReturn()
{
	top.location.href="/apps/appCom/wish/web2014/wish/index.asp";
	return false;
}

function changeCate(ctcode)
{
	top.location.href='/apps/appCom/wish/web2014/wish/index.asp?LstGun=CateList&catecode='+ctcode
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
	<div class="container bgGry">
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="wishMain">
				<div class="sorting">
					<p class="all <% If vListGubun="TrendList" Or vListGubun="CateList" Then %><% Else %>disabled<% End If %>">
						<% If vListGubun="TrendList" Or vListGubun="CateList" Then %>
							<select name="catecode" class="selectBox" title="카테고리 선택" onChange="changeCate(this.value)">
								<%=DrawSelectBoxDispCategory_Wish(vCateCode,"1") %>
							</select>
						<% Else %>
							<span class="button ctgySort"><a href="/apps/appcom/wish/web2014/wish/index.asp">트랜드</a></span>
						<% End If %>
					</p>					
					<p <% If vListGubun="FollowList" Then %>class="selected"<% End If %>><span class="button"><a href="index.asp?LstGun=FollowList">팔로우</a></span></p>
					<p <% If vListGubun="MateList" Then %>class="selected"<% End If %>><span class="button"><a href="index.asp?LstGun=MateList">메이트</a></span></p>
					<!--p <% If vListGubun="CateList" Then %>class="selected"<% End If %>><span class="button ctgySort"><a href="" onclick="fnOpenModal('/common/popCategoryList.asp?ErBValue=9');return false;"><%=getDisplayCateNameDB(vCateCode)%></a></span></p-->
					<p><span class="button myEvt"><a href="" onclick="fnAPPpopupBrowserURL('위시 프로필','<%=wwwUrl%>/apps/appcom/wish/web2014/my10x10/myWish/myWish.asp');return false;"><em>MY</em></a></span></p>
				</div>
				<div class="wishListWrap" id="wishListWrapList" >
					<ul class="wishList" id="incwishListValue"></ul>
				</div>
			</div>
		<!-- //content area -->
		</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
	</div>
	<div id="viewLoading" style="position:absolute; left:50%; margin:-25px 0 0 -25px;">
		<img src="http://fiximage.10x10.co.kr/m/2014/common/loading.gif" width="50px" height="50px">
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->