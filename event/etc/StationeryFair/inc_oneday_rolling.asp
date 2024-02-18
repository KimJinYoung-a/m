<%
'####################################################
' Description : MD 텐텐 문구 페어 - 원데이, 롤링배너
' History : 2021-03-02 이전도
'####################################################
%>
<!-- 원데이 -->
<section id="oneday" class="section-oneday">
    <h3><img src="//webimage.10x10.co.kr/fixevent/event/2021/109789/m/tit_oneday.png" alt="One Day Event"></h3>
    <div class="item">
        <a>
            <div class="desc">
                <p class="headline"></p>
                <p class="subcopy"></p>
            </div>
            <div class="thumbnail"><img src="" alt=""></div>
        </a>
    </div>
</section>

<!-- 롤링배너 -->
<section id="rolling_banner" class="section-special">
    <h3><img src="//webimage.10x10.co.kr/fixevent/event/2021/109789/m/tit_special.png" alt="Special Event"></h3>
    <div class="evt-slider">
        <div class="swiper-container">
            <div class="swiper-wrapper"></div>
            <div class="pagination-progressbar"><span class="pagination-progressbar-fill"></span></div>
        </div>
    </div>
</section>
<script>
    getApiData(apiurl + '/tempEvent/tentenEvent', {
        'brandListMasterIdx' : is_develop ? '2' : '4',
        'deviceType' : is_app ? 'a' : 'm',
        'mastercode' : is_develop ? '16' : '19'
    }, data => {
        console.log(data);
        setOneDayHTML(data.oneDay);
        setRollingBannerHTML(data.rolling);
    });

    // Get API DATA
    function getApiData(url, send_data, callback) {
        $.ajax({
            type: "GET",
            data: send_data,
            url: url,
            ContentType: "json",
            crossDomain: true,
            xhrFields: {
                withCredentials: true
            },
            success: callback,
            error: function (xhr) {
                console.log(xhr.responseText);
            }
        });
    }
    // 원데이 HTML SET
    function setOneDayHTML(oneDay) {
        const one_day_area = document.getElementById('oneday');
        one_day_area.querySelector('.thumbnail > img').src = decodeBase64(oneDay.imageurl);
        one_day_area.querySelector('.headline').innerHTML = oneDay.titlename;
        one_day_area.querySelector('.subcopy').innerHTML = oneDay.subtitlename;
        one_day_area.querySelector('a').addEventListener('click', () => {
            const link_url = decodeBase64(oneDay.linkurl);
            if( link_url.indexOf('itemid=') > -1 ) { // 상품
                TnGotoProduct(link_url.split('itemid=')[1]);
            } else if( link_url.indexOf('eventid=') > -1 ) { // 이벤트
                if( is_app ) { // App 일 경우
                    const domain = is_develop ? 'testm.10x10.co.kr' : 'm.10x10.co.kr';
                    fnAPPpopupBrowserURL('기획전',`http://${domain}/apps/appCom/wish/web2014${link_url}`);
                    return false;
                } else { // Mobile Web 일 경우
                    location.href = link_url;
                }
            } else if( link_url.indexOf('disp=') > -1 ) { // 카테고리
                if( is_app ) { // App 일 경우
                    fnAPPpopupCategory(link_url.split('disp=')[1]);
                    return false;
                } else { // Mobile Web 일 경우
                    location.href = link_url;
                }
            } else if( link_url.indexOf('brandid=') > -1 ) {
                if( is_app ) {
                    fnAPPpopupBrand(link_url.split('brandid=')[1]);
                    return false;
                } else { // Mobile Web 일 경우
                    location.href = link_url;
                }
            }
        });
    }
    // 롤링배너 HTML SET
    function setRollingBannerHTML(banners) {
        let promise = new Promise((resolve, reject) => {
            const rolling_banner_area = document.getElementById('rolling_banner');
            let bannerHTML = '';

            banners.forEach(banner => {
                bannerHTML += createBannerHTML(is_app, banner.evt_code, decodeBase64(banner.bannerImage), banner.evt_name, banner.evt_subname, banner.salePer);
            });
            rolling_banner_area.querySelector('.swiper-wrapper').innerHTML = bannerHTML;

            resolve();
        });

        promise.then(doSwiper)
            .catch(cause => console.log(cause));
    }
    // 배너 HTML 생성
    function createBannerHTML(is_app, evtCode, imageUrl, evtName, evtSubName, disCount) {
        const domain = is_develop ? 'testm.10x10.co.kr' : 'm.10x10.co.kr';
        const linkUrl = '/event/eventmain.asp?eventid=' + evtCode;
        const link = is_app ? `onclick="fnAPPpopupBrowserURL('기획전','http://${domain}/apps/appCom/wish/web2014${linkUrl}');return false;"`
                        : `href="${linkUrl}"`;

        return `
            <div class="swiper-slide">
                <a ${link}>
                    <div class="thumbnail"><img src="${imageUrl}" alt=""></div>
                    <div class="desc">
                        <p class="headline">${evtName}</p>
                        <p class="subcopy">${evtSubName}</p>
                        <p class="discount">${disCount > 0 ? '~'+disCount+'%' : ''}</p>
                    </div>
                </a>
            </div>
        `;
    }
    // 디코딩
    function decodeBase64(str) {
        if( str == null ) return null;
        return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
    }

    // 슬라이드
    function doSwiper() {
        // 롤링배너
        var evtSlider = $('.stationery-fair .evt-slider');
        var swiper = evtSlider.find('.swiper-container');
        var amt = swiper.find('.swiper-slide').length;
        var progress = evtSlider.find('.pagination-progressbar-fill');
        if (amt > 1) {
                var evtSwiper = new Swiper(swiper, {
                    autoplay: 3000,
                    loop: true,
                    speed: 700,
                    autoplayDisableOnInteraction: false,
                    onInit: function(evtSwiper) {
                        var init = (1 / amt).toFixed(2);
                        progress.css('transform', 'scaleX(' + init + ')');
                    },
                    onSlideChangeStart: function(evtSwiper) {
                        var activeIndex = evtSwiper.activeIndex;
                        var realIndex = parseInt(evtSwiper.slides.eq(activeIndex).attr('data-swiper-slide-index') || activeIndex, 10);
                        var calc = ( (realIndex+1) / amt ).toFixed(2);
                        progress.css('transform', 'scaleX(' + calc + ')');
                    }
                });
        } else {
            var evtSwiper = new Swiper(swiper, {
                noSwiping: true
            });
            evtSlider.find('.pagination-progressbar').hide();
        }
    }
</script>