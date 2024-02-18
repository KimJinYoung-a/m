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
                <li class="upcom"><a @click="go_other_tab('upcoming.asp','판매예정')" href="javascript:void(0)">판매예정</a></li>
                <li><a @click="go_other_tab('main.asp','판매중')" href="javascript:void(0)">판매중</a></li>
                <li class="active"><a href="#">판매완료</a></li>
            </ul> 

            <!-- 품절상품 없을때 -->            
            <No-Data v-if="soldout_items.length < 1"
                     :type="'soldout'"
            ></No-Data>
              
            <!-- 상품 리스트 -->
            <section class="section01 section" v-for="(item,index) in soldout_items">
                <Main-Item-List
                    :item="item"
                    :index="index"              
                    :itemSize="soldout_items.length"                        
                ></Main-Item-List>
            </section>
            
            <div id="modalLayer" style="display:none;"></div>       
        </div><!-- // content -->
    `
    , created() {
        this.$store.dispatch('GET_TOP_BANNER');
        this.$store.dispatch('GET_SOLDOUT_ITEMS');
    }
    , computed : {
        top_banner() { // 상단 배너
            return this.$store.getters.top_banner;
        },
        soldout_items() { // 종료 상품
            return this.$store.getters.soldout_items;
        }
    }
    , methods : {
        go_other_tab(path, type){
            // Amplitude
            fnAmplitudeEventMultiPropertiesAction("click_exclusive_tab", "type", type);
            this.go_other(path);
        },
        go_other(path){
            location.href = path + location.search;
        }
    }
});