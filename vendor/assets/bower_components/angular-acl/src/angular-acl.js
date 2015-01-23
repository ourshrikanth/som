'use strict';

angular.module('mm.acl', []);

angular.module('mm.acl').provider('AclService', [
  function () {

    /**
     * Polyfill for IE8
     *
     * http://stackoverflow.com/a/1181586
     */
    if (!Array.prototype.indexOf) {
      Array.prototype.indexOf = function (needle) {
        for (var i = 0; i < this.length; i++) {
          if (this[i] === needle) {
            return i;
          }
        }
        return -1;
      };
    }

    var config = {
      storage: 'sessionStorage',
      storageKey: 'AclService'
    };

    var data = {
      roles: [],
      abilities: {}
    };

    /**
     * Does the given role have abilities granted to it?
     *
     * @param role
     * @returns {boolean}
     */
    var roleHasAbilities = function (role) {
      return (typeof data.abilities[role] === 'object');
    };

    /**
     * Retrieve the abilities array for the given role
     *
     * @param role
     * @returns {Array}
     */
    var getRoleAbilities = function (role) {
      return (roleHasAbilities(role)) ? data.abilities[role] : [];
    };

    /**
     * Persist data to storage based on config
     */
    var save = function () {
      switch (config.storage) {
        case 'sessionStorage':
          saveToStorage('sessionStorage');
          break;
        case 'localStorage':
          saveToStorage('localStorage');
          break;
        default:
          // Don't save
          return;
      }
    };

    /**
     * Persist data to web storage
     */
    var saveToStorage = function (storagetype) {
      window[storagetype].setItem(config.storageKey, JSON.stringify(data));
    };

    /**
     * Retrieve data from web storage
     */
    var fetchFromStorage = function (storagetype) {
      var data = window[storagetype].getItem(config.storageKey);
      return (data) ? JSON.parse(data) : false;
    };

    var AclService = {};

    /* start-test-block */

    // Add debug annotations for unit testing private functions/variables,
    // which will be stripped during the production build
    AclService._config = config;
    AclService._data = data;
    AclService._roleHasAbilities = roleHasAbilities;
    AclService._getRoleAbilities = getRoleAbilities;
    AclService._save = save;
    AclService._saveToStorage = saveToStorage;
    AclService._fetchFromStorage = fetchFromStorage;

    /* end-test-block */

    /**
     * Restore data from web storage.
     *
     * Returns true if web storage exists and false if it doesn't.
     *
     * @returns {boolean}
     */
    AclService.resume = function () {
      var storedData;

      switch (config.storage) {
        case 'sessionStorage':
          storedData = fetchFromStorage('sessionStorage');
          break;
        case 'localStorage':
          storedData = fetchFromStorage('localStorage');
          break;
        default:
          storedData = null;
      }
      if (storedData) {
        angular.extend(data, storedData);
        return true;
      }

      return false;
    };

    /**
     * Attach a role to the current user
     *
     * @param role
     */
    AclService.attachRole = function (role) {
      if (data.roles.indexOf(role) === -1) {
        data.roles.push(role);
        save();
      }
    };

    /**
     * Remove role from current user
     *
     * @param role
     */
    AclService.detachRole = function (role) {
      var i = data.roles.indexOf(role);
      if (i > -1) {
        data.roles.splice(i, 1);
        save();
      }
    };

    /**
     * Remove all roles from current user
     */
    AclService.flushRoles = function () {
      data.roles = [];
      save();
    };

    /**
     * Check if the current user has role attached
     *
     * @param role
     * @returns {boolean}
     */
    AclService.hasRole = function (role) {
      return (data.roles.indexOf(role) > -1);
    };

    /**
     * Set the abilities object (overwriting previous abilities)
     *
     * Each property on the abilities object should be a role.
     * Each role should have a value of an array. The array should contain
     * a list of all of the roles abilities.
     *
     * Example:
     *
     *    {
     *        guest: ['login'],
     *        user: ['logout', 'view_content'],
     *        admin: ['logout', 'view_content', 'manage_users']
     *    }
     *
     * @param abilities
     */
    AclService.setAbilities = function (abilities) {
      data.abilities = abilities;
      save();
    };

    /**
     * Add an ability to a role
     *
     * @param role
     * @param ability
     */
    AclService.addAbility = function (role, ability) {
      if (!data.abilities[role]) {
        data.abilities[role] = [];
      }
      data.abilities[role].push(ability);
      save();
    };

    /**
     * Does current user have permission to do something?
     *
     * @param ability
     * @returns {boolean}
     */
    AclService.can = function (ability) {
      var role, abilities;
      // Loop through roles
      for (var i = 0, len = data.roles.length; i < len; i++) {
        // Grab the the current role
        role = data.roles[i];
        abilities = getRoleAbilities(role);
        if (abilities.indexOf(ability) > -1) {
          // Ability is in role abilities
          return true;
        }
      }
      // We made it here, so the ability wasn't found in attached roles
      return false;
    };

    return {
      config: function (userConfig) {
        angular.extend(config, userConfig);
      },
      $get: function () {
        return AclService;
      }
    };

  }
]);