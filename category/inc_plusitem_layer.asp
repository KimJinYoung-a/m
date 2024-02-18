<% ''//세트 구매 상품 관련
set oPlusSaleItem = new CSetSaleItem
oPlusSaleItem.FRectItemID = itemid

dim tempCount : tempCount = 0

if (oPlusSaleItem.IsSetSaleLinkItem) then
    oPlusSaleItem.GetLinkSetSaleItemList
end if

if oPlusSaleItem.FResultCount>0 then
%>
<script>
function plusitemview(itemid){
    var openNewWindow = window.open("about:blank");
    openNewWindow.location.href='/category/pop_category_itemPrd_detail.asp?itemid='+itemid;
}

function fnOpenPlusItemLayer(){
    setTimeout(function(){
        fnAmplitudeEventMultiPropertiesAction('click_plussale_open','','');
    }, 300);

    $("#pop-plus-sale").show();
}

function fnClosePlusItemLayer(){
    setTimeout(function(){
        fnAmplitudeEventMultiPropertiesAction('click_plussale_close','','');
    }, 300);

    $("#pop-plus-sale").hide();
    $("#lySpBagList").find("[class*=plusitem]").remove();

    var tFrm = $("#pop-plus-sale").find('li');
    if ($(tFrm).hasClass('added')){
        $(tFrm).removeClass("added");
        $(tFrm).find('.btn-area button').attr("class","btnRed2V16a");
        $(tFrm).find('.btn-area button').text("함께 담기");
        fnOrderButtonChg();
    }
}

function fnOrderButtonChg(){
    if ($("#pop-plus-sale").find('.added').length < 1){
        $("#addorder").hide();
        $("#passorder").show();
    }else{
        $("#passorder").hide();
        $("#addorder").show();
    }
}

function addItemNo(idx,addno){
    var frm = document.sbagfrm;
    var itemeacomp;

    //담기중엔 수량 변경 안됨
    if ($("#lySpBagList").find(".plusitem"+idx).length > 0){
        alert('담기 취소후 수량 변경이 가능 합니다.');
        return;
    }

    if ($("#pop-plus-sale").find('li').length == 1){
        itemeacomp = frm.plusitemea;
    }else{
        itemeacomp = frm.plusitemea[idx];
    }

    if (itemeacomp.value*1+addno<1) return;

    itemeacomp.value = itemeacomp.value*1+addno;
}

// 함께 구매하기 상단 갯수 레이어 
function fnOrderInfo(){
    var txtsave = $("#addorder").find('.txt-save');
    txtsave.hide();

    var tempbag = $("#lySpBagList").find("[class*=plusitem]");
    if(tempbag.length > 0)
    {
        var totalDCPrice = function(){
            var output = 0;
            tempbag.each(function(){
                output += parseInt($(this).find('input[name="discountPrice"]').val());
            });
            return output;
        }

        if (totalDCPrice() > 0){
            txtsave.show();
            $("#addorder").find('span').text(tempbag.length +'개를 같이 담아'+ totalDCPrice() +'원 절약!');
        }
    }
}

