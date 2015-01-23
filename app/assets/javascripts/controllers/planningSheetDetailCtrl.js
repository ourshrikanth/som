var planning_sheet_ctrl = app.controller('PlanningSheetDetailCtrl', ['$scope', '$http', 'ngTableParams', '$state', 'Auth', '$window', '$stateParams', function($scope, $http, ngTableParams, $state, Auth, $window, $stateParams) {
        // if (!($window.sessionStorage._userId == isOwner.user_id)) {
        //     $state.go('dashboard')
        // }
        console.log("PlanningSheetDetailCtrl")
        $scope.data = [];
        $scope.tableParams = new ngTableParams({
            page: 1,
            count: 10,
            sorting: {
                'planned_tasks.id': 'desc' // initial sorting
            }
        }, {
            getData: function($defer, params) {
                $http.get('planned_tasks/getAllTasksOfSheet.json', {
                        params: {
                            page: params.page(),
                            id: $stateParams.id,
                            limit: params.count(),
                            order_by: params.sorting()
                        }
                    })
                    .success(function(response, status) {
                        $scope.data = response.data;
                        params.total(response.tasks_count);
                        $defer.resolve($scope.data);
                    });
            }
        });

    }]);
    //check whether planning sheet requested belongs to user or not. 
    // If not redirect user to dashboard. 
    planning_sheet_ctrl.isSheetCanBeShown = function($stateParams, $q, $window, $state, notify, planningSheetsService) {
        planningSheetsService.getPlanningSheet($stateParams.id).then(function(response) {
            var sheet = response.data;
            if (!($window.sessionStorage._userId == sheet.user_id)) {
                $state.go('dashboard')
                    //alert error message
                notify({
                    classes: 'alert-danger',
                    message: "The planning sheet requested doesnt not belong by you",
                    templateUrl: ""
                });
            }

        }, function(error) {
            if (error.status == 404) {
                $state.go('dashboard')
                    //alert error message
                notify({
                    classes: 'alert-danger',
                    message: "The planning sheet requested doesnt not exits.",
                    templateUrl: ""
                });
            }
        })
    }

