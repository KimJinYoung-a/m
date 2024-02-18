<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/enjoy/shoppingchanceCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/award/newawardcls_B.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
Dim gaparam, userid
Dim vSaleFreeDeliv , adminatype, userlevelname, useragename
dim Dategubun : Dategubun = RequestCheckVar(request("dategubun"),1)	'기간별 검색 w:주간, m:월간
dim userlevel : userlevel = RequestCheckVar(request("userlevel"),1)	'회원등급별 검색
dim userage : userage = RequestCheckVar(request("userage"),2)	'연령
dim vDisp : vDisp = RequestCheckVar(request("disp"),3)
dim flag : flag = RequestCheckVar(request("flag"),1)
dim atype : atype = RequestCheckVar(request("atype"),2)
dim gnbflag : gnbflag = RequestCheckVar(request("gnbflag"),1)
dim CurrPage : CurrPage = getNumeric(request("cpg"))
dim toggle : toggle = RequestCheckVar(request("toggle"),2)
dim classStr, adultChkFlag, adultPopupLink, linkUrl
dim gnbparam : gnbparam = request("gnbparam")
dim swiperInitialNumber

userid = getLoginUserid()
adminatype = getAdminAtype() '어드민 사이트관리-모바일BEST_구분설정에서 셋팅한 기본값

if atype = "" then
	'atype = adminatype
end if

If gnbflag = "" Then '//gnb 숨김 여부
	gnbflag = true
Else
	gnbflag = False
	strHeadTitleName = "BEST"
End if

if IsUserLoginOK() and userlevel="" then
	userlevel = GetLoginUserLevel()
end if

if IsUserLoginOK() and userage="" then
	userage = getUserAge(userid)
end if

if userage="" then
	dim rndm
	randomize
	rndm = int(Rnd*10)+1

	SELECT CASE rndm
		Case 1, 2 : userage = 10
		Case 3, 4, 5 : userage = 20
		Case 6, 7, 8 : userage = 30
		Case 9, 10 : userage = 40
		Case Else : userage = 20
	END SELECT
end if

if userlevel="" then userlevel=8
if Dategubun="" then Dategubun="d"
if CurrPage="" then CurrPage=1
if atype="" then atype="dt"		'fnATYPErandom()
dim minPrice '검색 최저가

'// 2018 회원등급 개편
select case userlevel
	case 7,8,9
		userlevelname = "Guest"
	case 0,5
		userlevelname = "WHITE"
	case 1
		userlevelname = "RED"
	case 2
		userlevelname = "VIP"
	case 3
		userlevelname = "VIP GOLD"
	case 4,6
		userlevelname = "VVIP"
	case else
		userlevelname = "Guest"
end select

select case userage
	case 10
		useragename = "10대"
	case 20
		useragename = "20대"
	case 30
		useragename = "30대"
	case 40
		useragename = "40대"
	case else
		useragename = "20대"
end select
								
Dim oaward, i, iLp, sNo, eNo, tPg, chgtype, vWishArr, vZzimArr

'// 정렬방법 통일로 인한 코드 변환
Select Case atype
	Case "ne":
		chgtype = "n"
		minPrice=4500		'신상순
		gaparam = "&gaparam=tbest_new_"
		swiperInitialNumber = 1
	Case "be":
		chgtype = "b"
		minPrice=4500		'인기순
		gaparam = "&gaparam=tbest_sell_"
		swiperInitialNumber = 10
	Case "ws":
		chgtype = "f"
		minPrice=4500		'위시순
		gaparam = "&gaparam=tbest_wish_"
		swiperInitialNumber = 3
	Case "hs":
		chgtype = "s"
		minPrice=4500		'할인순
		gaparam = "&gaparam=tbest_sale_"
		swiperInitialNumber = 11
	Case "st":
		chgtype = "t"
		minPrice=4500		'//2017 스테디셀러
		gaparam = "&gaparam=tbest_steady_"
		swiperInitialNumber = 2
	Case "br":
		chgtype = "r"
		minPrice=4500		'//2017 브랜드 베스트
		gaparam = "&gaparam=tbest_brand_"
		swiperInitialNumber = 7
	Case "vi":
		chgtype = "i"
		minPrice=10000		'//2017 VIP 베스트
		gaparam = "&gaparam=tbest_vip_"
		swiperInitialNumber = 5
	Case "dt": 
		chgtype = "d" 
		minPrice=5000		'//기간별 베스트
		gaparam = "&gaparam=tbest_date_"
		swiperInitialNumber = 0
	Case "lv": 
		chgtype = "l" 
		minPrice=4500		'//등급별 베스트
		gaparam = "&gaparam=tbest_level_"
		swiperInitialNumber = 6
	Case "ag": 
		chgtype = "a" 
		minPrice=4500		'//연령별 베스트
		gaparam = "&gaparam=tbest_age_"
		swiperInitialNumber = 4
	Case "mz": 
		chgtype = "m" 
		minPrice=4500		'//맨즈 베스트
		gaparam = "&gaparam=tbest_man_"
		swiperInitialNumber = 8
	Case "fo": 
		chgtype = "c" 
		minPrice=4500		'//첫구매 베스트
		gaparam = "&gaparam=tbest_firstorder_"
		swiperInitialNumber = 9
	Case Else:
		chgtype = "b"
		minPrice=4500		'기본값(인기순)
		swiperInitialNumber = 0
End Select

if (chgtype="n") then
    ''신상품 베스트
    set oaward = new SearchItemCls
	    oaward.FListDiv 		= "newlist"
	    oaward.FRectSortMethod	= "be"
	    oaward.FRectSearchFlag 	= "newitem"
	    oaward.FPageSize 		= 200
	    oaward.FCurrPage 		= 1
	    oaward.FSellScope		= "Y"
	    oaward.FScrollCount 	= 1
	    oaward.FRectSearchItemDiv ="D"
	    oaward.FRectCateCode	  = vDisp
	    oaward.FminPrice	= minPrice
	    oaward.FSalePercentLow = 0.89

	    oaward.getSearchList

