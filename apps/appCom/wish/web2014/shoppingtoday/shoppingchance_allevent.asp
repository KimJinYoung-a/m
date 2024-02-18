<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
	Session.CodePage = 65001
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/enjoy/shoppingchanceCls_B.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/event/mktevtbannerCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
	Dim scType, scTypegb, sCategory, sCateMid, vIsMine, ddayicon , gnbflag
	Dim cShopchance
	Dim iTotCnt, arrList,intLoop
	Dim iPageSize, iCurrpage ,iDelCnt
	Dim iStartPage, iEndPage, iTotalPage, ix,iPerCnt, k
	Dim atype, selOp
	Dim cMktbanner , sqlStr , arrMktevt , mPageSize , MktCnt
	Dim eName, eNameredsale, eNamegreensale, addTag, ip

	atype = RequestCheckVar(request("atype"),1)
	if atype="" then atype="b"

	selOp		=  requestCheckVar(Request("selOP"),1) '정렬
	vIsMine		=  requestCheckVar(Request("ismine"),1)
	gnbflag		=  RequestCheckVar(request("gnbflag"),1)

	If gnbflag = "" Then '//gnb 숨김 여부
		gnbflag = true
	Else
		gnbflag = False
	End if

	If vIsMine = "o" Then
		selOp = ""
		sCategory = ""
	End If

	'APP 버전에 따른 표시 여부 분기
	dim iandOrIos, iappVer, isViewChk
'	iappVer = getAppVerByAgent(iandOrIos)
'	isViewChk = TRUE
'	if (iandOrIos="a") then	'안드
''	    if (iappVer>="1.91") then	'안드 최신버전이면
''	        isViewChk = FALSE
''	    end if
'	else	'ios
'	    if (iappVer>="1.997") then	'ios 최신버전이면
'	        isViewChk = FALSE
'	    end if
'	end if

	'파라미터값 받기 & 기본 변수 값 세팅
	scType 		= requestCheckVar(Request("scT"),4) '쇼핑찬스 분류
	scTypegb 		= requestCheckVar(Request("scTgb"),10) '마케팅이벤트/기획전 이벤트 분류 2016-05-02 유태욱
	sCategory 	= requestCheckVar(Request("disp"),3) '카테고리 대분류
	iCurrpage 	= requestCheckVar(Request("iC"),10)	'현재 페이지 번호

	If scType ="end" then
		selOp = "1"
	ElseIf selOp = "" Then
		selOp = "0"
	End if

	If scTypegb = "" then		''planevt - 기획전 , mktevt - 마케팅 이벤트
		scTypegb = "planevt"
	end if

	IF iCurrpage = "" THEN	iCurrpage = 1

	iPageSize = 15  '이벤트 배너
	iPerCnt = 4		'보여지는 페이지 간격

	mPageSize = CInt(iPageSize/5) '//마케팅 배너

	'배너 데이터 가져오기 2015-06-11 이종화 추가
	Dim i , gubun , mktimg , m_eventid , a_eventid , isurl
	reDim vHtml(10)
	set cMktbanner = new CEvtMktbanner
	cMktbanner.FPageSize	=	mPageSize '//5개당 1개 노출
	cMktbanner.FCurrPage	=	iCurrpage
	cMktbanner.Fdevice		=	"A"
	If scTypegb = "mktevt" then
		cMktbanner.Fevtgubun		=	2
	else
		cMktbanner.Fevtgubun		=	1
	end if
	if (scTypegb = "mktevt") or scTypegb = "planevt" then
		cMktbanner.GetMktBannerList()
	end if
	MktCnt		= cMktbanner.FResultCount

	If MktCnt > 0 Then
		FOR i=0 to cMktbanner.FResultCount-1
			gubun				= cMktbanner.FItemList(i).Fgubun
			mktimg				= cMktbanner.FItemList(i).Fmktimg
			m_eventid			= cMktbanner.FItemList(i).Fm_eventid
			a_eventid			= cMktbanner.FItemList(i).Fa_eventid

			isurl = "fnAPPpopupEvent('"& a_eventid &"'); return false;"

			vHtml(i) = "<li class='ad-bnr'><a href onclick="""& isurl &"""><div class=""thumbnail""><img src="""&mktimg&""" alt="""" /></div></a>	</li>"
		Next
	End If
	Set cMktbanner = Nothing

	'데이터 가져오기
	set cShopchance = new ClsShoppingChance
	cShopchance.FCPage 			= iCurrpage		'현재페이지
	cShopchance.FPSize 			= iPageSize		'페이지 사이즈
	cShopchance.FSCType 			= scType    	'이벤트구분(전체,세일,사은품,상품후기, 신규,마감임박)
	cShopchance.FSCTypegb		= scTypegb    	'이벤트구분(기획전,마케팅)
	cShopchance.FSCategory 		= sCategory 	'제품 카테고리 대분류
	cShopchance.FSCateMid 		= sCateMid		'제품 카테고리 중분류
	cShopchance.FEScope 			= 2				'view범위: 10x10
	cShopchance.FselOp	 		= selOp			'이벤트정렬
	cShopchance.FUserID			= CHKIIF(vIsMine="o",GetLoginUserID(),"")
	cShopchance.Fis2014renew	= "o"			'2014리뉴얼구분
	if (scTypegb = "mktevt") or scTypegb = "planevt" then
		arrList = cShopchance.fnGetAppBannerList	'배너리스트 가져오기
	end if
	iTotCnt = cShopchance.FTotCnt 				'배너리스트 총 갯수
	set cShopchance = nothing
	iTotalPage =   int((iTotCnt-1)/iPageSize) +1  '전체 페이지 수

	'// APP 버전 정보 접수
