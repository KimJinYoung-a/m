Vue.component('Pagination',{
    template : '\
            <!-- 페이지네이션 -->\
            <div class="pagination">\
                <a class="prev"\
                    :style="{visibility: current_page > 1 ? \'visible\' : \'hidden\'}" \
                    @click="click_page_move_btn(-1)"><span class="blind">이전페이지</span></a>\
                <div class="current">\
                    <span class="num">{{current_page}}</span>\
                    <input @keyup="page_key_up" @change="change_page" id="current_page" type="number" :value="current_page">\
                </div>\
                <i class="bar">/</i>\
                <span class="total">{{format_last_page}}</span>\
                <a class="next" \
                    :style="{visibility: current_page < last_page ? \'visible\' : \'hidden\'}" \
                    @click="click_page_move_btn(1)"><span class="blind">다음페이지</span></a>\
            </div>\
    ',
    props : {
        current_page : Number,
        last_page : Number
    },
    computed : {
        format_last_page : function () {
            return this.number_format(this.last_page);
        }
    },
    methods : {
        // 현재페이지 변경
        change_page : function(event) {
            this.move_page(event.target.value);
        },

        // 페이지이동 버튼 클릭
        click_page_move_btn : function(num) {
            let page_input = document.getElementById('current_page');
            let change_page = this.current_page + num;
            page_input.value = change_page;
            this.$emit('move_page', change_page);
        },

        // 페이지 키업
        page_key_up : function(e) {
            let page = e.target.value;
            if( isNaN(page) || page.trim() === '' && Number(page) === 0 ) {
                return false;
            } else if( Number(page) > this.last_page ) {
                document.getElementById('current_page').value = this.last_page;
            }
        },

        // 페이지 이동
        move_page : function(page) {
            if( isNaN(page) || page.trim() === '' || Number(page) === 0 ) {
                return false;
            } else if( Number(page) > this.last_page ) {
                document.getElementById('current_page').value = this.last_page;
                this.$emit('move_page', this.last_page);
            } else {
                document.getElementById('current_page').value = page;
                this.$emit('move_page', Number(page));
            }
        },

        // 숫자 Format(#,###)
        number_format : function (number) {
            return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }
    }
})