elseif (chgtype="s") then
	set oaward = new SearchItemCls
		''oaward.FListDiv 		= "salelist"
		oaward.FListDiv 		= "saleonly"
		oaward.FRectSortMethod	= "hs"		'인기순(be), 세일순(hs)
		oaward.FRectSearchFlag 	= "saleitem"
		oaward.FPageSize 		= 200
		oaward.FRectCateCode	= vDisp
		oaward.FCurrPage 		= 1
		oaward.FSellScope 		= "Y"
		oaward.FScrollCount 	= 1
		oaward.FminPrice	= minPrice
		oaward.getSearchList
elseif (chgtype="f") then	'위시순
'	set oaward = new SearchItemCls
'		oaward.FListDiv 		= "bestlist"
'		oaward.FRectSortMethod	= "ws"
'		oaward.FRectSearchFlag 	= "n"
'		oaward.FPageSize 		= 200
'		oaward.FRectCateCode	= vDisp
'		oaward.FCurrPage 		= 1
'		oaward.FSellScope 		= "Y"
'		oaward.FScrollCount 	= 1
'		oaward.FminPrice	= minPrice
'		oaward.getSearchList
'//2019-02-14 pc와 베스트위시와 동일한 로직사용
	set oaward = new CAWard
	oaward.FPageSize = 100
	oaward.FRectDisp1 = vDisp
	oaward.FRectAwardgubun = chgtype
	
	oaward.GetNormalItemList	
elseif (atype="lp") or (atype="hp") then
	set oaward = new SearchItemCls
        oaward.FListDiv 			= "bestlist"
        oaward.FRectSortMethod	    = atype
        oaward.FPageSize 			= 200
        oaward.FCurrPage 			= 1
        oaward.FSellScope			= "Y"
        oaward.FScrollCount 		= 1
        oaward.FRectSearchItemDiv   ="D"
        oaward.FRectCateCode		= vDisp
        oaward.FminPrice	= minPrice
        oaward.getSearchList
ElseIf chgtype = "t" Then  '//스테디 베스트
	set oaward = new CAWard
		oaward.FPageSize = 200
		oaward.FRectCateCode		= vDisp
		oaward.GetSteadyItemList_2017

	If (oaward.FResultCount < 3) Then
		set oaward = Nothing
		set oaward = new SearchItemCls
			oaward.FListDiv 			= "bestlist"
			oaward.FRectSortMethod	    = "be"
			''oaward.FRectSearchFlag 	= "newitem"  ''검색범위
			oaward.FPageSize 			= 200
			oaward.FCurrPage 			= 1
			oaward.FSellScope			= "Y"
			oaward.FScrollCount 		= 1
			oaward.FRectSearchItemDiv   ="D"
			oaward.FRectCateCode		= vDisp
			oaward.FminPrice	= minPrice
			oaward.getSearchList
	End if
ElseIf chgtype = "r" Then
	set oaward = new CAWard
		oaward.FPageSize = 600
		oaward.FRectCateCode		= vDisp
		oaward.GetBrandItemList_2017

	If (oaward.FResultCount < 1) Then
	elseIf (oaward.FResultCount < 3) Then
		set oaward = Nothing
		set oaward = new SearchItemCls
			oaward.FListDiv 			= "bestlist"
			oaward.FRectSortMethod	    = "be"
			''oaward.FRectSearchFlag 	= "newitem"  ''검색범위
			oaward.FPageSize 			= 200
			oaward.FCurrPage 			= 1
			oaward.FSellScope			= "Y"
			oaward.FScrollCount 		= 1
			oaward.FRectSearchItemDiv   ="D"
			oaward.FRectCateCode		= vDisp
			oaward.FminPrice	= minPrice
			oaward.getSearchList
	End if

ElseIf chgtype = "i" Then
	Dim chkCnt
	set oaward = new CAWard
	oaward.FPageSize = 200
	oaward.FRectCateCode		= vDisp
	oaward.GetVIPItemList_2017

	'// 3개 이하일 경우엔 하단 상품후기 부분 가려야 되므로 체킹함
	chkCnt = oaward.FResultCount

	If (oaward.FResultCount < 3) Then
		set oaward = Nothing
		set oaward = new SearchItemCls
			oaward.FListDiv 			= "bestlist"
			oaward.FRectSortMethod	    = "be"
			''oaward.FRectSearchFlag 	= "newitem"  ''검색범위
			oaward.FPageSize 			= 200
			oaward.FCurrPage 			= 1
			oaward.FSellScope			= "Y"
			oaward.FScrollCount 		= 1
			oaward.FRectSearchItemDiv   ="D"
			oaward.FRectCateCode		= vDisp
			oaward.FminPrice	= minPrice
			oaward.getSearchList
	End if
ElseIf chgtype = "d" Then 	'기간별 검색
	if Dategubun <> "d" then
		set oaward = new CAWard
			oaward.FPageSize = 200
			oaward.FRectDategubun = Dategubun
			oaward.FRectCateCode		= vDisp
			oaward.GetDateItemList
	else
		set oaward = Nothing
		set oaward = new SearchItemCls
			oaward.FListDiv 			= "bestlist"
			oaward.FRectSortMethod	    = "be"
			''oaward.FRectSearchFlag 	= "newitem"  ''검색범위
			oaward.FPageSize 			= 200
			oaward.FCurrPage 			= 1
			oaward.FSellScope			= "Y"
			oaward.FScrollCount 		= 1
			oaward.FRectSearchItemDiv   ="D"
			oaward.FRectCateCode		= vDisp
			oaward.FminPrice			= minPrice
			oaward.FawardType			= "period"
			oaward.getSearchList
	end if
	If (oaward.FResultCount < 3) Then
		set oaward = Nothing
		set oaward = new SearchItemCls
			oaward.FListDiv 			= "bestlist"
			oaward.FRectSortMethod	    = "be"
			''oaward.FRectSearchFlag 	= "newitem"  ''검색범위
			oaward.FPageSize 			= 200
			oaward.FCurrPage 			= 1
			oaward.FSellScope			= "Y"
			oaward.FScrollCount 		= 1
			oaward.FRectSearchItemDiv   ="D"
			oaward.FRectCateCode		= vDisp
			oaward.FminPrice			= minPrice
			oaward.FawardType			= "period"
			oaward.getSearchList
	End if
