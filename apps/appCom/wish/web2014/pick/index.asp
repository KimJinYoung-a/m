<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/main/main_Pick.asp" -->
<%
	Dim cPk, vIdx, vTitle, intI
	
	SET cPk = New CPick
	cPk.GetPickOne()
	
	If cPk.FTotalCount > 0 Then
		vIdx = cPk.FItemOne.Fidx
		vTitle = cPk.FItemOne.Ftitle
	End IF
	
	If vIdx <> "" Then
		cPk.FPageSize = 50
		cPk.FCurrPage = 1
		cPk.FRectIdx = vIdx
		cPk.FRectSort = 1
		cPk.GetPickItemList()
	End If
%>
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type='text/javascript' src='/lib/js/jquery.lazyload.min.js'></script>
<script>
$(function(){
	// 순차 로딩
	$("img.lazy").lazyload({
	    effect : "fadeIn",
	    effectspeed: 300
	}).removeClass("lazy");
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

	wsapp_Ccd = "pick"
	wsapp_Ncd = "sale"  : wsapp_Nurl = "http://m.10x10.co.kr/apps/appCom/wish/web2014/sale/saleitem.asp"
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
	<div class="container bgGry">
		<!-- content area -->
		<div class="content evtView" id="contentArea">
			
			<h1 class="hide">PICK</h1>
			<div class="evtTypeC pickList">
				<%
				If cPk.FResultCount > 0 Then
					For intI =0 To cPk.FResultCount
						If (intI mod 2) = 0 Then
				%>
						<div class="evtPdtListWrap">
							<div class="pdtListWrap">
								<ul class="pdtList">
				<% 		End If %>
								<li onclick="fnAPPpopupProduct('<% = cPk.FCategoryPrdList(intI).Fitemid %>');">
									<div class="pPhoto">
										<% IF cPk.FCategoryPrdList(intI).IsSoldOut Then %><p><span><em>품절</em></span></p><% End if %>
											<% if (intI+1)<2 then %>
											<img src="<%=getThumbImgFromURL(cPk.FCategoryPrdList(intI).FImageBasic,"400","400","true","false") %>" alt="<% = cPk.FCategoryPrdList(intI).FItemName %>" /></div>
											<% else %>
											<img data-original="<%=getThumbImgFromURL(cPk.FCategoryPrdList(intI).FImageBasic,"400","400","true","false") %>" alt="<% = cPk.FCategoryPrdList(intI).FItemName %>" src="http://fiximage.10x10.co.kr/web2008/category/blank.gif" class="lazy" /></div>
											<% end if %>
									<div class="pdtCont">
										<p class="pBrand"><% = cPk.FCategoryPrdList(intI).FBrandName %></p>
										<p class="pName"><% = cPk.FCategoryPrdList(intI).FItemName %></p>
										<% IF cPk.FCategoryPrdList(intI).IsSaleItem or cPk.FCategoryPrdList(intI).isCouponItem Then %>
											<% IF cPk.FCategoryPrdList(intI).IsSaleItem Then %>
												<p class="pPrice"><% = FormatNumber(cPk.FCategoryPrdList(intI).getRealPrice,0) %>원 <span class="cRd1">[<% = cPk.FCategoryPrdList(intI).getSalePro %>]</span></p>
											<% End IF %>
											<% IF cPk.FCategoryPrdList(intI).IsCouponItem Then %>
												<p class="pPrice"><% = FormatNumber(cPk.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cPk.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
											<% End IF %>
										<% Else %>
											<p class="pPrice"><% = FormatNumber(cPk.FCategoryPrdList(intI).getRealPrice,0) %><% if cPk.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
										<% End if %>
									</div>
								</li>
				<% If (intI mod 2) = 1 OR intI = cPk.FResultCount Then %>
								</ul>
							</div>
						</div>
				<%
						End If
					Next
				End If
				%>
			</div>

		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</div>
</body>
</html>
<% SET cPk = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->