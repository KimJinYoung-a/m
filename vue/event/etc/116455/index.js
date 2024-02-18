const app = new Vue({
    el: '#app',
    template: `
      <div class="mEvt116455">
       <section class="section01">
           <img src="//webimage.10x10.co.kr/fixevent/event/2022/116455/m/section01.jpg" alt="">
           <p class="float01"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116455/m/float01.png" alt=""></p>
           <p class="float02"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116455/m/float02.png" alt=""></p>
       </section>
        <!-- 타임 특가 -->
        <section class="section02 time_sale">
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
                <template v-for="item in timeDealItems">
                     <div class="swiper-slide" :id="item.openDate">
                      <a href="javascript:void(0)" :class="['layer', item.openDate < currentDate ? 'close timeDealList'+item.itemid : 'open timeDealList'+item.itemid]" @click="itemDetailPopup(item.itemid,item.openDate)">
                        <figure class="thumbnail">
                          <img src="http://fiximage.10x10.co.kr/web2017/my10x10/bnr_offline.png" alt="">
                          <div class="mask"></div>
                        </figure>
                        <p class="time_date"><span>{{getTimeDealDate(item.openDate,'.')}}</span>{{item.openDate < currentDate ? '종료' : item.brandName}}</p>
                        <p class="more"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115376/more.png" alt=""></p>
                      </a>
                    </div>                
                </template>
              </div>
            </div>
          </div>
        </section>                
       <section class="section03">
           <img src="//webimage.10x10.co.kr/fixevent/event/2022/116455/m/section02.jpg" alt="">
           <a href="/category/category_itemprd.asp?itemid=4378552"  onclick="fnAPPpopupProduct('4378552&pEtr=116455'); return false;" class="prd_code"></a>
           <div class="prd_area">
                <ul>
                    <li class="item3852438"><!-- target의 접두어 및 상품코드 지정 -->
                        <a href="/category/category_itemprd.asp?itemid=3852438" onclick="fnAPPpopupProduct('3852438&pEtr=116455'); return false" >
                            <div class="thumbnail">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2022/116455/m/prd01_01.png" alt="상품명" />
                            </div>
                            <div class="desc">
                                <div class="brand">PEANUTS</div>
                                <div class="name">여기 상품명 컬러<br>바꿔보자</div>
                                <div class="price"><s>12,000</s> <span>10%</span>8,000</div>
                            </div>
                        </a>
                    </li>
                    <li class="item3725065"><!-- target의 접두어 및 상품코드 지정 -->
                        <a href="/category/category_itemprd.asp?itemid=3725065" onclick="fnAPPpopupProduct('3725065&pEtr=116455'); return false">
                            <div class="thumbnail">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2022/116455/m/prd01_02.png" alt="상품명" />
                            </div>
                            <div class="desc">
                                <div class="brand">브랜드명</div>
                                <div class="name">상품명</div>
                                <div class="price"><s>12,000</s> <span>10%</span>8,000</div>
                            </div>
                        </a>
                    </li>
                    <li class="item4123554"><!-- target의 접두어 및 상품코드 지정 -->
                        <a href="/category/category_itemprd.asp?itemid=4123554" onclick="fnAPPpopupProduct('4123554&pEtr=116455'); return false">
                            <div class="thumbnail">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2022/116455/m/prd01_03.png" alt="상품명" />
                            </div>
                            <div class="desc">
                                <div class="brand">브랜드명</div>
                                <div class="name">상품명</div>
                                <div class="price"><s>12,000</s> <span>10%</span>8,000</div>
                            </div>
                        </a>
                    </li>
                    <li class="item4359214"><!-- target의 접두어 및 상품코드 지정 -->
                        <a href="/category/category_itemprd.asp?itemid=4359214" onclick="fnAPPpopupProduct('4359214&pEtr=116455'); return false">
                            <div class="thumbnail">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2022/116455/m/prd01_04.png" alt="상품명" />
                            </div>
                            <div class="desc">
                                <div class="brand">PEANUTS</div>
                                <div class="name">여기 상품명 컬러 바꿔보자</div>
                                <div class="price"><s>12,000</s> <span>10%</span>8,000</div>
                            </div>
                        </a>
                    </li>
                </ul>
           </div>
           <a href="#group393160" class="btn_go"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116455/m/btn01.png" alt=""></a>
       </section>
       <section class="section04">
            <img src="//webimage.10x10.co.kr/fixevent/event/2022/116455/m/section03.jpg" alt="">
            <a href="/category/category_itemprd.asp?itemid=3903293"  onclick="fnAPPpopupProduct('3903293&pEtr=116455'); return false;" class="prd_code"></a>
            <div class="prd_area">
                <ul>
                    <li class="item4291977"><!-- target의 접두어 및 상품코드 지정 -->
                        <a href="/category/category_itemprd.asp?itemid=4291977" onclick="fnAPPpopupProduct('4291977&pEtr=116455'); return false">
                            <div class="thumbnail">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2022/116455/m/prd02_01.png" alt="상품명" />
                            </div>
                            <div class="desc">
                                <div class="brand">PEANUTS</div>
                                <div class="name">여기 상품명 컬러 바꿔보자</div>
                                <div class="price"><s>12,000</s> <span>10%</span>8,000</div>
                            </div>
                        </a>
                    </li>
                    <li class="item3332369"><!-- target의 접두어 및 상품코드 지정 -->
                        <a href="/category/category_itemprd.asp?itemid=3332369" onclick="fnAPPpopupProduct('3332369&pEtr=116455'); return false">
                            <div class="thumbnail">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2022/116455/m/prd02_02.png" alt="상품명" />
                            </div>
                            <div class="desc">
                                <div class="brand">PEANUTS</div>
                                <div class="name">여기 상품명 컬러<br>바꿔보자</div>
                                <div class="price"><s>12,000</s> <span>10%</span>8,000</div>
                            </div>
                        </a>
                    </li>
                    <li class="item4338279"><!-- target의 접두어 및 상품코드 지정 -->
                        <a href="/category/category_itemprd.asp?itemid=4338279" onclick="fnAPPpopupProduct('4338279&pEtr=116455'); return false">
                            <div class="thumbnail">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2022/116455/m/prd02_03.png" alt="상품명" />
                            </div>
                            <div class="desc">
                                <div class="brand">브랜드명</div>
                                <div class="name">상품명</div>
                                <div class="price"><s>12,000</s> <span>10%</span>8,000</div>
                            </div>
                        </a>
                    </li>
                    <li class="item4150009"><!-- target의 접두어 및 상품코드 지정 -->
                        <a href="/category/category_itemprd.asp?itemid=4150009" onclick="fnAPPpopupProduct('4150009&pEtr=116455'); return false">
                            <div class="thumbnail">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2022/116455/m/prd02_04.png" alt="상품명" />
                            </div>
                            <div class="desc">
                                <div class="brand">브랜드명</div>
                                <div class="name">상품명</div>
                                <div class="price"><s>12,000</s> <span>10%</span>8,000</div>
                            </div>
                        </a>
                    </li>
                </ul>
            </div>
            <a href="#group393162" class="btn_go"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116455/m/btn02.png" alt=""></a>
       </section>
       <section class="section05">
            <img src="//webimage.10x10.co.kr/fixevent/event/2022/116455/m/section04.jpg" alt="">
            <a href="/category/category_itemprd.asp?itemid=4337960"  onclick="fnAPPpopupProduct('4337960&pEtr=116455'); return false;" class="prd_code"></a>
            <div class="prd_area">
                <ul>
                    <li class="item3436295"><!-- target의 접두어 및 상품코드 지정 -->
                        <a href="/category/category_itemprd.asp?itemid=3436295" onclick="fnAPPpopupProduct('3436295&pEtr=116455'); return false">
                            <div class="thumbnail">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2022/116455/m/prd03_01.png" alt="상품명" />
                            </div>
                            <div class="desc">
                                <div class="brand">PEANUTS</div>
                                <div class="name">여기 상품명 컬러 바꿔보자</div>
                                <div class="price"><s>12,000</s> <span>10%</span>8,000</div>
                            </div>
                        </a>
                    </li>
                    <li class="item4364402"><!-- target의 접두어 및 상품코드 지정 -->
                        <a href="/category/category_itemprd.asp?itemid=4364402" onclick="fnAPPpopupProduct('4364402&pEtr=116455'); return false">
                            <div class="thumbnail">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2022/116455/m/prd03_02.png" alt="상품명" />
                            </div>
                            <div class="desc">
                                <div class="brand">PEANUTS</div>
                                <div class="name">여기 상품명 컬러<br>바꿔보자</div>
                                <div class="price"><s>12,000</s> <span>10%</span>8,000</div>
                            </div>
                        </a>
                    </li>
                    <li class="item4344130"><!-- target의 접두어 및 상품코드 지정 -->
                        <a href="/category/category_itemprd.asp?itemid=4344130" onclick="fnAPPpopupProduct('4344130&pEtr=116455'); return false">
                            <div class="thumbnail">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2022/116455/m/prd03_03.png" alt="상품명" />
                            </div>
                            <div class="desc">
                                <div class="brand">브랜드명</div>
                                <div class="name">상품명</div>
                                <div class="price"><s>12,000</s> <span>10%</span>8,000</div>
                            </div>
                        </a>
                    </li>
                    <li class="item3811442"><!-- target의 접두어 및 상품코드 지정 -->
                        <a href="/category/category_itemprd.asp?itemid=3811442" onclick="fnAPPpopupProduct('3811442&pEtr=116455'); return false">
                            <div class="thumbnail">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2022/116455/m/prd03_04.png" alt="상품명" />
                            </div>
                            <div class="desc">
                                <div class="brand">브랜드명</div>
                                <div class="name">상품명</div>
                                <div class="price"><s>12,000</s> <span>10%</span>8,000</div>
                            </div>
                        </a>
                    </li>
                </ul>
            </div>
            <a href="#group393163" class="btn_go"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116455/m/btn03.png" alt=""></a>
       </section>
       <section class="section06">
           <img src="//webimage.10x10.co.kr/fixevent/event/2022/116455/m/section05.jpg" alt="">
           <a href="/category/category_itemprd.asp?itemid=4193426" onclick="fnAPPpopupProduct('4193426&pEtr=116455'); return false" class="prd_code"></a>
           <a href="#group393164" class="btn_go"></a>
       </section>                   
      </div>      
    `,
    data: function () {
        return {
            eventCode: eCode,
            currentDate: this.getToday(),
            timeDealItems : [
                {itemid: '4379521', openDate: '20220124', brandName: 'iconic'},
                {itemid: '4379626', openDate: '20220125', brandName: 'PPOMPPOM STUDIO'},
                {itemid: '4379520', openDate: '20220126', brandName: '7321 Design'},
                {itemid: '4379512', openDate: '20220127', brandName: 'Wannathis'},
                {itemid: '4379509', openDate: '20220128', brandName: 'JellyCrew'},
                {itemid: '4379485', openDate: '20220129', brandName: 'heeheeclub'},
                {itemid: '4388967', openDate: '20220130', brandName: 'LIVEWORK'}
            ],
            groupItems : [
                {items: '3852438,3725065,4123554,4359214'},
                {items: '4291977,3332369,4338279,4150009'},
                {items: '3436295,4364402,4344130,3811442'},
            ],
            todayTimeDeal: {},
            isApp: isApp,
            isDevelop: isDevelop,
            isStaging: isStaging
        }
    },
    created() {

        // 타임딜 세팅
        this.todayTimeDeal = this.timeDealItems.find(v => v.openDate == this.currentDate);
        if(this.todayTimeDeal){
            this.setTodayTimeDeal();
        }
        this.setSubTimeDeal();

        this.groupItems.forEach(v => {
            fnApplyItemInfoEach({
                items:v.items,      // 상품코드
                target:"item",
                fields:["brand","name","price","sale"],
                unit:"hw"
            });
        });
    },
    methods : {
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
                let appUrl = location.origin+'/apps/appCom/wish/web2014/event/etc/116455/item_detail.asp'+ param;
                fnAPPpopupBrowser(OpenType.FROM_BOTTOM, [], title, [], appUrl);
            } else {
                let webUrl = '/event/etc/116455/item_detail.asp'+ param;
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
         * 오늘 날짜 조회
         * @returns {string}
         */
        getToday() {
            let date = new Date();
            let year = date.getFullYear();
            let month = ("0" + (1 + date.getMonth())).slice(-2);
            let day = ("0" + date.getDate()).slice(-2);
            return year + month + day;
        }
    }
});