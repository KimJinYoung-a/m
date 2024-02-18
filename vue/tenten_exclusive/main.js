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
                <li class="active"><a href="javascript:void(0)">판매중</a></li>
                <li><a @click="go_other_tab('soldout.asp','판매완료')" href="javascript:void(0)">판매완료</a></li>
            </ul>    
            
            <Main-Item-List v-for="(item,index) in open_items"
                :item="item"
                :index="index"       
                :itemSize="open_items.length"       
            ></Main-Item-List>
                
            <Item-Footer></Item-Footer>                                
        <div id="modalLayer" style="display:none;"></div>            
        </div><!-- // content -->
    `
    , created() {
        this.$store.dispatch('GET_TOP_BANNER');
        this.$store.dispatch('GET_OPEN_ITEMS');
        // Amplitude
        fnAmplitudeEventMultiPropertiesAction("view_exclusive_main", "", "");
    }
    , computed : {
        top_banner() { // 상단 배너
            return this.$store.getters.top_banner;
        },
        open_items() { // 오픈된 상품
            return this.$store.getters.open_items;
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