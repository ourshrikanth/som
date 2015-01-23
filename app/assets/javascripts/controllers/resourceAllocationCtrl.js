app.controller('ResourceAllocationCtrl', ['$timeout', '$window', '$scope', '$q', 'ngTableParams', '$filter', '$timeout', 'userService', 'projectsService', 'resouceAllocationService', 'ngDialog', 'notify', function($timeout, $window, $scope, $q, ngTableParams, $filter, $timeout, userService, projectsService, resouceAllocationService, ngDialog, notify) {
    //logged in user role 
    $scope.role = $window.sessionStorage._role

    //scope of create request form
    $scope.createRequest = {}
        //get all projects.
    $scope.projects = {}
        //get all project list from service
    var projects_defer = $q.defer();
    projectsService.getAll().then(function(response) {
        // $scope.projects = response.data;
        // console.log($scope.projects)
        // $timeout(chosen_update, 1000);
        projects_defer.resolve(response.data.data);
        return projects_defer.promise;
    });
    projects_defer.promise.then(function success(data) {
        $scope.projects = data;
        $timeout(chosen_update, 1000);
    });
    //date range picker configuration. 
    $scope.dateOptions = {
        format: 'MM-DD-YYYY',
        opens: 'center',
        locale: {}
    }

    //get all active employees present in the system. 
    $scope.employees = []
        //default params, only employees required. 
    var params = {
        page: 1,
        limit: 1000,
        filters: {
            "users.role_id": 2
        }
    }
    var employees_defer = $q.defer();
    //get all employees from service. 
    userService.getAll(params).then(function(response) {
        employees_defer.resolve(response.data.data);
        return employees_defer.promise;
    });
    employees_defer.promise.then(function success(data) {
        $scope.all_employees = data;
        $timeout(chosen_update, 1000);
    });
    //handle submission of resource request sheet 
    $scope.clickToUpdate = function(resource_id, status) {
            $scope.status = status;

            //format the date format 
            // $scope.createRequest.dateRange.startDate = $filter('date')($scope.createRequest.dateRange.startDate, "MM-dd-yyyy");
            // $scope.createRequest.dateRange.endDate = $filter('date')($scope.createRequest.dateRange.endDate, "MM-dd-yyyy");
            $scope.dialog_for = "for Resource Allocation"
            var dialog = ngDialog.open({
                template: 'teamusers/popup.html',
                scope: $scope,
                controller: ['$scope', '$state', 'resouceAllocationService', function($scope, $state, resouceAllocationService) {
                    $scope.updateStatus = function() {
                        console.log($scope.status)
                        if ($scope.status == 'request') {
                            $scope.createRequest.comment = {
                                comment: $scope.review.comment
                            };
                            resouceAllocationService.create($scope.createRequest).success(function(response) {
                                notify({
                                    classes: 'alert alert-success',
                                    message: "Resouce Allocation Sheet created successfully",
                                    templateUrl: ""
                                });
                                $scope.closeThisDialog();
                                $scope.TableParams.reload();
                            })
                        } else {
                            resouceAllocationService.updateStatus(resource_id, $scope.status, $scope.review).success(function(response) {
                                notify({
                                    classes: 'alert alert-success',
                                    message: "Resouce Allocation Sheet updated successfully",
                                    templateUrl: ""
                                });
                                $scope.closeThisDialog();
                                $scope.TableParams.reload();
                            }).error(function(response) {

                            })
                        }
                    }
                }]

            });
        }
        //adding new user to resouce request. 
    $scope.createRequest.newUsers = []
    $scope.addNewUser = function() {
        addDefaultUser();
    }
    var defaultNewUser = function(user) {
        return _.defaults(user || {}, DEFAULT_USER)
    };
    var addDefaultUser = function() {
        $scope.createRequest.newUsers.push(defaultNewUser());
    };
    $scope.removeUser = function($index, $event) {
        $scope.createRequest.newUsers.splice($index, 1);
    };
    var DEFAULT_USER = {
        user_id: '',
        dateRange: '',
        hours: ''

    };

    //list data
    $scope.resources = {}
    $scope.TableParams = new ngTableParams({
        page: 1, // show first page
        count: 10, // count per page
        sorting: {
            'resource_requests.id': 'desc' // initial sorting
        }
    }, {
        getData: function($defer, params) {
            var par = {
                page: params.page(),
                limit: params.count(),
                order_by: params.sorting(),
                filters: params.filter()
            }
            resouceAllocationService.getAll(par).success(function(response) {
                var data = response;
                params.total(100);
                angular.forEach(data, function(value, key) {
                    angular.forEach(value.requested_resources, function(v, k) {
                        var date = {
                            startDate: v.start_date,
                            endDate: v.end_date
                        }
                        value.requested_resources[k].date = date
                    });

                });
                $scope.resources = data;
                $defer.resolve($scope.resources);
            });


        }
    });

    //handle toggling of row inside table and show employee details.. 
    $scope.toggleData = {};
    $scope.toggleEmployee = function(data) {
        $scope.toggleData = angular.copy(data);
    }

    //get all status of resource allocation. 
    //resource edit. 
    $scope.edit = {}
    $scope.resource = {}
    $scope.resource.requested_resources = []
    $scope.editResource = function(data) {
        $scope.edit = angular.copy(data);
        $scope.resource.requested_resources = data.requested_resources;


    }

       //adding new user to resouce request. 
    $scope.resource.newUsers = []
    $scope.addNewUserEdit = function() {
        addDefaultUser();
    }
    var defaultNewUser = function(user) {
        return _.defaults(user || {}, DEFAULT_USER_EDIT)
    };
    var addDefaultUserEdit = function() {
        $scope.resource.newUsers.push(defaultNewUser());
    };
    $scope.removeUserEdit = function($index, $event) {
        $scope.resource.newUsers.splice($index, 1);
    };
    var DEFAULT_USER_EDIT = {
        user_id: '',
        dateRange: '',
        hours: ''

    };



}]);
