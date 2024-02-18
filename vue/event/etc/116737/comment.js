new Vue({
    el : '#comments',
    template : `
        <div class="cmt-section">
            <h3><img src="//webimage.10x10.co.kr/fixevent/event/2022/116737/m/img_sub06.jpg" alt="참여 카피 리스트" /></h3>
            
            <div v-if="comments.length > 0" class="cmt-wrap">
                <div class="cmt-list">
                    <ul>
                        <li v-for="comment in comments">
                            <div class="info">
                                <span class="num">NO.{{comment.number}}</span>
                                <span class="writer">{{comment.userId}}</span>
                            </div>
                            <div class="copy">{{comment.contents}}</div>
                            <button v-if="comment.mine" class="btn-delete" @click="deleteComment(comment.index)"></button>
                        </li>
                    </ul>
                </div>
                <div class="pageWrapV15">
                    <div class="paging pagingV15a">
                        <span v-if="currentPage>1" class="arrow prevBtn"><a @click="goPrevPage">prev</a></span>
                        <span v-for="page in pages" :class="{current:page===currentPage}">
                            <a @click="goPage(page)">{{page}}</a>
                        </span>
                        <span v-if="lastPage>currentPage" class="arrow nextBtn"><a @click="goNextPage">next</a></span>
                    </div>
                </div>
            </div>
        </div>
    `,
    created() {
        this.getComments(1);
    },
    data() {return {
        totalCount : 0,
        currentPage : 0,
        lastPage : 1,
        pageSize : 5,
        comments : [],
        pages : [1]
    }},
    methods : {
        getComments(page) {
            this.currentPage = page;
            const url = `/event/comments/116737/pagesize/${this.pageSize}/page/${page}`;
            getFrontApiDataV2('GET', url, null, this.getCommentsSuccess);
        },
        getCommentsSuccess(data) {
            this.totalCount = data.totalCount;
            this.lastPage = data.lastPage;
            this.comments = data.comments;
            this.createPages();
        },
        createPages() {
            const startPage = this.getStartPage();
            let endPage = startPage + this.pageSize - 1;
            endPage = endPage > this.lastPage ? this.lastPage : endPage;

            this.pages = [];
            for( let i=startPage ; i<=endPage ; i++ ) {
                this.pages.push(i);
            }
        },
        getStartPage() {
            const page = this.currentPage - 1;
            return page - (page%this.pageSize) + 1;
        },
        deleteComment(index) {
            jsDelComment(index);
        },
        goPage(page) {
            this.getComments(page);
        },
        goPrevPage() {
            this.goPage(this.currentPage-1);
        },
        goNextPage() {
            this.goPage(this.currentPage+1);
        },
    }
})