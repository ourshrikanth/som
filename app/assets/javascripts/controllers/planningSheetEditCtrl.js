var planning_sheet_edit_ctrl = app.controller('PlanningSheetEditCtrl', ['$scope', '$http', '$filter', 'ngTableParams', '$state', 'Auth', '$stateParams', 'planned_tasks', 'ngDialog','notify', function($scope, $http, $filter, ngTableParams, $state, Auth, $stateParams, planned_tasks, ngDialog,notify) {
    $scope.data = {};
    $scope.tableParams = new ngTableParams({
        page: 1,
        count: 10,
        sorting: {
            'planned_tasks.id': 'desc' // initial sorting
        }
    }, {
        getData: function($defer, params) {
            console.log("inside getData PlanningSheetEditCtrl");
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

    $scope.addRow = function(task) {
        task.planning_sheet_id = $stateParams.id
        planned_tasks.create({
            data: task
        }).success(function(res) {
            $scope.data.tasks.unshift(res);
            $scope.tableParams.reload();
        }).error(function(err) {
            console.log("error")
        });

    }

    $scope.edit = {};
    //inline edit calling. 
    $scope.setEdit = function(p) {
            $scope.edit = angular.copy(p);
            console.log($scope.edit);

        }
        //save the edited row . 
    $scope.saveEdit = function(p) {
            console.log("-----start saveEdit---");
            //TODO : call the service to save data. 
            p.title = $scope.edit.title;
            p.work_hours = $scope.edit.work_hours;
            p.billable_hours = $scope.edit.billable_hours;
            console.log(p);
            //calling factory method : update
            planned_tasks.update({
                data: p
            }).success(function(res) {
                $scope.setEdit({});
                $scope.tableParams.reload();
            });
        }
        //close the inline edit. 
    $scope.cancelEdit = function() {
            $scope.edit = {}
        }
        //delete row from table
    $scope.deleteRow = function(index) {
        var task__to_delete = $scope.data.tasks[index];
        // window.data = $scope.data.tasks;
        planned_tasks.delete(task__to_delete).success(function() {
            console.log('deleted successfully');
            $scope.data.tasks.splice(index, 1);
            $scope.tableParams.reload();
        }).error(function(err) {
            alert(err);
        });
    }

    //handle submission of time sheet done by the user. 
    $scope.clickToSubmit = function(status) {
        $scope.status = status;
        $scope.dialog_for = "Planning sheet"
        var dialog = ngDialog.open({
            template: 'teamusers/popup.html',
            scope: $scope,
            controller: ['$scope', '$state', '$stateParams', 'teamUserService', function($scope, $state, $stateParams, teamUserService) {
                $scope.updateStatus = function(data) {
                    console.log($scope.review);
                    //update status of planning sheet , call service. 
                    teamUserService.updateUserPlanningSheet($stateParams.id, $scope.status, $scope.review).success(function(data) {
                        $scope.closeThisDialog();
                        notify.closeAll();
                notify({
                    classes: 'alert alert-success',
                    message:"Planning sheet submitted successfully",
                    templateUrl: ""
                });
                $state.go('dashboard')

                    }).error(function(err) {
                        console.log(err);
                    })

                };
            }]
        });

    };




}]);

//check whether planning sheet requested belongs to user or not and exists
// If not redirect user to dashboard. 
planning_sheet_edit_ctrl.isSheetCanBeEdited = function($stateParams, $q, $window, $state, notify, planningSheetsService) {
    planningSheetsService.getPlanningSheet($stateParams.id).then(function(response) {
        sheet = response.data;
        if (!($window.sessionStorage._userId == sheet.user_id)) {
            $state.go('dashboard')
                //alert error message
            notify({
                classes: 'alert-danger',
                message: "The planning sheet requested doesnt not belong by you",
                templateUrl: ""
            });
        }
        if(sheet.status="submitted"){
           $state.go('dashboard')
            notify({
                classes: 'alert-danger',
                message: "Requested planning sheet is already submitted, cant edit again",
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
    });
}