ElseIf chgtype = "l" Then 	'회원등급별
	set oaward = new CAWard
		oaward.FPageSize = 200
		oaward.FRectUserlevel = userlevel
		oaward.FRectCateCode		= vDisp
		oaward.GetUserLevelItemList

	If (oaward.FResultCount < 3) Then
		set oaward = Nothing
		set oaward = new SearchItemCls
			oaward.FListDiv 			= "bestlist"
			oaward.FRectSortMethod	    = "be"
			''oaward.FRectSearchFlag 	= "newitem"  ''검색범위
			oaward.FPageSize 			= 200
			oaward.FCurrPage 			= 1
			oaward.FSellScope			= "Y"
			oaward.FScrollCount 		= 1
			oaward.FRectSearchItemDiv   ="D"
			oaward.FRectCateCode		= vDisp
			oaward.FminPrice			= minPrice
			oaward.FawardType			= "userlevel"
			oaward.getSearchList
	End if
ElseIf chgtype = "a" Then 	'연령별
	set oaward = new CAWard
		oaward.FPageSize = 200
		oaward.FRectAgegubun = userage
		oaward.FRectSexFlag = 0
		oaward.FRectCateCode		= vDisp
		oaward.GetAgeItemList

	If (oaward.FResultCount < 3) Then
		set oaward = Nothing
		set oaward = new SearchItemCls
			oaward.FListDiv 			= "bestlist"
			oaward.FRectSortMethod	    = "be"
			''oaward.FRectSearchFlag 	= "newitem"  ''검색범위
			oaward.FPageSize 			= 200
			oaward.FCurrPage 			= 1
			oaward.FSellScope			= "Y"
			oaward.FScrollCount 		= 1
			oaward.FRectSearchItemDiv   ="D"
			oaward.FRectCateCode		= vDisp
			oaward.FminPrice	= minPrice
			oaward.getSearchList
	End if
ElseIf chgtype = "m" Then 	'맨즈 베스트(연령별과 같지만 sexflag/2=1인것만 가져옴)
	set oaward = new CAWard
		oaward.FPageSize = 200
		oaward.FRectAgegubun = userage
		oaward.FRectSexFlag = 1
		oaward.FRectCateCode		= vDisp
		oaward.GetAgeItemList

	If (oaward.FResultCount < 3) Then
		set oaward = Nothing
		set oaward = new SearchItemCls
			oaward.FListDiv 			= "bestlist"
			oaward.FRectSortMethod	    = "be"
			''oaward.FRectSearchFlag 	= "newitem"  ''검색범위
			oaward.FPageSize 			= 200
			oaward.FCurrPage 			= 1
			oaward.FSellScope			= "Y"
			oaward.FScrollCount 		= 1
			oaward.FRectSearchItemDiv   ="D"
			oaward.FRectCateCode		= vDisp
			oaward.FminPrice	= minPrice
			oaward.getSearchList
	End if
ElseIf chgtype = "c" Then 	'첫구매 베스트
	set oaward = new CAWard
		oaward.FPageSize = 200
		oaward.FRectCateCode		= vDisp
		oaward.GetFirstOrderItemList

	If (oaward.FResultCount < 3) Then
		set oaward = Nothing
		set oaward = new SearchItemCls
			oaward.FListDiv 			= "bestlist"
			oaward.FRectSortMethod	    = "be"
			''oaward.FRectSearchFlag 	= "newitem"  ''검색범위
			oaward.FPageSize 			= 200
			oaward.FCurrPage 			= 1
			oaward.FSellScope			= "Y"
			oaward.FScrollCount 		= 1
			oaward.FRectSearchItemDiv   ="D"
			oaward.FRectCateCode		= vDisp
			oaward.FminPrice	= minPrice
			oaward.getSearchList
	End if
else
    set oaward = new CAWard
	    oaward.FPageSize = 200
	    oaward.FRectDisp1   = vDisp
		oaward.FRectAwardgubun = chgtype
		oaward.GetNormalItemList

	If (oaward.FResultCount < 3) Then
		set oaward = Nothing
		set oaward = new SearchItemCls
	        oaward.FListDiv 			= "bestlist"
	        oaward.FRectSortMethod	    = "be"
	        ''oaward.FRectSearchFlag 	= "newitem"  ''검색범위
	        oaward.FPageSize 			= 200
	        oaward.FCurrPage 			= 1
	        oaward.FSellScope			= "Y"
	        oaward.FScrollCount 		= 1
	        oaward.FRectSearchItemDiv   ="D"
	        oaward.FRectCateCode		= vDisp
	        oaward.FminPrice	= minPrice
	        oaward.getSearchList

	End if
end If

if IsUserLoginOK then
	'// 검색결과 상품목록 작성
	dim rstArrItemid: rstArrItemid=""	'위시체크
	dim rstArrBrand: rstArrBrand=""		'찜브랜드체크
	IF oaward.FResultCount >0 then
		For iLp=0 To oaward.FResultCount -1
			rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & oaward.FItemList(iLp).FItemID
			rstArrBrand = rstArrBrand & chkIIF(rstArrBrand="","","|,|") & oaward.FItemList(iLp).FMakerid
		Next
	End if
	'// 위시결과 상품목록 작성
	if rstArrItemid<>"" then
		Call getMyFavItemList(getLoginUserid(),rstArrItemid,vWishArr)
	end if
	'// 찜브랜드결과 상품목록 작성
	if rstArrBrand<>"" then
		rstArrBrand = "|"&rstArrBrand&"|"
		Call getMyZzimBrandList(getLoginUserid(),rstArrBrand,vZzimArr)
	end if
