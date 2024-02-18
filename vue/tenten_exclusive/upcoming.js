const app = new Vue({
    el: '#app'
    , store : store
    , mixin : [common_mixin]
    , template : `
        <div id="content" class="content ten_only">
            <div class="main">
                <img :src="top_banner" alt="텐텐 메인 이미지 가상">
            </div>
            <ul class="tab">
                <li class="active upcom"><a href="javascript:void(0)">판매예정</a></li>
                <li><a @click="go_other_tab('main.asp','판매중')" href="javascript:void(0)">판매중</a></li>
                <li><a @click="go_other_tab('soldout.asp','판매완료')" href="javascript:void(0)">판매완료</a></li>
            </ul>
            
            <!-- 품절상품 없을때 -->            
            <No-Data v-if="wait_items.length < 1"
                     :type="'upcoming'"
            ></No-Data>
            
            <div class="up_list">       
                <article class="upcoming" v-for="(item,index) in wait_items">
                    <figure class="prd_img">
                        <img :src="item.itemImg" alt="상품명">
                        <p class="open_alert"><span>{{ item.openDate }}</span>에 오픈해요</p>
                    </figure>
                    <div class="prd_info">
                        <div class="prd_name">{{ item.itemname }}</div>
                        <div class="prd_price">
                            <s class="o_price" v-if="item.discount > 0">{{ number_format(item.orgprice) }}</s>
                            <span class="set_price">{{ number_format(item.sellcash) }}<i>원</i></span>
                            <span class="discount" v-if="item.discount > 0">{{ item.discount }}%</span>
                        </div>
                    </div>
                    <p class="prd_want" v-if="item.pushRegCnt >= 20"><span>{{ item.pushRegCnt }}</span>명이 이 상품을 기대하는 중</p>
                    <a class="push start" v-if="item.pushYn == 'N'" @click="click_push(index)">오픈되면 알림받기</a>
                    <a class="push end"  v-if="item.pushYn == 'Y'">알림받기 완료</a>
                </article>
            </div>
        </div><!-- // content -->
    `
    , created() {
        this.$store.dispatch('GET_TOP_BANNER');
        this.$store.dispatch('GET_WAIT_ITEMS');
    }
    , mounted(){

    }
    , computed : {
        top_banner() { // 상단 배너
            return this.$store.getters.top_banner;
        },
        wait_items() { // 상품정보
            return this.$store.getters.wait_items;
        }
    }
    , methods : {
        click_push : function (index){
            // 푸시 로그 저장
            let exclusiveIdx = this.$store.getters.wait_items[index].exclusiveIdx;
            if(this.call_push_api(exclusiveIdx)){
                this.$store.getters.wait_items[index].pushYn = 'Y';
                alert('알림 신청이 완료되었어요.\n 마이페이지에서 PUSH 수신여부를 확인해주세요.');
            }
        }
        , call_push_api : function (exclusiveIdx) {
            let request = {
                exclusiveIdx : exclusiveIdx
            };

            if(!isApp){
                if(confirm('알림 신청은 APP에서만 가능해요!\nAPP에서 신청하시겠어요?')){
                    go_app();
                }
                return;
            }

            let result = false;
            $.ajax({
                type : 'POST',
                url: apiurl + '/tenten-exclusive-real/push',
                data: request,
                ContentType : "json",
                crossDomain: true,
                async: false,
                xhrFields: {
                    withCredentials: true
                }
                , success: function(data) {
                    result = true;
                    // _this.send_amplitude(method === 'post' ? 'on' : 'off');
                }
                , error: function (xhr) {
                    console.log(xhr);
                    const error = JSON.parse(xhr.responseText);
                    if( error.code === -10 ) {
                        if( isApp && isApp != '0' ) {
                            calllogin();
                            return false;
                        } else {
                            location.href = '/login/login.asp?backpath=' + location.pathname + location.search;
                        }
                    }
                }
            });
            return result;
        },
        go_other_tab(path, type){
            // Amplitude
            fnAmplitudeEventMultiPropertiesAction("click_exclusive_tab", "type", type);
            this.go_other(path);
        },
        go_other(path){
            location.href = path + location.search;
        }
    }
    , watch : {
    }
});