'	function getAppVerByAgent(byref iosOrAnd)
'	    dim agnt : agnt =  Lcase(Request.ServerVariables("HTTP_USER_AGENT"))
'	    dim pos1 : pos1 = Instr(agnt,"tenapp ")
'	    dim buf
'	    dim retver : retver=""
'	    getAppVerByAgent = retver
'
'	    if (pos1<1) then exit function
'	    buf = Mid(agnt,pos1,255)
'
'	    iosOrAnd = MID(agnt,pos1 + LEN("tenapp "),1)
'	    getAppVerByAgent = Trim(MID(agnt,pos1 + LEN("tenapp ")+1,5))
'	end function

	'// 구버전 신버전 분기 (padding-top)
	Dim appver
	If (InStr(uAgent,"tenapp i2.")>0) Or (InStr(uAgent,"tenapp a2.")>0) Or (InStr(uAgent,"tenapp a3.")>0) Or (InStr(uAgent,"tenapp i3.")>0) Then
		appver = true
	Else
		appver = false
	End If
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!--<style><% if not(appver) then %>.body-main {padding-top:0px;}<% end if %></style>-->
<script type="text/javascript">
$(function() {
	$(function() {
		if ($("body").hasClass("body-sub")){
			$(window).scroll(sticky_sortingbar);
		}
	});
});

function sticky_sortingbar() {
	var window_top = $(window).scrollTop();
	var div_top = $("#exhibitionList").offset().top;
	if (window_top >= div_top) {
		$("#exhibitionList").addClass('sticky');
	} else {
		$("#exhibitionList").removeClass('sticky');
	}
}

function jsGoPage(iP){
	document.frmSC.iC.value = iP;
	document.frmSC.action = "/apps/appcom/wish/web2014/shoppingtoday/shoppingchance_allevent.asp";
	document.frmSC.submit();
}

function jsIsMine(a,b){
<% If IsUserLoginOK() Then %>
	document.frmSC.iC.value = 1;
	document.frmSC.ismine.value = a;
	document.frmSC.scTgb.value = b;
	document.frmSC.action = "/apps/appcom/wish/web2014/shoppingtoday/shoppingchance_allevent.asp";
	document.frmSC.submit();
<% Else %>
	calllogin();
	return false;
<% End If %>
}

