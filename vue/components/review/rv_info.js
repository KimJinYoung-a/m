Vue.component('Review-Info',{
    template : `
                <!-- 리뷰 정보 -->
                <div class="rv_info">
                    <div v-if="rv_type == 'different'" class="rv_name" v-html="add_highlight(get_product_name(item_name))"></div>
                    <div class="user_side">
                        <span class="user_eval"><dfn>평점</dfn>
                            <i :style="{width: get_review_point(total_point) + '%'}">
                                {{get_review_point(total_point)}}점
                            </i>
                        </span>
                        <span class="user_id"><dfn>작성자</dfn>{{user_id}}</span>
                    </div>
                    <div class="rv_desc">
                        <p v-html="add_highlight(content)"></p>
                    </div>
                    <button v-if="rv_type == 'different'" @click="pop_view_this_item_reviews" type="button" class="btn_more">이 상품의 후기 더보기</button>
                </div>
    `,
    props : {
        search_keyword : {type:String, default:''}, // 검색 키워드
        rv_type : {type:String, default:''}, // 리뷰 타입('different': 서로다른 후기, 'same': 같은 상품 후기)
        item_id : {type:Number, default:0}, // 상품ID
        item_name : {type:String, default:''}, // 상품 명
        total_point : {type:Number, default:0}, // 후기 평점
        user_id : {type:String, default:''}, // 작성자
        content : {type:String, default:''} // 후기 내용
    },
    methods : {
        // GET 상품 명
        get_product_name : function(item_name) {
            return item_name + '<i class="i_arw_r2"></i>';
        },

        // GET 후기 점수
        get_review_point : function(total_point) {
            return total_point * 20;
        },

        // 검색키워드 하이라이트 처리
        add_highlight(content) {
            if( this.search_keyword != null && this.search_keyword !== '' )
                return content.split(this.search_keyword).join(`<mark class="match">${this.search_keyword}</mark>`);
            else
                return content;
        },

        // 이상품 후기 더보기 팝업
        pop_view_this_item_reviews() {
            this.$emit('pop_view_this_item_reviews', this.item_id);
        },
    }
})