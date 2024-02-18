<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 럭키박스 블루마블
' History : 2020-04-03 조경애
'####################################################
%>
<%
dim currentdate
	currentdate = date()
	'currentdate = "2020-04-07"

	'response.write currentdate
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.item-list li {position:relative;}
.item-list li .price {position:absolute; left:0; bottom:7%; width:100%; color:#371c0f; text-align:center; font-family:'CoreSansCBold'; font-size:1.8rem; line-height:1.1;}
.item-list li .price s {font-family:'CoreSansCRegular'; font-size:1.45rem; }
.item-list li .price span {display:inline-block; height:1.96rem; margin-left:.5rem; line-height:2.1rem; padding:.1rem .3rem 0; color:#fff; border:.08rem solid #371c0f; background:#c92326;}
.brand-list {position:relative;}
.brand-list li {position:absolute; top:0; left:4.8%; width:21.3%; height:14.7%; font-size:0;}
.brand-list li a {display:block; width:100; height:100%;}
.brand-list li.item1 {left:26%; }
.brand-list li.item2 {left:47%; width:26.5%;}
.brand-list li.item3 {left:74%; height:20.68%;}
.brand-list li.item4 {left:74%; top:20.68%;}
.brand-list li.item5 {left:52.78%; top:20.68%;}
.brand-list li.item6 {left:31.3%; top:20.68%;}
.brand-list li.item7 {top:20.68%; width:26.5%;}
.brand-list li.item8 {top:35.57%;}
.brand-list li.item9 {top:50%;}
.brand-list li.item10 {left:26%; top:50%;}
.brand-list li.item11 {left:47%; top:50%;}
.brand-list li.item12 {left:68.6%; top:50%; width:26.27%;}/* jump */
.brand-list li.item13 {left:74%; top:64.5%; height:19.5%;}
.brand-list li.item14 {left:52.78%; top:69.5%;}
.brand-list li.item15 {left:31.3%; top:69.5%;}
</style>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script type="text/javascript">
$(function(){
    fnApplyItemInfoEach({
        items:"2796450,2797054,2775137,2796882,2807356,2802729,2803691,2442085,2786478,2786479,2807398,2802906,2803895,2803377,2814257",
        target:"item",
        fields:["price","sale"],
        unit:"won",
        saleBracket:false
    });
    var swiper1 = new Swiper('.item-list .swiper-container', {
        effect:"fade",
		loop:true,
        speed:100,
		autoplay:3000
	});
});
</script>
<!-- 101687 이벤트기간:0406~0420 -->
<ul id="list" class="item-list">
    <% if currentdate < "2020-04-07" then %>
    <li class="item2796450">
        <a href="/category/category_itemPrd.asp?itemid=2796450&pEtr=101687" class="mWeb">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item1.jpg?v=2" alt="">
            <p class="price"><s>원가</s> 판매가<span>할인율</span></p>
        </a>
        <a href="" onclick="fnAPPpopupProduct('2796450');return false;" class="mApp">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item1.jpg?v=2" alt="">
            <p class="price"><s>원가</s> 판매가<span>할인율</span></p>
        </a>
    </li>

    <% elseif currentdate < "2020-04-08" then %>
    <li class="item2797054">
        <a href="/category/category_itemPrd.asp?itemid=2797054&pEtr=101687" class="mWeb">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item2.jpg" alt="">
            <p class="price"><s>원가</s> 판매가<span>할인율</span></p>
        </a>
        <a href="" onclick="fnAPPpopupProduct('2797054');return false;" class="mApp" target="_top">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item2.jpg" alt="">
            <p class="price"><s>원가</s> 판매가<span>할인율</span></p>
        </a>
    </li>

    <% elseif currentdate < "2020-04-09" then %>
    <li class="item2775137">
        <a href="/category/category_itemPrd.asp?itemid=2775137&pEtr=101687" class="mWeb">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item3.jpg" alt="">
            <p class="price"><s>원가</s> 판매가<span>할인율</span></p>
        </a>
        <a href="" onclick="fnAPPpopupProduct('2775137');return false;" class="mApp">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item3.jpg" alt="">
            <p class="price"><s>원가</s> 판매가<span>할인율</span></p>
        </a>
    </li>

    <% elseif currentdate < "2020-04-10" then %>
    <li class="item2796882">
        <a href="/category/category_itemPrd.asp?itemid=2796882&pEtr=101687" class="mWeb">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item4.jpg" alt="">
            <p class="price"><s>원가</s> 판매가<span>할인율</span></p>
        </a>
        <a href="" onclick="fnAPPpopupProduct('2796882');return false;" class="mApp">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item4.jpg" alt="">
            <p class="price"><s>원가</s> 판매가<span>할인율</span></p>
        </a>
    </li>

    <% elseif currentdate < "2020-04-11" then %>
    <li>
        <a href="/category/category_itemPrd.asp?itemid=2807356&pEtr=101687" class="mWeb">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item5.jpg" alt="">
            <p class="price">9,900원~</p>
        </a>
        <a href="" onclick="fnAPPpopupProduct('2807356');return false;" class="mApp">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item5.jpg" alt="">
            <p class="price">9,900원~</p>
        </a>
    </li>

    <% elseif currentdate < "2020-04-12" then %>
    <li class="item2802729">
        <a href="/category/category_itemPrd.asp?itemid=2802729&pEtr=101687" class="mWeb">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item6.jpg" alt="">
            <p class="price"><s>원가</s> 판매가<span>할인율</span></p>
        </a>
        <a href="" onclick="fnAPPpopupProduct('2802729');return false;" class="mApp">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item6.jpg" alt="">
            <p class="price"><s>원가</s> 판매가<span>할인율</span></p>
        </a>
    </li>

    <% elseif currentdate < "2020-04-13" then %>
    <li class="item2802729">
        <a href="/category/category_itemPrd.asp?itemid=2802729&pEtr=101687" class="mWeb">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item6.jpg" alt="">
            <p class="price"><s>원가</s> 판매가<span>할인율</span></p>
        </a>
        <a href="" onclick="fnAPPpopupProduct('2802729');return false;" class="mApp">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item6.jpg" alt="">
            <p class="price"><s>원가</s> 판매가<span>할인율</span></p>
        </a>
    </li>

    <% elseif currentdate < "2020-04-14" then %>
    <li class="item2803691">
        <a href="/category/category_itemPrd.asp?itemid=2803691&pEtr=101687" onclick="fnAPPpopupProduct('2803691');return false;">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item7.jpg" alt="">
            <p class="price"><s>원가</s> 판매가<span>할인율</span></p>
        </a>
    </li>

    <% elseif currentdate < "2020-04-15" then %>
    <li class="item2442085">
        <a href="/category/category_itemPrd.asp?itemid=2442085&pEtr=101687" onclick="fnAPPpopupProduct('2442085');return false;">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item8.jpg" alt="">
            <p class="price"><s>원가</s> 판매가<span>할인율</span></p>
        </a>
    </li>

    <% elseif currentdate < "2020-04-16" then %>
    <li class="swiper-container">
        <div class="swiper-wrapper">
            <div class="swiper-slide item2786478">
                <a href="/category/category_itemPrd.asp?itemid=2786478&pEtr=101687" onclick="fnAPPpopupProduct('2786478');return false;">
                    <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item9_1.jpg" alt="">
                    <p class="price"><s>원가</s> 판매가<span>할인율</span></p>
                </a>
            </div>
            <div class="swiper-slide item2786479">
                <a href="/category/category_itemPrd.asp?itemid=2786479&pEtr=101687" onclick="fnAPPpopupProduct('2786479');return false;">
                    <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item9_2.jpg" alt="">
                    <p class="price"><s>원가</s> 판매가<span>할인율</span></p>
                </a>
            </div>
        </div>
    </li>

    <% elseif currentdate < "2020-04-17" then %>
    <li>
        <a href="/category/category_itemPrd.asp?itemid=2807398&pEtr=101687" onclick="fnAPPpopupProduct('2807398');return false;">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item10.jpg" alt="">
            <p class="price">19,900원~</p>
        </a>
    </li>

    <% elseif currentdate < "2020-04-18" then %>
    <li class="item2802906">
        <a href="/category/category_itemPrd.asp?itemid=2802906&pEtr=101687" onclick="fnAPPpopupProduct('2802906');return false;">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item11.jpg" alt="">
            <p class="price"><s>원가</s> 판매가<span>할인율</span></p>
        </a>
    </li>

    <% elseif currentdate < "2020-04-19" then %>
    <li class="item2803895">
        <a href="/category/category_itemPrd.asp?itemid=2803895&pEtr=101687" onclick="fnAPPpopupProduct('2803895');return false;">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item12.jpg" alt="">
            <p class="price"><s>원가</s> 판매가<span>할인율</span></p>
        </a>
    </li>

    <% elseif currentdate < "2020-04-20" then %>
    <li class="item2803377">
        <a href="/category/category_itemPrd.asp?itemid=2803377&pEtr=101687" onclick="fnAPPpopupProduct('2803377');return false;">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item13.jpg" alt="">
            <p class="price"><s>원가</s> 판매가<span>할인율</span></p>
        </a>
    </li>

    <% else %>
    <li class="item2814257">
        <a href="/category/category_itemPrd.asp?itemid=2814257&pEtr=101687" onclick="fnAPPpopupProduct('2814257');return false;">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/item14.jpg" alt="">
            <p class="price"><s>원가</s> 판매가<span>할인율</span></p>
        </a>
    </li>
    <% end if %>

</ul>
<p><img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/txt_every.png" alt="매일 00:00시 럭키박스가 공개됩니다"></p>
<div class="brand-list">
    <ul>
        <li class="item1">
            <a href="/category/category_itemPrd.asp?itemid=2796450&pEtr=101687" class="mWeb"></a>
            <a href="" onclick="fnAPPpopupProduct('2796450');return false;" class="mApp"></a>
        </li>

        <% if currentdate < "2020-04-07" then %>
        <li class="item2">coming soon</li>
        <% Else %>
        <li class="item2">
            <a href="/category/category_itemPrd.asp?itemid=2797054&pEtr=101687" class="mWeb"></a>
            <a href="" onclick="fnAPPpopupProduct('2797054');return false;" class="mApp"></a>
        </li>
        <% End If %>

        <% if currentdate < "2020-04-08" then %>
        <li class="item3">coming soon</li>
        <% Else %>
        <li class="item3">
            <a href="/category/category_itemPrd.asp?itemid=2775137&pEtr=101687" class="mWeb"></a>
            <a href="" onclick="fnAPPpopupProduct('2775137');return false;" class="mApp"></a>
        </li>
        <% End If %>

        <% if currentdate < "2020-04-09" then %>
        <li class="item4">coming soon</li>
        <% Else %>
        <li class="item4">
            <a href="/category/category_itemPrd.asp?itemid=2796882&pEtr=101687" class="mWeb"></a>
            <a href="" onclick="fnAPPpopupProduct('2796882');return false;" class="mApp"></a>
        </li>
        <% End If %>

        <% if currentdate < "2020-04-10" then %>
        <li class="item5">coming soon</li>
        <% Else %>
        <li class="item5">
            <a href="/category/category_itemPrd.asp?itemid=2807356&pEtr=101687" class="mWeb"></a>
            <a href="" onclick="fnAPPpopupProduct('2807356');return false;" class="mApp"></a>
        </li>
        <% End If %>

        <% if currentdate < "2020-04-11" then %>
        <li class="item6">coming soon</li>
        <% Else %>
        <li class="item6">
            <a href="/category/category_itemPrd.asp?itemid=2802729&pEtr=101687" class="mWeb"></a>
            <a href="" onclick="fnAPPpopupProduct('2802729');return false;" class="mApp"></a>
        </li>
        <% End If %>

        <% if currentdate < "2020-04-13" then %>
        <li class="item8">coming soon</li>
        <% Else %>
        <li class="item8"><a href="/category/category_itemPrd.asp?itemid=2803691&pEtr=101687" onclick="fnAPPpopupProduct('2803691');return false;"></a></li>
        <% End If %>

        <% if currentdate < "2020-04-14" then %>
        <li class="item9">coming soon</li>
        <% Else %>
        <li class="item9"><a href="/category/category_itemPrd.asp?itemid=2442085&pEtr=101687" onclick="fnAPPpopupProduct('2442085');return false;"></a></li>
        <% End If %>

        <% if currentdate < "2020-04-15" then %>
        <li class="item10">coming soon</li>
        <% Else %>
        <li class="item10"><a href="/category/category_itemPrd.asp?itemid=2786478&pEtr=101687" onclick="fnAPPpopupProduct('2786478');return false;"></a></li>
        <% End If %>

        <% if currentdate < "2020-04-16" then %>
        <li class="item11">coming soon</li>
        <% Else %>
        <li class="item11"><a href="/category/category_itemPrd.asp?itemid=2807398&pEtr=101687" onclick="fnAPPpopupProduct('2807398');return false;"></a></li>
        <% End If %>

        <% if currentdate < "2020-04-17" then %>
        <li class="item12">coming soon</li>
        <% Else %>
        <li class="item12"><a href="/category/category_itemPrd.asp?itemid=2802906&pEtr=101687" onclick="fnAPPpopupProduct('2802906');return false;"></a></li>
        <% End If %>

        <% if currentdate < "2020-04-18" then %>
        <li class="item13">coming soon</li>
        <% Else %>
        <li class="item13"><a href="/category/category_itemPrd.asp?itemid=2803895&pEtr=101687" onclick="fnAPPpopupProduct('2803895');return false;"></a></li>
        <% End If %>

        <% if currentdate < "2020-04-19" then %>
        <li class="item14">coming soon</li>
        <% Else %>
        <li class="item14"><a href="/category/category_itemPrd.asp?itemid=2803377&pEtr=101687" onclick="fnAPPpopupProduct('2803377');return false;"></a></li>
        <% End If %>

        <% if currentdate < "2020-04-20" then %>
        <li class="item15">coming soon</li>
        <% Else %>
        <li class="item15"><a href="/category/category_itemPrd.asp?itemid=2814257&pEtr=101687" onclick="fnAPPpopupProduct('2814257');return false;"></a></li>
        <% End If %>

    </ul>

    <!-- 맵 이미지 변경 -->
    <% if currentdate < "2020-04-07" then %>
    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/img_map_1.png?v=2" alt=""></p>

    <% elseif currentdate < "2020-04-08" then %>
    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/img_map_2.png?v=2" alt=""></p>

    <% elseif currentdate < "2020-04-09" then %>
    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/img_map_3.png?v=2" alt=""></p>

    <% elseif currentdate < "2020-04-10" then %>
    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/img_map_4.png?v=2" alt=""></p>

    <% elseif currentdate < "2020-04-11" then %>
    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/img_map_5.png?v=2" alt=""></p>

    <% elseif currentdate < "2020-04-12" then %>
    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/img_map_6.png?v=2" alt=""></p>

    <% elseif currentdate < "2020-04-13" then %>
    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/img_map_6.png?v=2" alt=""></p>

    <% elseif currentdate < "2020-04-14" then %>
    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/img_map_7.png?v=2" alt=""></p>

    <% elseif currentdate < "2020-04-15" then %>
    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/img_map_8.png?v=2" alt=""></p>

    <% elseif currentdate < "2020-04-16" then %>
    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/img_map_9.png?v=2" alt=""></p>

    <% elseif currentdate < "2020-04-17" then %>
    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/img_map_10.png?v=2" alt=""></p>

    <% elseif currentdate < "2020-04-18" then %>
    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/img_map_11.png?v=2" alt=""></p>

    <% elseif currentdate < "2020-04-19" then %>
    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/img_map_12.png?v=2" alt=""></p>

    <% elseif currentdate < "2020-04-20" then %>
    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/img_map_13.png?v=2" alt=""></p>

    <% Else %>
    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2020/101687/m/img_map_14.png?v=2" alt=""></p>
    <% End If %>
        
</div>
<!--// 101687 -->