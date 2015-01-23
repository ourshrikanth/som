

app.controller('DepartmentsCtrl', ['$scope', 'departments', 'notify','$q',function($scope, departments, notify,$q) {
    //get all departments from service. 
    $scope.departments = departments.departments;
    //delete department method
    $scope.deleteDept = function(department) {
        notify.closeAll();
        departments.delete(department).then(function(response) {
            // /alert success message
            notify({
                classes: 'alert alert-success',
                message: department.name + "  department deleted successfully",
                templateUrl: ""
            });
        }, function(error) {
            //alert error message
            notify({
                classes: 'alert alert-danger',
                message: "There is a problem in your request, Please try again",
                templateUrl: ""
            });
        });

    };
    //add department method
    $scope.addDepartment = function() {
        if (!$scope.name || $scope.name === '') {
            return;
        }
        notify.closeAll();
        departments.create({
            name: $scope.name
        }).success(function(response) {
            //alert success message
            notify({
                classes: 'alert alert-success',
                message: $scope.name + "  department created successfully",
                templateUrl: ""
            });
            //reset the department name. 
            $scope.name = '';
            // to reset the department-form after submissioin
            $scope.departmentForm.$setPristine();
        }).error(function(error) {
            //alert error message
            notify({
                classes: 'alert-danger',
                message: "There is a problem in your request, Please try again",
                templateUrl: ""
            });
        })
    };

    $scope.updateDepartment = function(department,data){
          var d = $q.defer();
            departments.update(department, data).success(function(res) {
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
}]);
