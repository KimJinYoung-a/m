const app = new Vue({
    el: '#app'
    , template : `
        <div class="mEvt113634">
            <div class="topic">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/bg_main02.jpg" alt="">
                <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/tit_main.png" alt="추석 출석체크 이벤트"></h2>
                <p class="txt"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/txt_main.png" alt="마일리지 최대 4500p 받아가세요."></p>
            </div>

            <div class="section-photo">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/bg_family.jpg" alt="">
                    <div class="ph01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_01_off.png" alt="할머니"></div>
                    <div class="ph02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_02_off.png" alt="이모부"></div>
                    <div class="ph03"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_03_off.png" alt="할아버지"></div>
                    <div class="ph04"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_04_off.png?v=2" alt="엄마"></div>
                    <div class="ph05"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_05_off.png" alt="강아지"></div>
                    <div class="ph06"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_06_off.png" alt="이모"></div>
                    <div class="ph07"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_07_off.png" alt="조카"></div>
                    <div class="ph08"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_08_off.png" alt="아빠"></div>
                    <div class="ph09"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_09_off.png" alt="아기"></div>

                    <div class="ph01-01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_01_on.png" alt="할머니"></div>
                    <div class="ph02-02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_02_on.png" alt="이모부"></div>
                    <div class="ph03-03"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_03_on.png" alt="할아버지"></div>
                    <div class="ph04-04"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_04_on.png?v=2" alt="엄마"></div>
                    <div class="ph05-05"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_05_on.png" alt="강아지"></div>
                    <div class="ph06-06"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_06_on.png" alt="이모"></div>
                    <div class="ph07-07"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_07_on.png" alt="조카"></div>
                    <div class="ph08-08"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_08_on.png" alt="아빠"></div>
                    <div class="ph09-09"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_family_09_on.png" alt="아기"></div>
                <div class="bar"></div>
            </div>
            <div class="section-check">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_check02.jpg" alt="">
                <!-- app 설치 버튼 -->
                <a href="https://tenten.app.link/1ezxw0cxWib?%24deeplink_no_attribution=true" class="btn-check"></a>
                <div class="bar"></div>
            </div>
            <div class="section-mileage">
                <div class="id-area">
                    <p><span>{{userid}}</span> 님의</p>
                    <p>마일리지 지급 현황</p>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_mw_event.jpg" alt="">
                <div class="show-mileage">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_show_milige02.jpg" alt="현재까지 받은 마일리지">
                    <!-- 클릭시 마일리지 페이지로 이동 -->
                    <a href="/offshop/point/mileagelist.asp" class="btn-mileage"></a>
                </div>
            </div>
            <div class="section-detail">
                <div class="btn-area">
                    <button type="button" class="btn-detail">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/btn_detail02.jpg" alt="이벤트 유의사항 자세히보기" />
                        <span class="icon"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/icon_arrow02.png" alt=""></span>
                    </button>
                    <div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_detail02.jpg" alt="이벤트 유의사항" /></div>
                </div>
            </div>
            <div class="section-bnr">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113634/m/img_banner02.jpg" alt="이번 추석은 미리 준비해볼까요?">
                <div class="prd01">
                    <a href="/category/category_itemprd.asp?itemid=3988801&pEtr=113634" class="mWeb"></a>
                </div>
                <div class="prd02">
                    <a href="/category/category_itemprd.asp?itemid=2591592&pEtr=113634" class="mWeb"></a>
                </div>
                <div class="prd03">
                    <a href="/category/category_itemprd.asp?itemid=2172278&pEtr=113634" class="mWeb"></a>
                </div>
                <div class="prd04">
                    <a href="/category/category_itemprd.asp?itemid=3977897&pEtr=113634" class="mWeb"></a>
                </div>
                <div class="prd05">
                    <a href="/category/category_itemprd.asp?itemid=3986060&pEtr=113634" class="mWeb"></a>
                </div>
                <div class="prd06">
                    <a href="/category/category_itemprd.asp?itemid=3992093&pEtr=113634" class="mWeb"></a>
                </div>
                <a href="/event/eventmain.asp?eventid=113035" class="mWeb btn-go"></a>
            </div>

        </div>
    `
    , created() {
        if(userid == ""){
            this.userid = '고객';
        }else{
            this.userid = userid;
        }
    }
    , mounted(){
        // btn more
        $('.mEvt113634 .btn-detail').click(function (e) {
            $(this).next().toggleClass('on');
            $(this).find('.icon').toggleClass('on');
        });
    }
    , data(){
        return {
            userid : ''
        }
    }
});