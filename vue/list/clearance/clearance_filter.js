Vue.component('Clearance-Filter',{
    template : `
        <!-- 꼼꼼하게 찾기 - 상품 필터 -->
        <div id="clearance_filter" class="modalV20 modal_type3">
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
                            <li class="on"><span>가격대</span></li>
                        </ul>
                        <div class="filter_sub">
                            <!-- 가격대 -->
                            <div class="filter_sub_cont filter_price on">
                                <div class="filt_price input_txt">
                                    <input type="text" title="최소 가격" name="min_price" v-model="min_price"
                                        @click="click_price_input" @blur="blur_input_price" @focus="focus_input"
                                        :placeholder="number_format(product_min_price)" readonly/>
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
                                        :placeholder="number_format(product_max_price)" readonly/>
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
        kkomkkom_count : 0, // 꼼꼼하게 찾기 상품 갯수
        focus_price_type : 'min_price', // 최저 가격
        min_price : '', // 최저 가격
        is_readonly_min_price : true, // 최저 가격 입력창 readonly 여부
        max_price : '', // 최고 가격
        is_readonly_max_price : true, // 최고 가격 입력창 readonly 여부
    }},
    props : {
        isApp : {type:Boolean, default: false}, // 앱 여부
        searched_min_price : {type:String, default:''}, // 검색한 최저 가격
        searched_max_price : {type:String, default:''}, // 검색한 최고 가격
        searched_category_code : {type:Number, default:0}, // 검색한 카테고리 코드
        result_count : {type:Number, default:0}, // 검색결과 수
        product_min_price : {type:Number, default:0}, // 검색결과 상품 중 최저 가격
        product_max_price : {type:Number, default:0}, // 검색결과 상품 중 최고 가격
    },
    methods : {
        get_kkomkkom_count() { // 꼼꼼하게찾기 상품 갯수 조회 API 호출
            const _this = this;
            let kkomkkom_count_apiurl = apiurl + '/clearance/ItemCount';
            let parameter = '';
            if( this.searched_category_code !== 0 ) {
                parameter += '&catecode=' + this.searched_category_code;
            }
            if( this.min_price !== '' ) {
                parameter += '&minPrice=' + this.remove_commas(this.min_price);
            }
            if( this.max_price !== '' ) {
                parameter += '&maxPrice=' + this.remove_commas(this.max_price);
            }
            if( parameter !== '' ) {
                kkomkkom_count_apiurl += '?' + parameter.substr(1);
            }

            $.ajax({
                type: "GET",
                url: kkomkkom_count_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log(kkomkkom_count_apiurl, data);
                    _this.kkomkkom_count = data;
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        },
        refresh() { // 처음 검색상태로 refresh
            // 가격대
            this.focus_price_type = 'min_price';
            this.min_price = this.number_format(this.searched_min_price);
            this.max_price = this.number_format(this.searched_max_price);

            this.kkomkkom_count = this.result_count;
        },
        do_kkomkkom_search() { // 꼼꼼하게 찾기 검색 실행
            this.$emit('do_kkomkkom_search'
                , this.remove_commas(this.min_price)
                , this.remove_commas(this.max_price));
        },
        close_kkomkkom() { // 모달 닫기
            this.close_pop('clearance_filter');
        },
        focus_input(e) { // input 포커스시 모달 height 조정
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
            this.min_price = '';
            this.max_price = '';
            this.$emit('clear_all');
            this.get_kkomkkom_count();
        },

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