<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<%
	Dim vDisp : vDisp = getNumeric(requestCheckVar(request("disp"),15))
	Dim vDepth, i,TotalCnt
		vDepth = "1"
	dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),9))
	dim searchFlag 	: searchFlag = "sale"
	dim CurrPage 	: CurrPage = getNumeric(requestCheckVar(request("cpg"),9))
	dim SortMet		: SortMet = requestCheckVar(request("srm"),2)

	dim LoginUserid
	LoginUserid = getLoginUserid()

	dim ListDiv,ScrollCount
	ListDiv="salelist"
	ScrollCount = 5

	if CurrPage="" then CurrPage=1
	PageSize =20

	If SortMet = "" Then SortMet = "be"

	dim oDoc,iLp
	set oDoc = new SearchItemCls
		oDoc.FListDiv 			= ListDiv
		oDoc.FRectSortMethod	= SortMet
		oDoc.FRectSearchFlag 	= searchFlag
		oDoc.FPageSize 			= PageSize
		oDoc.FRectCateCode			= vDisp
		oDoc.FCurrPage 			= CurrPage
		oDoc.FSellScope 		= "Y"
		oDoc.FScrollCount 		= ScrollCount
		oDoc.getSearchList
		
	TotalCnt = oDoc.FResultCount
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript">
	function goPage(page){
		document.sFrm.cpg.value=page;
		document.sFrm.submit();
	}

	function fnSearch(frmval){
		document.sFrm.cpg.value=1;
		document.sFrm.srm.value=frmval;
		document.sFrm.submit();
	}

	// 관심 품목 담기 - 상품 페이지 전용 : 상품 코드로 변경
	function TnAddFavoritePrd(iitemid){
	<% If IsUserLoginOK() Then ''ErBValue.value -> 공통파일의 구분값 (cate는 1)%>
	   fnAPPpopupBrowserURL("위시폴더","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popWishFolder.asp?itemid="+iitemid+"&ErBValue=6");
	<% Else %>
		calllogin();
		return false;
	<% End If %>
	}

	// Wish Cnt 증가
	function FnPlusWishCnt(iid) {
		var vCnt = $("#wish"+iid).html();
		if(vCnt=="") vCnt=0;
		vCnt++;
		$("#wish"+iid).html(vCnt);
	}


var vPg=1, vScrl=true;
$(function(){
	// 스크롤시 추가페이지 접수
	$(window).scroll(function() {
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-354){
			if(vScrl) {
				vScrl = false;
				vPg++;
				$.ajax({
					url: "act_saleitem.asp?sflag=<%=searchFlag%>&srm=<%=SortMet%>&psz=<%=PageSize%>&disp=<%=vDisp%>&cpg="+vPg,
					cache: false,
					success: function(message) {
						if(message!="") {
							$("#lyrSaleList").append(message);
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

	wsapp_Ccd = "sale"
	wsapp_Ncd = "event"  : wsapp_Nurl = "http://m.10x10.co.kr/apps/appCom/wish/web2014/shoppingtoday/shoppingchance_allevent_TT.asp"
	wsapp_Pcd = "best" : wsapp_Purl = "http://m.10x10.co.kr/apps/appCom/wish/web2014/award/awarditem_TT.asp"
	
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
	<div class="container bgGry">
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="content" id="contentArea">
				<div class="inner10 saleMain">
				    <form name="sFrm" method="get" action="" style="margin:0px;">
    				<input type="hidden" name="sflag" value="<%= oDoc.FRectSearchFlag  %>">
    				<input type="hidden" name="srm" value="<%= oDoc.FRectSortMethod%>">
    				<input type="hidden" name="cpg" value="<%=oDoc.FCurrPage %>">
    				<input type="hidden" name="psz" value="<%= PageSize%>">			
					<div class="sorting">
						<p class="all">
							<select name="disp" class="selectBox" title="카테고리 선택" onChange="goPage('1')">
								<%=DrawSelectBoxDispCategory(vDisp,"1") %>
							</select>
						</p>
						<p <%=CHKIIF(SortMet="ne","class='selected'","")%>><span class="button"><a onClick="fnSearch('ne');">신상순</a></span></p>
						<p <%=CHKIIF(SortMet="be","class='selected'","")%>><span class="button"><a onClick="fnSearch('be');">인기순</a></span></p>
						<p <%=CHKIIF(SortMet="hs","class='selected'","")%>><span class="button"><a onClick="fnSearch('hs');">할인율순</a></span></p>
					</div>
                    </form>
					<div class="pdtListWrap">
						<ul class="pdtList" id="lyrSaleList">
						    <% for i=0 to oDoc.FResultCount-1 %>
							<li <%=CHKIIF(oDoc.FItemList(i).IsSoldOut,"class='soldOut'","")%>>
								<div class="pPhoto" onclick="fnAPPpopupProduct('<%=oDoc.FItemList(i).FItemID%>');" ><p><span><em>품절</em></span></p><img src="<%=getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,"286","286","true","false") %>" alt="<% = oDoc.FItemList(i).FItemName %>"></div>
								<div class="pdtCont">
									<p class="pBrand"><%= oDoc.FItemList(i).FBrandName %></p>
									<p class="pName"><%= oDoc.FItemList(i).FItemName %></p>
									
									<% IF oDoc.FItemList(i).IsSaleItem or oDoc.FItemList(i).isCouponItem Then %>
                                    	<% IF oDoc.FItemList(i).IsSaleItem And oDoc.FItemList(i).IsCouponItem = false Then %>
                                    		<p class="pPrice"><% = FormatNumber(oDoc.FItemList(i).getRealPrice,0) %>원 <span class="cRd1">[<% = oDoc.FItemList(i).getSalePro %>]</span></p>
                                    	<% End IF %>
                                    	<% IF oDoc.FItemList(i).IsCouponItem Then %>
                                    		<% IF Not(oDoc.FItemList(i).IsFreeBeasongCoupon() or oDoc.FItemList(i).IsSaleItem) then %>
                                    		<% End IF %>
                                    		<p class="pPrice"><% = FormatNumber(oDoc.FItemList(i).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = oDoc.FItemList(i).GetCouponDiscountStr %>]</span></p>
                                    	<% End IF %>
                                    <% Else %>
                                    	<p class="pPrice"><% = FormatNumber(oDoc.FItemList(i).getRealPrice,0) %><% if oDoc.FItemList(i).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
                                    <% End if %>

									<p class="pShare">
										<span class="cmtView"><%=FormatNumber(oDoc.FItemList(i).Fevalcnt,0)%></span>
										<span class="wishView" id="wish<%=oDoc.FItemList(i).FItemID%>" onClick="TnAddFavoritePrd('<%=oDoc.FItemList(i).FItemID%>');"><%=FormatNumber(oDoc.FItemList(i).FfavCount,0)%></span>
									</p>
								</div>
							</li>
						    <% next %>
						    
						</ul>
					</div>
					<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</div>
</body>
</html>
<%
set oDoc = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->