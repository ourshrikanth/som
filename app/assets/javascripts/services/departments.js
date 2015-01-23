app.factory('departments',['$http', function($http) {
    var dept = {
        departments: []
    };
    dept.getAll = function() {
        return $http.get('/departments.json').success(function(data) {
            angular.copy(data, dept.departments);
        });
    };
    dept.create = function(department) {
        return $http.post('/departments.json', department).success(function(data) {
            dept.departments.push(data);
        });
    };
    dept.get = function(id) {
        return $http.get('/departments/' + id + '.json').then(function(response) {
            return response.data;
        })
    };
    dept.update = function(department, name) {
        return $http.put('/departments/' + department.id + '.json?name=' + name);
    };
    dept.delete = function(department) {
        return $http.delete('/departments/' + department.id + '.json').then(function(res) {
             //updating status to inactive
            angular.forEach(dept.departments, function(u, i) {
                if (u.id == res.data.id) {
                    dept.departments[i] = res.data;
                }
            });
        })
    };
    return dept;
}]);