end if	

'// 구버전 신버전 분기 (padding-top)
Dim appver
If InStr(uAgent,"tenapp i2.")>0 Or (InStr(uAgent,"tenapp a2.")>0) Then
	appver = true
Else 
	appver = false
End If 

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script src="/apps/appCom/wish/web2014/lib/js/adultAuth.js?v=1.3"></script>
<script type="text/javascript">
$(function() {
//	$("#navBest ul li:gt(5)").hide();

	var bestSwiper = new Swiper('.topicV19 .tabwrap', {
		slidesPerView:'auto',
		<% if swiperInitialNumber > 2 then %>
		initialSlide : <%=swiperInitialNumber%>,
		<% end if %>
	})

	if(!$('body').hasClass('body-main') ){
		$(window).load(function(){
			var conT = $(".sortingbarV19").offset().top;
			$(window).scroll(function(){
				var y = $(window).scrollTop();
				if ( conT < y ) {
					$(".topicV19").addClass("is-fixed");
				} else {
					$(".topicV19").removeClass("is-fixed");
				}
			});
		});
	}
	
	$("#navBest li>a").on("click", function(){
		$("#navBest li>a").removeClass("on");
		if ($(this).hasClass("on")) {
			$(this).removeClass("on");
		} else {
			$(this).addClass("on");
		}
		return false;
	});

	$("#navBest .btn-toggle").on("click", function(){
		$(this).toggleClass("on");
		if (!$(this).hasClass("on")) {
			$("#toggle").val("");
		}
		$("#navBest ul li:gt(5)").toggle();
	});

	<% If atype = "lv" Or atype = "br" Or atype = "mz" Or atype = "fo" Or toggle = "on" Then %>
		$("#btn-toggle").toggleClass("on");
		$("#navBest ul li:gt(5)").toggle();
	<% end if %>

	/* zzim button on off */
//	$(".btn-zzim").on("click", function(e){
//		if ( $(this).hasClass("on")) {
//			$(this).removeClass("on");
//		} else {
//			$(this).addClass("on");
//		}
//	});
});

function fnChgDisp(dsp) {
	var frm = document.frmAward;
	frm.disp.value=dsp;
//	frm.submit();
	var vprm = $(frm).serialize()
	location.replace("?"+vprm);
}

function fnChgSort(stp) {
	var frm = document.frmAward;
	frm.atype.value=stp;
	frm.disp.value="";
	frm.dategubun.value="";
	frm.userlevel.value="";
	frm.userage.value="";
	if(stp=="lv"||stp=="br"||stp=="mz"||stp=="fo"){
		$("#toggle").val("on");
	}
//	frm.submit();
	var vprm = $(frm).serialize()
	location.replace("?"+vprm);
}

function fnChgDate(dt) {
	var frm = document.frmAward;
	frm.dategubun.value=dt;
//	frm.submit();
	var vprm = $(frm).serialize()
	location.replace("?"+vprm);
}

function fnChgLevel(lv) {
	var frm = document.frmAward;
	frm.userlevel.value=lv;
//	frm.submit();
	var vprm = $(frm).serialize()
	location.replace("?"+vprm);
}

function fnChgAge(age) {
	var frm = document.frmAward;
	frm.userage.value=age;
//	frm.submit();
	var vprm = $(frm).serialize()
	location.replace("?"+vprm);
}


// 관심 품목 담기 - 상품 페이지 전용 : 상품 코드로 변경
function goWishPop(i,ecd){
	<% If IsUserLoginOK() Then ''ErBValue.value -> 공통파일의 구분값 (cate는 1)%>
	   fnAPPpopupBrowserURL("위시폴더","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popWishFolder.asp?ecode="+ecd+"&itemid="+i+"&ErBValue=13&gb=search2017",'','wishfolder');
	<% Else %>
		calllogin();
		return false;
	<% End If %>
}

var vPg=1, vScrl=true;
$(function(){
	// 스크롤시 추가페이지 접수
	$(window).scroll(function() {
//		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-800){
		var currentPercentage = ($(window).scrollTop() / ($(document).outerHeight() - $(window).height())) * 100;
		if(currentPercentage>40){
			if(vScrl) {
				vScrl = false;
				vPg++;
				$.ajax({
					url: "act_awarditem.asp?cpg="+vPg,
					data: $("#frmAward").serialize(),
					cache: false,
					success: function(message) {
						if(message!="") {
							$("#lyrEvtList").append(message);
							vScrl=true;
						} else {
							//$(window).unbind("scroll");
						}
					}
					,error: function(err) {
						console.log(err.responseText);
						$(window).unbind("scroll");
					}
				});
			}
		}
	});

	// 로딩중 표시
	$("#lyLoading").ajaxStart(function(){
		$(this).show();
	}).ajaxStop(function(){
		$(this).hide();
	});

	//급상승 상품
	$(".bestUpV15 .rank").append("<span class='icon icon-up'>급상승</span>");
});

function jsAfterWishBtn(i){
	if($("#wish"+i+"").hasClass("on")){
	}else{
		$("#wish"+i+"").addClass("on");
		
		var cnt = $("#cnt"+i+"").text();

		if(cnt == ""){
			$("#wish"+i+"").empty();
			$("#cnt"+i+"").empty().text("1");
		}else{
			cnt = parseInt(cnt) + 1;
			if(cnt > 999){
				$("#cnt"+i+"").empty().text("999+");
			}else{
				$("#cnt"+i+"").empty().text(cnt);
			}
		}
	}
}