function jsSelOp(a){ //이벤트정렬
	document.frmSC.iC.value = 1;
	document.frmSC.selOP.value = a;
	document.frmSC.action = "/apps/appcom/wish/web2014/shoppingtoday/shoppingchance_allevent.asp";
	document.frmSC.submit();
}

//카테고리 변경
function changeCate(v){
	document.frmSC.disp.value = v;
	document.frmSC.submit();
}

var vPg=1, vScrl=true;
$(function(){
	// 스크롤시 추가페이지 접수
	$(window).scroll(function() {
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-512){
			if(vScrl) {
				vScrl = false;
				vPg++;
				$.ajax({
					url: "act_shoppingchance_allevent.asp?scTgb=<%=scTypegb%>&scT=<%=scType%>&disp=<%=sCategory%>&selOP=<%=selOp%>&ismine=<%=vIsMine%>&iC="+vPg,
					cache: false,
					success: function(message) {
						if(message!="") {
							$("#lyrEvtList").append(message);
							vScrl=true;
						} else {
//							var ctbnr = "<li class='culture-bnr' id='ctbnr'><a href='' onclick='fnAPPpopupCulture_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/culturestation/index.asp'); return false;'><span class='icon icon-culture'></span><b>컬쳐 스테이션</b> <span class='subcopy'>감성을 채우는 문화정거장</span></a></li>"
//							$("#lyrEvtList").append(ctbnr);
							$("#ctbnr").show();
							<% if sCategory<>"" then  %>
							var anotherDisp = "<%=DrawDispCategoryList(sCategory,"1",gnbflag) %>"
							$("#lyrEvtList").append(anotherDisp);
							<% end if %>
							$(window).unbind("scroll");
						}
					}
					,error: function(err) {
						alert(err.responseText);
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
});
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

	wsapp_Ccd = "event"
	wsapp_Ncd = "wish"  : wsapp_Nurl = "http://m.10x10.co.kr/apps/appCom/wish/web2014/wish/index.asp"
	wsapp_Pcd = "sale" : wsapp_Purl = "http://m.10x10.co.kr/apps/appCom/wish/web2014/sale/saleitem.asp"

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

<%
	'//구버전 height (리뉴얼 이후버전 2.0)
	if not((InStr(uAgent,"tenapp i2.")>0) or (InStr(uAgent,"tenapp a2.")>0)) then
%>
	$(function(){ $("body-main").css({"padding-top":"0"}); });
<%
	end if
%>
</script>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"sub","main")%>"><%' for dev msg : GNB메뉴에서 들어갈때만 body-main클래스가 붙습니다. 그 이외의 페이지에서는 body-sub가 붙습니다. %>
	<div id="content" class="content">
		<!-- exhibition/event list -->
		<section id="exhibitionList" class="exhibition-list">
			<h2 class="hidden"><%=CHKIIF(scTypegb="planevt","기획전","이벤트")%></h2>

			<% if vIsMine = "o" then %>
				<ul class="commonTabV16a">
					<li class="<%=chkiif(scTypegb="planevt","current","")%>" name="tab01" onClick="jsIsMine('o','planevt'); return false;" style="width:50%;">기획전</li>
					<li class="<%=chkiif(scTypegb="mktevt","current","")%>" name="tab02" onClick="jsIsMine('o','mktevt'); return false;" style="width:50%;">이벤트</li>
				</ul>
			<% else %>
				<% If scTypegb <> "bw" Then '//슈퍼루키(브랜드위크) 없을때만 노출 %>
					<!-- 건수 및 정렬 옵션 셀렉트박스 -->
					<div class="sortingbar">
						<div class="option-left">
							<p class="total"><b><%= iTotCnt %></b>건</p>
						</div>

						<div class="option-right">
							<div class="styled-selectbox styled-selectbox-default">
								<select class="select" onchange="changeCate(this.value);" title="카테고리 선택옵션">
									<% if scTypegb = "mktevt" then %>
										<option selected="selected" onclick="changeCate(''); return flase;" value="">전체</option>
										<option value="" onclick="changeCate(''); return flase;">마케팅 이벤트</option>
									<% else %>
										<%=DrawSelectBoxDispCategory(sCategory,"1") %>
									<% end if %>
								</select>
							</div>
							<div class="styled-selectbox styled-selectbox-default">
								<select class="select" onchange="jsSelOp(this.value);" title="정렬 선택옵션">
									<option <%=CHKIIF(selOp="0","selected='selected'","")%>  value="0" >신규순</option>
									<% if scTypegb = "planevt" then %>
										<option <%=CHKIIF(selOp="2","selected='selected'","")%> value="2" >인기순</option>
									<% end if %>
									<option <%=CHKIIF(selOp="1","selected='selected'","")%> value="1">마감임박순</option>
									<option <%=CHKIIF(selOp="3","selected='selected'","")%> value="3">할인율순</option>
								</select>
							</div>
						</div>
					</div>
				<% end if %>
			<% end if %>

			<%
			'### 배열번호
			' 0 ~ 7  : A.evt_code, B.evt_bannerimg, A.evt_startdate, A.evt_enddate, A.evt_kind, B.brand,B.evt_LinkType ,B.evt_bannerlink '
			' 8		 : ,(Case When A.evt_kind=13 Then (Select top 1 itemid from [db_event].[dbo].[tbl_eventitem] where evt_code=A.evt_code order by itemid desc) else 0 end) as itemid '
			' 9 ~ 20 : , B.evt_bannerimg_mo, A.evt_name, B.issale, B.isgift, B.iscoupon, B.isOnlyTen, B.isoneplusone, B.isfreedelivery, B.isbookingsell, B.iscomment, B.etc_itemid, A.evt_subcopyK '
			'21		 : , case when isNull(B.etc_itemimg,'''') = '''' then (select isNull(basicimage600,'''') from db_item.dbo.tbl_item where itemid = B.etc_itemid) end as basicimage600 '
			'22		 : , case when isNull(B.etc_itemimg,'''') = '''' then (select basicimage from db_item.dbo.tbl_item where itemid = B.etc_itemid) end as basicimage '
			'24	~ 28 : , A.evt_subname, B.evt_mo_listbanner , B.evt_todaybanner, b.isitemps, b.saleCper '

			Dim vLink, vIcon , vRnum
			vRnum = 0

			IF isArray(arrList) THEN %>
			<div class="list-card type-align-left">
				<ul id="lyrEvtList">
				<!-- for dev msg :
					기획전 : 이슈배너는 정렬순에 따라 배너 사이에 배치 (기획전 배너 5당 하나씩)되며, 이슈배너는 클래스명 class="ad-bnr"가 붙습니다.
					이벤트 : <li class="culture-bnr"> (... omitted ...) </li>가 하단 제일 아래에 붙습니다.
				-->
				<%
				For intLoop =0 To UBound(arrList,2)

					if arrList(4,intLoop) = "13" Then '//상품이벤트 일경우
						vLink = "fnAPPpopupProduct('" & arrList(8,intLoop) & "');"
					Else '// 그외에
						IF arrList(6,intLoop)="I" and arrList(7,intLoop)<>"" THEN '링크타입 체크
							vLink = "fnAPPpopupEvent_URL('" & arrList(7,intLoop) & "');"
						ELSE
							vLink = "fnAPPpopupEvent('" & arrList(0,intLoop) & "'); return false;"
						END IF
					End If

					'//이벤트 명 할인이나 쿠폰시
					If arrList(11,intLoop) Or arrList(13,intLoop) Then
						if ubound(Split(arrList(10,intLoop),"|"))> 0 Then
							If arrList(11,intLoop) Or (arrList(11,intLoop) And arrList(13,intLoop)) then
								eName	= cStr(Split(arrList(10,intLoop),"|")(0))
'								eNameredsale	= " <b class=""red""><span><i>"&cStr(Split(arrList(10,intLoop),"|")(1))&"</i></span></b>"
								eNameredsale	= cStr(Split(arrList(10,intLoop),"|")(1))
							ElseIf arrList(13,intLoop) Then
								eName	= cStr(Split(arrList(10,intLoop),"|")(0))
'								eNameredsale	= " <b class=""red""><span><i>"&cStr(Split(arrList(10,intLoop),"|")(1))&"</i></span></b>"
								eNameredsale	= cStr(Split(arrList(10,intLoop),"|")(1))
								'eNamegreensale = " <b class=""green""><span><i>"&cStr(Split(arrList(10,intLoop),"|")(1))&"</i></span></b>"
							End If
						Else
							eName = arrList(10,intLoop)
							eNameredsale	= ""
							'eNamegreensale = ""
						end If
					Else
						eName = arrList(10,intLoop)
						eNameredsale	= ""
						'eNamegreensale = ""
					End If

					ddayicon = datediff("d",arrList(3,intLoop),date)
					dim saleCper

					If arrList(26,intLoop) Then vIcon = " <em class=""color-blue"">후기</em>" End IF
					If arrList(18,intLoop) Then vIcon = " <em class=""color-blue"">코멘트</em>" End IF
					If arrList(14,intLoop) Then vIcon = " <em class=""color-blue"">단독</em>" End IF
					If arrList(15,intLoop) Then vIcon = " <em class=""color-blue"">1+1</em>" End IF
					If arrList(12,intLoop) Then vIcon = " <em class=""color-blue"">기프트</em>" End IF
					If arrList(17,intLoop) Then vIcon = " <em class=""color-blue"">예약</em>" End IF
'					If Not(arrList(27,intLoop)="" or isNull(arrList(27,intLoop))) Then
					If arrList(13,intLoop) <> 0 Then
						saleCper = arrList(27,intLoop)
'						vIcon = " <em class=""color-green"">쿠폰"&saleCper&"</em>"
						vIcon = " <em class=""color-green"">쿠폰</em>"
		'						If arrList(11,intLoop) Then vIcon = " <em class=""color-green"">쿠폰"&saleCper&"</em>" End IF
					end if

'					If ddayicon < 1 and ddayicon > -4 Then
'						if ddayicon = 0 then
'							vIcon = "<b class=""grey""><span><i>오늘<br/>까지</i></span></b>"
'						else
'							vIcon = "<b class=""grey""><span><i>D"&ddayicon&"</i></span></b>"
'						End If
'					End IF

					'If arrList(11,intLoop) Then vIcon = "" End IF
					'If arrList(13,intLoop) Then vIcon = "" End IF
					'If datediff("d",arrList(2,intLoop),date)<=3 Then vIcon = "" End IF

					if vIsMine <> "o" then
						'// 마케팅 배너 삽입 2015-06-11 이종화
						If scTypegb <> "bw" and intLoop > 0 Then  '// 2017-04-17 브랜드 위크 일때 노출 안함
							If intLoop Mod 5 = 0 Then
								Response.write vHtml(vRnum)
								vRnum = vRnum + 1
							End If
						End If
					end if

					'20210819 리스트 태그 추가(정태훈)
					addTag = ""
					if arrList(29,intLoop) <> "" or not(isnull(arrList(29,intLoop))) then
						if ubound(Split(arrList(29,intLoop),",")) > 0 Then
							addTag = addTag & "<ul class='list-tag'>"
							for ip = 0 to ubound(Split(arrList(29,intLoop),","))
								if ip > 5 then exit for
								addTag = addTag & "<li><a href='' onclick='fnAPPpopupSearchOnNormal(""" & Split(arrList(29,intLoop),",")(ip) & """);return false;'>#"& Split(arrList(29,intLoop),",")(ip) &"</a></li>"
							next 
							addTag = addTag & "</ul>"
						end if 
					end if
				%>
					<li<% If arrList(28,intLoop)<>"" Then %> class="has-vod"<% End If %>>
						<a href="" onclick="<%=vLink%> return false;">
							<!-- for dev msg : 썸네일 alt값 alt=""으로 처리해주세요. -->
							<div class="thumbnail"><img src="<%=chkiif(arrList(24,intLoop)="",arrList(25,intLoop),arrList(24,intLoop))%>" alt="<%=db2html(arrList(10,intLoop))%>"></div>
							<div class="desc">
								<p>
									<b class="headline"><span class="ellipsis" <% IF arrList(11,intLoop) and eNameredsale <> "" THEN %>style="width:80%;"<% else %>style="width:100%;"<% end if %>><%=Replace(stripHTML(db2html(eName)),"[☆2015 다이어리]","")%></span> <% IF arrList(11,intLoop) and eNameredsale <> "" THEN %><b class="discount color-red"><%=eNameredsale%></b><% end if %></b>
									<span class="subcopy"><% if vIcon <> "" then %><span class="label label-color"><%=vIcon%></span><% end if %><%=stripHTML(db2html(arrList(23,intLoop)))%></span>
								</p>
								<%=addTag%>
							</div>
						</a>
						<%	'// 5개 마다 노출
							'If intLoop Mod 5 = 0 And scTypegb="planevt" Then
							'	Response.write fngetListItemHtml(arrList(0,intLoop))
							'End If
						%>
					</li>
				<%
				vLink = ""
				vIcon = ""
				Next
				%>
					<li class="culture-bnr" id="ctbnr" style="display:none" ><a href="" onclick="fnAPPpopupCulture_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/culturestation/index.asp'); return false;"><span class="icon icon-culture"></span><b>컬쳐 스테이션</b> <span class="subcopy">감성을 채우는 문화정거장</span></a></li>
				</ul>
			</div>
			<% Else %>
				<% if scTypegb = "planevt" then %>
					<div class="emptyMsgV16a emptyExhtV16a">
						<div>
							<p><%=chkIIF(vIsMine="o","진행중인 관심 기획전이 없습니다.","진행중인 기획전이 없습니다.")%></p>
						</div>
					</div>
				<% else %>
					<div class="emptyMsgV16a emptyEvtV16a">
						<div>
							<p><%=chkIIF(vIsMine="o","진행중인 관심 이벤트가 없습니다.","진행중인 이벤트가 없습니다.")%></p>
						</div>
					</div>
				<% end if %>
			<% End If %>

			<form name="frmSC" method="get" action="/apps/appcom/wish/web2014/shoppingtoday/shoppingchance_allevent.asp" style="margin:0px;">
			<input type="hidden" name="scTgb" value="<%=scTypegb%>">
			<input type="hidden" name="iC" >
			<input type="hidden" name="scT" value="<%=scType%>">
			<input type="hidden" name="disp" value="<%=sCategory%>">
			<input type="hidden" name="selOP" value="<%=selOP%>">
			<input type="hidden" name="ismine" value="<%=vIsMine%>">
			<input type="hidden" name="gnbflag" value="<%=chkiif(gnbflag,"","1")%>" />
			</form>
		</section>
		<% if scTypegb = "mktevt" then %>

		<script type="text/javascript">
		// Check offshop event; 20170421 허진원
		setTimeout(function(){
	        callNativeFunction('getDeviceInfo', {"callback": function(deviceInfo) {
		        	var vNid = deviceInfo.nudgeuid;
		        	var vIdfa = deviceInfo.idfa;
		        	var vPid = deviceInfo.psid;
		        	var vUuid = deviceInfo.uuid;

					if(!vNid) vNid = vIdfa;				// Android : nudgeid - IOX : idfa

					$.ajax({
						url: "/apps/appcom/wish/web2014/shoppingtoday/offshop/act_offshop_evtbanner.asp",
						data: "nid="+vNid +"&pid="+vPid+"&uid="+vUuid,
						type: "POST",
						cache: false,
						success: function(message) {
							if(message!="") {
								if($("#lyrEvtList").length>0) {
									$("#lyrEvtList").prepend(message);
								} else {
									$(".emptyMsgV16a").before('<section class="listCardV16"><ul  id="lyrEvtList">'+message+'</ul></section>').remove();
								}
							}
						}
						,error: function(err) {
							alert(err.responseText);
						}
					});
		        }
			});
		},50);
		</script>
		<% end if %>
	</div>
	<!-- //contents -->

	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->