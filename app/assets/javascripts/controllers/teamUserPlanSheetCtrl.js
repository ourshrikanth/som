var team_user_plan_sheet_ctrl = app.controller('teamUserPlanSheetCtrl',['$scope', '$state', '$stateParams', '$http', 'teamUserService', 'ngDialog', 'ngTableParams', 'notify',function($scope, $state, $stateParams, $http, teamUserService, ngDialog, ngTableParams, notify) {
    // teamUserService.getUserPlanningSheetDetails($stateParams.id).success(function(response) {
    //     $scope.planning_sheet = response;
    // }).error(function(err) {
    //     console.log(er);
    // });
    //handle popup of approve or reject dialog box. 
    $scope.clickToUpdate = function(status) {
        $scope.status = status;
        $scope.dialog_for = "Planning sheet"
        var dialog = ngDialog.open({
            template: 'teamusers/popup.html',
            scope: $scope,
            controller: ['$scope', '$state', '$stateParams', 'teamUserService', function($scope, $state, $stateParams, teamUserService) {
                $scope.updateStatus = function(data) {
                    //update status of planning sheet , call service. 
                    teamUserService.updateUserPlanningSheet($stateParams.id, $scope.status, $scope.review).success(function(data) {
                        $scope.closeThisDialog();
                        $state.go($state.$current, null, {
                            reload: true
                        });
                        notify({
                            classes: 'alert alert-success',
                            message: "Planning Sheet updated successfully",
                            templateUrl: ""
                        });
                    }).error(function(err) {
                       notify({
                            classes: 'alert alert-danger',
                            message: "There was a problem in your request",
                            templateUrl: ""
                        });
                    })

                };
            }]
        });

        dialog.closePromise.then(function(data) {
            console.log(data);
            // $state.transitionTo('userplansheet', {
            //     id: $stateParams.id
            // });
            // $state.go('home');
            // $state.go($state.$current, null, { reload: true });

        });
    };
    $scope.planning_sheet = [];

    $scope.tableParams = new ngTableParams({
        page: 1, // show first page
        count: 10, // count per page
        sorting: {
            'planned_tasks.id': 'desc' // initial sorting
        }
    }, {
        getData: function($defer, params) {
            // req = {
            //     page: params.page(),
            //     limit: params.count(),
            //     id: $stateParams.id,
            //     order_by: params.sorting()
            // }

            $http.get('planned_tasks/getAllTasksOfSheet.json', {
                    params: {
                        page: params.page(),
                        limit: params.count(),
                        id: $stateParams.id,
                        order_by: params.sorting()
                    }
                })
                .success(function(response, status) {
                    $scope.planning_sheet = response.data;
                    console.log(response.data);
                    params.total(response.tasks_count);
                    $defer.resolve($scope.planning_sheet);
                });
            // teamUserService.getUserPlanningSheetDetails(req).success(function(response) {
            //     params.total(response.count);
            //     $scope.planning_sheet = response;
            //     $defer.resolve($scope.planning_sheet);
            // }).error(function(err) {
            //     console.log(err);
            // });


        }
    });
    // $scope.planning_sheet = teamUserService.team_users;

}]);

//to check whether manager / approver is accessing his team members planning sheet or not. 
team_user_plan_sheet_ctrl.isSheetBelongsToTeam = function($stateParams, $q, $window, $state, notify, teamUserService) {
     teamUserService.isSheetBelongsToTeam($stateParams.id).then(function(response){
        if (!response.data){
            $state.go('dashboard')
               //alert error message
            notify({
                classes: 'alert-danger',
                message: "You are not a reviewer for a requested planning sheet or doesnt exists. ",
                templateUrl: ""
            });
        } 
     })
}

