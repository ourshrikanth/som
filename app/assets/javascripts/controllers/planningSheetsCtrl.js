app.controller('PlanningSheetsCtrl', ['$scope', '$http', 'ngTableParams', '$state', '$q', 'Auth', '$stateParams', function($scope, $http, ngTableParams, $state, $q, Auth, $stateParams) {

    console.log("am here")
    $data = [];
    $scope.tableParams = new ngTableParams({
        page: 1,
        count: 10,
        sorting: {
            'planning_sheets.id': 'desc' // initial sorting
        },
        filter: {
            year: '',
            week_no: ''
        }
    }, {
        getData: function($defer, params) {
            $http.get('planning_sheets.json', {
                    params: {
                        page: params.page(),
                        limit: params.count(),
                        order_by: params.sorting(),
                        filters: params.filter()
                    }
                })
                .success(function(response, status) {
                    $data = response.data;
                    params.total(response.count);
                    $defer.resolve($data);
                });
        }
    });

    //handle add sheet button
    $scope.addSheet = function () {
        $http.get('/planning_sheets/add_sheet/');
        return $scope.tableParams.reload();
    }
    //handle show sheet button 
    $scope.showSheet = function(sheet_id) {
            Auth.currentUser().then(function(user) {});
            $state.go('planning-sheet', {
                id: sheet_id
            });
        }
        //handle edit sheet button
    $scope.editSheet = function(sheet_id) {
        $state.go('planning-sheet-edit', {
            id: sheet_id
        });
    }

    //get all plannning sheet status 
    $scope.getStatus = function(data) {
        var def = $q.defer(),
            names = [];
        names.push({
            'id': 'submitted',
            'title': 'Submitted'
        }, {
            'id': 'draft',
            'title': 'Draft'
        }, {
            'id': 'approved',
            'title': 'Approved'
        }, {
            'id': 'rejected',
            'title': 'Rejected'
        });
        def.resolve(names);
        return def;

    }

}]);
