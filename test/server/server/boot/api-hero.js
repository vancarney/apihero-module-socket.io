var hero = require('api-hero');
var socket_hero = require('../../../../index');
module.exports = function(app) {
	hero.init(app);
	socket_hero.init(app);
};