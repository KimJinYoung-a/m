<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  발렌타인데이 기획전
' History : 2019-01-17 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/exhibition/exhibitionCls.asp" -->
<%
dim eventEndDate, currentDate, eventStartDate 
dim vGaparam, gnbflag
dim strGaParam, strGnbStr
Dim oExhibition 
dim mastercode, bestItemList, listType
dim i, j
dim numOfItems

eventStartDate = cdate("2019-01-17")	'이벤트 시작일
eventEndDate = cdate("2019-02-14")		'이벤트 종료일
currentDate = date()

numOfItems = 12

j = 0

vGaparam = request("gaparam")
if vGaparam <> "" then strGaParam = "&gaparam=" & vGaparam
if gnbflag <> "" then strGnbStr = "&gnbflag=1"

gnbflag = RequestCheckVar(request("gnbflag"),1)

listType = "A"

IF application("Svr_Info") = "Dev" THEN
	mastercode = 7
Else
	mastercode = 2	
End If

SET oExhibition = new ExhibitionCls

    bestItemList = oExhibition.getItemsListProc( listType, 100, mastercode, "", "1", "" )     '리스트타입, row개수, 마스터코드, 디테일코드, best아이템 구분, 카테고리 정렬 구분     

function format(ByVal szString, ByVal Expression)
	if len(szString) < len(Expression) then
	format = left(expression, len(szString)) & szString
	else
	format = szString
	end if
