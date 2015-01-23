app.controller('TechnologiesCtrl',['$scope', '$http', 'ngTableParams', '$state', '$stateParams', '$filter', '$q', 'technologiesService', 'notify',
    function($scope, $http, ngTableParams, $state, $stateParams, $filter, $q, technologiesService, notify) {
        // technologiesService.getAll().success(function(response) {
        //     $scope.technologies = response;
        // });

        $scope.TableParams = new ngTableParams({
            page: 1, // show first page
            count: 10, // count per page
            sorting: {
                'technologies.id': 'desc' // initial sorting
            },
        }, {
            getData: function($defer, params) {
                $http.get('technologies.json', {
                        params: {
                            page: params.page(),
                            limit: params.count(),
                            order_by: params.sorting(),
                            filters: params.filter()
                        }
                    })
                    .success(function(response, status) {
                        var data = response.data;
                        params.total(response.count);
                        $scope.technologies = data;
                        $defer.resolve($scope.technologies);
                    });
            },
        });

        $scope.edit = function(id) {
            $state.go('editTechnology', {
                id: id
            });
        }

        $scope.addTechnology = function() {
            if (!$scope.name || $scope.name === '') {
                return;
            }

            technologiesService.create({
                name: $scope.name,
            }).success(function(technology) {
                $scope.technologies.push(technology);
                notify.closeAll();
                notify({
                    classes: 'alert alert-success',
                    message: $scope.name + "  technology created successfully",
                    templateUrl: ""
                });
                $scope.name = '';
                // to reset the department-form after submissioin
                $scope.TechnologyForm.$setPristine();
            }).error(function(error) {
                //alert error message
                notify({
                    classes: 'alert-danger',
                    message: "There is a problem in your request, Please try again",
                    templateUrl: ""
                });
            });
        };

        $scope.deactivateTechnology = function(technology) {
            technologiesService.deactivate(technology).success(function(response) {
                //update status to inactive
                angular.forEach($scope.technologies, function(u, i) {
                    if (u.id == response.id) {
                        $scope.technologies[i] = response;
                    }
                });

                notify.closeAll();
                notify({
                    classes: 'alert alert-success',
                    message: technology.name + "  technology deactivated successfully",
                    templateUrl: ""
                });

            }).error(function(error) {
                notify({
                    classes: 'alert-danger',
                    message: "There is a problem in your request, Please try again",
                    templateUrl: ""
                });
            });
        };
        $scope.updateTechnology = function(technology, data) {
            var d = $q.defer();
            technologiesService.update(technology, data).success(function(res) {
                res = res || {};
                console.log(res);
                if (res.status == true) { // {status: "ok"}
                    d.resolve()
                } else { // {status: "error", msg: "Username should be `awesome`!"}
                    d.resolve(res.msg)
                }
            }).error(function(e) {
                d.reject('Server error!');
            });
            return d.promise;
        };



        //     $scope.technologies.pop(technology);
        //     notify.closeAll();
        //     notify({
        //         classes: 'alert-danger',
        //         message: technology.name + "  technology deactivated successfully",
        //         templateUrl: ""
        //     });
        // }


    }]);
