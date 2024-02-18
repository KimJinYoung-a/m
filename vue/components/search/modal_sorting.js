Vue.component('Modal-Sorting',{
    template : `
        <!-- 정렬 모달 -->
        <div id="modal_sorting" class="modalV20 modal_type3">
            <div @click="close_pop('modal_sorting')" class="modal_overlay"></div>
            <div class="modal_wrap">
                <div class="modal_header">
                    <h2>모달</h2>
                    <button class="btn_close" @click="close_pop('modal_sorting')"><i class="i_close"></i>모달닫기</button>
                </div>
                <div class="modal_body">
                    <div class="modal_cont sorting_cont">
                        <div v-if="is_groups_show" class="sorting_list">
                            <p class="sorting_tit">골라보기</p>
                            <ul>
                                <li class="radio">
                                    <input type="radio" name="optA" id="optA_1" value="total"
                                        @click="change_search_type"
                                        :checked="current_search_type == 'total'"
                                    >
                                    <label for="optA_1">전체 <span class="cnt">{{number_format(groups_count.total)}}</span></label>
                                </li>
                                <li class="radio">
                                    <input type="radio" name="optA" id="optA_2" value="product"
                                        @click="change_search_type"
                                        :checked="current_search_type == 'product'"
                                    >
                                    <label for="optA_2">상품 <span class="cnt">{{number_format(groups_count.product)}}</span></label>
                                </li>
                                <li class="radio">
                                    <input type="radio" name="optA" id="optA_3" value="review"
                                        @click="change_search_type"
                                        :checked="current_search_type == 'review'"
                                    >
                                    <label for="optA_3">상품후기 <span class="cnt">{{number_format(groups_count.review)}}</span></label>
                                </li>
                                <li class="radio">
                                    <input type="radio" name="optA" id="optA_4" value="exhibition"
                                        @click="change_search_type"
                                        :checked="current_search_type == 'exhibition'"
                                    >
                                    <label for="optA_4">기획전 <span class="cnt">{{number_format(groups_count.exhibition)}}</span></label>
                                </li>
                                <li class="radio">
                                    <input type="radio" name="optA" id="optA_5" value="event"
                                        @click="change_search_type"
                                        :checked="current_search_type == 'event'"
                                    >
                                    <label for="optA_5">이벤트 <span class="cnt">{{number_format(groups_count.event)}}</span></label>
                                </li>
                                <li class="radio">
                                    <input type="radio" name="optA" id="optA_6" value="brand"
                                        @click="change_search_type"
                                        :checked="current_search_type == 'brand'"
                                    >
                                    <label for="optA_6">브랜드 <span class="cnt">{{number_format(groups_count.brand)}}</span></label>
                                </li>
                            </ul>
                        </div>
                        <div class="sorting_list">
                            <p class="sorting_tit">정렬하기</p>
                            <ul>
                                <li class="radio" v-for="(s, index) in sort_list[current_search_type]" :key="index">
                                    <input type="radio" name="optB" :id="'optB_' + index" :value="s"
                                        @click="change_sort_option"
                                        :checked="s == current_sort_option"
                                    >
                                    <label :for="'optB_' + index">{{get_sort_text(s)}}</label>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="btn_block">
                        <button @click="do_sort_search" :class="['btn_ten', {btn_disabled : false}]">{{button_text}}</button>
                    </div>
                </div>
            </div>
        </div>
    `,
    data() {
        return {
            current_search_type : '', // 현재 선택된 검색 구분
            current_sort_option : '',
            sort_list : {
                product : ['new','bs','best','ws','br','lp','hp','hs'],
                review : ['rc','new'],
                exhibition : ['new','best','ws','hs'],
                event : ['new','ws','duedate'],
                brand : ['new','best','ws','br'],
                total : ['rc'],
                clearance : ['best','new','ws','hs','hp','lp'],
                sale : ['best','new','hs','hp','lp']
            },
            shake_group : '' // 흔들리는 그룹
        }
    },
    mounted() {
        this.current_search_type = this.search_type;
        this.current_sort_option = this.sort_option;
    },
    props : {
        isApp : {type:Boolean, default: false}, // 앱 여부
        is_groups_show : { type : Boolean , default : false }, // 그룹 노출 여부
        groups_count : {
            total : { type : Number , default : 0 }, // 전체 결과 수
            product : { type : Number , default : 0 }, // 상품 결과 수
            review : { type : Number , default : 0 }, // 후기 결과 수
            exhibition : { type : Number , default : 0 }, // 기획전 결과 수
            event : { type : Number , default : 0 }, // 이벤트 결과 수
            brand : { type : Number , default : 0 } // 브랜드 결과 수
        },
        search_type : { type : String , default : 'total' }, // 검색 타입
        sort_option : { type : String , default : 'new' }, // 정렬 옵션
        search_keyword : { type : String, default : '' }, // 검색 키워드
    },
    computed : {
        button_text() { // 버튼 텍스트
            let type_text;
            switch (this.current_search_type) {
                case 'total': type_text = '전체를'; break;
                case 'product': case 'clearance': case 'sale': type_text = '상품을'; break;
                case 'review': type_text = '상품후기를'; break;
                case 'exhibition': type_text = '기획전을'; break;
                case 'event': type_text = '이벤트를'; break;
                case 'brand': type_text = '브랜드를'; break;
                default: type_text = '전체를';
            }

            return type_text + ' ' + this.get_sort_text(this.current_sort_option) + '으로 보기';
        }
    },
    methods : {
        change_search_type(e) { // 검색 구분 변경
            this.current_search_type = e.target.value;
            this.current_sort_option = this.sort_list[this.current_search_type][0];
        },
        change_sort_option(e) { // 정렬 옵션 변경
            this.current_sort_option = e.target.value;
        },
        get_sort_text(sort_option) { // 정렬옵션 텍스트
            let sort_text;
            switch (sort_option) {
                case 'new': sort_text = '신규순'; break;
                case 'bs': sort_text = '판매량순'; break;
                case 'best': sort_text = '인기순'; break;
                case 'br': sort_text = '평가좋은순'; break;
                case 'lp': sort_text = '낮은가격순'; break;
                case 'hp': sort_text = '높은가격순'; break;
                case 'hs': sort_text = '할인율순'; break;
                case 'ws': sort_text = '위시순'; break;
                case 'rc': sort_text = '추천순'; break;
                case 'duedate': sort_text = '마감임박순'; break;
                case 'rank': sort_text = '판매순위순'; break;
                default: sort_text = '신규순';
            }
            return sort_text;
        },
        do_sort_search() {
            this.close_pop('modal_sorting'); // iPhone 이동 후 뒤로가기로 왔을 때 모달 올라와있는것 방지

            if( this.is_groups_show ) { // 상품 검색
                let search_url;
                switch(this.current_search_type) {
                    case 'product': search_url = 'search_product2020.asp'; break;
                    case 'review': search_url = 'search_review2020.asp'; break;
                    case 'exhibition': search_url = 'search_exhibition2020.asp'; break;
                    case 'event': search_url = 'search_event2020.asp'; break;
                    case 'brand': search_url = 'search_brand2020.asp'; break;
                    default: search_url = 'search_result2020.asp';
                }
                location.href = `/search/${search_url}?${this.create_uri('sort_method', this.current_sort_option).substr(1)}`;
            } else { // 그 외(카테고리탐색, 클리어런스)
                this.$emit('change_sort_option', this.current_sort_option);
            }
        }
    }
});