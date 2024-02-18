Vue.component('Tab-Type1',{
    template : '\
            <!-- 탭 타입1(주로 상품 그리드와 사용) -->\
            <div class="tab_type1">\
                <ul class="tab_list">\
                    <li \
                        v-for="(tab, index) in tabs"\
                        :key="index"\
                        :class="get_tab_classes(tab.is_active)">\
                        <a href="javascript:;"\
                            :id="\'tab_\' + index"\
                            @click="click_tab(index, tab.value)">\
                            <span>{{tab.text}}</span>\
                        </a>\
                    </li>\
                </ul>\
            </div>\
    ',
    props : {
        tabs : {
            value : String,
            text : String,
            is_active : Boolean
        }
    },
    methods : {
        // GET 탭 클래스 리스트
        get_tab_classes : function (is_active) {
            return 'tab_item' + (is_active ? ' active' : '');
        },

        // 탭 클릭
        click_tab : function (index, value) {
            // 클릭한 탭 active 처리
            const this_tab = document.getElementById('tab_' + index);
            const li_arr = this_tab.closest('ul').children;
            for( let i=0 ; i<li_arr.length ; i++ ) {
                li_arr[i].classList.remove('active');
            }
            this_tab.parentElement.classList.add('active');

            this.$emit('click_tab', value);
        }
    }
})