Vue.component('Modal-Filter',{
    template : /*html*/`
        <!-- 꼼꼼하게 찾기 - 상품 필터 -->
        <div id="modal_filter" class="modalV20 modal_type3">
            <div @click="close_kkomkkom" class="modal_overlay"></div>
            <div class="modal_wrap">
                <div class="modal_header">
                    <h2>모달</h2>
                    <button class="btn_close" @click="close_kkomkkom"><i class="i_close"></i>모달닫기</button>
                </div>
                <div class="modal_body">
                    <button @click="clear_all" class="btn_reset btn_type2 btn_wht">초기화<i class="i_refresh2"></i></button>
                    <div class="modal_cont filter_cont">
                        <ul class="filter_main">
                            <li @click="change_tab('deliType')" :class="[{on : active_tab == 'deliType'}, {selected : deliType.length > 0}]"><span>배송/기타</span></li>
                            <li v-if="!is_category_search" @click="change_tab('category')" :class="[{on : active_tab == 'category'}, {selected : dispCategories.length > 0}]"><span>카테고리</span></li>
                            <li v-if="!is_brand_detail" @click="change_tab('brand')" :class="[{on : active_tab == 'brand'}, {selected : makerIds.length > 0}]"><span>브랜드</span></li>
                            <li @click="change_tab('price')" :class="[{on : active_tab == 'price'}, {selected : min_price != '' || max_price != ''}]"><span>가격대</span></li>
                        </ul>
                        <div @scroll="scroll_modal" class="filter_sub">
                            <!-- 배송/기타 -->
                            <div :class="['filter_sub_cont', 'filter_delivery', {on : active_tab == 'deliType'}]">
                                <!-- 배송 -->
                                <ul class="filter_list">
                                    <li class="checkbox">
                                        <input type="checkbox" name="deliType" value="FD" id="filt_deliv1"
                                            @change="change_checkbox" :checked="deliType.indexOf('FD') > -1">
                                        <label for="filt_deliv1">무료배송</label>
                                    </li>
                                    <li class="checkbox">
                                        <input type="checkbox" name="deliType" value="TN" id="filt_deliv2"
                                            @change="change_checkbox" :checked="deliType.indexOf('TN') > -1">
                                        <label for="filt_deliv2">텐바이텐 배송</label>
                                    </li>
                                    <li class="checkbox">
                                        <input type="checkbox" name="deliType" value="DT" id="filt_deliv3"
                                            @change="change_checkbox" :checked="deliType.indexOf('DT') > -1">
                                        <label for="filt_deliv3">해외직구</label>
                                    </li>
                                </ul>
                                <!-- 기타 -->
                                <ul class="filter_list">
                                    <li class="checkbox">
                                        <input type="checkbox" name="deliType" value="SP" id="filt_etc1"
                                            @change="change_checkbox" :checked="deliType.indexOf('SP') > -1">
                                        <label for="filt_etc1">선물포장 가능</label>
                                    </li>
                                    <li class="checkbox">
                                        <input type="checkbox" name="deliType" value="WD" id="filt_etc2"
                                            @change="change_checkbox" :checked="deliType.indexOf('WD') > -1">
                                        <label for="filt_etc2">해외배송 가능</label>
                                    </li>
                                    <li class="checkbox">
                                        <input type="checkbox" name="deliType" value="TD" id="filt_etc3"
                                            @change="change_checkbox" :checked="deliType.indexOf('TD') > -1">
                                        <label for="filt_etc3">텐텐딜</label>
                                    </li>
                                    <li class="checkbox">
                                        <input type="checkbox" name="deliType" value="PS" id="filt_etc4"
                                            @change="change_checkbox" :checked="deliType.indexOf('PS') > -1">
                                        <label for="filt_etc4">품절 상품 제외</label>
                                    </li>
                                </ul>
                            </div>
                            
                            <!-- 카테고리 -->
                            <div v-if="!is_category_search" :class="['filter_sub_cont', 'filter_cate', {on : active_tab == 'category'}]">
                                <ul class="filter_list">
                                    <li v-for="(category_1, index) in parameter.categories" :key="category_1.category_code">
                                        <div class="cate_1depth">
                                            <div class="checkbox">
                                                <input type="checkbox" name="dispCategories" :value="category_1.category_code" :id="'cate_1dp_' + category_1.category_code"
                                                    @change="change_category_depth1">
                                                <label :for="'cate_1dp_' + category_1.category_code"></label>
                                            </div>
                                            <p :id="'cate_tit_' + category_1.category_code" @click="toggle_category_depth2" class="cate_tit">{{category_1.category_name}}</p>
                                        </div>
                                        <ul class="cate_2depth">
                                            <li class="checkbox" v-for="(category_2, index) in category_1.row_list" :key="category_2.category_code">
                                                <input type="checkbox" name="dispCategories" :value="category_2.category_code" :id="'cate_2dp_' + category_2.category_code"
                                                    @change="change_category_depth2">
                                                <label :for="'cate_2dp_' + category_2.category_code">{{category_2.category_name}}</label>
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                            </div>
                            
                            <!-- 브랜드 -->
                            <div :class="['filter_sub_cont', 'filter_brand', {on : active_tab == 'brand'}]">
                                <!-- 검색바 -->
                                <div class="srchbar_wrap">
                                    <div class="srchbar input_txt">
                                        <input type="search" title="검색어 입력" placeholder="브랜드 검색" class="srch_input"
                                            id="brand_search_keyword" v-model="brand_search_keyword" 
                                            @keyup="brand_search" @focus="focus_input">
                                        <button v-show="brand_search_keyword != ''" @click="clear_brand_search_keyword" class="btn_del"><i class="i_close"></i></button>
                                    </div>
                                </div>
        
                                <!-- 브랜드 리스트 -->
                                <ul v-show="brand_search_keyword == '' && auto_completed_brands.length == 0" class="filter_list srch_kwd_list">
                                    <li class="checkbox" v-for="(brand, index) in parameter.brands" :key="brand.brand_id">
                                        <input type="checkbox" name="makerIds" :id="'filt_brand_' + brand.brand_id" :value="brand.brand_id" 
                                            @change="change_makerIds" :checked="brand.is_checked">
                                        <label :for="'filt_brand_' + brand.brand_id">{{brand.brand_name}}</label>
                                    </li>
                                </ul>
        
                                <!-- 자동 완성 -->
                                <ul v-show="auto_completed_brands.length > 0" class="filter_list srch_kwd_list type3">
                                    <li class="checkbox" v-for="(brand, index) in auto_completed_brands" :key="brand.brand_id">
                                        <input type="checkbox" name="makerIds" :id="'auto_filt_brand_' + brand.brand_id" :value="brand.brand_id"
                                            @change="change_makerIds" :checked="brand.is_checked">
                                        <label :for="'auto_filt_brand_' + brand.brand_id" v-html="highlight_brand_name(brand.brand_name)"></label>
                                    </li>
                                </ul>
                                <!-- 검색 결과 없을 경우 -->
                                <div v-show="brand_search_keyword != '' && auto_completed_brands.length == 0" class="no_data">아쉽게도 검색결과가 없어요</div>
                            </div>
                            
                            <!-- 가격대 -->
                            <div :class="['filter_sub_cont', 'filter_price', {on : active_tab == 'price'}]">
                                <div class="filt_price input_txt">
                                    <input type="text" title="최소 가격" name="min_price" v-model="min_price"
                                        @click="click_price_input" @blur="blur_input_price" @focus="focus_input"
                                        :placeholder="number_format(parameter.result_price.min)" readonly/>
                                    <span>원 부터</span>
                                </div>
                                <div v-show="focus_price_type == 'min_price'" class="price_btns">
                                    <button @click="plus_price('min_price', 100000)" class="btn_type1 btn_ten">+10만</button>
                                    <button @click="plus_price('min_price', 10000)" class="btn_type1 btn_ten">+1만</button>
                                    <button @click="plus_price('min_price', 1000)" class="btn_type1 btn_ten">+1천</button>
                                    <button @click="plus_price('min_price', 100)" class="btn_type1 btn_ten">+1백</button>
                                    <button @click="direct_input_price('min_price')" class="btn_type1 btn_wht btn_typing">직접 입력</button>
                                </div>
                                <div class="filt_price input_txt">
                                    <input type="text" title="최대 가격" name="max_price" v-model="max_price"
                                        @click="click_price_input" @blur="blur_input_price" @focus="focus_input"
                                        :placeholder="number_format(parameter.result_price.max)" readonly/>
                                    <span>원 까지</span>
                                </div>
                                <div v-show="focus_price_type == 'max_price'" class="price_btns" style="display:none;">
                                    <button @click="plus_price('max_price', 100000)" class="btn_type1 btn_ten">+10만</button>
                                    <button @click="plus_price('max_price', 10000)" class="btn_type1 btn_ten">+1만</button>
                                    <button @click="plus_price('max_price', 1000)" class="btn_type1 btn_ten">+1천</button>
                                    <button @click="plus_price('max_price', 100)" class="btn_type1 btn_ten">+1백</button>
                                    <button @click="direct_input_price('max_price')" class="btn_type1 btn_wht btn_typing">직접 입력</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="btn_block">
                        <button @click="do_kkomkkom_search" class="btn_ten">꼼꼼히 찾아본 {{number_format(kkomkkom_count)}}개의 상품</button>
                    </div>
                </div>
            </div>
        </div>
    `,
    data() {return{
        deliType : [], // 선택한 배송/기타
        dispCategories : [], // 선택한 카테고리 리스트
        makerIds : [], // 선택한 브랜드ID 리스트
        kkomkkom_count : 0, // 꼼꼼하게 찾기 상품 갯수
        active_tab : 'deliType', // 활성화 탭

        brand_is_loading : false, // 브랜드 페이징 로딩 여부
        auto_completed_brands : [], // 자동완성 브랜드 리스트
        brand_search_keyword : '', // 브랜드명 검색 키워드

        focus_price_type : 'min_price', // 최저 가격
        min_price : '', // 최저 가격
        max_price : '', // 최고 가격
    }},
    props : {
        parameter : {
            search_keyword : {type:String, default:''}, // 검색어
            disp_category : {type:Number, default:0}, // 카테고리탐색 = 카테고리코드
            brand_id : {type:String, default:''}, // 브랜드상세 = 브랜드ID
            searched_deliType : {type:Array, default:function(){return []}}, // 검색한 배송/기타 리스트
            searched_categories : {type:Array, default:function(){return []}}, // 검색한 카테고리 리스트
            searched_brands : {type:Array, default:function(){return []}}, // 검색한 브랜드 리스트
            searched_min_price : {type:String, default:''}, // 검색한 최저 가격
            searched_max_price : {type:String, default:''}, // 검색한 최고 가격
            view_type : {type:String, default:'detail'}, // 뷰 타입
            sort_method : {type:String, default:'bs'}, // 정렬
            result_count : {type:Number, default:0}, // 검색결과 수
            result_price : { // 검색결과 최저/최고 가격
                min : {type:Number, default:0},
                max : {type:Number, default:0}
            },
            categories : {type:Array, default:function(){return []}}, // 카테고리 리스트
            brands : {type:Array, default:function(){return []}}, // 브랜드 리스트
            brand_page : {type:Number, default:1}, // 브랜드 페이지
        },
        is_category_search : {type:Boolean, default:false}, // 카테고리탐색 여부
        is_biz : {type:Boolean, default:false}, // 비즈 여부
        is_brand_detail : {type:Boolean, default:false}, // 브랜드 상세 여부
    },
    methods : {
        get_kkomkkom_count() { // 꼼꼼하게찾기 상품 갯수 조회 API 호출
            const _this = this;
            const kkomkkom_count_apiurl = apiurl
                + (this.is_biz ? '/b2b/mobile/product/count' : '/search/itemCountSearch')
                + this.create_product_parameter(false);
            console.log(kkomkkom_count_apiurl);

            $.ajax({
                type: "GET",
                url: kkomkkom_count_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    _this.kkomkkom_count = data;
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        create_product_parameter(is_do_search) { // 파라미터 생성
            let param = '';

            if( this.is_category_search ) {
                param += (is_do_search ? '?disp=' : '?dispCategories=') + this.parameter.disp_category;
            } else if( this.is_brand_detail ) {
                param += (is_do_search ? '?brandid=' : '?makerIds=') + this.parameter.brand_id;
            } else {
                param += (is_do_search || this.is_biz ? '?keyword=' : '?keywords=') + this.parameter.search_keyword;
            }

            if( this.deliType.length > 0 ) { // 배송/기타
                for( let i=0 ; i<this.deliType.length ; i++ ) {
                    param += '&deliType=' + this.deliType[i];
                }
            }
            if( !this.is_category_search && this.dispCategories.length > 0 ) { // 카테고리 - 카테고리탐색은 X
                for( let i=0 ; i<this.dispCategories.length ; i++ ) {
                    param += '&dispCategories=' + this.dispCategories[i];
                }
            }
            if( this.makerIds.length > 0 ) { // 브랜드
                for( let i=0 ; i<this.makerIds.length ; i++ ) {
                    param += '&makerIds=' + this.makerIds[i];
                }
            }

            if( this.min_price !== '' ) { // 최저가
                param += '&minPrice=' + this.remove_commas(this.min_price);
            }
            if( this.max_price !== '' ) { // 최고가
                param += '&maxPrice=' + this.remove_commas(this.max_price);
            }

            if( is_do_search ) {
                param += '&view_type=' + this.parameter.view_type + '&sort_method=' + this.parameter.sort_method
            }

            return param;
        },
        refresh() { // 처음 검색상태로 refresh
            //console.log(this.parameter);
            // 배송/기타
            this.deliType = [];
            for( let i=0 ; i<this.parameter.searched_deliType.length ; i++ ) {
                this.deliType.push(this.parameter.searched_deliType[i]);
            }
            // 카테고리
            if( !this.is_category_search ) {
                this.dispCategories = [];
                for( let i=0 ; i<this.parameter.searched_categories.length ; i++ ) {
                    this.dispCategories.push(this.parameter.searched_categories[i]);
                }
            }
            // 브랜드
            if( !this.is_brand_detail ) {
                this.makerIds = [];
                for( let i=0 ; i<this.parameter.searched_brands.length ; i++ ) {
                    this.makerIds.push(this.parameter.searched_brands[i]);
                }
                const makerIdsCheckboxArr = document.querySelectorAll('input[name=makerIds]');
                for( let i=0 ; i<makerIdsCheckboxArr.length ; i++ ) {
                    makerIdsCheckboxArr[i].checked = this.makerIds.indexOf(makerIdsCheckboxArr[i].value) > -1;
                }
            }

            // 가격대
            this.focus_price_type = 'min_price';
            this.min_price = this.number_format(this.parameter.searched_min_price);
            this.max_price = this.number_format(this.parameter.searched_max_price);
            this.kkomkkom_count = this.parameter.result_count;
            this.active_tab = 'deliType';

            if( !this.is_category_search ) {
                this.first_check_dispCategories();
            }
        },
        change_checkbox(e) { // 체크박스 변경
            const arr_data = this[e.target.name];
            const value = e.target.value;
            const is_checked = e.target.checked;

            if( is_checked ) {
                arr_data.push(value);
            } else {
                arr_data.splice(arr_data.indexOf(value), 1);
            }
            this.get_kkomkkom_count();
        },
        do_kkomkkom_search() { // 꼼꼼하게 찾기 검색 실행
            this.close_pop('modal_filter');

            if( !this.is_category_search && !this.is_biz ) {
                location.href = this.create_product_parameter(true);
            } else {
                let deliType = [], makerIds = [];
                this.deliType.forEach(type => deliType.push(type));
                this.makerIds.forEach(type => makerIds.push(type));

                const kkomkkom_parameters = {
                    deliType : deliType,
                    makerIds : makerIds,
                    min_price : this.remove_commas(this.min_price),
                    max_price : this.remove_commas(this.max_price)
                };

                // Biz 검색
                if( !this.is_category_search ) {
                    const dispCategories = [];
                    this.dispCategories.forEach(category => dispCategories.push(category));
                    kkomkkom_parameters.dispCategories = dispCategories;
                }

                this.$emit('do_kkomkkom_search', kkomkkom_parameters);
            }
        },
        change_tab(tab) { // 탭 변경
            this.active_tab = tab;
        },
        close_kkomkkom() { // 모달 닫기
            this.clear_brand_search_keyword(); // 브랜드 검색 키워드&자동완성 초기화
            this.$emit('close_kkomkkom'); // store에 저장된 추가한 브랜드 리스트 초기화
            this.close_pop('modal_filter');
        },
        focus_input(e) { // input 포커스시
            /**
             * 아이폰에서는 blur + focus 작동안함
             * 그래서 가격대 input 누른상태에서 직접입력 누르면
             * 가격대 input이 blur되면서 button에 focus가 갔다가 다시 script로 focus를 처리하려하니
             * 아이폰에서 키보드가 안올라오고 가격대input에 focus가 안되는 현상이 발생
             * 그래서 readonly상태면 focus시 바로 미리 blur시키게 수정
             */
            if( e.target.readOnly ) {
                e.target.blur();
            }
        },
        clear_all() { // 초기화
            this.deliType = [];
            this.dispCategories = [];
            this.makerIds = [];
            this.min_price = '';
            this.max_price = '';
            this.brand_search_keyword = '';

            const input_arr = document.querySelectorAll('.modal_cont input[type=checkbox]');
            for( let i=0 ; i<input_arr.length ; i++ ) {
                input_arr[i].checked = false;
            }
            const cate_tit_arr = document.querySelectorAll('.cate_tit');
            for( let i=0 ; i<cate_tit_arr.length ; i++ ) {
                cate_tit_arr[i].style.color = 'var(--c_111)';
            }
            this.$emit('clear_all');
            this.get_kkomkkom_count();
        },

        /* 카테고리 관련 */
        toggle_category_depth2(e) { // 뎁스1 카테고리명 클릭 시 하위 카테고리 리스트 펼침/접음
            e.target.parentElement.classList.toggle('show');
        },
        change_category_depth1(e) { // 뎁스1 카테고리 변경
            const _this = this;
            const depth2Categories = e.target.closest('li').querySelectorAll('.cate_2depth input');
            const is_checked = e.target.checked;

            if( is_checked ) {
                for( let i=0 ; i<depth2Categories.length ; i++ ) {
                    depth2Categories[i].checked = true;
                    _this.add_dispCategories(depth2Categories[i].value);
                }
            } else {
                for( let i=0 ; i<depth2Categories.length ; i++ ) {
                    depth2Categories[i].checked = false;
                    _this.sub_dispCategories(depth2Categories[i].value);
                }
            }

            _this.change_color_category_title(e.target.checked, e.target.value);
            _this.change_checkbox(e);
        },
        change_category_depth2(e) { // 뎁스2 카테고리 변경
            const _this = this;
            if( !e.target.checked ) {
                const category_1_code = e.target.value.toString().substr(0, 3);
                document.getElementById('cate_1dp_' + category_1_code).checked = false;
                _this.change_color_category_title(false, category_1_code);
                _this.sub_dispCategories(category_1_code);
            }
            _this.change_checkbox(e);
        },
        change_color_category_title(is_checked, category_code) { // 1뎁스 카테고리 타이틀 텍스트 색상 변경
            if( is_checked ) {
                document.getElementById('cate_tit_' + category_code).style.color = 'var(--ten)';
            } else {
                document.getElementById('cate_tit_' + category_code).style.color = 'var(--c_111)';
            }
        },
        add_dispCategories(category_code) { // data - dispCategories 카테고리 추가
            if( this.dispCategories.indexOf(category_code) < 0 ) {
                this.dispCategories.push(category_code);
            }
        },
        sub_dispCategories(category_code) { // data - dispCategories 카테고리 제거
            if( this.dispCategories.indexOf(category_code) > -1 ) {
                this.dispCategories.splice(this.dispCategories.indexOf(category_code), 1);
            }
        },
        first_check_dispCategories() { // refresh 할 때 dispCategories 카테고리 체크박스 체크
            const _this = this;
            const category_checkbox_arr = document.querySelectorAll('.filter_cate input');
            for( let i=0 ; i<category_checkbox_arr.length ; i++ ) {
                if( _this.dispCategories.indexOf(category_checkbox_arr[i].value) > -1 ) {
                    category_checkbox_arr[i].checked = true;

                    if( category_checkbox_arr[i].value.length === 3 ) { // 1depth면 타이틀 색상 변경
                        _this.change_color_category_title(true, category_checkbox_arr[i].value);
                    }
                }
            }
        },
        /* //카테고리 관련 */

        /* 브랜드 관련 */
        scroll_modal(e) { // 브랜드 리스트 스크롤 페이징
            const _this = this;
            if( !_this.brand_is_loading && _this.active_tab === 'brand' && _this.auto_completed_brands.length === 0
                && (e.target.scrollHeight - e.target.offsetHeight - e.target.scrollTop) <= 300) {
                _this.brand_is_loading = true;
                setTimeout(function () {
                    _this.brand_is_loading = false;
                }, 1000);
                this.$emit('modal_paging', {brand_name_keyword: ''});
            }
        },
        brand_search(e) { // 브랜드 검색
            const _this = this;
            if( e.target.value.trim() === '' ) {
                _this.auto_completed_brands = [];
                return false;
            }
            const keyword = e.target.value.toLowerCase();

            if( this.is_biz ) {
                console.log(keyword);
                this.auto_completed_brands = [];
                const allBrands = this.parameter.brands;

                allBrands.find(b => {
                    const name = b.brand_name.toLowerCase();
                    if( name.indexOf(keyword) > -1 ) {
                        b.is_checked = _this.makerIds.indexOf(b.brand_id) > -1;
                        _this.auto_completed_brands.push(b);
                    }
                });

            } else {
                let kkomkkom_brand_apiurl;
                if( this.is_category_search ) { // 카테고리탐색 꼼꼼하게찾기
                    kkomkkom_brand_apiurl = apiurl + '/search/kkomkkom/brands'
                        + '?page=1&dispCategories=' + _this.parameter.disp_category
                        + '&brand_name_keyword=' + keyword;
                } else { // 상품검색 꼼꼼하게 찾기
                    kkomkkom_brand_apiurl = apiurl + '/search/kkomkkom/brands'
                        + '?page=1&keywords=' + _this.parameter.search_keyword
                        + '&brand_name_keyword=' + keyword;
                }

                $.ajax({
                    type: "GET",
                    url: kkomkkom_brand_apiurl,
                    ContentType: "json",
                    crossDomain: true,
                    xhrFields: {
                        withCredentials: true
                    },
                    success: function (data) {
                        _this.auto_completed_brands = [];
                        if( data.totalCount > 0 ) {
                            for( let i=0 ; i<data.brands.length ; i++ ) {
                                data.brands[i].is_checked = _this.makerIds.indexOf(data.brands[i].brand_id) > -1;
                                _this.auto_completed_brands.push(data.brands[i]);
                            }
                        }
                    },
                    error: function (xhr) {
                        console.log(xhr.responseText);
                    }
                });
            }
        },
        highlight_brand_name(brand_name) { // 브랜드 검색 결과 브랜드명 하이라이트 처리
            return brand_name.replace(new RegExp(this.brand_search_keyword, 'gi'), `<b>${this.brand_search_keyword}</b>`);
        },
        change_makerIds(e) { // 브랜드 체크/해제
            const brand_id = e.target.value;
            if( e.target.id.startsWith('auto') && document.getElementById('filt_brand_' + brand_id) !== null ) { // 자동완성에서 체크 및 해제시 기존 리스트 동시 체크 및 해제
                document.getElementById('filt_brand_' + brand_id).checked = true;
            }
            this.change_checkbox(e);
            this.$emit('change_makerIds', {brand_id:brand_id, is_checked:e.target.checked}); // 추가,삭제 브랜드를 store와 동기화 - 브랜드명 검색때문에
        },
        clear_brand_search_keyword() { // 브랜드 검색키워드 초기화
            this.brand_search_keyword = '';
            this.auto_completed_brands = [];
        },
        /* //브랜드 관련 */

        /* 가격대 관련 */
        click_price_input(e) { // 가격 부분 클릭 시 아래에 가격 조정 영역 표시
            this.focus_price_type = e.target.name;
        },
        plus_price(type, price) { // 가격 버튼으로 가격 증가 & 상품 수 API 호출
            this[type] = this.number_format(Number(this[type].trim() !== '' ? this.remove_commas(this[type]) : 0) + price);
            this.get_kkomkkom_count();
        },
        direct_input_price(type) { // 직접 입력 활성화
            const price_input = document.querySelector(`input[name=${type}]`);
            price_input.readOnly = false;
            if( type === 'min_price' ) {
                this.min_price = this.remove_commas(this.min_price);
            } else {
                this.max_price = this.remove_commas(this.max_price);
            }
            price_input.focus();
        },
        blur_input_price(e) { // 가격 입력창 blur 이벤트 콤마 찍고 상품 수 API 호출
            const type = e.target.name;
            if( !e.target.readOnly ) {
                e.target.readOnly = true;
                if( type === 'min_price' ) {
                    if( this.min_price !== '' && !isNaN(this.min_price) ) {
                        this.min_price = this.number_format(this.min_price);
                    } else {
                        this.min_price = '';
                    }
                    this.get_kkomkkom_count();
                } else {
                    if( this.max_price !== '' && !isNaN(this.max_price) ) {
                        this.max_price = this.number_format(this.max_price);
                    } else {
                        this.max_price = '';
                    }
                    this.get_kkomkkom_count();
                }
            }
        }
        /* //가격대 관련 */
    }
})