end function
%>
<style>
.valentine2019 button {display:block; width:100%;}
.valen-head {position:relative;}
.valen-head a {display:inline-block; position:absolute; top:0; right:0; width:50%; height:26.83%; text-indent:-999em;}
.represnt-item {display:inline-block; position:relative; height:100%;}
.represnt-item span {position:absolute; top:62.09%; right:30.77%; width:9.7%;  animation:bounce1 .8s 1s 200 ease-in-out;}
.valen-vod {position:relative;}
.valen-vod iframe {position:absolute; bottom:9.3%; left:0; width:100%; height:52.46%; padding:0 7.8%;}
.valen-item .type-grid {border-top:0;}
.valen-item .type-grid ul {padding:0 .85rem;}
.valen-item .type-grid li {height:23.89rem;}
.valen-item .type-grid li:nth-child(2n-1) {padding:0 .29rem 0 0;}
.valen-item .type-grid li:nth-child(2n) {padding:0 0 0 .29rem;}
.valen-item .type-grid .desc {height:9.39rem; padding-top:1.53rem; padding-left:.77rem;}
.valen-item .type-grid .price {margin-top:.8rem;}
.valen-item .type-grid .name {margin-top:0;}
.valen-item .type-grid .thumbnail {width:100%; height:14.84rem;}
.valen-item .type-grid .discount {margin-left:.3rem;}
.valen-item .type-grid .color-red {color:#ff4800;}
.valen-item .type-grid .color-green {color:#14be98;}
.valen-item .more-list {display:none;}
.valen-item .more-list.on {display:block;}
.valen-item .btn-more {width:32rem; height:4.57rem; margin:0 auto; background:url(//fiximage.10x10.co.kr/web2019/valentine/m/btn_more.png)no-repeat 50% 50%; background-size:100%; color:#fff; font-size:1.1rem; line-height:4.8rem;}
.valen-item .btn-icon {position:relative; display:inline-block; left:.5rem; top:-.31rem; width:.68rem; height:.68rem; padding:0; transform:rotate(135deg); border-top:0.1rem solid #fff; border-right:0.1rem solid #fff;}
.valen-item .bnr {display:inline-block; margin-top:4.27rem;}
.valen-item .bnr3 {margin:.85rem 0 1.28rem;}
.noti {background-color:#696969;}
.noti ul {margin-top:1.79rem; padding:0 5% 3.16rem 9%;}
.noti ul li {position:relative; color:#fff; font-size:1.28rem; line-height:1.92; letter-spacing:-.06rem; word-break:keep-all;}
.noti ul li:before {display:inline-block; position:absolute; top:.8rem; left:-1.11rem; width:.38rem; height:.38rem; border-radius:50%; background-color:#fff; content:'';}
@keyframes bounce1 {
	from to{transform:translateY(0);}
	50%{transform:translateY(8px)}
}
</style>
<script type="text/javascript">
$(function() {
    $("section .section1 ul li:gt(5)").css('display','none');    
    $("section .section2 ul li:gt(5)").css('display','none');    
	// 더보기
	$('.btn-more').click(function(e) { 
        var btnIdx = $(".btn-more").index($(this));
        console.log(btnIdx)
        if(btnIdx == 0){
            $("section .section1 ul li").css('display','');
        }else{
            $("section .section2 ul li").css('display','');    
        }
        $(this).hide();        
		// $(this).prev('.more-list').addClass('on');
		e.preventDefault();
	});
	// skip to gift event
	$(".valen-head a").click(function(event){
	event.preventDefault();
	window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},800);
    });
});
function jsEventLogin(){
	<% if isApp="1" then %>
		calllogin();
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode("/valentine/index.asp")%>');
	<% end if %>
	return;
}
function doAction(){
	<% if (eventStartDate > currentDate or eventEndDate < currentDate) and GetLoginUserLevel <> "7" then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>				
    if ("<%=IsUserLoginOK%>"=="False") {
        jsEventLogin();
    }else{
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/doeventsubscript/doEventSubscript91902.asp",
			data: "",
			dataType: "text",
			async: false
		}).responseText;	
		if(!str){alert("시스템 오류입니다."); return false;}
		var reStr = str.split("|");
		if(reStr[0]=="OK"){
            alert('응모 신청되었습니다.');				
            return false;
		}else{
			var errorMsg = reStr[1].replace(">?n", "\n");
			alert(errorMsg);
			return false;
		}
    }	
}
</script>
	<div id="content" class="content valentine2019">
        <!-- 상단 -->
        <div class="valen-head">
			<h2><img src="//fiximage.10x10.co.kr/web2019/valentine/m/tit_valentine.gif" alt="난 너를 두근두근해" /></h2>
			<a href="#gift">애플워치응모이벤트</a>
		</div>

		<a href="/category/category_itemPrd.asp?itemid=2214790" onclick="fnAPPpopupProduct('2214790'); return false;" class="represnt-item">
			<img src="//fiximage.10x10.co.kr/web2019/valentine/m/img_item.jpg?=v1.01" alt="푸딩앤 바크 초콜릿만들기 세트" />
			<span><img src="//fiximage.10x10.co.kr/web2019/valentine/m/btn_cross.png" alt="상품보기"></span>
		</a>

		<!-- 동영상 -->
		<div class="valen-vod">
			<h3><img src="//fiximage.10x10.co.kr/web2019/valentine/m/tit_vod.jpg" alt=" 혼자서도 만들기 쉬운 초콜릿 레시피"></h3>
			<iframe src="https://www.youtube.com/embed/6lvRRY72z5s" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
		</div>

		<!-- 상품목록및배너 -->
		<section class="valen-item">
			<div class="items type-grid">
				<!-- 딴거 말고 단거 -->
				<div class="section1">
					<h3><img src="//fiximage.10x10.co.kr/web2019/valentine/m/tit_item_list_1.png" alt="딴 거 말고 단 거" /></h3>
					<ul>             
                    <% if Ubound(bestItemList) > 0 then %>                           
                    <%
                        dim tempNumber, couponPrice, couponPer, tempPrice, salePer
                        dim saleStr, couponStr
                        j = 0
                        
                        for i = 0 to Ubound(bestItemList) - 1
                            if j = numOfItems then exit for '12개 상품만 노출
                            tempNumber = format(i+1, "00")    
                            couponPer = oExhibition.GetCouponDiscountStr(bestItemList(i).Fitemcoupontype, bestItemList(i).Fitemcouponvalue)
                            couponPrice = oExhibition.GetCouponDiscountPrice(bestItemList(i).Fitemcoupontype, bestItemList(i).Fitemcouponvalue, bestItemList(i).Fsellcash)                    
                            salePer     = CLng((bestItemList(i).Forgprice-bestItemList(i).Fsellcash)/bestItemList(i).FOrgPrice*100)
                            if bestItemList(i).Fsailyn = "Y" and bestItemList(i).Fitemcouponyn = "Y" then '세일
                                tempPrice = bestItemList(i).Fsellcash - couponPrice
                                saleStr = "<b class=""discount color-red"">"&salePer&"%</b>"
                                couponStr = "<b class=""discount color-green"">"&couponPer&"</b>"  
                            elseif bestItemList(i).Fitemcouponyn = "Y" then
                                tempPrice = bestItemList(i).Fsellcash - couponPrice
                                saleStr = ""
                                couponStr = "<b class=""discount color-green"">"&couponPer&"</b>"  
                            elseif bestItemList(i).Fsailyn = "Y" then
                                tempPrice = bestItemList(i).Fsellcash
                                saleStr = "<b class=""discount color-red"">"&salePer&"%</b>"
                                couponStr = ""                                              
                            else
                                tempPrice = bestItemList(i).Fsellcash
                                saleStr = ""
                                couponStr = ""                                              
                            end if
                    %>
                    <%                            
                            if bestItemList(i).Fpicksorting <= 50  then                                                                    
                    %>
						<li>
                            <% if isapp = 1 then %>    
                            <a href="javascript:void(0)" onclick="fnAPPpopupProduct('<%=bestItemList(i).Fitemid%>');" >	
                            <% else %>
                            <a href="/category/category_itemPrd.asp?itemid=<%=bestItemList(i).Fitemid%>" >
                            <% end if %>	
								<div class="thumbnail">
									<img src="<%=bestItemList(i).FImageList%>" alt="" />
                                    <% if bestItemList(i).FsellYn = "N" then %>
                                    <b class="soldout">일시 품절</b>
                                    <% end if %>
								</div>
								<div class="desc">
									<p class="name"><%=bestItemList(i).Fitemname%></p>
									<div class="price">
										<div class="unit">
                                            <b class="sum"><%=formatNumber(tempPrice, 0)%><span class="won">원</span></b>
                                            <% response.write saleStr%>
                                            <% response.write couponStr%>
                                        </div>
									</div>
								</div>
							</a>
						</li>
                    <%
                            j = j + 1 'index값 
                            else
                            end if
                    %>    
                        <% next %>
                    <% end if %>                        					
					</ul>				
					<button class="btn-more">더보기<span class="btn-icon"></span></button>
				</div>
				<a href="/event/eventmain.asp?eventid=91904" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=91904'); return false;" class="bnr bnr1"><img src="//fiximage.10x10.co.kr/web2019/valentine/m/img_bnr_1.jpg" alt="LOVE RECIPE"></a>
				<!-- 단거 말고 딴거 -->
                <div class="section2">
					<h3><img src="//fiximage.10x10.co.kr/web2019/valentine/m/tit_item_list_2.png" alt="딴 거 말고 단 거" /></h3>
					<ul>             
                    <% if Ubound(bestItemList) > 0 then %>                           
                    <%  
                        j = 0
                        for i = 0 to Ubound(bestItemList) - 1   
                            if j = numOfItems then exit for '12개 상품만 노출                      
                            tempNumber = format(i+1, "00")    
                            couponPer = oExhibition.GetCouponDiscountStr(bestItemList(i).Fitemcoupontype, bestItemList(i).Fitemcouponvalue)
                            couponPrice = oExhibition.GetCouponDiscountPrice(bestItemList(i).Fitemcoupontype, bestItemList(i).Fitemcouponvalue, bestItemList(i).Fsellcash)                    
                            salePer     = CLng((bestItemList(i).Forgprice-bestItemList(i).Fsellcash)/bestItemList(i).FOrgPrice*100)
                            if bestItemList(i).Fsailyn = "Y" and bestItemList(i).Fitemcouponyn = "Y" then '세일
                                tempPrice = bestItemList(i).Fsellcash - couponPrice
                                saleStr = "<b class=""discount color-red"">"&salePer&"%</b>"
                                couponStr = "<b class=""discount color-green"">"&couponPer&"</b>"  
                            elseif bestItemList(i).Fitemcouponyn = "Y" then
                                tempPrice = bestItemList(i).Fsellcash - couponPrice
                                saleStr = ""
                                couponStr = "<b class=""discount color-green"">"&couponPer&"</b>"  
                            elseif bestItemList(i).Fsailyn = "Y" then
                                tempPrice = bestItemList(i).Fsellcash
                                saleStr = "<b class=""discount color-red"">"&salePer&"%</b>"
                                couponStr = ""                                              
                            else
                                tempPrice = bestItemList(i).Fsellcash
                                saleStr = ""
                                couponStr = ""                                              
                            end if
                    %>
                    <%                            
                            if bestItemList(i).Fpicksorting > 50  then                            
                    %>
						<li>
                            <% if isapp = 1 then %>    
                            <a href="javascript:void(0)" onclick="fnAPPpopupProduct('<%=bestItemList(i).Fitemid%>');" >	
                            <% else %>
                            <a href="/category/category_itemPrd.asp?itemid=<%=bestItemList(i).Fitemid%>" >
                            <% end if %>	
								<div class="thumbnail">
									<img src="<%=bestItemList(i).FImageList%>" alt="" />
                                    <% if bestItemList(i).FsellYn = "N" then %>
                                    <b class="soldout">일시 품절</b>
                                    <% end if %>
								</div>
								<div class="desc">
									<p class="name"><%=bestItemList(i).Fitemname%></p>
									<div class="price">
										<div class="unit">
                                            <b class="sum"><%=formatNumber(tempPrice, 0)%><span class="won">원</span></b>
                                            <% response.write saleStr%>
                                            <% response.write couponStr%>
                                        </div>
									</div>
								</div>
							</a>
						</li>                    
                    <%
                            j = j + 1 'index값 
                            else
                            end if
                    %>                        
                        <% next %>
                    <% end if %>                        					
					</ul>				
					<button class="btn-more">더보기<span class="btn-icon"></span></button>
				</div>
                <a href="/event/eventmain.asp?eventid=91902" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=91902'); return false;" class="bnr bnr2"><img src="//fiximage.10x10.co.kr/web2019/valentine/m/img_bnr_2.jpg" alt="그저평범한 운동화가 아니야"></a>
                <a href="/event/eventmain.asp?eventid=91903" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=91903'); return false;" class="bnr bnr3"><img src="//fiximage.10x10.co.kr/web2019/valentine/m/img_bnr_3.jpg" alt="이런 선물, 리스펙트!"></a>
			</div>
        </section>
        <!-- 사은품응모 -->
        <section class="gift" id="gift">
            <p><img src="//fiximage.10x10.co.kr/web2019/valentine/m/img_gift.jpg" alt="자, 내 선물이야! 사랑하는 사람에게 애플 워치를 선물하세요. 응모하신 분 중 추첨을 통해 1명에게 애플 워치 2대를 드립니다."/></p>
            <button onclick="doAction();"><img src="//fiximage.10x10.co.kr/web2019/valentine/m/btn_submit.jpg" alt=" 응모하기"/></button>
        </section>
        <!-- 유의사항 -->
        <div class="noti">
            <p><img src="//fiximage.10x10.co.kr/web2019/valentine/m/tit_noti.png" alt="유의사항" /></p>
            <ul>
                <li>텐바이텐 고객에 한하여, ID 당 한 번만 참여 가능합니다.
                <li>당첨자에게는 세무 신고에 필요한 개인 정보를 요청할 수 있습니다. (제세공과금은 텐바이텐 부담)</li>
                <li>당첨 상품 :Apple Watch Series 4 (GPS) 스페이스 그레이 알루미늄 케이스, 블랙 스포츠 밴드 40mm, 44mm 각 1개</li>
            </ul>
        </div>
	</div>
	<!-- //contents -->