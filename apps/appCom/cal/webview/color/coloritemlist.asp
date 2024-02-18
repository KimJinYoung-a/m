<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
' Description : 컬러 상세보기
' History : 2014.02.18 서동석 생성
'           2014.02.19 한용민 수정
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appCom/cal/webview/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->

<%
dim i, colorcode, catecode, vFListDiv, page, SortMet, vDepth
	colorcode = getNumeric(requestcheckvar(request("colorcode"),10))
	catecode = requestCheckVar(Request("disp"),3)
	page = getNumeric(requestCheckVar(Request("page"),10))
	SortMet = requestCheckVar(request("srm"),2)
	catecode = getNumeric(requestCheckVar(request("disp"),15))

vDepth = "1"
If SortMet="" Then SortMet="be" '베스트:be, 신상:ne
if page="" then page=1

if colorcode="" then
	response.write "<script type='text/javascript'>"
	response.write "  alert('컬러코드를 정확히 입력해 주세요.');"
	response.write "  self.history.back();"
	response.write "</script>"
	dbget.close() : response.end
end if

vFListDiv = "bestlist"

'//최대 페이지수 제한. ismaxlimit가 true일경우, limitCurrPage까지만 보여줌
dim ismaxlimit, limitCurrPage
ismaxlimit = false
limitCurrPage = "30"

'// 상품검색
dim oDoc,iLp
set oDoc = new SearchItemCls
	oDoc.FRectSortMethod = SortMet
	oDoc.FRectSearchCateDep = "T"
	oDoc.FRectMakerid = ""
	oDoc.FCurrPage = page
	oDoc.FPageSize = 8
	oDoc.FScrollCount = 5
	oDoc.FListDiv = vFListDiv
	oDoc.FLogsAccept = false
	oDoc.FRectColsSize = 6

	if colorcode>0 then
		oDoc.FcolorCode = Num2Str(colorcode,3,"0","R")
	end if

	oDoc.FRectcatecode = catecode
	oDoc.FSellScope="Y"
	oDoc.getSearchList
%>

<!-- #include virtual="/apps/appCom/cal/webview/lib/head.asp" -->

<script type="text/javascript">
function changeCategory(disp){
	var params="disp="+disp+"&colorcode=<%=colorcode%>";
	location.href="?"+params;
}

function changeSort(srm){
	var params="srm="+srm+"&colorcode=<%=colorcode%>&disp=<%=catecode%>";
	location.href="?"+params;
}

// 관심 품목 담기 - 상품 페이지 전용 : 상품 코드로 변경
function TnAddFavoritePrd(iitemid){
	jsOpenModal('/apps/appcom/cal/webview/my10x10/ajax_MyFavorite.asp?ispop=ajax&mode=add&itemid=' + iitemid + '&backurl=<%=Replace(CurrURLQ(),"&","^")%>')
	return;
}

var isloading=false;
var loadCnt = 1;
var maxPage = 30;

function appendAddList(){
    var iurl="/apps/appcom/cal/webview/color/getcoloritemlist.asp";
    var params="srm=<%=SortMet%>&colorcode=<%=colorcode%>&disp=<%=catecode%>&ismaxlimit=<%=ismaxlimit%>&limitCurrPage=<%=limitCurrPage%>&page="+parseInt(loadCnt+1);

    $.ajax({
        type:"post",
        url:iurl,
        data:params,
        cache: false,
        //dataType: "text",
        //timeout : 1000,
        success:function(args){
        //추가 내용은 임시레이어에 넣고 순차적으로 Import!
        //$('#lyTemp').empty().html(args);
        //$('#lyTemp .item').each(function(i) {
        //	$('#itemLIST .item').last().after("<li class='item' style='display:none;'>" +$(this).html() + "</li>");
        //	$('#itemLIST .item').last().delay(i*30).fadeIn(100);
        //});

            $("#itemLIST").append(args);
            //window.location.hash = '#'+loadCnt;
            //history.pushState({}, "aaa", location.href);
        },
        //beforeSend:onBeforSend,
        error:function(e){
            alert(e.responseText);
        }
    });
    
    loadCnt++;
    isloading=false;
}

