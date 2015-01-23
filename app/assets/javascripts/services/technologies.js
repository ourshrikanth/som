app.factory('technologiesService', ['$http', function($http) {
    var technolgies = {};
    technolgies.getAll = function() {
        return $http.get('/technologies/get_all.json');
    };

    technolgies.create = function(name) {
        return $http.post('/technologies.json', name);
    };
    technolgies.deactivate = function(technology) {
        return $http.delete('/technologies/'+technology.id+'.json');
    };
    technolgies.update = function(technology,name) {
        return $http.put('/technologies/'+technology.id+'.json?name='+name);
    }
    return technolgies;
}])
