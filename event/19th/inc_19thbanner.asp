<%
    '// 아래 해당 배너를 off 해야될 때가 오면 해당 값을 false로 변경해줌
    '// 다시 킬땐 true
    PresentItemViewFlag     = true '// 구매사은품
    shinhanEventViewFlag    = true  '// 신한카드 할인
    jubjubEventViewFlag     = true  '// 줍줍 이벤트
    pictureDiaryViewFlag    = true  '// 그림일기 이벤트
    watchaEventViewFlag     = true  '// 왓챠 이벤트
    kakaoPayEventViewFlag   = true  '// 카카오페이 할인
    tenQuizEventViewFlag    = true  '// 텐퀴즈
    profitItemEventViewFlag = true  '// 득템 이벤트
    giftEventViewFlag       = true  '// 선물의 참견
    chaiEventViewFlag       = true  '// 차이 할인 이벤트
    photoCommentViewFlag    = true  '// 포토후기 이벤트
    updownEventViewFlag     = true  '// 비밀의 책 이벤트
    bcCardEventViewFlag     = false '// bc카드 할인
    mileage2222ViewFlag     = true  '// 마일리지2222
%>
<% Select Case Trim(Left(now(), 10)) %>
    <% Case "2020-10-05" %>
    <% '구매사은품, 신한카드, 줍줍(에어팟프로), 그림일기 %>
        <% If PresentItemViewFlag Then %>
            <li>
                <a href="/event/eventmain.asp?eventid=106353" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon02.png" alt="생일 특별 선물 선착순 입니다. 선물 받아 가세요."></a>
            </li>
        <% End If %>
        <li>
            <a href="/event/eventmain.asp?eventid=106209" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon03.png" alt="결제 혜택 지금 3,000원 할인 받는 법"></a>
        </li>
        <li>
            <a href="/event/eventmain.asp?eventid=106236" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon04.png" alt="응모 이벤트 에어팟 프로 딱 100원에 도전하기"></a>
        </li>
        <li>
            <a href="/event/eventmain.asp?eventid=106091" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon05.png" alt="참여 이벤트 일기만 잘 써도 아이패드가 무료"></a>
        </li>

    <% Case "2020-10-06" %>
    <% '그림일기, 줍줍(에어팟프로), 신한카드, 구매사은품 %>
        <li>
            <a href="/event/eventmain.asp?eventid=106091" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon05.png" alt="참여 이벤트 일기만 잘 써도 아이패드가 무료"></a>
        </li>
        <li>
            <a href="/event/eventmain.asp?eventid=106236" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon04.png" alt="응모 이벤트 에어팟 프로 딱 100원에 도전하기"></a>
        </li>
        <li>
            <a href="/event/eventmain.asp?eventid=106209" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon03.png" alt="결제 혜택 지금 3,000원 할인 받는 법"></a>
        </li>
        <% If PresentItemViewFlag Then %>        
            <li>
                <a href="/event/eventmain.asp?eventid=106353" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon02.png" alt="생일 특별 선물 선착순 입니다. 선물 받아 가세요."></a>
            </li>
        <% End If %>

    <% Case "2020-10-07" %>
    <% '왓챠, 구매사은품, 신한카드, 줍줍(에어팟 프로), 그림일기 %>
        <li><%' 왓챠 베너 추가 %>
            <a href="/event/eventmain.asp?eventid=106205" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon08.png" alt="왓챠 이벤트"></a>
        </li>    
        <% If PresentItemViewFlag Then %>        
            <li>
                <a href="/event/eventmain.asp?eventid=106353" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon02.png" alt="생일 특별 선물 선착순 입니다. 선물 받아 가세요."></a>
            </li>
        <% End If %>
        <li>
            <a href="/event/eventmain.asp?eventid=106209" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon03.png" alt="결제 혜택 지금 3,000원 할인 받는 법"></a>
        </li>
        <li>
            <a href="/event/eventmain.asp?eventid=106236" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon04.png" alt="응모 이벤트 에어팟 프로 딱 100원에 도전하기"></a>
        </li>
        <li>
            <a href="/event/eventmain.asp?eventid=106091" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon05.png" alt="참여 이벤트 일기만 잘 써도 아이패드가 무료"></a>
        </li>

    <% Case "2020-10-08", "2020-10-09" %>
    <% ' 왓챠, 구매사은품, 그림일기, 줍줍(에어팟 프로) %>
        <% If watchaEventViewFlag Then %>
            <li><%' 왓챠 베너 추가 %>
                <a href="/event/eventmain.asp?eventid=106205" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon08.png" alt="왓챠 이벤트"></a>
            </li>
        <% End If %>
        <% If PresentItemViewFlag Then %>        
            <li>
                <a href="/event/eventmain.asp?eventid=106353" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon02.png" alt="생일 특별 선물 선착순 입니다. 선물 받아 가세요."></a>
            </li>
        <% End If %>
        <% If pictureDiaryViewFlag Then %>
            <li>
                <a href="/event/eventmain.asp?eventid=106091" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon05.png" alt="참여 이벤트 일기만 잘 써도 아이패드가 무료"></a>
            </li>
        <% End If %>
        <% If jubjubEventViewFlag Then %>
            <li>
                <a href="/event/eventmain.asp?eventid=106236" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon04.png" alt="응모 이벤트 에어팟 프로 딱 100원에 도전하기"></a>
            </li>
        <% End If %>

    <% Case "2020-10-10", "2020-10-11" %>
    <% ' 그림일기, 구매사은품, 왓챠, 줍줍(에어팟 프로) %>
        <% If pictureDiaryViewFlag Then %>    
            <li>
                <a href="/event/eventmain.asp?eventid=106091" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon05.png" alt="참여 이벤트 일기만 잘 써도 아이패드가 무료"></a>
            </li>
        <% End If %>
        <% If PresentItemViewFlag Then %>        
            <li>
                <a href="/event/eventmain.asp?eventid=106353" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon02.png" alt="생일 특별 선물 선착순 입니다. 선물 받아 가세요."></a>
            </li>
        <% End If %>
        <% If watchaEventViewFlag Then %>
            <li><%' 왓챠 베너 추가 %>
                <a href="/event/eventmain.asp?eventid=106205" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon08.png" alt="왓챠 이벤트"></a>
            </li>
        <% End If %>
        <% If jubjubEventViewFlag Then %>
            <li>
                <a href="/event/eventmain.asp?eventid=106236" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon04.png" alt="응모 이벤트 에어팟 프로 딱 100원에 도전하기"></a>
            </li>        
        <% End If %>

    <% Case "2020-10-12" %>
    <% '카카오페이, 선물의 참견, 왓챠, 그림일기, 구매사은품 %>
        <% If kakaoPayEventViewFlag Then %>
            <li><%' 카카오페이 베너 추가 %>
                <a href="/event/eventmain.asp?eventid=106436" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon09.png" alt="카카오페이 이벤트"></a>
            </li>
        <% End If %>
        <% If giftEventViewFlag Then %>
            <li><%' 선물의 참견 베너 추가 %>
                <a href="/gift/gifttalk/" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon10.png" alt="선물의참견 이벤트"></a>
            </li>
        <% End If %>
        <% If watchaEventViewFlag Then %>
            <li><%' 왓챠 베너 추가 %>
                <a href="/event/eventmain.asp?eventid=106205" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon08.png" alt="왓챠 이벤트"></a>
            </li>
        <% End If %>
        <% If pictureDiaryViewFlag Then %>
            <li>
                <a href="/event/eventmain.asp?eventid=106091" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon05.png" alt="참여 이벤트 일기만 잘 써도 아이패드가 무료"></a>
            </li>
        <% End If %>
        <% If PresentItemViewFlag Then %>        
            <li>
                <a href="/event/eventmain.asp?eventid=106353" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon02.png" alt="생일 특별 선물 선착순 입니다. 선물 받아 가세요."></a>
            </li>        
        <% End If %>

    <% Case "2020-10-13" %>
    <% '텐퀴즈, 선물의 참견, 카카오페이, 왓챠, 그림일기 %>
        <% If tenQuizEventViewFlag Then %>
            <li><%' 텐퀴즈 베너 추가 %>
                <a href="/tenquiz/quizmain.asp" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon14.png" alt="텐퀴즈 이벤트"></a>
            </li>
        <% End If %>
        <% If giftEventViewFlag Then %>
            <li><%' 선물의 참견 베너 추가 %>
                <a href="/gift/gifttalk/" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon10.png" alt="선물의참견 이벤트"></a>
            </li>
        <% End If %>
        <% If kakaoPayEventViewFlag Then %>
            <li><%' 카카오페이 베너 추가 %>
                <a href="/event/eventmain.asp?eventid=106436" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon09.png" alt="카카오페이 이벤트"></a>
            </li>
        <% End If %>
        <% If watchaEventViewFlag Then %>
            <li><%' 왓챠 베너 추가 %>
                <a href="/event/eventmain.asp?eventid=106205" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon08.png" alt="왓챠 이벤트"></a>
            </li>
        <% End If %>
        <% If pictureDiaryViewFlag Then %>
            <li>
                <a href="/event/eventmain.asp?eventid=106091" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon05.png" alt="참여 이벤트 일기만 잘 써도 아이패드가 무료"></a>
            </li>
        <% End If %>

    <% Case "2020-10-14" %>
    <%' 선물의 참견, 카카오 페이, 왓챠, 그림일기 %>
        <% If giftEventViewFlag Then %>
            <li><%' 선물의 참견 베너 추가 %>
                <a href="/gift/gifttalk/" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon10.png" alt="선물의참견 이벤트"></a>
            </li>
        <% End If %>
        <% If kakaoPayEventViewFlag Then %>
            <li><%' 카카오페이 베너 추가 %>
                <a href="/event/eventmain.asp?eventid=106436" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon09.png" alt="카카오페이 이벤트"></a>
            </li>
        <% End If %>
        <% If watchaEventViewFlag Then %>
            <li><%' 왓챠 베너 추가 %>
                <a href="/event/eventmain.asp?eventid=106205" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon08.png" alt="왓챠 이벤트"></a>
            </li>
        <% End If %>
        <% If pictureDiaryViewFlag Then %>
            <li>
                <a href="/event/eventmain.asp?eventid=106091" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon05.png" alt="참여 이벤트 일기만 잘 써도 아이패드가 무료"></a>
            </li>
        <% End If %>

    <% Case "2020-10-15", "2020-10-16", "2020-10-17", "2020-10-18" %>
    <%' 득템이벤트, 선물의 참견, 카카오 페이, 왓챠, 그림일기 %>
        <% If profitItemEventViewFlag Then %>
            <li><%' 득템 이벤트 베너 추가 %>
                <a href="/event/eventmain.asp?eventid=106510" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon17.png" alt="득템 이벤트"></a>
            </li>
        <% End If %>
        <% If giftEventViewFlag Then %>        
            <li><%' 선물의 참견 베너 추가 %>
                <a href="/gift/gifttalk/" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon10.png" alt="선물의참견 이벤트"></a>
            </li>
        <% End If %>
        <% If kakaoPayEventViewFlag Then %>
            <li><%' 카카오페이 베너 추가 %>
                <a href="/event/eventmain.asp?eventid=106436" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon09.png" alt="카카오페이 이벤트"></a>
            </li>
        <% End If %>
        <% If watchaEventViewFlag Then %>
            <li><%' 왓챠 베너 추가 %>
                <a href="/event/eventmain.asp?eventid=106205" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon08.png" alt="왓챠 이벤트"></a>
            </li>
        <% End If %>
        <% If pictureDiaryViewFlag Then %>
            <li>
                <a href="/event/eventmain.asp?eventid=106091" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon05.png" alt="참여 이벤트 일기만 잘 써도 아이패드가 무료"></a>
            </li>
        <% End If %>

    <% Case "2020-10-19", "2020-10-20" %>
    <% '구매 사은품, 차이, 포토후기, 비밀의 책, 득템이벤트, 선물의 참견 %>
        <% If chaiEventViewFlag Then %>
            <li><%' 차이 베너 추가 %>
                <a href="/event/eventmain.asp?eventid=106508" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon11.png" alt="차이 이벤트"></a>
            </li>
        <% End If %>
        <% If photoCommentViewFlag Then %>
            <li><%' 포토후기 베너 추가 %>
                <a href="/my10x10/goodsusing.asp" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon15.png" alt="포토후기 이벤트"></a>
            </li>
        <% End If %>
        <% If profitItemEventViewFlag Then %>
            <li><%' 득템 이벤트 베너 추가 %>
                <a href="/event/eventmain.asp?eventid=106510" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon17.png" alt="득템 이벤트"></a>
            </li>
        <% End If %>
        <% If giftEventViewFlag Then %>
            <li><%' 선물의 참견 베너 추가 %>
                <a href="/gift/gifttalk/" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon10.png" alt="선물의참견 이벤트"></a>
            </li>
        <% End If %>
        <% If PresentItemViewFlag Then %>
            <li>
                <a href="/event/eventmain.asp?eventid=106353" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon02.png" alt="생일 특별 선물 선착순 입니다. 선물 받아 가세요."></a>
            </li>
        <% End If %>

    <% Case "2020-10-21", "2020-10-22" %>
    <% '구매 사은품, 마일리지2222, 차이, 포토후기, 비밀의 책, 선물의 참견 %>
        <% If mileage2222ViewFlag Then %>
            <li><%' 마일리지2222 베너 추가 %>
                <a href="/event/eventmain.asp?eventid=106514" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon12.png" alt="마일리지2222 이벤트"></a>
            </li>
        <% End If %>
        <% If chaiEventViewFlag Then %>
            <li><%' 차이 베너 추가 %>
                <a href="/event/eventmain.asp?eventid=106508" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon11.png" alt="차이 이벤트"></a>
            </li>
        <% End IF %>
        <% If photoCommentViewFlag Then %>
            <li><%' 포토후기 베너 추가 %>
                <a href="/my10x10/goodsusing.asp" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon15.png" alt="포토후기 이벤트"></a>
            </li>
        <% End If %>
        <% If updownEventViewFlag Then %>
            <li><%' 비밀의 책 베너 추가 %>
                <a href="/event/eventmain.asp?eventid=106512" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon18.png" alt="비밀의 책 이벤트"></a>
            </li>
        <% End If %>
        <% If giftEventViewFlag Then %>
            <li><%' 선물의 참견 베너 추가 %>
                <a href="/gift/gifttalk/" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon10.png" alt="선물의참견 이벤트"></a>
            </li>
        <% End If %>
        <% If PresentItemViewFlag Then %>
            <li>
                <a href="/event/eventmain.asp?eventid=106353" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon02.png" alt="생일 특별 선물 선착순 입니다. 선물 받아 가세요."></a>
            </li>
        <% End If %>

    <% Case "2020-10-23" %>
    <% '구매 사은품, 차이, 포토후기, 비밀의 책, 선물의 참견 %>
        <% If chaiEventViewFlag Then %>
            <li><%' 차이 베너 추가 %>
                <a href="/event/eventmain.asp?eventid=106508" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon11.png" alt="차이 이벤트"></a>
            </li>
        <% End If %>
        <% If photoCommentViewFlag Then %>
            <li><%' 포토후기 베너 추가 %>
                <a href="/my10x10/goodsusing.asp" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon15.png" alt="포토후기 이벤트"></a>
            </li>
        <% End If %>
        <% If updownEventViewFlag Then %>
            <li><%' 비밀의 책 베너 추가 %>
                <a href="/event/eventmain.asp?eventid=106512" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon18.png" alt="비밀의 책 이벤트"></a>
            </li>
        <% End If %>
        <% If giftEventViewFlag Then %>
            <li><%' 선물의 참견 베너 추가 %>
                <a href="/gift/gifttalk/" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon10.png" alt="선물의참견 이벤트"></a>
            </li>
        <% End If %>
        <% If PresentItemViewFlag Then %>
            <li>
                <a href="/event/eventmain.asp?eventid=106353" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon02.png" alt="생일 특별 선물 선착순 입니다. 선물 받아 가세요."></a>
            </li>
        <% End If %>

    <% Case "2020-10-24", "2020-10-25" %>
    <% '구매 사은품, 차이, 비밀의 책, 선물의 참견 %>
        <% If chaiEventViewFlag Then %>
            <li><%' 차이 베너 추가 %>
                <a href="/event/eventmain.asp?eventid=106508" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon11.png" alt="차이 이벤트"></a>
            </li>
        <% End If %>
        <% If updownEventViewFlag Then %>
            <li><%' 비밀의 책 베너 추가 %>
                <a href="/event/eventmain.asp?eventid=106512" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon18.png" alt="비밀의 책 이벤트"></a>
            </li>
        <% End If %>
        <% If giftEventViewFlag Then %>
            <li><%' 선물의 참견 베너 추가 %>
                <a href="/gift/gifttalk/" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon10.png" alt="선물의참견 이벤트"></a>
            </li>
        <% End If %>
        <% If PresentItemViewFlag Then %>
            <li>
                <a href="/event/eventmain.asp?eventid=106353" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon02.png" alt="생일 특별 선물 선착순 입니다. 선물 받아 가세요."></a>
            </li>
        <% End If %>

    <% Case "2020-10-26", "2020-10-27", "2020-10-28", "2020-10-29" %>
    <% '구매 사은품, bc카드, 비밀의 책, 선물의 참견 %>
        <% If bcCardEventViewFlag Then %>
            <li><%' bc카드 베너 추가 %>
                <a href="/event/eventmain.asp?eventid=106509" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon13.png" alt="bc카드 이벤트"></a>
            </li>
        <% End If %>
        <% If updownEventViewFlag Then %>
            <li><%' 비밀의 책 베너 추가 %>
                <a href="/event/eventmain.asp?eventid=106512" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon18.png" alt="비밀의 책 이벤트"></a>
            </li>
        <% End If %>
        <% If giftEventViewFlag Then %>
            <li><%' 선물의 참견 베너 추가 %>
                <a href="/gift/gifttalk/" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon10.png" alt="선물의참견 이벤트"></a>
            </li>
        <% End If %>
        <% If PresentItemViewFlag Then %>
            <li>
                <a href="/event/eventmain.asp?eventid=106353" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon02.png" alt="생일 특별 선물 선착순 입니다. 선물 받아 가세요."></a>
            </li>
        <% End If %>
<% End Select %>