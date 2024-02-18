<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/enjoy/shoppingchanceCls_B.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
	Dim scType, sCategory, sCateMid, vIsMine
	Dim cShopchance
	Dim iTotCnt, arrList,intLoop
	Dim iPageSize, iCurrpage ,iDelCnt
	Dim iStartPage, iEndPage, iTotalPage, ix,iPerCnt, k
	Dim atype, selOp
	atype = RequestCheckVar(request("atype"),1)
	if atype="" then atype="b"

	selOp		=  requestCheckVar(Request("selOP"),1) '정렬
	vIsMine		= requestCheckVar(Request("ismine"),1)
	
	If vIsMine = "o" Then
		selOp = ""
		sCategory = ""
	End If

	'파라미터값 받기 & 기본 변수 값 세팅
	scType 		= requestCheckVar(Request("scT"),4) '쇼핑찬스 분류
	sCategory 	= requestCheckVar(Request("disp"),3) '카테고리 대분류
	iCurrpage 	= requestCheckVar(Request("iC"),10)	'현재 페이지 번호

	If scType ="end" then
		selOp = "1"
	ElseIf selOp = "" Then
		selOp = "0"
	End if

	IF iCurrpage = "" THEN	iCurrpage = 1


	iPageSize = 12
	iPerCnt = 4		'보여지는 페이지 간격


	'데이터 가져오기
	set cShopchance = new ClsShoppingChance
	cShopchance.FCPage 			= iCurrpage		'현재페이지
	cShopchance.FPSize 			= iPageSize		'페이지 사이즈
	cShopchance.FSCType 		= scType    	'이벤트구분(전체,세일,사은품,상품후기, 신규,마감임박)
	cShopchance.FSCategory 		= sCategory 	'제품 카테고리 대분류
	cShopchance.FSCateMid 		= sCateMid		'제품 카테고리 중분류
	cShopchance.FEScope 		= 2				'view범위: 10x10
	cShopchance.FselOp	 		= selOp			'이벤트정렬
	cShopchance.FUserID			= CHKIIF(vIsMine="o",GetLoginUserID(),"")
	cShopchance.Fis2014renew	= "o"			'2014리뉴얼구분
	arrList = cShopchance.fnGetAppBannerList	'배너리스트 가져오기
	iTotCnt = cShopchance.FTotCnt 				'배너리스트 총 갯수
	set cShopchance = nothing

	iTotalPage =   int((iTotCnt-1)/iPageSize) +1  '전체 페이지 수
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript">
function jsGoPage(iP){
	document.frmSC.iC.value = iP;
	document.frmSC.action = "/apps/appcom/wish/web2014/shoppingtoday/shoppingchance_allevent.asp";
	document.frmSC.submit();
}

