<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/exhibition/exhibitionCls.asp" -->
<%
'####################################################
' Description :  
' History : 2019-03-26 
'####################################################

Dim oExhibition, i, y
dim mastercode,  detailcode, bestItemList, eventList, detailGroupList, listType
dim tempNumber, couponPrice, couponPer, tempPrice, salePer
dim saleStr, couponStr

IF application("Svr_Info") = "Dev" THEN
	mastercode = 1
Else
	mastercode = 5	
End If

listType = "A"

SET oExhibition = new ExhibitionCls

	detailGroupList = oExhibition.getDetailGroupList(mastercode)
function format(ByVal szString, ByVal Expression)
	if len(szString) < len(Expression) then
	format = left(expression, len(szString)) & szString
	else
	format = szString
	end if
end function    

%>
 <style type="text/css">
.whitemember .topic {position: relative; background-color: #4ac56f;}
.whitemember .topic h2 {position: absolute; z-index: 8; top: 11%; width: 100%;}
.whitemember .topic .bg-area span {position: absolute; }
.whitemember .topic .bg-area span.hello1 {top: 3.2rem; left: 8%; width: 16.7%; animation: hello1 1s 20; transform-origin: 40% bottom;}
.whitemember .topic .bg-area span.balloon1 {top: 11.5rem; right: -3rem; width: 6.1rem; animation:balloon1 5s 10;}
.whitemember .topic .bg-area span.balloon2 {top: 16.7rem; right: 3rem; width: 3.1rem; animation:balloon2 3s 10;}
.whitemember .topic .bg-area span.shop1 {top: 55.5%; left: 39.4%; width: 21.2%; animation:shop1 .8s steps(1) 20;}
.whitemember .topic .txt-area {position: absolute; bottom: 3.5%; width: 100%;}
.whitemember .topic .txt-area p {margin-bottom: 1.1rem; animation:fadeDown 1s ease-out both;}
.whitemember .topic .txt-area p.txt2 {animation-delay: .5s}
.whitemember .topic .txt-area p.txt3 {animation-delay: 1s}
.whitemember .navi {position: relative; background-color: #4ac56f;}
.whitemember .navi ul {position: absolute; top: 8.8%; left: 7%; width: 86%; height:78%; background: url(//webimage.10x10.co.kr/fixevent/event/2019/memberGuide/white/m/img_white_list.jpg?v=1.02) no-repeat center top /100% auto; *zoom:1} 
.whitemember .navi ul:after {display:block; clear:both; content:'';} 
.whitemember .navi ul li {float: left; width: 33.33%; height: 25.32%; }
.whitemember .navi ul li a {display: block; width: 100%; height: 100%; text-indent: -9999px;}
.whitemember h3.groupBar span {opacity: 1;}
@keyframes hello1 {
  0% {transform: rotate(-5deg);}
  50% {transform: rotate(5deg);}
  100% {transform: rotate(-5deg);}
}
@keyframes balloon1 {
    from, to { transform:translate(0, -.5rem) rotate(4deg);}
    50%{ transform:translate(-1rem, .5rem) rotate(-3deg);}
}@keyframes balloon2 {
    from, to { transform:translateY(0) rotate(-6deg);}
    50%{ transform:translateY(-.5rem) rotate(8deg); }
}
@keyframes fadeDown { 
    from {transform:translateY(-1rem); opacity:0;} 
    to {transform:translateY(0); opacity:1;} 
}
@keyframes shop1 { 
    50% {opacity: 0;}
}
</style>
            <!-- 텐바이텐 신규 회원을 위한 혜택 가이드!  -->
            <div class="memberGuide whitemember">
                <div class="topic">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2019/memberGuide/white/m/bg_white.jpg" alt="">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/memberGuide/white/m/tit_white.png" alt="텐바이텐은 처음이지"></h2>
                    <div class="bg-area">
                        <span class="hello1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/memberGuide/white/m/tit_white2.png" alt=""></span>
                        <span class="balloon1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/memberGuide/white/m/bg_balloon1.png" alt=""></span>
                        <span class="balloon2"><img src="//webimage.10x10.co.kr/fixevent/event/2019/memberGuide/white/m/bg_balloon2.png" alt=""></span>
                        <span class="shop1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/memberGuide/white/m/bg_shop.png" alt=""></span>
                    </div>
                    <div class="txt-area">
                        <p class="txt1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/memberGuide/white/m/txt_01.png" alt="어서 오세요. 텐바이텐에 오신 걸 환영합니다!"></p>
                        <p class="txt2"><img src="//webimage.10x10.co.kr/fixevent/event/2019/memberGuide/white/m/txt_02.png" alt="아래 원하는 관심사를 선택하시면, 텐바이텐 입문 고객을 위한 맞춤 아이템을 추천해드릴게요!"></p>
                        <p class="txt3"><img src="//webimage.10x10.co.kr/fixevent/event/2019/memberGuide/white/m/txt_03.png" alt="오늘부터 단골손님이 되어도 책임 못 져요!"></p>
                    </div>
                </div>
                <div class="navi">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2019/memberGuide/white/m/img_white_bg.jpg" alt="">
                    <ul>
                        <li><a href="#groupBar01">인테리어</a></li>
                        <li><a href="#groupBar02">다꾸</a></li>
                        <li><a href="#groupBar03">패션</a></li>
                        <li><a href="#groupBar04">여행</a></li>
                        <li><a href="#groupBar05">취미</a></li>
                        <li><a href="#groupBar06">다이어트</a></li>
                        <li><a href="#groupBar07">디지털기기</a></li>
                        <li><a href="#groupBar08">육아</a></li>
                        <li><a href="#groupBar09">반려동물</a></li>
                        <li><a href="#groupBar10">요리</a></li>
                        <li><a href="#groupBar11">뷰티</a></li>
                        <li><a href="#groupBar12">토이</a></li>
                    </ul>
                </div>
            <% 
            if Ubound(detailGroupList) > 0 then                             
                dim tmpItemList, tmpidx
                for i = 0 to Ubound(detailGroupList) - 1 
                tmpidx = format(detailGroupList(i).Fdetailcode/10, "00")                                 
                
                tmpItemList = oExhibition.getItemsListProc( listType, 100, mastercode, detailGroupList(i).Fdetailcode, "", "")'리스트타입, 아이템수, 마스터코드, 디테일코드, 픽아이템, 카테고리sort                                
            %>
                <div class="items-list" id="groupBar<%=tmpidx%>">
                    <h3 class="groupBar">
                        <span style="background-color:#feec26;"></span><b><%=detailGroupList(i).Ftitle%></b>
                    </h3>
                    <div class="items type-grid">
                        <ul>
                        <% 
                        if Ubound(tmpItemList) > 0 then 
                            for y = 0 to Ubound(tmpItemList) - 1             
                                couponPer = oExhibition.GetCouponDiscountStr(tmpItemList(y).Fitemcoupontype, tmpItemList(y).Fitemcouponvalue)
                                couponPrice = oExhibition.GetCouponDiscountPrice(tmpItemList(y).Fitemcoupontype, tmpItemList(y).Fitemcouponvalue, tmpItemList(y).Fsellcash)                    
                                salePer     = CLng((tmpItemList(y).Forgprice-tmpItemList(y).Fsellcash)/tmpItemList(y).FOrgPrice*100)
                                if tmpItemList(y).Fsailyn = "Y" and tmpItemList(y).Fitemcouponyn = "Y" then '세일
                                    tempPrice = tmpItemList(y).Fsellcash - couponPrice
                                    saleStr = "<b class=""discount color-red"">"&salePer&"%</b>"
                                    couponStr = "<b class=""discount color-green"">"&couponPer&"</b>"  
                                elseif tmpItemList(y).Fitemcouponyn = "Y" then
                                    tempPrice = tmpItemList(y).Fsellcash - couponPrice
                                    saleStr = ""
                                    couponStr = "<b class=""discount color-green"">"&couponPer&"</b>"  
                                elseif tmpItemList(y).Fsailyn = "Y" then
                                    tempPrice = tmpItemList(y).Fsellcash
                                    saleStr = "<b class=""discount color-red"">"&salePer&"%</b>"
                                    couponStr = ""                                              
                                else
                                    tempPrice = tmpItemList(y).Fsellcash
                                    saleStr = ""
                                    couponStr = ""                                              
                                end if                                                                            
                        %>	                        
                            <li>
                            <% if isapp = 1 then %>             
                                <a href="javascript:fnAPPpopupProduct('<%=tmpItemList(y).Fitemid%>');" >							                                  	 	
                            <% else %>
                                <a href="/category/category_itemPrd.asp?itemid=<%=tmpItemList(y).Fitemid%>">
                            <% end if %>
                                    <div class="thumbnail">
                                        <img src="<%=tmpItemList(y).FImageList%>" alt="" />
                                        <% if tmpItemList(y).FsellYn = "N" then %>
                                        <b class="soldout">일시 품절</b>
                                        <% end if %>			
                                    </div>
                                    <div class="desc">
                                        <span class="brand"><%=tmpItemList(y).FbrandName%></span>
                                        <p class="name"><%=tmpItemList(y).Fitemname%></p>
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
                            next
                        end if
                        %>                             
                        </ul>
                    </div>
                </div>            
            <%
                next
            end if
            %>	                
            </div>
            <!--// 텐바이텐 신규 회원을 위한 혜택 가이드! -->
<!-- #include virtual="/lib/db/dbclose.asp" -->