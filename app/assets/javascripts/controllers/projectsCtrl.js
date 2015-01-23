//define controller. 
app.controller('projectsCtrl', ['$scope', '$http', 'ngTableParams', '$q', 'projectsService', 'notify','$window', function($scope, $http, ngTableParams, $q, projectsService, notify,$window) {

    $scope.projects = {}
    $scope.TableParams = new ngTableParams({
        page: 1, // show first page
        count: 10, // count per page
        sorting: {
            'projects.id': 'desc' // initial sorting
        }
    }, {
        getData: function($defer, params) {
            var par = {
                page: params.page(),
                limit: params.count(),
                order_by: params.sorting(),
                filters: params.filter()
            }
            projectsService.getAll(par).success(function(response) {
                var data = response.data;
                params.total(response.count);
                $scope.projects = data;
                $defer.resolve($scope.projects);
            });


        }
    });

    //get all status of project
    $scope.getStatus = function() {
        var def = $q.defer(),
            names = [];
        names.push({
            'id': 'active',
            'title': 'Active'
        }, {
            'id': 'inactive',
            'title': 'Inactive'
        });
        def.resolve(names);
        return def;

    }

    //create new project. 
    $scope.addProject = function(){
        projectsService.create({
                name: $scope.name,
                user_id:window.sessionStorage._userId
            }).success(function(project) {
                $scope.projects.unshift(project);
                notify.closeAll();
                notify({
                    classes: 'alert alert-success',
                    message: $scope.name + "  project created successfully",
                    templateUrl: ""
                });
                $scope.name = '';
                // to reset the add-project-form after submissioin
                $scope.AddProjectForm.$setPristine();
            }).error(function(error) {
                //alert error message
                notify({
                    classes: 'alert-danger',
                    message: "There is a problem in your request, Please try again",
                    templateUrl: ""
                });
            });
    }

  //update project details
     $scope.updateProject = function(project, data) {
            var d = $q.defer();
            projectsService.update(project, data).success(function(res) {
                res = res || {};
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
        //deactivate project 
         $scope.deactivateProject = function(project) {
            projectsService.deactivate(project).success(function(response) {
                //update status to inactive
                angular.forEach($scope.projects, function(u, i) {
                    if (u.id == response.id) {
                        $scope.projects[i] = response;
                    }
                });

                notify.closeAll();
                notify({
                    classes: 'alert alert-success',
                    message: project.name + "  project deactivated successfully",
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

}]);
