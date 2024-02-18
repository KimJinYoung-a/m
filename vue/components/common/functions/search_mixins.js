const search_mixin = Vue.mixin({
    methods : {
        search_within_this() { // 이 안에서 검색
            $('html, body').animate({scrollTop: 0}, 500);
            $('.lyr_add_kwd').show();
            $('#add_keyword .srch_input').val('');
            $('#add_keyword .srch_input').focus();
        },
        do_search_within_this(keyword) { // 이 안에서 검색 실행
            location.href = '?keyword=' + keyword + '&sort_method=' + this.parameter.sort_method;
        },
        scroll : function(callback) { // 스크롤
            const _store = this.$store;
            window.onscroll = function () {
                if( !_store.getters.is_loading_complete ) {
                    if ($(window).scrollTop() >= ($(document).height() - $(window).height()) - 550) {
                        if (_store.getters.is_loading === false) {
                            _store.commit('SET_IS_LOADING', true);
                            callback();
                        }
                    }
                }
            };
        },
        go_group_search(type) { // 검색 그룹 변경
            switch (type) {
                case 'product': location.href='./search_product2020.asp?keyword=' + this.searched_keyword; break;
                case 'review': location.href='./search_review2020.asp?keyword=' + this.searched_keyword; break;
                case 'exhibition': location.href='./search_exhibition2020.asp?keyword=' + this.searched_keyword; break;
                case 'event': location.href='./search_event2020.asp?keyword=' + this.searched_keyword; break;
                case 'brand': location.href='./search_brand2020.asp?keyword=' + this.searched_keyword; break;
            }
        },
        pop_sort_option() { // POPUP 정렬옵션
            //console.log('pop_sort_option');
        },
        number_format(number) { // 숫자 Format(#,###)
            return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        },
        change_view_type(type) { // 뷰 타입 전환
            const uri = this.create_uri('view_type', type);
            location.href = '?' + uri.substr(1);
        },
        move_search_result(keyword) { // 검색창 이동
            if( keyword.trim() !== '' ) {
                keyword = keyword.trim().replace(/(<([^>]+)>)/ig,'');
                location.href = '?keyword=' + keyword;
            }
        },
        move_ignore_correct() { // 교정 무시 이동
            location.href = `?keyword=${this.pre_correct_keyword}&correct_keyword=${this.correct_keyword}`;
        },
        create_uri(key, value) { // URI 생성
            const parameter = this.$store.getters.parameter;
            let uri = '';
            for( let k in parameter ) {
                if( k === key ) {
                    uri += `&${key}=${value}`;
                } else {
                    if( Array.isArray(parameter[k]) ) {
                        for( let i=0 ; i<parameter[k].length ; i++ ) {
                            uri += `&${k}=${parameter[k][i]}`;
                        }
                    } else {
                        uri += `&${k}=${parameter[k]}`;
                    }
                }
            }
            return uri;
        },
        create_uri_obj(obj) {
            const parameter = this.$store.getters.parameter;
            const key_arr = [];
            for( let key in obj ) {
                key_arr.push(key);
            }

            let uri = '';
            for( let k in parameter ) {
                if( key_arr.indexOf(k) > -1 ) {
                    uri += `&${k}=${obj[k]}`;
                } else {
                    if( Array.isArray(parameter[k]) ) {
                        for( let i=0 ; i<parameter[k].length ; i++ ) {
                            uri += `&${k}=${parameter[k][i]}`;
                        }
                    } else {
                        uri += `&${k}=${parameter[k]}`;
                    }
                }
            }
            return uri;
        },
        // 검색 Amplitude 전송
        send_search_amplitude(keyword, result_type, view_type, sort_method, deliType, dispCategories
                              , makerIds, min_price, max_price, current_page) {
            fnAmplitudeEventObjectAction('view_search_result', {
                'keyword' : keyword,
                'result_type' : result_type,
                'list_type' : amplitudeListType(view_type),
                'sort' : amplitudeSort(sort_method),
                'filter_recommend' : amplitudeFilterRecommend(deliType).join(','),
                'filter_category' : dispCategories.join(','),
                'filter_brand' : makerIds.join(','),
                'filter_lowprice' : min_price,
                'filter_highprice' : max_price,
                'paging_index': current_page
            });
        }
    }
});