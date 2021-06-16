var PaginationViewModel = function (o, caller) {
    var defaultRpp = (caller.view == "project" || caller.view == "allrecords") ? 20 : 1000;
    var self = this;
    if (!o) o = {};
    if (!caller) caller = self;
    self.rppOptions = [10, 20, 30, 50, 100, 500, 1000];
    self.resultsPerPage = ko.observable(defaultRpp);
    self.totalResults = ko.observable();
    self.currentPage = ko.observable();
    self.start = ko.observable();

    self.lastPage = ko.pureComputed(function() {
        return Math.ceil((self.totalResults() / self.resultsPerPage()));
    });

    self.info = ko.computed(function () {
        if (self.totalResults() > 0) {
            self.start(self.calculatePageOffset(self.currentPage()) + 1);
            var end = Math.min(self.totalResults(), self.start() + self.resultsPerPage() - 1);
            return "Showing " + self.start() + " to " + end + " of " + self.totalResults();
        }
    });

    self.showPagination = ko.computed(function () {
        return self.totalResults() > 0
    }, this);

    self.calculatePageOffset = function (currentPage) {
        return currentPage < 1 ? 0 : (currentPage - 1) * self.resultsPerPage();
    };

    self.next = function () {
        caller.refreshPage(self.calculatePageOffset(self.currentPage() + 1));
        self.currentPage(self.currentPage() + 1);
    };

    self.previous = function () {
        caller.refreshPage(self.calculatePageOffset(self.currentPage() - 1));
        self.currentPage(self.currentPage() - 1);
    };

    self.first = function () {
        caller.refreshPage(0);
        self.currentPage(1)
    };

    self.last = function () {
        caller.refreshPage(self.calculatePageOffset(Math.ceil((self.totalResults() / self.resultsPerPage()))));
        self.currentPage(self.lastPage());
    };

    self.resultsPerPage.subscribe(function () {
        self.first();
    });

    self.refreshPage = function (rp) {
        // Do nothing.
    };

    self.loadPagination = function (page, total) {
        self.totalResults(total);
        self.currentPage(page < 1 ? 1 : page);
    };
};
