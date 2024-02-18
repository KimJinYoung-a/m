Vue.component('Pagination',{
    template : '\
                <div class="pageWrapV15">\
                    <div class="paging">\
                        <a @click="pagination(1)" title="첫 페이지" class="first arrow"><span style="cursor:pointer;">맨 처음 페이지로 이동</span></a>\
                        <a @click="pagination(prePageNumber)" title="이전 페이지" class="prev arrow"><span style="cursor:pointer;">이전페이지로 이동</span></a>\
                        <template>\
                            <a @click="pagination(item)" v-for="item in pageEndBlock" v-if="item >= pageStartBlock && item <= totalPage" :key="item" :class="[currentPage == item ? \'current\' : \'\']"><span style="cursor:pointer;">{{item}}</span></a>\
                        </template>\
                        <a @click="pagination(nextPageNumber)" title="다음 페이지" class="next arrow"><span style="cursor:pointer;">다음 페이지로 이동</span></a>\
                        <a @click="pagination(totalPage)" title="마지막 페이지" class="end arrow"><span style="cursor:pointer;">맨 마지막 페이지로 이동</span></a>\
                    </div>\
                </div>\
    ',
    computed : {
        currentPage : function() {
            return this.$store.state.params.page;
        },
        pageStartBlock : function() {
            return parseInt((this.currentPage - 1) / this.$store.state.params.pageBlock) * this.$store.state.params.pageBlock + 1;
        },
        pageEndBlock : function() {
            return parseInt((this.currentPage - 1) / this.$store.state.params.pageBlock) * this.$store.state.params.pageBlock + this.$store.state.params.pageBlock;
        },
        totalPage : function() {
            return this.$store.state.params.totalPage < 1 ? 1 : this.$store.state.params.totalPage ;
        },
        prePageNumber : function() {
            return this.currentPage > 1 ? this.currentPage - 1 : '' ;
        },
        nextPageNumber : function() {
            return this.currentPage < this.totalPage ? this.currentPage + 1 : '' ;
        },
    },
    methods : {
        pagination : function(pageNumber) {
            if (pageNumber == '') {
                return false;
            }

            this.$store.commit('SET_PAGENUMBER', pageNumber);
            this.$store.dispatch('GET_ITEMLISTS'); // Search Action
        }
    }
})