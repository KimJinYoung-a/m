Vue.component('Search-Category',{
    template : `
            <!-- 검색결과 구분 -->
            <div v-if="active_group" class="srch_cate">
                <ul>
                    <li :class="get_group_li_class('total')">
                        <button type="button" @click="go_group_search('total')">전체<span class="cnt">{{number_format(groups_count.total)}}</span></button>
                    </li>
                    <li :class="get_group_li_class('product')">
                        <button type="button" :class="get_group_a_class('product')" @click="go_group_search('product')">상품<span class="cnt">{{number_format(groups_count.product)}}</span></button>
                    </li>
                    <li :class="get_group_li_class('review')">
                        <button type="button" :class="get_group_a_class('review')" @click="go_group_search('review')">상품 후기<span class="cnt">{{number_format(groups_count.review)}}</span></button>
                    </li>
                    <li :class="get_group_li_class('exhibition')">
                        <button type="button" :class="get_group_a_class('exhibition')" @click="go_group_search('exhibition')">기획전<span class="cnt">{{number_format(groups_count.exhibition)}}</span></button>
                    </li>
                    <li :class="get_group_li_class('event')">
                        <button type="button" :class="get_group_a_class('event')" @click="go_group_search('event')">이벤트<span class="cnt">{{number_format(groups_count.event)}}</span></button>
                    </li>
                    <li :class="get_group_li_class('brand')">
                        <button type="button" :class="get_group_a_class('brand')" @click="go_group_search('brand')">브랜드<span class="cnt">{{number_format(groups_count.brand)}}</span></button>
                    </li>
                </ul>
            </div>
    `,
    props : {
        groups_count: {
            total : 0, // 전체
            product : 0, // 상품
            review : 0, // 상품후기
            exhibition : 0, // 기획전
            event : 0, // 이벤트
            brand : 0 // 브랜드
        },
        active_group: {type:String, default:'total'}, // 활성화 할 그룹
        search_keyword: {type:String, default:''}, // 활성화 할 그룹
    },
    methods : {
        go_group_search(type) { // 그룹 검색 이동
            let search_url;
            switch(type) {
                case 'product': search_url = 'search_product2020.asp'; break;
                case 'review': search_url = 'search_review2020.asp'; break;
                case 'exhibition': search_url = 'search_exhibition2020.asp'; break;
                case 'event': search_url = 'search_event2020.asp'; break;
                case 'brand': search_url = 'search_brand2020.asp'; break;
                default: search_url = 'search_result2020.asp';
            }
            location.href = `/search/${search_url}?${this.create_uri('sort_method', '').substr(1)}`;
        },
        get_group_li_class(type) { // 활성화 할 그룹이면 on 클래스
            return type === this.active_group ? 'on' : '';
        },
        get_group_a_class(type) { // 그룹내 결과 수 없으면 disabled 클래스
            return this.groups_count[type] === 0 ? 'disabled' : '';
        }
    }
})