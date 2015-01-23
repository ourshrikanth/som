app.factory('projectsService', ['$http', function($http) {
    var projects = {};
    projects.getAll = function(params) {
        return $http.get('/projects.json',{params:params});
    };

    projects.create = function(name) {
        return $http.post('/projects.json', name);
    };
    projects.deactivate = function(project) {
        return $http.delete('/projects/' + project.id + '.json');
    };
    projects.update = function(project, name) {
        return $http.put('/projects/' + project.id + '.json?name=' + name);
    }
    return projects;
}])