function jsIsMine(a){
<% If IsUserLoginOK() Then %>
	document.frmSC.iC.value = 1;
	document.frmSC.ismine.value = a;
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
					url: "act_shoppingchance_allevent.asp?&scT=<%=scType%>&disp=<%=sCategory%>&selOP=<%=selOp%>&ismine=<%=vIsMine%>&iC="+vPg,
					cache: false,
					success: function(message) {
						if(message!="") {
							$("#lyrEvtList").append(message);
							vScrl=true;
						} else {
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

function rectPosition() {
	var recX1 = $('.evtTopBnr .swiper-container').width()/100*10;
	var recY1 = 0;
	var recX2 = $('.evtTopBnr .swiper-container').width()/100*90;
	var recY2 = $('.evtTopBnr .swiper-container').height();

	alert(recX1 + ' , ' +recY1 + ' , ' +recX2 + ' , ' + recY2);
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

	wsapp_Ccd = "event"
	wsapp_Ncd = "wish"  : wsapp_Nurl = "http://m.10x10.co.kr/apps/appCom/wish/web2014/wish/index.asp"
	wsapp_Pcd = "best" : wsapp_Purl = "http://m.10x10.co.kr/apps/appCom/wish/web2014/award/awarditem.asp"
	
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
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry">
			<!-- content area -->
			<div class="content evtMain" id="contentArea">
				<!-- mktbanner area -->
				<!-- #include virtual="/apps/appcom/wish/web2014/event/event_mktbanner_T.asp" -->
				<!-- mktbanner area -->
				<div class="inner5">
					<div class="sorting">
					<% If vIsMine = "o" Then %>
						<p class="all disabled">
							<select name="disp" class="selectBox" title="카테고리 선택" disabled>
								<%=DrawSelectBoxDispCategory(sCategory,"1") %>
							</select>
						</p>
						<p><span class="button"><a href="" onClick="document.frmSC.ismine.value=''; jsSelOp('0'); return false;">신규순</a></span></p>
						<p><span class="button"><a href="" onClick="document.frmSC.ismine.value=''; jsSelOp('2'); return false;">인기순</a></span></p>
						<p<%=CHKIIF(vIsMine="o"," class=selected","")%>><span class="button myEvt"><a href="" onClick="jsIsMine('<%=CHKIIF(vIsMine="o","","o")%>'); return false;"><em>MY</em></a></span></p>
					<% Else %>
						<p class="all <%=CHKIIF(vIsMine="o","disabled","")%>">
							<select name="disp" class="selectBox" title="카테고리 선택" onChange="changeCate(this.value)">
								<%=DrawSelectBoxDispCategory(sCategory,"1") %>
							</select>
						</p>
						<p<%=CHKIIF(selOp="0"," class=selected","")%>><span class="button"><a href="" onClick="jsSelOp('0'); return false;">신규순</a></span></p>
						<p<%=CHKIIF(selOp="2"," class=selected","")%>><span class="button"><a href="" onClick="jsSelOp('2'); return false;">인기순</a></span></p>
						<p<%=CHKIIF(vIsMine="o"," class=selected","")%>><span class="button myEvt"><a href="" onClick="jsIsMine('<%=CHKIIF(vIsMine="o","","o")%>'); return false;"><em>MY</em></a></span></p>
					<% End If %>
					</div>

					<%	
						'### 배열번호
						' 0 ~ 7  : A.evt_code, B.evt_bannerimg, A.evt_startdate, A.evt_enddate, A.evt_kind, B.brand,B.evt_LinkType ,B.evt_bannerlink '
						' 8		 : ,(Case When A.evt_kind=13 Then (Select top 1 itemid from [db_event].[dbo].[tbl_eventitem] where evt_code=A.evt_code order by itemid desc) else 0 end) as itemid '
						' 9 ~ 20 : , B.evt_bannerimg_mo, A.evt_name, B.issale, B.isgift, B.iscoupon, B.isOnlyTen, B.isoneplusone, B.isfreedelivery, B.isbookingsell, B.iscomment, B.etc_itemid, A.evt_subcopyK '
						'21		 : , case when isNull(B.etc_itemimg,'''') = '''' then (select isNull(basicimage600,'''') from db_item.dbo.tbl_item where itemid = B.etc_itemid) end as basicimage600 '
						'22		 : , case when isNull(B.etc_itemimg,'''') = '''' then (select basicimage from db_item.dbo.tbl_item where itemid = B.etc_itemid) end as basicimage '
						'23	~ 24 : , A.evt_subname, B.evt_mo_listbanner '

						Dim vLink, vIcon
						
						IF isArray(arrList) THEN %>
						<ul class="evtList" id="lyrEvtList">
							<%
							For intLoop =0 To UBound(arrList,2)
								IF arrList(6,intLoop)="I" and arrList(7,intLoop)<>"" THEN '링크타입 체크
									vLink = "fnAPPpopupEvent_URL('" & arrList(7,intLoop) & "');"
								ELSE
									vLink = "fnAPPpopupEvent('" & arrList(0,intLoop) & "'); return false;"
								END IF

								If arrList(12,intLoop) AND vIcon = "" Then vIcon = " <span class=""cGr2"">GIFT</span>" End IF
								If arrList(18,intLoop) AND vIcon = "" Then vIcon = " <span class=""cBl2"">참여</span>" End IF
								If arrList(15,intLoop) AND vIcon = "" Then vIcon = " <span class=""cGr2"">1+1</span>" End IF
								
								'If arrList(11,intLoop) Then vIcon = "" End IF
								'If arrList(13,intLoop) Then vIcon = "" End IF
								'If datediff("d",arrList(2,intLoop),date)<=3 Then vIcon = "" End IF
							%>
								<li onclick="<%=vLink%>">
									<div class="pic"><img src="<%=chkiif(arrList(24,intLoop)="",arrList(25,intLoop),arrList(24,intLoop))%>" alt="<%=db2html(arrList(10,intLoop))%>" /></div>
									<dl>
										<dt>
											<%=Replace(db2html(arrList(10,intLoop)),"[☆2015 다이어리]","")%>
											<%=vIcon%>
										</dt>
										<dd><%=db2html(arrList(23,intLoop))%></dd>
									</dl>
								</li>
							<%
								vLink = ""
								vIcon = ""
								Next %>
						</ul>
					 <% Else %>
					<div class="tMar20">
						<div class="noData">
						<%=chkIIF(vIsMine="o","<p>등록된 관심 이벤트가 없습니다.</p>","<p>진행중인 이벤트가 없습니다.</p>")%>
						</div>
					</div>
					<% End If %>
					<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
					<form name="frmSC" method="get" action="/apps/appcom/wish/web2014/shoppingtoday/shoppingchance_allevent.asp" style="margin:0px;">
					<input type="hidden" name="iC" >
					<input type="hidden" name="scT" value="<%=scType%>">
					<input type="hidden" name="disp" value="<%=sCategory%>">
					<input type="hidden" name="selOP" value="<%=selOP%>">
					<input type="hidden" name="ismine" value="<%=vIsMine%>">
					</form>
				</div>
			</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</div>
</body>
</html>