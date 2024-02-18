// 카테고리 익스플로어
Vue.component('Category-Explorer',{
    template : `
        <div class="modal_body">
            <div @scroll="scroll" class="modal_cont explorer">
                <ul class="depth1">
                    <!-- Depth1 -->
                    <li v-for="(category_1 in explorer_categories" :key="category_1.cate_code">
                        <a @click="select_other_category(category_1.cate_code)" :id="category_1.cate_code"
                            :class="[{control: category_1.row_list}, {active: category_1.cate_code == category_code}]">{{category_1.cate_name}}</a>
                        <ul v-if="category_1.row_list && category_1.row_list.length > 0" :class="['depth2', {show: category_1.row_list && category_depth == 1}]">
                            <!-- Depth2 -->
                            <li v-for="(category_2 in category_1.row_list" :key="category_2.cate_code">
                                <a @click="select_other_category(category_2.cate_code)" :id="category_2.cate_code"
                                    :class="[{control: category_2.row_list}, {active: category_2.cate_code == category_code}]">{{category_2.cate_name}}</a>
                                <ul v-if="category_2.row_list && category_2.row_list.length > 0" :class="['depth3', {show: category_2.row_list && category_depth == 2}]">
                                    <!-- Depth3 -->
                                    <li v-for="(category_3 in category_2.row_list" :key="category_3.cate_code">
                                        <a @click="select_other_category(category_3.cate_code)" :id="category_3.cate_code"
                                            :class="[{control: category_3.row_list}, {active: category_3.cate_code == category_code}]">{{category_3.cate_name}}</a>
                                        <ul v-if="category_3.row_list && category_3.row_list.length > 0" :class="['depth4', {show: category_3.row_list && category_depth == 3}]">
                                            <!-- Depth4 -->
                                            <li v-for="(category_4 in category_3.row_list" :key="category_4.cate_code">
                                                <a @click="select_other_category(category_4.cate_code)" :id="category_4.cate_code"
                                                    :class="[{control: category_4.row_list}, {active: category_4.cate_code == category_code}]">{{category_4.cate_name}}</a>
                                                <ul v-if="category_4.row_list && category_4.row_list.length > 0" class="depth5">
                                                    <li v-for="(categories_5 in category_4.row_list" :key="categories_5.cate_code">
                                                        <a @click="select_other_category(categories_5.cate_code)" :id="category_5.cate_code"
                                                            :class="{active: categories_5.cate_code == category_code}">{{categories_5.cate_name}}</a>
                                                    </li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
            <div class="btn_block">
                <button v-show="category_code" @click="move_category_search" class="btn_ten">{{this.category_name}} 보기</button>
            </div>
        </div>
    `,
    data() {return{
        category_code : '', // 선택한 카테고리 코드
        category_name : '', // 선택한 카테고리 명
        categories : [], // 카테고리 리스트
        category_depth : 1, // 현재 카테고리 뎁스
    }},
    props : {
        selected_category_code : {type:String, default:''}, // 선택한 카테고리 코드
        explorer_categories : {type:Array, default:function(){return [];}}, // 카테고리 리스트
        view_type : {type:String, default:'detail'}, // 뷰 타입
        sort_method : {type:String, default:'new'}, // 정렬
    },
    methods : {
        refresh() {
            this.categories = this.explorer_categories;
            this.select_other_category(this.selected_category_code);
        },
        select_other_category(selected_category_code) { // 다른 카테고리 선택
            const selected_category_depth = selected_category_code.length/3;

            if( this.category_code === selected_category_code ) {
                this.clear_categories(this.category_code, this.categories, selected_category_depth);
                this.category_code = '';
            } else if( document.getElementById(selected_category_code) != null ) {
                this.category_name = document.getElementById(selected_category_code).innerText;
                this.clear_categories(this.category_code, this.categories, selected_category_depth);
                this.category_code = selected_category_code;
                this.get_row_list(selected_category_code);
            }
        },
        clear_categories(prev_category_code, categories, depth) { // 카테고리 리스트 초기화
            const _this = this;
            for( let i=0 ; i<categories.length ; i++ ) {
                categories[i].select_yn = false;
                if( categories[i].depth === depth ) {
                    categories[i].row_list = null;
                } else if( categories[i].cate_code === prev_category_code.substr(0, categories[i].cate_code.length)
                    && categories[i].depth < depth ) {
                    this.clear_categories(prev_category_code, categories[i].row_list, depth);
                }
            }
        },
        get_row_list(category_code) { // 하위 리스트 조회
            const _this = this;
            const get_row_list_apiurl = apiurl + '/category/topDispCateList?allFlag=false&catecode=' + category_code;
            $.ajax({
                type: "GET",
                url: get_row_list_apiurl,
                ContentType: "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function (data) {
                    console.log('get_row_list', data);
                    if( data.categories != null ) {
                        _this.set_row_list(category_code, _this.categories, data.categories);
                        _this.category_depth = category_code.length/3;
                    }

                    if( category_code.length === 3 ) {
                        // 스크롤 이동
                        var btn = $('#' + category_code);
                        if (btn.is('.depth1 > li > a')) {
                            var bt = btn.parent().index() * btn.height();
                            $('.modal_cont').animate({scrollTop : bt}, 300);
                        }
                    }
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            })
        },
        set_row_list(category_code, categories, row_list) { // set 하위 카테고리 리스트
            const _this = this;
            for( let i=0 ; i<categories.length ; i++ ) {
                if( categories[i].cate_code === category_code ) {
                    categories[i].select_yn = true;
                    categories[i].row_list = [];
                    for( let j=0 ; j<row_list.length ; j++ ) {
                        categories[i].row_list.push({
                            cate_code : row_list[j].catecode,
                            cate_name : row_list[j].catename,
                            depth : row_list[j].catecode.length/3,
                            row_list : null,
                            select_yn : false
                        });
                    }
                } else if( categories[i].cate_code === category_code.substr(0, categories[i].cate_code.length) ) {
                    _this.set_row_list(category_code, categories[i].row_list, row_list);
                }
            }
        },
        scroll(e) {
            var st = e.target.scrollTop;
            $('.depth1 > li > a').each(function(i, el) {
                if ($(el).next('ul').is(':visible')) {
                    var bt = $(el).parent().index() * $(el).height();
                    if (st >= bt) {
                        $(el).addClass('fixed');
                    } else {
                        $(el).removeClass('fixed');
                    }
                } else {
                    $(el).removeClass('fixed');
                }
            });
        },
        move_category_search() { // 선택한 카테고리 페이지로 이동
            if( this.category_code.length === 3 ) {
                location.href = `/category/category_main2020.asp?disp=${this.category_code}`;
            } else {
                const default_url = `/category/category_detail2020.asp?disp=${this.category_code}&cc=true`;

                if( this.view_type === undefined )
                    location.href = default_url;
                else
                    location.href = `${default_url}&view_type=${this.view_type}&sort_method=${this.sort_method}`;
            }
        },
        close_modal() {
            if( this.category_code === this.selected_category_code ) {
                // 카테고리 익스플로어를 열었지만 카테고리 변경을 하지 않고 닫았을 때
                // 재선택되서 선택이 풀리는걸 방지하기 위해 미리 클릭풀어 놓음
                document.getElementById(this.category_code).click();
            }
        }
    }
});