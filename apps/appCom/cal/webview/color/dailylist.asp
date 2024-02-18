<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 오늘의 컬러
'	History	:  2014.02.17 한용민 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appCom/cal/webview/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appCom/cal/webview/lib/classes/color/Color_Cls.asp" -->
<%
dim cldate, i, color_str, ColorName, colorCode
	cldate = requestcheckvar(request("cldate"),10)

if cldate<>"" then
	if isNumeric(replace(cldate,"-",""))=false then
		response.write "<script type='text/javascript'>"
		response.write "	alert('날짜를 정확히 입력해 주세요.');"
		response.write "	self.history.back();"
		response.write "</script>"
		dbget.close()	:	response.end
	end if
end if

dim ocolorm
set ocolorm = new Ccolorlist
	ocolorm.FRectyyyymmdd = cldate
	ocolorm.getDailyColorinfo
	
	'//파라메타가 있을경우
	if ocolorm.FTotalCount > 0 then
		cldate = ocolorm.FOneitem.FYyyymmdd
		color_str = ocolorm.FOneitem.fcolor_str
		ColorName = ocolorm.FOneitem.FColorName
		colorCode = ocolorm.FOneitem.fcolorCode
	
	'//값이 없을경우 최신순
	else
		set ocolorm = new Ccolorlist
			ocolorm.getDailyColorinfo
			
		if ocolorm.FTotalCount > 0 then
			cldate = ocolorm.FOneitem.FYyyymmdd
			color_str = ocolorm.FOneitem.fcolor_str
			ColorName = ocolorm.FOneitem.FColorName
			colorCode = ocolorm.FOneitem.fcolorCode
		end if
	end if
set ocolorm=nothing

dim ocolord
set ocolord = new Ccolorlist
	ocolord.FRectyyyymmdd = cldate
	ocolord.getDailyColoritemlist

%>

<!-- #include virtual="/apps/appCom/cal/webview/lib/head.asp" -->

<script type="text/javascript">

	window.onload = function(){
		$('img').load(function(){
			$(".pdtList").masonry({
				itemSelector: '.item'
			});
		});
		$(".pdtList").masonry({
			itemSelector: '.item'
		});
	
		$('.item .markWish').click(function(){
			$(this).toggleClass('myWishPdt');
	
			TnAddFavoritePrd($(this).attr("itemid"));
		});
	}

	// 관심 품목 담기 - 상품 페이지 전용 : 상품 코드로 변경
	function TnAddFavoritePrd(iitemid){
		jsOpenModal('/apps/appcom/cal/webview/my10x10/ajax_MyFavorite.asp?ispop=ajax&mode=add&itemid=' + iitemid + '&backurl=<%=Replace(CurrURLQ(),"&","^")%>')
		return;
	}

</script>

</head>
<body>
<div class="wrapper">
	<div id="content">
		<div class="listWrap inner01 todayMList gry01">
			<ul class="pdtList boxMdl">
				<li class="item">
					<div class="listHeadBox">
						<div>
							<p class="headTit">오늘의 컬러상품 <br />할인중</p>
							<p class="headSale">우선제낌<span>%</span></p>
						</div>
					</div>
				</li>
				
				<% if ocolord.FResultCount > 1 then %>
				
				<%
				dim tmpevennumber
					tmpevennumber = 0
				
				if ocolord.FResultCount mod 2 <> 0 then
					tmpevennumber=1
				end if

				'// 검색결과 내위시 표시정보 접수
				if IsUserLoginOK then
					'// 검색결과 상품목록 작성
					dim rstArrItemid: rstArrItemid=""
					for i = 0 to ocolord.FResultCount-1-tmpevennumber
						rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & ocolord.FItemList(i).fitemid
					Next

					'// 위시결과 상품목록 작성
					dim rstWishItem: rstWishItem=""
					dim rstWishCnt: rstWishCnt=""
					if rstArrItemid<>"" then
						Call getMyFavItemList(getLoginUserid(),rstArrItemid,rstWishItem, rstWishCnt)
					end if
				end if

				'//짝수로만 뿌림
				for i = 0 to ocolord.FResultCount-1-tmpevennumber
				%>
				<li class="item">
					<div>
						<span itemid="<%= ocolord.FItemList(i).fitemid %>" class="markWish <%=chkIIF(chkArrValue(rstWishItem,ocolord.FItemList(i).fitemid),"myWishPdt","")%>">
						관심상품(위시담기)</span>
						<% 'for dev msg : 나의 위시상품인 경우 myWishPdt 클래스명 추가 %>
						<a href="" onclick="TnGotoProduct('<%= ocolord.FItemList(i).fitemid %>'); return false;">
						<img src="<%= ocolord.FItemList(i).FImageBasic %>" alt="<%= ocolord.FItemList(i).fitemname %>" /></a>
					</div>
				</li>
				<% next %>
				<% end if %>
				
				<li class="item">
					<div class="listMoreBox" style="background-color:#<%= color_str %>">
						<a href="" onclick="top.location.href='coloritemlist.asp?colorcode=<%= colorCode %>'; return false;">
							<div><p>더 많은 <%= ColorName %> 상품보기</p></div>
						</a>
					</div>
				</li>
			</ul>
		</div>
	</div>
</div>
<div id="modalCont" style="display:none;"></div>
</body>
</html>

<%
set ocolord=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->