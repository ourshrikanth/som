app.factory('roleService',['$http', function($http) {
    var obj = {
        roles: []
    };
    $http.get('roles.json').then(function(response, status, headers, config) {
        var data = response.data.roles;
        if (data) {
            for (var i in data) {
                obj.roles.push(data[i]);
            }
            return obj.roles;
        }
    });

    return obj;
}]);
