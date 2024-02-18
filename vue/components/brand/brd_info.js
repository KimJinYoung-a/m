Vue.component('Brand-Info',{
    template : `
            <!-- 브랜드 리스트 -->
            <div class="brd_info">
                <div class="brd_name ellipsis2" v-html="highlight_brand_name"></div>
                <div class="brd_other">
                    <span v-if="best_yn" class="label">Best</span>
                    <span class="brd_cate">{{cate_name}}</span>
                </div>
            </div>
    `,
    props : {
        search_keyword : {type:String, default:''}, // 브랜드명
        brand_name : {type:String, default:''}, // 브랜드명
        cate_name : {type:String, default:''}, // 대표 카테고리명
        best_yn : {type:Boolean, default:false} // 베스트브랜드 여부
    },
    computed: {
        highlight_brand_name() {
            if( this.search_keyword != null && this.search_keyword !== '' )
                return this.brand_name.split(this.search_keyword).join(`<mark class="match">${this.search_keyword}</mark>`);
            else
                return this.brand_name;
        }
    }
})