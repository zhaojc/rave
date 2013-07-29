/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

define(['common/resources/category_resources', 'common/resources/page_resources', 'common/resources/person_resources', 'common/resources/region_resources', 'common/resources/region_widget_resources', 'common/resources/user_resources', 'underscore'],
    function(category, page, person, region, regionWidget, user, _) {
        'use strict';
        var servicesModule =  angular.module('common.resources', ['ngResource'], ['$httpProvider', function($httpProvider){
            $httpProvider.defaults.transformResponse = function(data, headers) {
                return data.data;
            };
        }]);

        //Array of services
        //For any common services added, they must be requried in this file and added
        //to the array below.
        var services = [category, page, person, region, regionWidget, user];

        //Loop through array to add services
        _.each(services, function(e, i){
            //Loop through each service on the object adding it to the serviceModule
            _.each(e, function(service, name){
                servicesModule.factory(name, service);
            })
        })

        return servicesModule;
    });
