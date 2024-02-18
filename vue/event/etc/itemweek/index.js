const app = new Vue({
    el: '#app',
    template: `
      <div class="item_week">
        <section class="section01">
          <img :src="commonImagePath + 'bg_main.jpg' + imgVer" alt="">
        </section>
        
        <!-- 푸시 리스트 -->
        <section class="section02">
          <div class="push_wrap" v-for="(push,index) in pushList">
            <img :src="commonImagePath + 'week0'+ (index+1) +'.jpg' + imgVer" alt="">
            <div class="push-dim"></div>
            <button :class="['event-btn', currentDate < push.openDate ? '' : 'end']" v-if="currentDate < push.closeDate" @click="regPush(push)"></button>
          </div>
        </section>
        
        <section class="section03">
          <img :src="commonImagePath + 'bg_sub.jpg' + imgVer" alt="">
        </section>
        
        <!-- 타임 특가 -->
        <section class="section04 time_sale">
          <div :class="'main_time todayTimeDeal'+todayTimeDeal.itemid" v-if="todayTimeDeal">
            <article class="prd_item">
              <div class="prd_date">
                <p class="date">오늘의 타임특가<span><b>{{getTimeDealDate(currentDate,'.')}}</b> {{getDayOfWeek(currentDate)}}</span></p>
                <p class="time" id="countdown"></p>
              </div>
              <figure class="thumbnail">
                <img src="http://fiximage.10x10.co.kr/web2017/my10x10/bnr_offline.png" alt="상품명">
                <span class="prd_mask"></span>                
              </figure>
              <div class="prd_info">
                <div class="prd_name name"></div>
				<div class="prd_price price"><s>39,000</s> 33,000<span>30%</span></div>
              </div>
            </article>
            <a href="javascript:void(0)" class="prd_link" @click="prdDetailPage(todayTimeDeal.itemid)">바로 구매하기</a>
          </div>
          
          <!-- 타입 특가 예정/종료 상품 -->
          <div class="sub_time">
            <div class="swiper-container">
              <div class="swiper-wrapper">
                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115376/preview.png" alt="" /></div>
                 <div class="swiper-slide" v-for="item in timeDealItems">
                  <a href="javascript:void(0)" :class="['layer', item.openDate < currentDate ? 'close timeDealList'+item.itemid : 'open timeDealList'+item.itemid]" @click="itemDetailPopup(item.itemid,item.openDate)">
                    <figure class="thumbnail">
                      <img src="http://fiximage.10x10.co.kr/web2017/my10x10/bnr_offline.png" alt="">
                      <div class="mask"></div>
                    </figure>
                    <p class="time_date"><span>{{getTimeDealDate(item.openDate,'.')}}</span>{{item.openDate < currentDate ? '종료' : getDayOfWeek(item.openDate)}}</p>
                    <p class="more"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115376/more.png" alt=""></p>
                  </a>
                </div>
              </div>
            </div>
          </div>
        </section>
        
        <!-- 상품 리스트 -->
        <section class="section05">
          <template v-for="(item,index) in conceptItems">
              <div :class="'item0' + (index+1)">
                <div class="main">
                  <img :src="commonImagePath + 'main_item0' + (index+1) + '.jpg' + imgVer" alt="">
                  <div class="hashtag">                
                    <p class="hash" v-for="hashtag in item.hashtag"><a href="javascript:void(0)" @click="move_search_page(hashtag,'product')">#<span>{{hashtag}}</span></a></p>
                  </div>
                  <a href="javascript:void(0)" @click="prdDetailPage(item.mainItemId)" class="purchase"></a>
                </div>
                <template v-for="(sub,index2) in item.subItems">
                    <a href="javascript:void(0)"  @click="prdDetailPage(sub)">
                      <img :src="commonImagePath + 'sub_item0'+ (index+1) + '_0' + (index2+1) + '.jpg' + imgVer" alt="">
                    </a>
                </template>
              </div>                          
          </template>
        </section>
        
        <!-- 하단 이미지 -->
        <section class="section05">
          <img :src="footerImg != '' ? footerImg + imgVer : commonImagePath + 'bg_coupon.jpg' + imgVer" alt="">
        </section>
             
        <!-- 푸시 완료 팝업 -->
        <div class="pop-container">
            <div class="pop-inner">
                <div class="pop-contents">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114981/m/bg_popup.png" alt="포인트로 스티커 사러 가자">
                    <button type="button" class="btn-close" @click="pushPopup('close')">닫기</button>
                    <button type="button" class="btn-push" @click="popupSetting()">푸쉬 설정 확인하기</button>
                </div>
            </div>
        </div>             
      </div>
    `,
    data: function () {
        return {
            eventCode: eCode,
            currentDate: this.getToday(),
            pushList: event_data.push_list,
            timeDealItems : event_data.time_deal_items,
            conceptItems : event_data.concept_items,
            commonImagePath : event_data.image_path.replaceAll('{eventCode}',eCode),
            footerImg : event_data.footer_img,
            todayTimeDeal: {},
            itemDetail: {},
            dealItemDetails: [],
            imgVer: event_data.img_ver,
            isApp: isApp
        }
    },
    created() {
        // 타임딜 세팅
        this.todayTimeDeal = this.timeDealItems.find(v => v.openDate == this.currentDate);
        if(this.todayTimeDeal){
            this.setTodayTimeDeal();
        }
        this.setSubTimeDeal();
    },
    mounted() {
        // CSS 배경 이미지 변경
        $('.item_week section .push_wrap .event-btn').css({'background':'url('+this.commonImagePath+'btn_start.png'+this.imgVer+')no-repeat 0 0','background-size':'100%'});
        $('.item_week section .push_wrap .event-btn.end').css({'background':'url('+this.commonImagePath+'btn_end.png'+this.imgVer+')no-repeat 0 0','background-size':'100%'});
    },
    methods : {
        /**
         * 푸쉬 설정 확인하기
         */
        popupSetting(){
            if(isApp){
                fnAPPpopupSetting();
            }
        },
        /**
         * 상품상세 페이지 이동
         * @param itemid
         */
        prdDetailPage(itemid){
            if(isApp) {
                fnAPPpopupProduct(itemid+'&pEtr='+this.eventCode);
            } else {
                location.href = "/category/category_itemPrd.asp?itemid=" + itemid + "&petr="+this.eventCode;
            }
        },
        /**
         * 오픈된 타임특가 세팅
         */
        setTodayTimeDeal(){
            let itemid =  this.todayTimeDeal.itemid;
            let url = '/item-week/deal/'+itemid+'/price';
            let method = 'GET';
            getFrontApiData(method, url, '',
                data => {
                    let fields = ["image", "name", "price", "sale"];
                    if(data.dealitemid){
                        fields = ["image", "name"];
                        let orgPrice = this.number_format(data.orgPrice);
                        let sellCash = this.number_format(data.sellCash);
                        $('.prd_price').html('<s>~'+orgPrice+'원</s> '+sellCash+'원~<span>~'+data.discountRate+'%</span>');
                    }
                    this.setItemInfo('todayTimeDeal', itemid, fields);
                    this.setCountDown();
                },
                xhr => {
                    const error = JSON.parse(xhr.responseText);
                    if (xhr.status == 400){
                        alert(error.message);
                    } else {
                        alert('서버에 오류가 발생하였습니다.');
                    }
                }
            );
        },
        /**
         * 오픈 예정 타임특가 세팅
         */
        setSubTimeDeal(){
            let items = this.timeDealItems.map(v => v.itemid);
            if(items){
                this.setItemInfo('timeDealList', items, ["image"]);
            }
        },
        /**
         * 상품 정보 연동
         * @param target
         * @param items
         * @param fields
         */
        setItemInfo(target, items, fields){
            fnApplyItemInfoEach({
                items: items,
                target: target,
                fields:fields,
                unit:"none",
                saleBracket:false
            });
        },
        /**
         * 타임세일 상품 상세 팝업
         * @param itemId
         * @param openDate
         */
        itemDetailPopup(itemId, openDate){
            if(openDate < this.currentDate) {
                return;
            }
            let param = '?itemid='+itemId+'&openDate='+openDate;
            if (isApp) {
                let title = openDate.substr(4,2) +'/' + openDate.substr(6,2) + ' ' + this.getDayOfWeek(openDate) + ' 제품 미리보기';
                let appUrl = location.origin+'/apps/appCom/wish/web2014/event/etc/itemweek/item_detail.asp'+ param;
                fnAPPpopupBrowser(OpenType.FROM_BOTTOM, [], title, [], appUrl);
            } else {
                let webUrl = '/event/etc/itemweek/item_detail.asp'+ param;
                window.open(webUrl);
            }
        },
        /**
         * 특정날짜 요일 구하기
         * @param date
         * @returns {string}
         */
        getDayOfWeek(date) {
            let yyyy = date.substr(0, 4);
            let mm = date.substr(4, 2);
            let dd = date.substr(6, 2);
            let week_array = new Array('일', '월', '화', '수', '목', '금', '토');
            let today_num = new Date(yyyy + '-' + mm + '-' + dd).getDay();
            return week_array[today_num] + '요일';
        },
        /**
         * 타임딜 날짜 mm.dd 형태로 반환
         * @param date
         * @param separator
         * @returns {*}
         */
        getTimeDealDate(date, separator) {
            let mm = date.substr(4, 2);
            let dd = date.substr(6, 2);
            mm = mm.indexOf(0) == 0 ? mm.substr(1, 1) : mm;
            dd = dd.indexOf(0) == 0 ? dd.substr(1, 1) : dd;
            return mm + separator + dd;
        },
        /**
         * 타임딜 카운트 다운 세팅
         */
        setCountDown() {
            let openDate = this.todayTimeDeal.openDate;
            countDownTimer(openDate.substr(0, 4)
                , openDate.substr(4, 2)
                , openDate.substr(6, 2)
                , 23
                , 59
                , 59
                , new Date()
            );
        },
        /**
         * 푸시 발송 내용 반환
         * @param pushData
         * @returns {{pushTitle: string, closePushContent: string, openPushContent: string}}
         */
        getPushContent(pushData) {
            let eventName = pushData.eventName;
            let closeDay = this.getTimeDealDate(pushData.closeDate, '/');
            let openDay = pushData.openDate.substr(6, 2);
            openDay = openDay.indexOf(0) == 0 ? openDay.substr(1, 1) : openDay;
            return {
                pushTitle : '신청하신 [' + eventName + '] 이벤트 알림입니다.',
                openPushContent : openDay+'일 자정부터 ' + eventName + ' 위크가 시작됩니다. 딱 일주일 특별한 할인 놓치지 마세요!',
                closePushContent : eventName + ' 위크 (~ ' +closeDay+ ')가 곧 종료됩니다. 더 이상 고민하지 말고 서두르세요!'
            }
        },
        /**
         * 푸시 저장
         * @param pushData
         */
        regPush(pushData) {
            if(!isApp){
                if(confirm('알림 신청은 APP에서만 가능해요!\nAPP에서 신청하시겠어요?')){
                    go_app();
                }
                return;
            }
            let pushContent = this.getPushContent(pushData);
            let data = {
                'evtCode': pushData.eventCode,
                'sendDate': this.currentDate < pushData.openDate ? pushData.openDate : pushData.closeDate,
                'pushTitle': pushContent.pushTitle,
                'pushContent': this.currentDate < pushData.openDate ? pushContent.openPushContent : pushContent.closePushContent,
            };
            let url = '/item-week/push';
            let method = 'POST';
            getFrontApiData(method, url, data,
                data => {
                    // 푸시 완료 팝업 오픈
                    this.pushPopup('open');
                },
                xhr => {
                    const error = JSON.parse(xhr.responseText);
                    if( error.code === -10 ) {
                        this.callLoginPage();
                    } else if (xhr.status == 400){
                        alert(error.message);
                    } else {
                        alert('서버에 오류가 발생하였습니다.');
                    }
                }
            );
        },
        /**
         * 로그인 페이지 이동
         */
        callLoginPage() {
            if (isApp && isApp != '0') {
                calllogin();
            } else {
                let url = '/login/login.asp';
                let param = '?backpath=' + location.pathname + location.search;
                location.href = url + param;
            }
        },
        /**
         * 푸시 완료 팝업 오픈/종료
         * @param type
         */
        pushPopup(type) {
            type == 'open' ? $('.pop-container').fadeIn() : $('.pop-container').fadeOut();
        },
        /**
         * 오늘 날짜 조회
         * @returns {string}
         */
        getToday() {
            let date = new Date();
            let year = date.getFullYear();
            let month = ("0" + (1 + date.getMonth())).slice(-2);
            let day = ("0" + date.getDate()).slice(-2);
            return year + month + day;
        },
        /**
         * 엔터 치환
         * @param text
         * @returns {*}
         */
        change_nr(text) {
            if (text){
                return text.replaceAll("\n", "<br />");
            }
        }
    }
});