function onBeforSend(){
    //document.idumifrm.location.href="blank.html#"+loadCnt;
   //alert(loadCnt);
}

$(document).ready(function(){
	$(window).scroll(function() {
		//최대 페이지수 제한.
		if (loadCnt>=maxPage) {return;}

		//var info1 = document.getElementById ("TTT");
		//var info2 = document.getElementById ("TTT2");
		//info1.innerHTML = $(document).height() + ":" + $(window).height() + ":" + $(document).scrollTop() + ":" + (($(window).height())*1+($(document).scrollTop())*1) + "::" + loadCnt;
		//info2.innerHTML = $(document).height() + ":" + $(window).height() + ":" + $(document).scrollTop() + ":" + (($(window).height())*1+($(document).scrollTop())*1) + "::" + loadCnt;

		if ($(window).scrollTop() >= $(document).height() - $(window).height() - 300){
			if (isloading==false){
				isloading=true;
				setTimeout("appendAddList()",500)
			}
		}

		$('.item .markWish').unbind("click").click(function(){
			$(this).toggleClass('myWishPdt');

			TnAddFavoritePrd($(this).attr("itemid"));
		});
    });

	$('.viewOpt').unbind("click").click(function(){
		$(this).toggleClass('bigView');
		$('.pdtList').toggleClass('bigView');
	});
});
</script>
</head>
<body>
<div class="wrapper">
	<div id="content">
		<div class="listWrap inner01 itemList gry01">
			<div class="sortWrap">
				<span class="viewOpt">보기옵션</span>
				<p>
					<span>
						<select name="disp" onChange="changeCategory(this.value);" title="소분류를 선택해주세요">
							<%=DrawSelectBoxDispCategorymulti(catecode,vDepth) %>
						</select>
					</span>
					<span>
						<select name="srm" onChange="changeSort(this.value);" title="원하시는 옵션을 선택해주세요">
							<option value="ne" <%=CHKIIF(SortMet="ne","selected","")%>>신상품순</option>
							<option value="be" <%=CHKIIF(SortMet="be","selected","")%>>인기상품순</option>
							<option value="lp" <%=CHKIIF(SortMet="lp","selected","")%>>낮은가격순</option>
							<option value="hp" <%=CHKIIF(SortMet="hp","selected","")%>>높은가격순</option>
							<option value="hs" <%=CHKIIF(SortMet="hs","selected","")%>>높은할인률순</option>
						</select>
					</span>
				</p>
			</div>
			<ul class="pdtList boxMdl" id="itemLIST">
				<%
				if oDoc.FResultCount>0 then

				'// 검색결과 내위시 표시정보 접수
				if IsUserLoginOK then
					'// 검색결과 상품목록 작성
					dim rstArrItemid: rstArrItemid=""
					for i = 0 to oDoc.FResultCount-1
						rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & oDoc.FResultCount-1
					Next

					'// 위시결과 상품목록 작성
					dim rstWishItem: rstWishItem=""
					dim rstWishCnt: rstWishCnt=""
					if rstArrItemid<>"" then
						Call getMyFavItemList(getLoginUserid(),rstArrItemid,rstWishItem, rstWishCnt)
					end if
				end if
				%>
				<% For i = 0 To oDoc.FResultCount-1 %>
					<li class="item">
						<div>
							<span itemid="<%= oDoc.FItemList(i).fitemid %>" class="markWish <%=chkIIF(chkArrValue(rstWishItem,oDoc.FItemList(i).fitemid),"myWishPdt","")%>">관심상품(위시담기)</span>
							<% 'for dev msg : 나의 위시상품인 경우 myWishPdt 클래스명 추가 %>
							<a href="" onclick="TnGotoProduct('<%= oDoc.FItemList(i).fitemid %>'); return false;">
							<img src="<%= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,400,400,"true","false") %>" alt="<%= oDoc.FItemList(i).fitemname %>" /></a>
						</div>
					</li>
				<% next %>
				<% end if %>
			</ul>
		</div>
	</div>
</div>
<div id="lyTemp" style="display:none;"></div>
<div id="modalCont" style="display:none;"></div>
</body>
</html>

<%
set oDoc=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->