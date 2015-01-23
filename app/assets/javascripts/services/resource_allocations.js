app.service('resouceAllocationService', ['$http', function($http) {
    var resources = {};

    resources.create = function(data) {
        console.log(data)
        return $http.post('/resource_requests.json', data);
    }
    resources.getAll = function(params) {
        return $http.get('/resource_requests.json', {
            params: params
        });
    };
    resources.updateStatus = function(id,status,comment){
    	console.log(comment)
    	  return $http.post('resource_requests/update_record.json', {
                id: id,
                status: status,
                comment: comment
            })
    }

    return resources;
}]);
