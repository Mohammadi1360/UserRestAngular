<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>AngularJS $http Rest example</title>

    <script src="res/js/angular.min.js"></script>
    <link href="res/css/bootstrap.css" rel="stylesheet" type="text/css">

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

    <script type="text/javascript">
        var app = angular.module("userManagement", []);

        //Controller Part
        app.controller("userController", function ($scope, $http) {
            $scope.users = [];
            $scope.reverseSort = false;
            $scope.userForm = {
                id: -1,
                name: "",
                age: "",
                salary: ""
            };

            //Now load the data from server
            _refreshuserData();

            //HTTP POST/PUT methods for add/edit user
            // with the help of id, we are going to find out whether it is put or post operation

            $scope.submituser = function () {

                var method = "";
                var url = "";
                if ($scope.userForm.id == -1) {
                    //Id is absent in form data, it is create new user operation
                    method = "POST";
                    url = 'users/';
                } else {
                    //Id is present in form data, it is edit user operation
                    method = "PUT";
                    url = 'users/' + $scope.userForm.id;
                }

                $http({
                    method: method,
                    url: url,
                    data: angular.toJson($scope.userForm),
                    headers: {
                        'Content-Type': 'application/json'
                    }
                }).then(_success, _error);
            };

            //HTTP DELETE- delete user by Id
            $scope.deleteuser = function (user) {
                $http({
                    method: 'DELETE',
                    url: 'users/' + user.id
                }).then(_success, _error);
            };

            // In case of edit, populate form fields and assign form.id with user id
            $scope.edituser = function (user) {
                $scope.userForm.id = user.id;
                $scope.userForm.name = user.name;
                $scope.userForm.age = user.age;
                $scope.userForm.salary = user.salary;
            };

            $scope.newUser = function () {
                $scope.userForm.id = -1;
                $scope.userForm.name = "";
                $scope.userForm.age = "";
                $scope.userForm.salary = "";
            };

            $scope.orderByMe = function (fieldName) {
                $scope.myOrderBy = fieldName;
                $scope.reverseSort = !($scope.reverseSort);
            };


            /* Private Methods */
            //HTTP GET- get all users collection
            function _refreshuserData() {
                $http({
                    method: 'GET',
                    url: 'users/'
                }).then(function successCallback(response) {
                    $scope.users = response.data;
                }, function errorCallback(response) {
                    console.log(response.statusText);
                });
            }

            function _success(response) {
                _refreshuserData();
                _clearFormData()
            }

            function _error(response) {
                console.log(response.statusText);
            }

            //Clear the form
            function _clearFormData() {
                $scope.userForm.id = -1;
                $scope.userForm.name = "";
                $scope.userForm.age = "";
                $scope.userForm.salary = "";

            };
        });
    </script>

    <head>
<body ng-app="userManagement" ng-controller="userController">

<div class="container">
    <div class="row">

        <div class="col-sm-1 col-md-2">
        </div>

        <div class="col-xs-12 col-sm-10 col-md-8">
            <div class="well">

                <div class="panel panel-primary">

                    <div class="panel-heading">
                        <h2 class="panel-title">AngularJS Restful web services example using $http</h2>
                    </div>

                    <div class="panel-body">

                        <form ng-submit="submituser()">

                            <table class="table">

                                <tr>
                                    <th colspan="2">Add/Edit user</th>
                                </tr>
                                <tr>
                                    <td>ID</td>
                                    <td><input type="text" ng-model="userForm.id" ng-readonly="true" placeholder="ID"
                                               class="form-control"/></td>
                                </tr>
                                <tr>
                                    <td>Name</td>
                                    <td><input type="text" ng-model="userForm.name" placeholder="Name"
                                               class="form-control"/></td>
                                </tr>
                                <tr>
                                    <td>AGE</td>
                                    <td><input type="text" ng-model="userForm.age" placeholder="AGE"
                                               class="form-control"/></td>
                                </tr>
                                <tr>
                                    <td>SALARY</td>
                                    <td><input type="text" ng-model="userForm.salary" placeholder="SALARY"
                                               class="form-control"/></td>
                                </tr>

                                <tr>
                                    <td colspan="2">
                                        <input type="submit" value="Submit" class="btn btn-sm btn-primary"/>

                                        <input type="button" ng-click="newUser()" value="New User"
                                               class="btn btn-sm btn-success"/>
                                    </td>
                                </tr>
                            </table>
                        </form>
                    </div>

                    <div class="panel panel-primary">
                        <div class="panel-heading">
                            <h2 class="panel-title">User List</h2>
                        </div>

                        <div class="panel-body">

                            <table class="table">
                                <tr>
                                    <th ng-click="orderByMe('id')">ID</th>
                                    <th ng-click="orderByMe('name')">NAME</th>
                                    <th ng-click="orderByMe('age')">AGE</th>
                                    <th ng-click="orderByMe('salary')">SALARY</th>
                                    <th>Edit</th>
                                    <th>Delete</th>
                                </tr>

                                <tr ng-repeat="user in users | orderBy:myOrderBy:reverseSort">

                                    <td> {{ user.id }}</td>
                                    <td>{{ user.name }}</td>
                                    <td>{{ user.age }}</td>
                                    <td>{{ user.salary }}</td>

                                    <td>
                                        <a ng-click="edituser(user)" class="btn btn-sm btn-warning">Edit</a>
                                    </td>
                                    <td>
                                        <a ng-click="deleteuser(user)" class="btn btn-sm btn-danger">Delete</a>
                                    </td>

                                </tr>

                            </table>

                        </div>

                    </div>

                </div>

            </div>
        </div>

        <div class="col-sm-1 col-md-2">
        </div>

    </div>
</div>


</body>
</html>