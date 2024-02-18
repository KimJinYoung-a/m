Vue.component('Main-Item-List',{
    template : `
        <section :class="['section01 section ', {soldout : item.sellyn != 'Y'}, {'no-margin' : itemSize == (index+1)}]">
            <div :class="['sub_main ', {prd_img : item.sellyn != 'Y'}]">
                <img :src="item.itemImg" alt="" @click="click_detail('click_exclusive_product')">
                <span class="prd_mask" v-if="item.sellyn != 'Y'"></span>
                <p class="watch" v-if="item.viewCount >= 50 && item.sellyn =='Y'"><span>{{ number_format(item.viewCount) }}</span>명이 보고 있어요</p>
                <p class="watch" v-if="item.itemCount <= 20 && item.sellyn =='Y' && item.limityn =='Y'"><span>{{ item.itemCount }}</span>개 남았어요</p>
                <p class="wish" :class="{on: item.wishYn == 'Y'}" @click="click_wish(index)"><span>{{ number_format(item.favcount) }}</span></p>
            </div>
            <!-- 추가 -->
            <div class="go_buy" v-if="item.sellyn == 'Y'" @click="click_prd_detail()">
                <div class="pro_img">
                    <img :src="decodeBase64(item.basicimage)" alt="">
                </div>
                <div class="price">
                    <div class="prd_price">
                        <span class="set_price">{{ number_format(item.sellcash) }}</span>
                        <span class="discount" v-if="item.discount >0 && item.couponDiscountYn != 'Y' && item.doubleDiscountYn != 'Y'">{{ item.discount }}%</span>
                        <span class="discount" v-if="item.discount >0 && item.couponDiscountYn == 'Y' && item.doubleDiscountYn != 'Y'">{{ item.discount }}% 쿠폰</span>
                        <span class="discount" v-if="item.doubleDiscountYn == 'Y'">더블할인</span>
                    </div>
                    <div class="prd_name">{{ item.itemname }}</div>
                </div>
            </div>
            <div class="line"></div>     
            <!-- 추가 -->            
            <div class="sub_padding">
                <h1 @click="click_detail('click_exclusive_product')"><pre>{{ item.headTitle }}</pre></h1>
                <pre @click="click_detail('click_exclusive_product')" class="sub_copy">{{ item.headContents }}</pre>
                <div class="more">
                    <div class="chat">
                        <p class="brand" v-bind:style="{\'background-image\': \'url(\'+ item.tootipNicknameImg +\')\'}" style="background-size: 8vw; background-repeat: no-repeat;background-position:0 0;">{{ item.tootipNickname }}</p>
                        <pre class="chat_brand">{{ item.tootipNickname }}</pre>
                    </div>
                    <div class="gra_zone">
                        <a class="go_more" @click="click_detail('click_exclusive_more')">더 많은 이야기가 궁금하다면?</a>            
                    </div>                 
                </div>
                <div class="sub_event">
                    <!-- <div class="event">
                        <p class="icon">EVENT</p>
                        <div>
                            <p class="event_info">
                                프루아의 질문에 답해주신 분들 중<br>추첨을 통해 shell card holder를<br>선물로 드립니다!
                            </p>
                        </div>
                        <a href="" class="go_shop">
                            상품 보러가기<span class="icon"></span>
                        </a>
                    </div> -->
                    <Vote
                        :exclusiveIdx="item.exclusiveIdx"
                        :index="index"      
                    >
                   </Vote>
                </div>
            </div>         
        </section>        
    `,
    props : {
        item : {}, // 상품정보
        index : {type:Number, default:0},
        itemSize : {type:Number, default:0}
    },
    methods : {
        click_prd_detail() {
            fnAmplitudeEventAction(this.amplitudeActionName+'item','itemid',this.item.itemid);
            if( isApp ) {
                fnAPPpopupBrowserURL('',location.origin + "/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid="+this.item.itemid,'right','','sc');
            } else {
                location.href = "/category/category_itemPrd.asp?itemid=" + this.item.itemid + "&flag=e";
            }
        }
        ,click_detail(event) {
            // Amplitude
            fnAmplitudeEventMultiPropertiesAction(event, 'item_id', "'"+this.item.itemid+"'");
            if( isApp ){
                fnAPPpopupBrowserURL('',location.origin + '/apps/appCom/wish/web2014/tenten_exclusive/item_detail.asp?gnbflag=1&exclusive_idx='+this.item.exclusiveIdx,'right','','sc');
            } else {
                location.href = '/tenten_exclusive/item_detail.asp?exclusive_idx='+this.item.exclusiveIdx;
            }
        }
        ,click_wish (index) {
            // 위시 처리
            const items = this.item.sellyn == 'Y' ? this.$store.getters.open_items[index] : this.$store.getters.soldout_items[index];
            if( this.item.wishYn == 'Y' ) {
                // 위시 제거
                if( this.call_wish_api('delete', this.item.itemid) ) {
                    items.favcount--;
                    items.wishYn = 'N';
                }
            } else {
                // 위시 등록
                if( this.call_wish_api('post', this.item.itemid) ) {
                    items.favcount++;
                    items.wishYn = 'Y';
                }
            }
        }
        , call_wish_api(method, itemId) {
            const _this = this;
            let _url = apiurl + '/wish/item';
            let request = {
                method : method,
                item_id : itemId
            };

            let result = false;
            $.ajax({
                type : 'POST',
                url: _url,
                data: request,
                ContentType : "json",
                crossDomain: true,
                async: false,
                xhrFields: {
                    withCredentials: true
                }
                , success: function(data) {
                    result = true;
                    // Amplitude
                    fnAmplitudeEventMultiPropertiesAction('click_exclusive_wish', 'item_id', "'"+_this.item.itemid+"'");
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
        }
        , decodeBase64(str) {
            if( str == null ) return null;
            return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
        }
    }
})