$(function(){
    fnAmplitudeEventMultiPropertiesAction('view_plussale','','');
    // 플러스할인 담기
    $('.btn-area button').click(function(e) {
        e.preventDefault();
        var tFrm = $(this).closest("li");
        var tSit = $(tFrm).find('[name="item_option"] option:selected');
        var tRqr = $(tFrm).find('textarea[name="requiredetailplus"]');

        var itemid = $(tFrm).find('input[name="pitemid"]').val();
        var itemPrc = $('input[name="itemPrice"]').val()*1;
        var plusPrc = $(tFrm).find('input[name="pitemplussaleprice"]').val()*1;
        var itemNm = $(tFrm).find('input[name="pitemname"]').val();
        var opSelCd = $(tFrm).find('[name="item_option"]').val();
        var optAddPrc = $(tSit).attr("addPrice")*1;
        var itemEa = $(tFrm).find('input[name="plusitemea"]').val();
        var opLimit=500;
        var opSoldout=false;
        var di = $(this).closest("li").index();
        var discountPrice = $(tFrm).find(".totalsum").text();

        // 간이 장바구니 버튼 스위칭 및 삭제유무 표기
        if ($(tFrm).hasClass('added')){
            // amplitude 담기 취소
            setTimeout(function() {
                fnAmplitudeEventMultiPropertiesAction('click_plussale_sbcancel','itemid',itemid);
            }, 300);

            $("#lySpBagList").find(".plusitem"+di).remove();
            $(tFrm).removeClass("added");
            $(this).attr("class","btnRed2V16a");
            $(this).text("함께 담기");
            fnOrderButtonChg();
            fnOrderInfo();
            return;
        }else{
            // amplitude 함께 담기
            setTimeout(function() {
                fnAmplitudeEventMultiPropertiesAction('click_plussale_sbadd','itemid',itemid);
            }, 300);

            $(tFrm).addClass("added");
            $(this).attr("class","btnRed1V16a");
            $(this).text("담기 취소");
            fnOrderButtonChg();
        }

        if(!optAddPrc) optAddPrc=0;
        if($(tSit).attr("limitEa")>0) opLimit=parseInt($(tSit).attr("limitEa"));
        if($(tSit).attr("soldout")=="Y") opSoldout = true;

        if(opSelCd!=""&&opSelCd!="0000") {
            itemNm = itemNm + ' / ' + $(tSit).text().replace(/\(한정.*?\)/g,'');
        }

        //옵션이 없으면 추가 안함
        if(opSelCd=="") {
            alert("플러스 상품의 옵션을 선택해주세요.");
            return;
        }

        //품절처리
        if(opSoldout) {
            alert("품절된 옵션은 선택하실 수 없습니다.");
            return;
        }

        // 중복 옵션 처리
        var chkDpl = false;
        $("#lySpBagList").find("li").each(function () {
            if($(this).find("[name='optItemid']").val()==itemid&&$(this).find("[name='optCd']").val()==opSelCd) {
                chkDpl=true;
            }
        });
        if(chkDpl) return;

        // 간이 장바구니 내용 작성
        var sAddItem='';
        sAddItem += "<li class='plusitem"+ di +"'>";
        sAddItem += "	<div class='optContV16a'>";
        sAddItem += "		<p>옵션 : " + itemNm + "</p>";
        sAddItem += "   </div>";
        sAddItem += "   <div class='optQuantityV16a'>";
        sAddItem += "		<p class='odrNumV16a'>";
        sAddItem += "			<button type='button' class='btnV16a minusQty'>감소</button>";
        sAddItem += "			<input id='optItemEa' name='optItemEa' type='text' value="+ itemEa +" readonly/>";
        sAddItem += "           <input id='discountPrice' name='discountPrice' type='hidden' value="+ discountPrice +">"
        sAddItem += "			<button type='button' class='btnV16a plusQty'>증가</button>";
        sAddItem += "		</p>";
        sAddItem += "		<p class='rt'>" + plusComma(plusPrc+optAddPrc) + "원</p>";
        sAddItem += "		<p class='lPad1r'><button type='button' class='btnV16a btnOptDelV16a del'>옵션 삭제</button></p>";
        sAddItem += "	</div>";
        sAddItem += "<input type='hidden' name='optItemid' value="+ (itemid) +" >";
        sAddItem += "<input type='hidden' name='optCd' value="+ opSelCd +" >";
        sAddItem += "<input type='hidden' name='optItemPrc' value="+ (plusPrc+optAddPrc) +" />";
        sAddItem += "<input type='hidden' name='optRequire' value=''>";
        sAddItem += "</li>";

        // 간이바구니에 추가
        $("#lySpBagList").append(sAddItem);

        fnOrderInfo();
    });
});
</script>
<div id="pop-plus-sale" class="pop-plus-sale" style="display:none">
    <div class="inner">
        <button type="button" class="btn-close" onclick="fnClosePlusItemLayer();">팝업 닫기</button>
        <div class="conts">
            <h1><img src="http://fiximage.10x10.co.kr/m/2018/temp/@tit_plus_sale.gif" alt="같이 샀더니 대만족 :)"></h1>
            <ul id="plus-sale-list" class="plus-sale-list">
                <% for j=0 to (oPlusSaleItem.FResultCount-1) %>
                <% if NOT oPlusSaleItem.FItemList(j).IsItemOptionExists then %>
                <li>
                    <input type="hidden" name="pitemid" value="<%= oPlusSaleItem.FItemList(j).FItemID %>" />
					<input type="hidden" name="pitemname" value="<%= Replace(oPlusSaleItem.FItemList(j).FItemName,Chr(34),"") %>">
					<input type="hidden" name="pitemorgprice" value="<%= oPlusSaleItem.FItemList(j).getRealPrice %>">
					<input type="hidden" name="pitemplussaleprice" value="<%= oPlusSaleItem.FItemList(j).GetPLusSalePrice %>">
                    <div class="thumbnail">
                        <button type="button" class="btn-zoom" onclick="plusitemview(<%=oPlusSaleItem.FItemList(j).FItemID%>);">상품 확대보기</button>
                        <a href="javascript:void(0);"><img src="<%= oPlusSaleItem.FItemList(j).FImageBasic %>" alt="<%=Replace(oPlusSaleItem.FItemList(j).FItemName,"""","")%>"></a>
                        <div class="fin"><span>담기 완료</span></div>
                    </div>
                    <div class="desc">
                        <h2 class="name"><%=oPlusSaleItem.FItemList(j).FItemName%></h2>
                        <div class="desc-grp">
                            <div class="opt">
                                <%' if oPlusSaleItem.FItemList(j).IsItemOptionExists then %>
									<!-- 상품옵션 -->
									<%'=getOneTypeOptionBoxDpLimitHtml(oPlusSaleItem.FItemList(j).FItemID, oPlusSaleItem.FItemList(j).IsSoldOut,"class='optSelect2 select'",oPlusSaleItem.FItemList(j).FLimitDispYn="Y")%>
							    <%' else %>
							        <input type="hidden" name="item_option" value="0000">
							    <%' end if %>
                            </div>
                            <div class="review"><span class="icon-rating"><i style="width:<%=fnEvalTotalPointAVG(oPlusSaleItem.FItemList(j).Fpoints,"")%>%;"><%=fnEvalTotalPointAVG(oPlusSaleItem.FItemList(j).Fpoints,"")%>점</i></span></div>
                        </div>
                        <div class="desc-grp">
                           
                            <% if oPlusSaleItem.FItemList(j).FPLusSalePro>0 then %>
                            <div class="unit">
                                <s> <%= FormatNumber(oPlusSaleItem.FItemList(j).FSellCash,0) %></s>
                                <b class="sum color-red"><%= FormatNumber(oPlusSaleItem.FItemList(j).GetPLusSalePrice,0) %><span>원</span></b>
                                <span class="totalsum" style="display:none;"><%= FormatNumber(oPlusSaleItem.FItemList(j).GetPLusSalePrice-oPlusSaleItem.FItemList(j).FSellCash,0) %></span>
                            </div>
                            <div class="percent">같이 사면 <%= oPlusSaleItem.FItemList(j).FPLusSalePro %>%할인</div>
                            <% else %>
                            <div class="unit">
                                <b class="sum"><%=FormatNumber(oPlusSaleItem.FItemList(j).FSellCash,0) %><span>원</span></b>
                            </div>
                            <% end if %>

                        </div>
                        <div class="desc-grp add-cart">
                            <div class="odr-num">
                                <button type="button" class="minus-qty" onclick="addItemNo(<%= j %>,-1);">감소</button>
                                <input name='plusitemea' type='text' value='1' readonly />
                                <button type="button" class="plus-qty" onclick="addItemNo(<%= j %>,1);">증가</button>
                            </div>
                            <div class="btn-area">
                                <button type="button" class="btnRed2V16a">함께 담기</button>
                            </div>
                        </div>
                    </div>
                </li>
                <% 
                    tempCount = tempCount + 1
                %>
                <% end if %>
                <% next %>
            </ul>
        </div>

        <%'!-- dev msg : 함께 담기 시 버튼 전환 --%>
        <div class="bot-floating">
            <div id="passorder"><button type="button" class="btnRed1V16a" onclick="fnAmplitudeEventMultiPropertiesAction('click_plussale_skip','','');<%=chkiif(oItem.Prd.FOptionCnt>0,"FnAddShoppingBag()","TnAddShoppingBag()")%>;">아쉽지만, 그냥 구매하기</button></div>
            <div id="addorder" style="display:none;"><span class="txt-save"></span><button type="button" class="btnRed2V16a" onclick="fnAmplitudeEventMultiPropertiesAction('click_plussale_purchase','','');<%=chkiif(oItem.Prd.FOptionCnt>0,"FnAddShoppingBag()","TnAddShoppingBag()")%>;">함께 구매하기</button></div>
        </div>
    </div>
</div>
<%
end if
set oPlusSaleItem = nothing
%>