function TnMyBrandZZim(mkid){
	var jjifrm = document.jjimfrm;
	jjifrm.makerid.value=mkid;
	<% If IsUserLoginOK() Then %>
		var cnt = $("#"+mkid+"").text();
		if($("#"+mkid+"btn").hasClass("on")){
			cnt = parseInt(cnt) - 1;
			$("#"+mkid+"").empty().text(cnt);
			$("#"+mkid+"btn").removeClass("on");
		}else{
			cnt = parseInt(cnt) + 1;
			$("#"+mkid+"").empty().text(cnt);
			$("#"+mkid+"btn").addClass("on");
		}
		jjimfrm.action = "/apps/appcom/wish/web2014/street/domybrandjjim.asp";
		jjimfrm.submit();
	<% Else %>
		alert("찜브랜드 추가는 로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?");
		top.location.href = "<%=M_SSLUrl%>/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>";
	<% End If %>
}
</script>
<!--<style><% if not(appver) then %>.body-main {padding-top:0px;}<% end if %></style>-->
<style><% if gnbparam = 1 then %>.body-main {padding-top:0;}<% end if %></style>
</head>
<body  class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">
<div id="content" class="content">
	<div class="topicV19">
		<div class="titwrap">
			<div class="tit-area">
				<h2 class="mar0">BEST SELLER</h2>
			</div>
			<div class="tabwrap">
				<ul class="swiper-wrapper">
					<li class="swiper-slide <%=chkiif(atype="dt","on","")%>"><a href="" onclick="fnChgSort('dt'); return false;" >기간별</a></li>
					<li class="swiper-slide <%=chkiif(atype="ne","on","")%>"><a href="" onclick="fnChgSort('ne'); return false;" >신상품</a></li>
					<li class="swiper-slide <%=chkiif(atype="st","on","")%>"><a href="" onclick="fnChgSort('st'); return false;" >스테디셀러</a></li>
					<li class="swiper-slide <%=chkiif(atype="ws","on","")%>"><a href="" onclick="fnChgSort('ws'); return false;" >위시</a></li>
					<li class="swiper-slide <%=chkiif(atype="ag","on","")%>"><a href="" onclick="fnChgSort('ag'); return false;" ><%=useragename%></a></li>
					<li class="swiper-slide <%=chkiif(atype="vi","on","")%>"><a href="" onclick="fnChgSort('vi'); return false;" >후기</a></li>
					<li class="swiper-slide <%=chkiif(atype="lv","on","")%>"><a href="" onclick="fnChgSort('lv'); return false;" ><%=userlevelname%></a></li>
					<li class="swiper-slide <%=chkiif(atype="br","on","")%>"><a href="" onclick="fnChgSort('br'); return false;" >브랜드</a></li>
					<li class="swiper-slide <%=chkiif(atype="mz","on","")%>"><a href="" onclick="fnChgSort('mz'); return false;" >맨즈</a></li>
					<li class="swiper-slide <%=chkiif(atype="fo","on","")%>"><a href="" onclick="fnChgSort('fo'); return false;" >첫 구매</a></li>
				</ul>
			</div>
		</div>
		<div class="sortingbarV19">
			<div class="option-slt">
				<div class="option-left">
					<div class="styled-selectbox styled-selectbox-default">
						<%
							'정렬상자 호출; sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명 (via functions.asp)
							Call fnPrntDispCateNaviV17BEST(vDisp,"F","fnChgDisp")
						%>
					</div>
				</div>
				<div class="option-right">
					<% If atype = "dt" then %>
					<div class="styled-selectbox styled-selectbox-default">
						<select class="select" title="기간 선택옵션" onchange="fnChgDate(this.value);">
						<option <% if Dategubun="m" then %>selected="selected"<% end if %> value="m">월간</option>
						<option <% if Dategubun="w" then %>selected="selected"<% end if %> value="w">주간</option>
						<option <% if Dategubun="d" then %>selected="selected"<% end if %> value="d">일간</option>
						</select>
					</div>
					<% elseif atype = "lv" then %>
					<div class="styled-selectbox styled-selectbox-default">
						<select class="select" title="등급 선택옵션" onchange="fnChgLevel(this.value);">
						<option <% if userlevel="4" Or userlevel="6" then %>selected="selected"<% end if %> value="4">VVIP</option>
						<option <% if userlevel="3" then %>selected="selected"<% end if %> value="3">VIP GOLD</option>
						<option <% if userlevel="2" then %>selected="selected"<% end if %> value="2">VIP</option>
						<option <% if userlevel="1" then %>selected="selected"<% end if %> value="1">RED</option>
						<option <% if userlevel="0" Or userlevel="5" then %>selected="selected"<% end if %> value="0">WHITE</option>
						<option <% if userlevel="7" or userlevel="8" then %>selected="selected"<% end if %> value="8">Guest</option>
						</select>
					</div>
					<% elseif atype = "ag" or atype = "mz" then %>
					<div class="styled-selectbox styled-selectbox-default">
						<select class="select" title="연령 선택옵션" onchange="fnChgAge(this.value);">
						<option <% if userage="10" then %>selected="selected"<% end if %> value="10">10대</option>
						<option <% if userage="20" then %>selected="selected"<% end if %> value="20">20대</option>
						<option <% if userage="30" then %>selected="selected"<% end if %> value="30">30대</option>
						<option <% if userage="40" then %>selected="selected"<% end if %> value="40">40대</option>
						</select>
					</div>
					<% end if %>
				</div>
			</div>
		</div>
	</div>

	<%'!-- for dev msg : 베스트는 기본형, 브랜드형, 후기형 타입이 있습니다. --%>
	<div id="bestItems" class="best-items-list">
	<%'기본형%>
	<% If atype = "ne" Or atype = "be" Or atype = "ws" Or atype = "hs" Or atype = "st" Or atype = "dt" Or atype = "lv" Or atype = "ag"  Or atype = "mz" Or atype = "fo" Then %>
		<div class="items type-list tenten-best-default tenten-best-new">
			<ul id="lyrEvtList">
			<%
			if CurrPage=1 then
				sNo=0
				eNo=14
			else
				sNo=(CurrPage-1) * 15
				eNo=(CurrPage * 15)-1
			end if

			if (oaward.FResultCount-1)<eNo then eNo = oaward.FResultCount-1

			tPg = (oaward.FResultCount\15)
			if (tPg<>(oaward.FResultCount/15)) then tPg = tPg +1

			If oaward.FResultCount > sNo Then
				If oaward.FResultCount Then
			%>
			<%	
				For i=sNo to eNo 

				classStr = ""		
				linkUrl = Request.ServerVariables("PATH_INFO") & "?" & GetParam("adtprdid="&oaward.FItemList(i).FItemID)							
				adultChkFlag = session("isAdult") <> true and oaward.FItemList(i).FadultType = 1

				if adultChkFlag then
					classStr = addClassStr(classStr,"adult-item")								
				end if														
			%>
					<li class="<%=classStr%>" <%=chkIIF(adultChkFlag, "onclick=""confirmAdultAuth('"& linkUrl &"', "& chkiif(IsUserLoginOK, "true", "false") &");""","")%>>
						<a href="" onclick="fnAPPpopupAutoUrl('/category/category_itemPrd.asp?itemid=<%=oaward.FItemList(i).FItemID%><%=gaparam & i+1 %>');return false;">
							<!-- for dev msg : 상품명으로 썸네일 alt값 달면 중복되니 alt=""으로 처리해주세요. -->
							<b class="no"><span class="rank"><%= i+1 %></span> <% If oaward.FItemList(i).GetLevelUpCount > "29" then %><span class="icon icon-up">급상승</span><% end if %></b>
							<div class="thumbnail">
								<%'// 해외직구배송작업추가 %>
								<% If oaward.FItemList(i).IsDirectPurchase Then %>
									<span class="abroad-badge">해외직구</span>
								<% End If %>
								<img src="<%=getThumbImgFromURL(oaward.FItemList(i).FImageBasic,"286","286","true","false") %>" alt="" />
								<% if adultChkFlag then %>									
								<div class="adult-hide">
									<p>19세 이상만 <br />구매 가능한 상품입니다</p>
								</div>
								<% end if %>									
							</div>
							<div class="desc">
								<span class="brand"><%=oaward.FItemList(i).FBrandName %></span>
								<p class="name"><%=oaward.FItemList(i).FItemName %></p>
								<div class="price">
								<%
									If oaward.FItemList(i).IsSaleItem AND oaward.FItemList(i).isCouponItem Then	'### 쿠폰 O 세일 O
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oaward.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
										Response.Write "&nbsp;<b class=""discount color-red"">" & oaward.FItemList(i).getSalePro & "</b>"
										If oaward.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
											If InStr(oaward.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
												Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
											Else
												Response.Write "&nbsp;<b class=""discount color-green"">" & oaward.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
											End If
										End If
										Response.Write "</div>" &  vbCrLf
									ElseIf oaward.FItemList(i).IsSaleItem AND (Not oaward.FItemList(i).isCouponItem) Then	'### 쿠폰 X 세일 O
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oaward.FItemList(i).getRealPrice,0) & "<span class=""won"">원</span></b>"
										Response.Write "&nbsp;<b class=""discount color-red"">" & oaward.FItemList(i).getSalePro & "</b>"
										Response.Write "</div>" &  vbCrLf
									ElseIf oaward.FItemList(i).isCouponItem AND (NOT oaward.FItemList(i).IsSaleItem) Then	'### 쿠폰 O 세일 X
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oaward.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
										If oaward.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
											If InStr(oaward.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
												Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
											Else
												Response.Write "&nbsp;<b class=""discount color-green"">" & oaward.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
											End If
										End If
										Response.Write "</div>" &  vbCrLf
									Else
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oaward.FItemList(i).getRealPrice,0) & "<span class=""won"">" & CHKIIF(oaward.FItemList(i).IsMileShopitem," Point"," 원") & "</span></b></div>" &  vbCrLf
									End If
								%>
								</div>
							</div>
						</a>
						<div class="etc">
							<% if oaward.FItemList(i).FEvalcnt > 0 then %>
								<div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(oaward.FItemList(i).FPoints,"search")%>%;">리뷰 종합 별점</i></span><span class="counting" title="리뷰 갯수"><%=chkIIF(oaward.FItemList(i).FEvalcnt>999,"999+",oaward.FItemList(i).FEvalcnt)%></span></div>
							<% end if %>
							<button class="tag wish btn-wish" onclick="goWishPop('<%=oaward.FItemList(i).FItemid%>','');">
							<%
							If oaward.FItemList(i).FFavCount > 0 Then
								If fnIsMyFavItem(vWishArr,oaward.FItemList(i).FItemID) Then
									Response.Write "<span class=""icon icon-wish on"" id=""wish"&oaward.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oaward.FItemList(i).FItemID&""">"
									Response.Write CHKIIF(oaward.FItemList(i).FFavCount>999,"999+",formatNumber(oaward.FItemList(i).FFavCount,0)) & "</span>"
								Else
									Response.Write "<span class=""icon icon-wish"" id=""wish"&oaward.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oaward.FItemList(i).FItemID&""">"
									Response.Write CHKIIF(oaward.FItemList(i).FFavCount>999,"999+",formatNumber(oaward.FItemList(i).FFavCount,0)) & "</span>"
								End If
							Else
								Response.Write "<span class=""icon icon-wish"" id=""wish"&oaward.FItemList(i).FItemID&"""><i> wish</i></span><span class=""counting"" id=""cnt"&oaward.FItemList(i).FItemID&"""></span>"
							End If
							%>
							</button>
							<% IF oaward.FItemList(i).IsCouponItem AND oaward.FItemList(i).GetCouponDiscountStr = "무료배송" Then %>
								<div class="tag shipping"><span class="icon icon-shipping"><i>무료배송</i></span> FREE</div>
							<% End If %>
						</div>
					</li>
			<%
					vSaleFreeDeliv = ""
				Next
			%>
			<%
				End If
			End If
			%>
			</ul>
		</div>
	<% elseif atype = "br" Then %>
		<div class="items type-list tenten-best-default tenten-best-new tenten-best-brand">
			<ul id="lyrEvtList">
			<%
			if CurrPage=1 then
				sNo=0
				eNo=44
			else
				sNo=(CurrPage-1) * 45
				eNo=(CurrPage * 45)-1
			end if

			if (oaward.FResultCount-1)<eNo then eNo = oaward.FResultCount-1

			tPg = (oaward.FResultCount\45)
			if (tPg<>(oaward.FResultCount/45)) then tPg = tPg +1
			If oaward.FResultCount > sNo Then
				If oaward.FResultCount Then
					For i=sNo to eNo
						If i Mod 3 = 0 Then
			%>
							<li>
								<a href="" onclick="fnAPPpopupAutoUrl('/street/street_brand.asp?makerid=<%=oaward.FItemList(i).FMakerID %><%=gaparam & i+1 %>');return false;">
									<b class="no"><span class="rank"><%=(i/3)+1%></span></b>
									<div class="desc">
										<span class="brand" lang="en"><%=oaward.FItemList(i).FBrandName %></span>
										<span class="brand" lang="ko"><%=oaward.FItemList(i).FSocName_Kor %></span>
									</div>
									<div class="thumbnail">
						<%
						End If
						%>
										<img src="<%=getThumbImgFromURL(oaward.FItemList(i).FImageBasic,"286","286","true","false") %>" alt="" />
						<%
						If i Mod 3 = 2 Then
						%>
									</div>
								</a>
								<div class="zzim">
									<span class="counting" id="<%=oaward.FItemList(i).FMakerID %>" title="찜브랜드"><%= oaward.FItemList(i).Frecommendcount %></span>
									<% if fnIsMyZzimBrand(vZzimArr,oaward.FItemList(i).FMakerID) then %>
										<button type="button" id="<%=oaward.FItemList(i).FMakerID&"btn" %>" onclick="TnMyBrandZZim('<%=oaward.FItemList(i).FMakerID %>'); return false;" class="btn-zzim on">찜브랜드 해제하기</button>
									<% else %>
										<button type="button" id="<%=oaward.FItemList(i).FMakerID&"btn" %>" onclick="TnMyBrandZZim('<%=oaward.FItemList(i).FMakerID %>'); return false;" class="btn-zzim">찜브랜드로 등록하기</button>
									<% end if %>
								</div>
								
							</li>
			<%
						end if
					Next
				End If
			End If
			%>
			</ul>
		</div>
	<% elseif atype = "vi" Then %>
		<div class="items type-list tenten-best-default tenten-best-new tenten-best-review">
			<ul id="lyrEvtList">
			<%
			if CurrPage=1 then
				sNo=0
				eNo=9
			else
				sNo=(CurrPage-1) * 10
				eNo=(CurrPage * 10)-1
			end if

			if (oaward.FResultCount-1)<eNo then eNo = oaward.FResultCount-1

			tPg = (oaward.FResultCount\10)
			if (tPg<>(oaward.FResultCount/10)) then tPg = tPg +1

			If oaward.FResultCount > sNo Then
				If oaward.FResultCount Then
					For i=sNo to eNo
						classStr = ""					
						adultChkFlag = session("isAdult") <> true and oaward.FItemList(i).FadultType = 1																						
						linkUrl = Request.ServerVariables("PATH_INFO") & "?" & GetParam("adtprdid="&oaward.FItemList(i).FItemID)							

						if adultChkFlag then
							classStr = addClassStr(classStr,"adult-item")								
						end if																			
			%>
						<li class="<%=classStr%>" <%=chkIIF(adultChkFlag, "onclick=""confirmAdultAuth('"& linkUrl &"', "& chkiif(IsUserLoginOK, "true", "false") &");""","")%>>
							<a href="" onclick="fnAPPpopupAutoUrl('/category/category_itemPrd.asp?itemid=<%=oaward.FItemList(i).FItemID%><%=gaparam & i+1 %>');return false;">
								<b class="no"><span class="rank"><%= i+1 %></span></b>
								<div class="thumbnail">
									<%'// 해외직구배송작업추가 %>
									<% If oaward.FItemList(i).IsDirectPurchase Then %>
										<span class="abroad-badge">해외직구</span>
									<% End If %>
									<img src="<%=getThumbImgFromURL(oaward.FItemList(i).FImageBasic,"200","200","true","false") %>" alt="" />
									<% if adultChkFlag then %>									
									<div class="adult-hide">
										<p>19세 이상만 <br />구매 가능한 상품입니다</p>
									</div>
									<% end if %>											
								</div>
								<div class="desc">
									<span class="brand"><%=oaward.FItemList(i).FBrandName %></span>
									<p class="name"><%=oaward.FItemList(i).FItemName %></p>
									<div class="price">
									<%
										If oaward.FItemList(i).IsSaleItem AND oaward.FItemList(i).isCouponItem Then	'### 쿠폰 O 세일 O
											Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oaward.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
											Response.Write "&nbsp;<b class=""discount color-red"">" & oaward.FItemList(i).getSalePro & "</b>"
											If oaward.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
												If InStr(oaward.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
													Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
												Else
													Response.Write "&nbsp;<b class=""discount color-green"">" & oaward.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
												End If
											End If
											Response.Write "</div>" &  vbCrLf
										ElseIf oaward.FItemList(i).IsSaleItem AND (Not oaward.FItemList(i).isCouponItem) Then	'### 쿠폰 X 세일 O
											Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oaward.FItemList(i).getRealPrice,0) & "<span class=""won"">원</span></b>"
											Response.Write "&nbsp;<b class=""discount color-red"">" & oaward.FItemList(i).getSalePro & "</b>"
											Response.Write "</div>" &  vbCrLf
										ElseIf oaward.FItemList(i).isCouponItem AND (NOT oaward.FItemList(i).IsSaleItem) Then	'### 쿠폰 O 세일 X
											Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oaward.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
											If oaward.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
												If InStr(oaward.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
													Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
												Else
													Response.Write "&nbsp;<b class=""discount color-green"">" & oaward.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
												End If
											End If
											Response.Write "</div>" &  vbCrLf
										Else
											Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oaward.FItemList(i).getRealPrice,0) & "<span class=""won"">" & CHKIIF(oaward.FItemList(i).IsMileShopitem," Point"," 원") & "</span></b></div>" &  vbCrLf
										End If
									%>
									</div>
								</div>
								<% If chkCnt > 2 Then %>
									<% If oaward.FItemList(i).FevaContents <> "" Then %>
										<div class="review-desc">
											<p><%=chrbyte(oaward.FItemList(i).FevaContents, "140","Y")%></p>
											<div class="review">
												<span class="id"><%= printUserId(oaward.FItemList(i).FevaUserid,2,"*") %></span>
												<span class="icon icon-rating"><i style="width:<%=oaward.FItemList(i).FevaTotalpoint*20%>%;"><%=oaward.FItemList(i).FevaTotalpoint*20%>점</i></span>
											</div>
										</div>
									<% End If %>
								<% End If %>
							</a>
							<div class="etc">
								<button class="tag wish btn-wish" onclick="goWishPop('<%=oaward.FItemList(i).FItemid%>','');">
								<%
								If oaward.FItemList(i).FFavCount > 0 Then
									If fnIsMyFavItem(vWishArr,oaward.FItemList(i).FItemID) Then
										Response.Write "<span class=""icon icon-wish on"" id=""wish"&oaward.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oaward.FItemList(i).FItemID&""">"
										Response.Write CHKIIF(oaward.FItemList(i).FFavCount>999,"999+",formatNumber(oaward.FItemList(i).FFavCount,0)) & "</span>"
									Else
										Response.Write "<span class=""icon icon-wish"" id=""wish"&oaward.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oaward.FItemList(i).FItemID&""">"
										Response.Write CHKIIF(oaward.FItemList(i).FFavCount>999,"999+",formatNumber(oaward.FItemList(i).FFavCount,0)) & "</span>"
									End If
								Else
									Response.Write "<span class=""icon icon-wish"" id=""wish"&oaward.FItemList(i).FItemID&"""><i> wish</i></span><span class=""counting"" id=""cnt"&oaward.FItemList(i).FItemID&"""></span>"
								End If
								%>
								</button>
							</div>
						</li>
			<%
					Next
				End If
			End If
			%>
			</ul>
		</div>
		<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:0; margin-top:-20px;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
	<% end if %>
		<div class="nav-other-best">
			<h2><span class="icon icon-trophy"></span>다른 베스트셀러들도 궁금하시다면!</h2>
			<ul>
				<li <%=chkiif(atype="dt","style='display:none;'","")%>><a href="" onclick="fnChgSort('dt'); return false;" >기간별</a></li>
				<li <%=chkiif(atype="ne","style='display:none;'","")%>><a href="" onclick="fnChgSort('ne'); return false;" >신상품</a></li>
				<li <%=chkiif(atype="st","style='display:none;'","")%>><a href="" onclick="fnChgSort('st'); return false;" >스테디셀러</a></li>
				<li <%=chkiif(atype="ws","style='display:none;'","")%>><a href="" onclick="fnChgSort('ws'); return false;" >위시</a></li>
				<li <%=chkiif(atype="ag","style='display:none;'","")%>><a href="" onclick="fnChgSort('ag'); return false;" >연령별</a></li>
				<li <%=chkiif(atype="vi","style='display:none;'","")%>><a href="" onclick="fnChgSort('vi'); return false;" >후기</a></li>
				<li <%=chkiif(atype="lv","style='display:none;'","")%>><a href="" onclick="fnChgSort('lv'); return false;" >등급별</a></li>
				<li <%=chkiif(atype="br","style='display:none;'","")%>><a href="" onclick="fnChgSort('br'); return false;" >브랜드</a></li>
				<li <%=chkiif(atype="mz","style='display:none;'","")%>><a href="" onclick="fnChgSort('mz'); return false;" >맨즈</a></li>
				<li <%=chkiif(atype="fo","style='display:none;'","")%>><a href="" onclick="fnChgSort('fo'); return false;" >첫 구매</a></li>
			</ul>
		</div>
	</div>
<form method="post" name="jjimfrm" style="margin:0px;" target="ifrm">
	<input type="hidden" name="makerid" value="">
	<input type="hidden" name="bestpg" value="1">
</form>
<form name="frmAward" id="frmAward" method="get" action="">
<input type="hidden" name="disp" value="<%=vDisp%>" />
<input type="hidden" name="flag" value="<%=flag%>" />
<input type="hidden" name="atype" value="<%=atype%>" />
<input type="hidden" name="dategubun" value="<%=dategubun%>" />
<input type="hidden" name="userlevel" value="<%=userlevel%>" />
<input type="hidden" name="userage" value="<%=userage%>" />
<input type="hidden" name="toggle" id="toggle" value="<%=toggle%>" />
<input type="hidden" name="gnbflag" value="<%=chkiif(gnbflag,"","1")%>" />
</form>
<iframe name="ifrm" frameborder="0" width="0" height="0"></iframe>
</div>
<!-- #include virtual="/apps/appcom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<%
set oaward = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->